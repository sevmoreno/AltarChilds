//
//  SeleccionTipodeDevocionalViewController.swift
//  Favorday
//
//  Created by Juan Moreno on 4/22/20.
//  Copyright © 2020 Juan Moreno. All rights reserved.
//

import UIKit

class SeleccionTipodeDevocionalViewController: UIViewController {
    
    
    let conTexto: UIButton = {
        
        let a = UIButton ()
        
        a.setTitle(NSLocalizedString("Text Devotional", comment: ""), for: .normal)
   //     a.alignmentRectInsets = 2
        
        a.layer.borderColor = advengers.shared.colorOrange.cgColor
        a.layer.borderWidth = 3
        

        return a
        
    } ()
    
    
    
       let conVideo: UIButton = {
           
           let a = UIButton ()
           
           a.setTitle(NSLocalizedString("Video Devotional", comment: ""), for: .normal)
      //     a.alignmentRectInsets = 2
           
           a.layer.borderColor = advengers.shared.colorOrange.cgColor
           a.layer.borderWidth = 3
           

           return a
           
       } ()

    @objc func iratexto () {
        
        print ("ir a Texto ")
      
        
        performSegue(withIdentifier: "conTexto", sender: self)
        
    }
    
    
    @objc func iraVideo () {
        
        print ("ir a Video ")
      
        
        performSegue(withIdentifier: "conVideo", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conTexto.addTarget(self, action: #selector(iratexto), for: .touchDown)
        conVideo.addTarget(self, action: #selector(iraVideo), for: .touchDown)
        view.backgroundColor = advengers.shared.colorBlue
        
        view.addSubview(conTexto)
        conTexto.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width - 40, height: (view.frame.height / 2) - 100)
        
        view.addSubview(conVideo)
        
        conVideo.anchor(top: conTexto.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width - 40, height: (view.frame.height / 2) - 100)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
