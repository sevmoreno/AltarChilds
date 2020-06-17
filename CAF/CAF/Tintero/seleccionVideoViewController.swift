//
//  seleccionVideoViewController.swift
//  altar
//
//  Created by Juan Moreno on 1/17/20.
//  Copyright © 2020 Juan Moreno. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class seleccionVideoViewController: UIViewController, UITextViewDelegate {
    
    
    var seleccionVideo: elementoVideo!
    
    var videoURL:URL!  // has the form "https://www.youtube.com/embed/videoID"
      var didLoadVideo = false
    var altura: CGFloat = 0.0
    
  //  @IBOutlet weak var videoConteiner: WKWebView!
    
    var tituloSeleccionado: String = ""
    
    var videoContainerInCode: WKWebView = {
        let a = WKWebView ()
        
        
        return a
        
    } ()
    
    var devText: UITextView = {
        
        let a = UITextView ()
        
        
        
        return a
        
    } ()
    
    var bottonCambiarPic: UIButton = {
        
        let a = UIButton ()
        a.setTitle(NSLocalizedString("Change background", comment: ""), for: .normal)
  
        a.setTitleColor(advengers.shared.colorOrange, for: .normal)
        
        a.titleLabel?.font = UIFont(name: "Avenir", size: 10)
        return a
    } ()
    
    var titulo: UITextView = {
        
        let a = UITextView ()
        
       // a.numberOfLines = 2
        a.font = UIFont(name: "Avenir-Heavy", size: 16)
        a.text = NSLocalizedString("Devotional video title", comment: "")
        a.textColor = .white
        a.textAlignment = .left
        a.backgroundColor = .clear
        return a
        
    } ()
    var fondo = ""
    
    var fondovisual: CustomImageView  = {
        
        let a = CustomImageView ()
        a.loadImage(urlString: advengers.shared.fondoSeleccionado)
        
        return a
        
    } ()
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        
    }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        tituloSeleccionado = textView.text ?? ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        tituloSeleccionado = textView.text ?? ""
    }
//    private func textFieldDidBeginEditing(_ textField: UITextView) {
//        textField.text = ""
//    }
//
//    func textViewDidChangeSelection(_ textField: UITextView) {
//
//        tituloSeleccionado = textField.text ?? ""
//
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//
//        tituloSeleccionado = textField.text ?? ""
//    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        view.backgroundColor = advengers.shared.colorBlue
        fondovisual.backgroundColor = .red
        
        titulo.delegate = self
        
        view.addSubview(fondovisual)
        fondovisual.contentMode = .scaleAspectFill
        
        view.addSubview(bottonCambiarPic)
        view.addSubview(titulo)
        
        view.addSubview(videoContainerInCode)
     //   view.addSubview(devText)
        
       altura = CGFloat(view.frame.width * 0.6093)
        
        fondovisual.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 250)
        
        fondovisual.clipsToBounds = true
        
        bottonCambiarPic.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 70, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 100, height: 80)
        
        titulo.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 180, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 80)
        
