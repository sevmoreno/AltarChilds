//
//  PrayViewController.swift
//  altar
//
//  Created by Juan Moreno on 9/13/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import MessageKit
import SDWebImage
import InputBarAccessoryView
import AVFoundation




class UsersViewController: UIViewController, UIScrollViewDelegate, delteEventVideoDelegate {
    
    
    func deletCellD(for cell: EventoVideoCollectionViewCell) {
        print("Llego Delegate")
        
        print(cell.evento?.postID)
        print(cell.evento?.church)
        
        Database.database().reference().child("Events").child((cell.evento?.church)!).child((cell.evento?.postID)!).removeValue()
        
        eventos.removeAll()
            //  eventos.remove(at: advengers.shared.eventolSeleccinadoIndex)
             
            loadEvents(completionHandler: { (success) -> Void in
                 
                 DispatchQueue.main.async {

                     
                 self.eventosCollection.reloadData()
                 }
                 
               
                 
             })
             
             
             
             
    }
    

    @IBOutlet weak var eventosCollection: UICollectionView!
    
    
    @IBOutlet weak var tablaUsuarios: UITableView!

    @IBOutlet weak var contenedor: UIView!
    let accountHelper = AccountHelpers ()
    var users = [User] ()
    @IBOutlet weak var pageController: UIPageControl!
    var slides:[Slide3Type] = []
    var eventos:[Event] = []
    @IBOutlet var scrollView: UIScrollView!
    
    var recive = ChatViewController ()
 
    

