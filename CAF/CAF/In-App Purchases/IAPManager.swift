//
//  IAPManager.swift
//  altar
//
//  Created by Juan Moreno on 2/25/20.
//  Copyright © 2020 Juan Moreno. All rights reserved.
//

import Foundation
import StoreKit


class IAPManager: NSObject {
 
  
     static let shared = IAPManager()
    var onReceiveProductsHandler: ((Result<[SKProduct], IAPManagerError>) -> Void)?
    var onBuyProductHandler: ((Result<Bool, Error>) -> Void)?
    var totalRestoredPurchases = 0
    
    enum IAPManagerError: Error {
          case noProductIDsFound
          case noProductsFound
          case paymentWasCancelled
          case productRequestFailed
      }
    
       private override init() {
           super.init()
       }
    
     func getProductIDs() -> [String]? {
     guard let url = Bundle.main.url(forResource: "IAP_ProductIDs", withExtension: "plist") else { return nil }
        do {
            let data = try Data(contentsOf: url)
                  let productIDs = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String] ?? []
                  return productIDs
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
      
    }
    
    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    func getProducts(withHandler productsReceiveHandler: @escaping (_ result: Result<[SKProduct], IAPManagerError>) -> Void) {
     
        onReceiveProductsHandler = productsReceiveHandler
        
        guard let productIDs = getProductIDs() else {
            productsReceiveHandler(.failure(.noProductIDsFound))
            return
        }
        
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        
        request.delegate = self
        
        request.start()
        
    }
    
    
    func restorePurchases(withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
        onBuyProductHandler = handler
        totalRestoredPurchases = 0
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

   
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
  
    func buy(product: SKProduct, withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
     
        // Keep the completion handler.
        onBuyProductHandler = handler
        
        
    }
    
}

extension IAPManager.IAPManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
        case .noProductsFound: return "No In-App Purchases were found."
        case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
        case .paymentWasCancelled: return "In-App Purchase process was cancelled."
        }
    }
}

extension IAPManager: SKProductsRequestDelegate {
    
 func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
  let products = response.products
    
    if products.count > 0 {
        onReceiveProductsHandler?(.success(products))
    } else {
     
        onReceiveProductsHandler?(.failure(.noProductsFound))
    }
 }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
     onReceiveProductsHandler?(.failure(.productRequestFailed))
    }
    
    func requestDidFinish(_ request: SKRequest) {
     
    }

}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
      transactions.forEach { (transaction) in
        
        switch transaction.transactionState {
            
        case .purchased:
         print("purchased")
            // INTERESANTE COMO PUEDO GUARDAR UNA FUNCION EN UNA VARIABLE Y SE EJECUTA
            onBuyProductHandler?(.success(true))
            SKPaymentQueue.default().finishTransaction(transaction)
        case .restored:
     
            totalRestoredPurchases += 1
            SKPaymentQueue.default().finishTransaction(transaction)
        case .failed:
         print("failed")
            if let error = transaction.error as? SKError {
                if error.code != .paymentCancelled {
                    onBuyProductHandler?(.failure(error))
                } else {
                    onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
                }
                print("IAP Error:", error.localizedDescription)
            }
            SKPaymentQueue.default().finishTransaction(transaction)
            
        case .deferred, .purchasing: break
        @unknown default: break
        }
        }
    }
    
    func startObserving() {
             SKPaymentQueue.default().add(self)
         }
          
          
         func stopObserving() {
             SKPaymentQueue.default().remove(self)
         }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if totalRestoredPurchases != 0 {
            onBuyProductHandler?(.success(true))
        } else {
            print("IAP: No purchases to restore!")
            onBuyProductHandler?(.success(false))
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError {
            if error.code != .paymentCancelled {
                print("IAP Restore Error:", error.localizedDescription)
                onBuyProductHandler?(.failure(error))
            } else {
                onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
            }
        }
    }
}
