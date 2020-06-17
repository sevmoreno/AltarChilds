//
//  AppDelegate.swift
//  altar
//
//  Created by Juan Moreno on 9/8/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    let actInd = UIActivityIndicatorView()
    var container: UIView! = nil
    
    class func instance () -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
//    func showActivityIndicatior () {
//        
//        if let window = window {
//            container = UIView ()
//            container.frame = window.frame
//            container.center = window.center
//            container.backgroundColor = UIColor(white: 0, alpha: 0.8)
//            actInd.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            actInd.hidesWhenStopped = true
//            actInd.center = CGPoint(x: container.frame.height/2, y: container.frame.size.width/2)
//            container.addSubview(actInd)
//            window.addSubview(container)
//            actInd.startAnimating()
//            
//     
//        }
//        
//    }
    
//    func dismissActivityIndicator () {
//        if let _ = window {
//            container.removeFromSuperview()
//        }
//    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        FirebaseApp.configure()
     
        UIApplication.shared.statusBarStyle = .lightContent
        
        attemptRegisterForNotifications(application: application)
        
        // Payment observer
        
        IAPManager.shared.startObserving()
        // Override point for customization after application launch.
        
        
        let secondaryOptions = FirebaseOptions(googleAppID: "1:270586771087:ios:56d67d6d286d4e608922fa",
                                               gcmSenderID: "270586771087")
        secondaryOptions.apiKey = "AIzaSyAmW91D-tujcgWjAoDwiUpqDctkUo-fbE4"
        secondaryOptions.projectID = "altar-92d12"

        // The other options are not mandatory, but may be required
        // for specific Firebase products.
        secondaryOptions.bundleID = "sevmoreno.com.altar"
     //   secondaryOptions.trackingID = "UA-12345678-1"
        secondaryOptions.clientID = "270586771087-16iur2sivi64ae0f93b5vhp7u9if768f.apps.googleusercontent.com"
        secondaryOptions.databaseURL = "https://altar-92d12.firebaseio.com"
        secondaryOptions.storageBucket = "altar-92d12.appspot.com"
   //     secondaryOptions.androidClientID = "12345.apps.googleusercontent.com"
     //   secondaryOptions.deepLinkURLScheme = "myapp://"
         secondaryOptions.storageBucket = "altar-92d12.appspot.com"
        secondaryOptions.appGroupID = nil
        
        
        FirebaseApp.configure(name: "secondary", options: secondaryOptions)

        // Retrieve a previous created named app.
        guard let secondary = FirebaseApp.app(name: "secondary")
          else { assert(false, "Could not retrieve secondary app")
            return true
        }


        // Retrieve a Real Time Database client configured against a specific app.
         let secondaryDb = Database.database(app: secondary)

        newSearchForMessage ()
       // activeAplication ()
        return true
    }
    
    
 
    
    private func attemptRegisterForNotifications(application: UIApplication) {
        print("Attempting to register APNS...")
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        // user notifications auth
        // all of this works for iOS 10+
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, err) in
            if let err = err {
                print("Failed to request auth:", err)
                return
            }
            
            if granted {
                print("Auth granted.")
            } else {
                print("Auth denied")
            }
        }
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         print("Registered for notifications:", deviceToken)
     }
     
     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
         print("Registered with FCM with token:", fcmToken)
     }
     
     // listen for user notifications
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         completionHandler(.alert)
     }
     

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
//        let accountHelper = AccountHelpers ()
//        
//        accountHelper.NoMoreActive ()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//         let accountHelper = AccountHelpers ()
//        accountHelper.activeAplication ()
      //  let splash = SplashScreenViewController ()
       // window?.rootViewController = splash
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        IAPManager.shared.stopObserving()
    }

    // MARK: - Core Data stack
    
    
       func newSearchForMessage () {
            
            // Aqui agarro las COLLECCIONES DONDE USUARIO ESTE
            let databaseMessageRef = Firestore.firestore().collection("Chats").whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
          
            
            
            // AGARRO LOS DOCUMENTOS BAJO LA COLLECION CHATS Y QUE SEAN DEL USUARIO
        
            databaseMessageRef.getDocuments {  querySnapshot, error in
            guard let snapshot = querySnapshot else {
              print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
              return
            }
                
                
                
             // AHORA TENGO TODOS LOS DOCUMENTOS
             //   print("Encontro esta cantidad de Documentos o chats digamos")
              //  print(snapshot.documents.count)
                
                for cadaChat in snapshot.documents {
                 
                    // CREAMOS UN LISTENER PARA CADA DOCUMENTO Y LEEMOS UN CREAMOS LISTENER PARA CADA THREAD
                    cadaChat.reference.collection("thread").order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                        
                        
                        if let error = error {
                            print("Error: \(error)")
                            return
                        } else {
                            
                          //  print("Cuenta cuantos mensajes hay en el chat: \(threadQuery?.documents.count)")
                            let source = threadQuery?.metadata.isFromCache
                            if source! { return }
                         //   print("Es del cache o nuevot \(source)")
                            // HORA LO QUE HAGO ES QUE EL LISENER SE DISPARE CUANDO SOLO HAY UN CAMBIO EN LA PRIERMA DATA
                            threadQuery?.documentChanges.forEach { diff in
                                
                                if (diff.type == .added) || (diff.type == .modified) {
                                    
                                   // print("New chat: \(diff.document.data())")
                              //     print("NUEVO ELEMENTO DE CHAT ")
                                    guard let quien = diff.document.data() as? NSDictionary else { return}
                               //      print("New chat: \(quien)")
                                    guard let senderID = quien["senderID"] as? String else { return }
                                    
                                    
    //                                self.mensajesTotales = self.mensajesTotales + 1
    //                                self.mensajesActuales ()
                                    
                                    print("LLEGO A ESUCHAR UN CAMBIO")
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NuevoMensaje"), object: nil)
                                    

                                }
                            
                                if (diff.type == .removed) {

                                }
                            }
                            
                        }
                            
                        
                    })
                    
                    
                }
            
            
            }
                
                
        }
        


    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "altar")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}