    override func viewWillAppear(_ animated: Bool) {
        
        eventosCollection.backgroundColor = advengers.shared.colorOrange

        
        eventosCollection.register(EventoCollectionViewCell.self, forCellWithReuseIdentifier: "evento")
        
          eventosCollection.register(EventoVideoCollectionViewCell.self, forCellWithReuseIdentifier: "eventoVideo")
        
        
        eventosCollection.delegate = self
        eventosCollection.dataSource = self
        
        
        
        navigationItem.title = "              "
        navigationController?.navigationBar.backgroundColor = advengers.shared.colorBlue
        navigationController?.navigationBar.barTintColor = advengers.shared.colorBlue
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingsincon"), style: .plain, target: self, action: #selector(logout))
        
        navigationItem.leftBarButtonItem?.tintColor = advengers.shared.colorOrange
        
  
        
        if advengers.shared.isPastor {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("+ Event", comment: ""), style: .plain, target: self, action: #selector(addEnvent))
            
            
            
            
        }
        
        let textAttributes2 = [NSAttributedString.Key.foregroundColor: advengers.shared.colorOrange,
                               NSAttributedString.Key.font:UIFont(name: "Avenir-Heavy", size: 15)]
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes2 as [NSAttributedString.Key : Any], for: .normal)
        navigationItem.rightBarButtonItem?.tintColor = advengers.shared.colorOrange
        
       
     //     mensajesActuales ()
               
        
    }

    
    
    override func viewDidLoad() {
      
       // mewMessageSearch ()
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "REloadEvent"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "loadEvent"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteEvent), name: NSNotification.Name(rawValue: "deleteEvent"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(mensajesActuales), name: NSNotification.Name(rawValue: "resetCounterMSG"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(reloadDataChats), name: NSNotification.Name(rawValue: "reloadUsuariosChats"), object: nil)
        
        accountHelper.loadCurrentUserInfo { (true) in
        
            if let hayChurch = advengers.shared.currenUSer["churchID"] as? String {
                     
                self.accountHelper.loadCurrentChurch(codigo: hayChurch) { (true) in
                        
                        
                         
                         
                         
                     }
                     
                 }
                 
            
            
        }
        

     self.retriveUsers(completionHandler: { (success) -> Void in


                                                  })


        
        
        loadEvents(completionHandler: { (success) -> Void in
            
            DispatchQueue.main.async {

                
            self.eventosCollection.reloadData()
            }
            
          
            
        })
        
        tablaUsuarios.backgroundColor = advengers.shared.colorBlue
        
        tablaUsuarios.delegate = self
        tablaUsuarios.dataSource = self
        
        view.backgroundColor = advengers.shared.colorBlue
   //     scrollView.delegate = self
        
        
        
        
  //    newSearchForMessage ()
//
//
//
//   mensajesActuales ()
 
    }
    

    
    func loadEvents (completionHandler: @escaping (_ success:Bool) -> Void) {
   
        guard let currentChurchID = advengers.shared.currenUSer["churchID"] as? String else { return }
        Database.database().reference().child ("Events").child(currentChurchID).observeSingleEvent(of: .value, with: { (data) in
            
            
            if let devoFeed = data.value as? [String:NSDictionary] {
                
                for (_,value) in devoFeed
                {
                    
                    let even  = Event (dictionary: value as! [String : Any])
                    
                    
                    
                    
                    self.eventos.append(even)
                    
//
//                    let a = Slide3Type ()
//
//                    a.even?.photoURL = even.photoURL
//                    a.even?.title = even.title
//
//                    self.slides.append(a)
                     self.eventos.sort(by: {$0.creationDate > $1.creationDate})
        
                }
                

                completionHandler(true)
            }
            
            
            if self.eventos.isEmpty {
                print("******************* LLEGA A CREAR *******************")
                let basico = ["church":advengers.shared.currentChurchInfo.uidChurch,
                              "title": advengers.shared.currentChurchInfo.displayname,
                              "postID": "NOID",
                              "message": "NO",
                              "author": Auth.auth().currentUser?.uid,
                              "photoURL":"https://firebasestorage.googleapis.com/v0/b/altar-92d12.appspot.com/o/backgroundsDevSR%2F-M-qdkd9WWOHCrEXBWLJ?alt=media&token=10af4f8f-7403-4060-a57c-4a2838e85e77"]
                let even  = Event (dictionary: basico as! [String : Any])
                
                self.eventos.append(even)
                
                
                DispatchQueue.main.async {

                    
                self.eventosCollection.reloadData()
                }
            }
            
        }, withCancel: { (err) in
            print("Failed to fetch like info for post:", err)
            completionHandler(false)
        })
    }
    

    

    @objc func addEnvent()  {
        
        performSegue(withIdentifier: "addEvent", sender: self)
    }
    
   
    
    @IBAction func logout(_ sender: Any) {
        
       let settingsController = SettingsViewController()
              //
              //
              //        navigationController?.pushViewController(settingsController, animated: true)
                      
                      let navController = UINavigationController(rootViewController: settingsController)
                       navController.modalPresentationStyle = .fullScreen

                      present(navController, animated: true, completion: nil)
        
    }
    

    
    
    @IBAction func reloadData(_ sender: Any) {
        
        
       
        eventos.removeAll()
  
   //     self.tablaUsuarios.reloadData()

        loadEvents(completionHandler: { (success) -> Void in
            
            DispatchQueue.main.async {

                
            self.eventosCollection.reloadData()
                
               
            }
            
          
            
        })
        
    }
    

    
    @objc func deleteEvent () {
        
        
        
        Database.database().reference().child("Events").child(advengers.shared.eventolSeleccinado.church).child(advengers.shared.eventolSeleccinado.postID).removeValue()
        eventos.remove(at: advengers.shared.eventolSeleccinadoIndex)
        
        eventos.removeAll()
             //  eventos.remove(at: advengers.shared.eventolSeleccinadoIndex)
              
             loadEvents(completionHandler: { (success) -> Void in
                  
                  DispatchQueue.main.async {

                      
                  self.eventosCollection.reloadData()
                  }
                  
                
                  
              })
              
        
    }
    
    


