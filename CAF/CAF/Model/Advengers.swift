//
//  Advengers.swift
//  altar
//
//  Created by Juan Moreno on 9/13/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import Firebase


class advengers {
    
    // --- The Singleton tharaaaaaaaaa
    
    var isPastor = false
    
    
    static let shared = advengers ()
    
    let usersStatusRef = Database.database().reference(withPath: "users")


    
    // -------------------- NEWS TOOOLS -------------------
    let lastNewsRef = Database.database().reference().child ("last_news")
    // var newsfeeds = [newFeed (newsDate: "", url: "", thumbURL: "", title: "", subtitle: "", bodyText: "")]
    
   let  postPrayFeed = Database.database().reference().child ("post_pray_feed")
    let PostPrayStorage = Storage.storage().reference().child("post_pray_feed")
    
    var currentChurch = "CAF"
 //   var currentChurchID = ""
    var currentChurchInfo = Church (dictionary: ["":""])
    
    //var currentActiveChannel = wChannel (dictionary: ["":""])
    let storageRef = Storage.storage().reference()
    
    let pathsRef = Database.database().reference().child ("Paths")
    
    let mediaRef = Database.database().reference().child ("Media")
    
    let colorBlue = UIColor.rgb(red: 32, green: 36, blue: 47)
    let colorOrange = UIColor.rgb(red: 245, green: 75, blue: 100)
    
    var loginInProcess = false
    
    var currenUSer = ["church": "",
                      "email": "",
                      "name":"",
                      "photoURL":"",
                      "userid":"",
                      "title":"",
                      "churchID":"F226E978-BE2F-46C4-82A6-7AFE18A8E114",
                      "isPastor": 0,
                      "uid":"",
                      "fcmToken":[""],
                      "inbox":["":0]
                     
        ] as! [String : Any] 
    

    var updateToPastor = false
    
    enum postType: String {
        case textOnly = "textOnly"
        case imageOnly = "imageOnly"
        case audio = "audio"
        case audioText = "audioText"
        case textImage = "textImage"
        case textBkground = "textBkground"
    }
    
    
    var seleccionVideo = elementoVideo ()

    var devocionalSeleccinado = Devo (dictionary: ["fsd":"FDSFSD"])
    
    var eventolSeleccinado = Event (dictionary: ["fsd":"FDSFSD"])
    
    var eventolSeleccinadoIndex = 0
    
     var eventolToDelete = Event (dictionary: ["fsd":"FDSFSD"])
    
    var fondoSeleccionado = ""
    
  //  var chatIndexSelection = IndexPath()
     var mensajesTotales =  0
    
    var fondoSeleccionadoIndex = ""
    
    var remitentes = [User] ()
    
    
     @objc  func settings () {
        
        print("Leggo")
    }
    
    
    private init() {
        
    }
    
    // Singleton POWER
    
    
  
    
    
}
