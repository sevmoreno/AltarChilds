//
//  DevocionalSeleccionadoVideoViewController.swift
//  Favorday
//
//  Created by Juan Moreno on 4/22/20.
//  Copyright © 2020 Juan Moreno. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import WebKit

class DevocionalSeleccionadoVideoViewController: UIViewController {

        
      
        let imagen: CustomImageView = {
                   let iv = CustomImageView()
                   iv.contentMode = .scaleAspectFill
                
                   iv.clipsToBounds = true
                   iv.backgroundColor = .blue
                   return iv
               }()
               
        
        lazy var titulo: UILabel = {
                     let label2 = UILabel ()
                     label2.font = UIFont(name: "Avenir-Heavy", size: 22)
                     label2.text = "You prayed 1"
                  label2.textColor = .white
                  //   button.setImage(UIImage(named: "cellPrayIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
                    // button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
            label2.numberOfLines = 2
                     return label2
                 }()
           
        
        let textoDevocional: UITextView = {
            
            let a = UITextView ()
            
            
            return a
            
        } ()
        
    var videoURL:URL!  // has the form
    
    var videoContainerInCode: WKWebView = {
          let a = WKWebView ()
          
          
          return a
          
      } ()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
             view.backgroundColor = advengers.shared.colorBlue
          //  devo = advengers.shared.devocionalSeleccinado
            
         //   view.backgroundColor = .white
           // textoDevocional.loadAttributedText(urlString: devo.urltexto)
            
            view.addSubview(imagen)
            
            view.addSubview(titulo)
            
            view.addSubview(videoContainerInCode)
            
         //   view.addSubview(textoDevocional)
            
//            if advengers.shared.isPastor {
//
//                navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Delete", comment: ""), style: .plain, target: self, action: #selector(borrarDevo))
//            } else {
//
//            textoDevocional.isEditable = false
//
//            }
            
            
            imagen.loadImage(urlString: advengers.shared.devocionalSeleccinado.photoURL!)
            
            titulo.text = advengers.shared.devocionalSeleccinado.title
       //     view.addSubview(textoDevocional)
            
            imagen.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 250)
            
           
            titulo.anchor(top: nil, left: imagen.leftAnchor, bottom: imagen.bottomAnchor, right: imagen.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
            
            
            let altura = CGFloat(view.frame.width * 0.6093)

        videoContainerInCode.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 320, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: altura)
        
        
    }
    
    override func viewDidLayoutSubviews() {
           
           
        super.viewDidLayoutSubviews()
         
        videoURL = URL(string: advengers.shared.devocionalSeleccinado.urltexto)

        videoContainerInCode.load(URLRequest(url: videoURL))
        
    }
    

}
