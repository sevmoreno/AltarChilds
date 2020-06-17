//
//  EventoVideoCollectionViewCell.swift
//  Favorday
//
//  Created by Juan Moreno on 4/23/20.
//  Copyright © 2020 Juan Moreno. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import WebKit

protocol delteEventVideoDelegate {

    func deletCellD(for cell: EventoVideoCollectionViewCell)
}


class EventoVideoCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var videoURL:URL!  // has the form
    
     var delegate: delteEventVideoDelegate?
    
    var videoContainerInCode: WKWebView = {
          let a = WKWebView ()
          
          
          return a
          
      } ()
    
    var evento: Event? {
           
           didSet {
              
               
               
               
            guard let postImageUrl = evento?.photoURL else { return }
         
               
            fondo.loadImage(urlString: postImageUrl)
            
            
            tituloEvento.text = evento?.title
            
            guard let videoURL = URL(string: (evento?.urltexto)!) else {return}
            videoContainerInCode.load(URLRequest(url: videoURL))
//
//               usernameLabel.text = post?.author
//               guard let profileuserURL = post?.userPhoto else {return}
//               userProfileImageView.loadImage(urlString: profileuserURL)

        }
    }
    
    let fondo: CustomImageView = {
        
        let a = CustomImageView ()
        
        a.backgroundColor = .green
        a.contentMode = .scaleAspectFill
        return a
        
        
    } ()
    
       let contenedor = UIView()
    let tituloEvento: UILabel = {
        
        let a = UILabel ()
        a.font = UIFont(name: "Avenir-Heavy", size: 20)
        a.textAlignment = .center
        a.numberOfLines = 0
        a.textColor = .white
        return a
    } ()
    
//    let deleteButton: UIButton = {
//
//        let a = UIButton ()
//
//        a.setImage(UIImage(named: "trash"), for: .normal)
//
//        a.addTarget(self, action: #selector(deleteEventVideo), for: .touchUpInside)
//        return a
//    } ()
//
//    @objc func deleteEventVideo () {
//
//
//        print("Quiere borrar")
//        //delegate?.deleteEvennt(controller: self)
//             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteEventVideo"), object: nil)
//             //deleteEvent
//         //    _ = navigationController?.popViewController(animated: true)
//
//    }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        
      

//            print("ES VIDEO")
//            print(evento?.urltexto)
        
            addSubview(fondo)
            addSubview(tituloEvento)
        fondo.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        fondo.contentMode = .scaleAspectFill
        
        tituloEvento.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 60, paddingRight: 10, width: 0, height: 0)
        tituloEvento.numberOfLines = 0
        tituloEvento.textAlignment = .center
        
        
        
        
            addSubview(videoContainerInCode)
        
         //   addSubview(deleteButton)

            videoContainerInCode.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

            

//           deleteButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//

    //    backgroundColor = .green
           let swipeCell = UISwipeGestureRecognizer(target: self, action: #selector(hiddenContainerViewTapped))
                swipeCell.direction = .left
                swipeCell.delegate = self
                
                addGestureRecognizer(swipeCell)

                let swipeCell2 = UISwipeGestureRecognizer(target: self, action: #selector(changeMyMind))
                              swipeCell2.direction = .right
                               swipeCell2.delegate = self
                              
                              addGestureRecognizer(swipeCell2)
        


                          }
    
    @objc func changeMyMind () {
                        
                        contenedor.isHidden = true
                        
                    }
    
    
    @objc func hiddenContainerViewTapped () {
                 
                 
                 print("Swiper")
                 
                 
                     //           print(evento?.userID )
                                 print(Auth.auth().currentUser?.uid)
                 

        if evento?.author == Auth.auth().currentUser?.uid || advengers.shared.isPastor == true {

                     
         
                         
                        
                       contenedor.isHidden = false
                         
                         contenedor.tag = 300

                        addSubview(contenedor)
                        
                        contenedor.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 0)
                        contenedor.backgroundColor = .red
                        
                        let deleteB = UIButton ()
                        
                        deleteB.addTarget(self, action: #selector(borrar), for: .touchDown)
                       // deleteB.titleLabel?.text = "Delete"
                      //  deleteB.tintColor = .white
                        deleteB.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
                        deleteB.setTitleColor(.white, for: .normal)
                        
                        contenedor.addSubview(deleteB)
                        deleteB.translatesAutoresizingMaskIntoConstraints = false
                        deleteB.centerXAnchor.constraint(equalTo: contenedor.centerXAnchor).isActive = true
                        deleteB.centerYAnchor.constraint(equalTo: contenedor.centerYAnchor).isActive = true
                            
                        }
                
             }
             
             @objc func borrar() {
         //        let imageDataDict = ["index": self.]
         //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeleteCell"), object: nil,userInfo: imageDataDict)
                print("Borrar")
                 contenedor.isHidden = true
                 delegate?.deletCellD(for: self)
             }
              
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
}