//
//        devText.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 80)
        
        
        videoContainerInCode.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 320, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: altura)
        
        
        DispatchQueue.main.async {
            self.fondovisual.loadImage(urlString: "https://firebasestorage.googleapis.com/v0/b/altar-92d12.appspot.com/o/backgroundsDevSR%2F-M-qdkcToEv4HU051_Iq?alt=media&token=c81ad0f4-ee3b-459c-89f2-7b5be3f7c7b6")
        }
        
        
        bottonCambiarPic.addTarget(self, action: #selector(changeFondo), for: .touchDown)
        

    }
    
    
    @objc func changeFondo () {
        
        let newViewController = SeleccionFotoCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
               self.navigationController?.pushViewController(newViewController, animated: true)
                
               
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Post", comment: ""), style: .plain, target: self, action: #selector(postDevo))
        navigationItem.leftBarButtonItem?.title = NSLocalizedString("Back", comment: "")
        
        
         let attributostitulo = [
           
         //  NSAttributedString.Key.underlineStyle : 1,
            NSAttributedString.Key.foregroundColor : advengers.shared.colorOrange,
           NSAttributedString.Key.font: UIFont(name: "Avenir", size: 15)
         //  NSAttributedString.Key.strokeWidth : 3.0
              
           ] as [NSAttributedString.Key : Any]
        // let font = UIFont(name: "Avenir", size: 15)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributostitulo, for: .normal)
        
        navigationItem.rightBarButtonItem?.tintColor = advengers.shared.colorOrange
        
        
          if advengers.shared.fondoSeleccionado == "" {
              fondo = "https://firebasestorage.googleapis.com/v0/b/altar-92d12.appspot.com/o/backgroundsDevSR%2F-M-qdkcToEv4HU051_Iq?alt=media&token=c81ad0f4-ee3b-459c-89f2-7b5be3f7c7b6"
          } else {
              fondo = advengers.shared.fondoSeleccionado
          }
        fondovisual.loadImage(urlString: advengers.shared.fondoSeleccionado)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
     super.viewDidLayoutSubviews()
        
        /*
        videoURL = URL(string: "https://www.youtube.com/embed/" + seleccionVideo.videoId)
        print(videoURL.lastPathComponent)
        */

        
//    var embedVideoHtml:String {
//        return """
//        <!DOCTYPE html>
//        <html>
//        <body>
//        <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
//        <div id="player"></div>
//
//        <script>
//        var tag = document.createElement('script');
//
//        tag.src = "https://www.youtube.com/player_api";
//        var firstScriptTag = document.getElementsByTagName('script')[0];
//        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
//
//        var player;
//        function onYouTubeIframeAPIReady() {
//        player = new YT.Player('player', {
//        playerVars: { 'autoplay': 1, 'controls': 1, 'fs': 0, 'playsinline': 1 },
//        height: '\(Int(altura))',
//        width: '\(view.frame.width)',
//        videoId: '\(advengers.shared.seleccionVideo.videoId)',
//        events: {
//        'onReady': onPlayerReady
//        }
//        });
//        }
//
//        function onPlayerReady(event) {
//        event.target.playVideo();
//        }
//        </script>
//        </body>
//        </html>
//        """
//    }
//    

        
        print("Este es el elemnto en Seleccion video")
        
        print(advengers.shared.seleccionVideo.videoId)
    //    print(videoConteiner.frame.width)
        
        
  //   if !didLoadVideo {
        
      //  videoConteiner.loadHTMLString(embedVideoHtml, baseURL: nil)
        print("****** Ancho **********")
        print(view.frame.width)
        print(altura)
       // videoContainerInCode.loadHTMLString(embedVideoHtml, baseURL: nil)
      
        videoURL = URL(string: "https://www.youtube.com/embed/" + advengers.shared.seleccionVideo.videoId)

        videoContainerInCode.load(URLRequest(url: videoURL))
        didLoadVideo = true
  //   }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
     @objc func postDevo () {
            
            
            let currentChurchID = advengers.shared.currentChurchInfo.uidChurch
           //  guard let currentChurchID = advengers.shared.currenUSer["churchID"] as? String else { return }
            let userPostRef = Database.database().reference().child("Devotionals").child(currentChurchID)
            
            let filenameA = NSUUID().uuidString
            
            let ref = userPostRef.child(filenameA)
            var fondo = ""
            if advengers.shared.fondoSeleccionado == "" {
                fondo = "https://firebasestorage.googleapis.com/v0/b/altar-92d12.appspot.com/o/backgroundsDevSR%2F-M-qdkcToEv4HU051_Iq?alt=media&token=c81ad0f4-ee3b-459c-89f2-7b5be3f7c7b6"
            } else {
                fondo = advengers.shared.fondoSeleccionado
            }
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
                               
                                                let event = ["urltexto": videoURL.absoluteString,
                                               "church" : currentChurchID,
                                               "author": Auth.auth().currentUser?.uid,
                                               "message": "video",
                                               "photoURL": fondo ,
                                               "devoUID": filenameA,
                                               
                                               "title": self.titulo.text!,
                                               "creationDate": Date().millisecondsSince1970] as [String : Any]
                                   
        ref.updateChildValues(event)
                                       
        let postnoto1 = [filenameA:currentChurchID]
                                                              
        Database.database().reference().child("Devonoti").updateChildValues(postnoto1)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadDevotional"), object: nil)
        print("Successfully saved post to DB")
                                       
        NotificationCenter.default.post(name: NSNotification.Name("reloaddata"), object: nil)
            
           // _ = navigationController?.popViewController(animated: true)

            _ = navigationController?.popToRootViewController(animated: true)
        }


}
