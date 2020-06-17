//
//  searchSongViewController.swift
//  altar
//
//  Created by Juan Moreno on 1/16/20.
//  Copyright © 2020 Juan Moreno. All rights reserved.
//

import UIKit
import Alamofire

class searchSongViewController: UIViewController {

  //  @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var backgroundView: UIView!
    var resultados = [elementoVideo] ()
  //  @IBOutlet weak var lista: UICollectionView!
    weak var lista : UICollectionView!
    var cellId = "cellID"
    var pageToken = ""
    var isLoading = false
    var seleccion = elementoVideo ()
    
    //TODO: BARRA QUE CREE CON TOMAS
    
    var searchBar: UISearchBar = {
        
        let a = UISearchBar ()
        
        a.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        
        return a
    } ()
    
    var tituloDelSearch: UILabel = {
        let a = UILabel ()
        
        a.font = UIFont(name: "Avenir", size: 25)
        a.text = NSLocalizedString("Paste a Youtube link or a keyword to search.", comment: "")
        a.numberOfLines = 0
        a.textColor = .white
        a.textAlignment = .center
        a.adjustsFontSizeToFitWidth = true
        return a
    } ()
    
     override func loadView() {
           super.loadView()

      
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
             let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                
                    self.lista = collectionView
                //    self.lista.backgroundColor = .lightGray
                 view.addSubview(searchBar)

                    
                   searchBar.translatesAutoresizingMaskIntoConstraints = false
                   
                    tituloDelSearch.translatesAutoresizingMaskIntoConstraints = false
         
            //    backgroundView.backgroundColor = advengers.shared.colorBlue
                
                var tamanoBack = CGSize ()
                
              //  tamanoBack.height = view.
             //   tamanoBack.width = view.frame.width
                
             //   backgroundView.sizeThatFits(tamanoBack)
                
                searchBar.barTintColor = .white
                searchBar.isTranslucent = true
                view.addSubview(tituloDelSearch)
                tituloDelSearch.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
                


               searchBar.topAnchor.constraint(equalTo: tituloDelSearch.bottomAnchor, constant: 20).isActive = true
               searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
                searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
               
        //        lista.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        //        lista.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        //        lista.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
                
                   self.view.addSubview(lista)
                   lista.translatesAutoresizingMaskIntoConstraints = false
                lista.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor ,right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 470)
        lista.backgroundColor = advengers.shared.colorBlue
        //searchBar.searchBarStyle = .prominent
          //      view.backgroundColor =
                backgroundView.backgroundColor = advengers.shared.colorBlue

        searchBar.delegate = self

        lista.dataSource = self
        lista.delegate = self 
        lista.register(VideoResultcolCollectionViewCell.self, forCellWithReuseIdentifier: cellId)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func searchToYouTube (busqueda: String) {
    
      //  resultados.removeAll()
        
        if busqueda.contains("https://www.youtube.com/watch?v=") {
            
            print("Direccion tinee")
            
            // ?v=
              if let rangeOfZero3 = busqueda.range(of: "?v=", options: .backwards) {
              var suffixC = String(busqueda.suffix(from: rangeOfZero3.upperBound))
                 // suffixC.popLast()
                //  websiteInfo = suffixC
                //  listaDeEmails = listaDeEmails + "http://" + websiteInfo + "\n"
                  print(suffixC)
                
                if suffixC.contains ("=") {
                           
                          var rangeOfZero4 = suffixC.range(of: "=", options: .backwards)
                           let suffixZ = String(suffixC.prefix(upTo: rangeOfZero4!.lowerBound))
                           
                            print("llego la selecciono")
                           print(suffixZ)
                       
                           suffixC = suffixZ
                       }

                advengers.shared.seleccionVideo.videoId = suffixC
                //return
            
              }

   
            //advengers.shared.seleccionVideo = a
            performSegue(withIdentifier: "selecionVideo", sender: self)
            return
            
        } else {
            
              print("No tiene")
        }

        let parameters = ["part": "snippet", "key" : "AIzaSyCEDNW-3mRvjhXq33TG2AhkOThqqEGaIY0", "q": busqueda, "order": "viewCount", "maxResults": "20", "type":"video", "pageToken": pageToken]
         
        AF.request("https://www.googleapis.com/youtube/v3/search", parameters: parameters).responseJSON { response in
            print(response.debugDescription)
            print(response.data)
            print("----------------------------------------")
            print("Response: \(response)")
            
            do {


                let decoded = try JSONDecoder().decode(YTResult.self, from: response.data!)
                
                
                for itema in decoded.items {
                    
                    var a = elementoVideo()
                    a.title = itema.snippet.title
                    a.description = itema.snippet.description
                    a.urlImage = itema.snippet.thumbnails.medium.url
                    a.videoId = itema.id.videoId
                    
                    self.resultados.append(a)
                    
                    self.lista.reloadData()
                    
                }
               
            
      


                //Now access the data
                print(decoded.pageInfo.resultsPerPage) // 25

                //since the items is array we take first for now
                if  let firstItem = decoded.items.first {
                    //to print the first one
                    print(firstItem.snippet.channelTitle) // "fouseyTUBE"

                    //same for URL
                    print(firstItem.snippet.thumbnails.medium.url) //
                }
                
                print(self.resultados.count)
                
                self.pageToken = decoded.nextPageToken


            } catch {
                debugPrint("\(error.localizedDescription)")
                
                
                
            }
            
            
                 }
       
    }

}

extension searchSongViewController: UISearchBarDelegate {
    

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text)
        if let aBuscar = searchBar.text {
        searchToYouTube(busqueda: aBuscar)
        }
      //  searchBar.text = ""
        
    }
    
}


extension searchSongViewController: UICollectionViewDataSource {
    
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return resultados.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? VideoResultcolCollectionViewCell)!
        
        if resultados.count > 0 {
        
        cell.resultado = resultados[indexPath.row]
       
        }
       return cell
   }
    
    
    
    
}

extension searchSongViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     //   let a = seleccionVideoViewController ()
    //    a.seleccionVideo = resultados[indexPath.row]
        advengers.shared.seleccionVideo = resultados[indexPath.row]
        performSegue(withIdentifier: "selecionVideo", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selecionVideo" {
            
            let a = seleccionVideoViewController ()
            a.seleccionVideo = seleccion
        }
    }
   

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height

            if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
                loadMoreData()
            }
        }
    
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                // Fake background loading task for 2 seconds
                sleep(2)
                if let aBuscar = self.searchBar.text {
                    self.searchToYouTube(busqueda: aBuscar)
                }
                DispatchQueue.main.async {
                    self.lista.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    
}


extension searchSongViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 140)
    }

    /*
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
 
 */
    
}