// MARK: CHAT FUNTIONS
    
       
        var messages: [Message] = []
        private var docReference: DocumentReference?
        
        
        var fistTime = false
        
        func retriveUsers (completionHandler: @escaping (_ success:Bool) -> Void) -> Void {
               
           self.users.removeAll()
            
               advengers.shared.usersStatusRef.observeSingleEvent(of: .value) { (datasnap) in
                   let usersRead = datasnap.value as! [ String : NSDictionary]
             
                   for (_,value) in usersRead {
                       
                       
                       if let userid = value["userid"] as? String {
                           
                           
                           
                           if userid != Auth.auth().currentUser?.uid
                           {
                               if advengers.shared.currentChurchInfo.uidChurch == value["churchID"] as? String {

                                   let userToShow = User()
                                   userToShow.setup(uid: value["userid"] as? String ?? "", dictionary:  value as! [String : Any])
                                   
                                   
                                   let usuario2Uid = userToShow.userID
                                   
                                   guard let mydictionary = advengers.shared.currenUSer["inbox"] as? [String:Int] else  {return}
                                   
                                //   print("Passa el guard ????")
                                   
                                   if let cantindadDeMensajes = mydictionary[usuario2Uid] {
                                       if cantindadDeMensajes > 0 || userToShow.isPastor > 0{
                                           self.users.insert(userToShow, at: 0)
                                       } else {
                                        //   print("Append lapimera vez")
                                           self.users.append(userToShow)
                                       }
                                   } else {
                                       
                                      //  print("Append la segunda vez")
                                       self.users.append(userToShow)
                                       
                                   }
                                   
                                   
                                   self.tablaUsuarios.reloadData()
                                   
                               }
                               
                               
                           }
                       }
                   }
                   
                   completionHandler(true)
                   
               }
               // advengers.shared.usersStatusRef.removeAllObservers()
               
           }
        


    @objc func reloadDataChats () {

    
    // chatid: String
    
    
    print("LLEGO A RELOAD DATA CHATS")
   // var updateIndex: Int?
    // playSoundMessage ()
    
   // self.users.removeAll()
        
         DispatchQueue.main.async {
    self.retriveUsers(completionHandler: { (success) -> Void in
    
       
             self.tablaUsuarios.reloadData()
     
                                       

                                                                                 })
               }

//    for usario in self.users {
//
//        if usario.userID == chatid {
//
//            guard let indice = self.users.firstIndex(of:usario) else { return }
//            updateIndex = indice
//
//        }
//
//       if  updateIndex != nil {
//
//            self.users[updateIndex!].inbox?[chatid] = 0
//
//            var diction2 = advengers.shared.currenUSer["inbox"] as! [String:Int]
//            diction2.updateValue(1, forKey: chatid)
//            advengers.shared.currenUSer["inbox"] = diction2
//
//
//        if updateIndex != 0 {
//
//            self.users.rearrange(from: updateIndex!, to: 0)
//
//        }
//
//        }
//
//
//
//        self.tablaUsuarios.reloadData()
//    }
//
    

}
    
    
        
        @objc func mensajesActuales () {
            
            print("Llego a mensajes acutales")
           
            let total = advengers.shared.mensajesTotales

            
            
            if let tabItems = self.tabBarController?.tabBar.items
                   {
                    
                    let tabItem = tabItems[3]
                       if advengers.shared.mensajesTotales > 0 {
                               // In this case we want to modify the badge number of the seond tab:
                               
                         // tabItem.badgeValue = String(advengers.shared.mensajesTotales) // set count you need
                               tabItem.badgeValue = "" // set count you need
                         UIApplication.shared.applicationIconBadgeNumber = advengers.shared.mensajesTotales
                      //  advengers.shared.mensajesTotales = 0
                        
                       } else {
                        
                  //     print("no tiene ahora")
                        
                       
                        
                        
                        DispatchQueue.main.async {
                            
    //                        UIApplication.shared.applicationIconBadgeNumber = advengers.shared.mensajesTotales
                            UIApplication.shared.applicationIconBadgeNumber = 0
                           self.tabBarController?.tabBar.items![3].badgeValue = nil
                            self.tabBarController?.reloadInputViews()
                        }

                        //tabItem.badgeValue = nil
                        
                        
                    
                   }
            
        
            
        }
            
        }
        






    }
extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return users.count
        
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellA", for: indexPath) as! UsuariosUITableTableViewCell
        
        cell.foto.loadImage(urlString: users[indexPath.row].photoUser)
        

        
        DispatchQueue.main.async {
            
            
            let usuario2Uid = self.users[indexPath.row].userID
            
            guard let mydictionary = advengers.shared.currenUSer["inbox"] as? [String:Int] else  {return}
            
            print("----------------------------- EN TABLE VIEW ------------------------------")
            print(mydictionary)

            print(self.users[indexPath.row].fullName)
            print(usuario2Uid)
            
            if let cantindadDeMensajes = mydictionary[usuario2Uid] {
                if cantindadDeMensajes > 0 {
                    
                    advengers.shared.mensajesTotales = advengers.shared.mensajesTotales + 1
                    self.mensajesActuales ()
                    
                cell.tieneMensaje.isHidden = false
                } else {
                   cell.tieneMensaje.isHidden = true
                }
            } else {
            
            
              cell.tieneMensaje.isHidden = true
            
            }

            
        }
//
        if self.users[indexPath.row].isPastor == 1 {
            
            cell.pastor.isHidden = false
        } else {
            cell.pastor.isHidden = true
            
        }

        cell.nombre.text = self.users[indexPath.row].fullName
//
      
        
      
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
         let chat = ChatViewController ()
        chat.user2Name = users[indexPath.row].fullName
        chat.user2UID = users[indexPath.row].uid
        chat.user2ImgUrl = users[indexPath.row].photoUser
        

        var diction2 = advengers.shared.currenUSer["inbox"] as! [String:Int]
       
        
        if let mensajeAQuitar = diction2[users[indexPath.row].uid] {
            
            print("Encontro tantos")
            print(mensajeAQuitar)
            
           
                      
                      
                
                   // advengers.shared.mensajesTotales = advengers.shared.mensajesTotales - mensajeAQuitar
            
                    advengers.shared.mensajesTotales = 0
                    print("Estos son los mensajes totales \(mensajeAQuitar)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetCounterMSG"), object: nil)
                   // self.mensajesActuales ()
                    
               
                      
                      
            
            
        }
        
        
      
       
        
            diction2.updateValue(0, forKey: users[indexPath.row].uid)
         //   let diction = [chat.user2UID: 0]
           advengers.shared.currenUSer["inbox"] = diction2
            Database.database().reference().child("users").child( Auth.auth().currentUser!.uid).child("inbox").updateChildValues(diction2)
          //  accountHelper.fetchUserInfo()
        
        
            tableView.reloadRows(at: [indexPath], with: .automatic)
        
        
//            print("LLEGO AQUI")
//            print(diction2)
        
 
    
        navigationController?.pushViewController(chat, animated: true)
        
        
    }
    
    
    
}


// MARK: EVENTS FUNTIONS




extension UsersViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if eventos[indexPath.row].message == "video"{
            
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventoVideo", for: indexPath) as! EventoVideoCollectionViewCell
              cell.evento = eventos[indexPath.row]
            cell.delegate = self
              print("Celda ")
              
            //  cell.backgroundColor = UIColor.cyan
              
              return cell
            
        } else  {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "evento", for: indexPath) as! EventoCollectionViewCell
              cell.evento = eventos[indexPath.row]
              print("Celda ")
              
            //  cell.backgroundColor = UIColor.cyan
              
              return cell
            
        }
 
    }
    

    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           // let width = (view.frame.width - 2) / 3
            return CGSize(width: view.frame.width, height: 300)
        }
        

        // METODO QUE HABLA DEL ESPACING
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Selecciono Evento")
      
         if eventos.count > 0 {
             
            if eventos[indexPath.row].postID != "NOID" {
        
         advengers.shared.eventolSeleccinado = eventos[indexPath.row]
       //  advengers.shared.eventolSeleccinadoIndex = pageController.currentPage
         
         let devocionalSeleccionado = EventoSeleccionado ()
         // performSegue(withIdentifier: "aEvent", sender: self)
         navigationController?.pushViewController(devocionalSeleccionado, animated: true)
            }
         }
    }
    

}


extension UsersViewController: UITextViewDelegate {
    
    
}
extension RangeReplaceableCollection where Indices: Equatable {
    mutating func rearrange(from: Index, to: Index) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid indices")
        insert(remove(at: from), at: to)
    }
}
