//
//  EventoCollectionViewCell.swift
//  Favorday
//
//  Created by Juan Moreno on 4/23/20.
//  Copyright © 2020 Juan Moreno. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import WebKit


class EventoCollectionViewCell: UICollectionViewCell {
    
    var videoURL:URL!  // has the form
    
//    var videoContainerInCode: WKWebView = {
//          let a = WKWebView ()
//          
//          
//          return a
//          
//      } ()
    
    var evento: Event? {
           
           didSet {
              
               
               
               
            guard let postImageUrl = evento?.photoURL else { return }
         
               
            fondo.loadImage(urlString: postImageUrl)
            
            
            tituloEvento.text = evento?.title
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
    
    let tituloEvento: UILabel = {
        
        let a = UILabel ()
        a.font = UIFont(name: "Avenir-Heavy", size: 20)
        a.textAlignment = .center
        a.numberOfLines = 0
        a.textColor = .white
        return a
    } ()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        
      
        
   
            
            print("NO ES VIDEO")
            print(evento?.message)
            print(evento?.title)
            
            
              addSubview(fondo)
                    fondo.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                    
                    fondo.clipsToBounds = true
                    
                    
                    addSubview(tituloEvento)
                    tituloEvento.adjustsFontSizeToFitWidth = true
                    tituloEvento.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
            //
                      tituloEvento.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                    tituloEvento.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            
      

    //    backgroundColor = .green
    }
    
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
}
