//
//  DevotionalCollectionViewCell.swift
//  altar
//
//  Created by Juan Moreno on 1/6/20.
//  Copyright © 2020 Juan Moreno. All rights reserved.
//

import Firebase

protocol devotionalDelegate {

    func deletCellD(for cell: DevotionalCollectionViewCell)
}

class DevotionalCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    let contenedor = UIView()
    
     var delegate: devotionalDelegate?
    
    var post: Devo? {
        
        didSet {
           
              guard let imagenDevo = post!.photoURL else { return }
            
             imagenDevocional.loadImage(urlString: imagenDevo)
            imagenDevocional.contentMode = .scaleAspectFill
            guard let titulotext = post?.title else { return }
            
            titulo.text = titulotext
            
            
            let fecha = post?.creationDate
                     //  let fecha = Date(milliseconds: Int64(post?.creationDate ?? 0))
                       
            praysDate.text = fecha!.timeAgoDisplay()
            
            if post?.message == "video" {
                
            } else {
                
                
            }

        }
        

    }
    
    
    
    
    lazy var imagenDevocional: CustomImageView = {


        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
          iv.clipsToBounds = true
       iv.backgroundColor = .blue
        return iv
    }()
    
    lazy var iconoVideo: UIImageView = {
        
        let a = UIImageView ()
        
        
        
        return a
        
    } ()
    
    lazy var titulo: UILabel = {
              let label2 = UILabel ()
              label2.font = UIFont(name: "Avenir-Black", size: 25)
              label2.text = "You prayed 1"
           label2.textColor = .white
        label2.numberOfLines = 2
           //   button.setImage(UIImage(named: "cellPrayIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
             // button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
              return label2
          }()
    
    lazy var praysDate: UILabel = {
                 let label2 = UILabel ()
                 label2.font = UIFont(name: "Avenir-Medium", size: 12)
                 label2.text = ""
                 label2.textColor = .white
                 label2.layer.backgroundColor = advengers.shared.colorOrange.cgColor
        label2.layer.cornerRadius = 5
        label2.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
              //   button.setImage(UIImage(named: "cellPrayIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
                // button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
                 return label2
             }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
  contenedor.isHidden = true
        
    addSubview(imagenDevocional)
        
    imagenDevocional.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(titulo)
        
        titulo.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 50, paddingRight: 15, width: frame.size.width, height: 0)
       // titulo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
      //  imagenDevocional.image = UIImage(named: "devoback1")
        
       // let mastamano = 20.0 + titulo.frame.width
        addSubview(praysDate)
        praysDate.textAlignment = .center
        praysDate.anchor(top: nil, left: titulo.leftAnchor, bottom: titulo.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 90, height: 0)
        

       
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
                
                contenedor.isHidden = false
                
                if advengers.shared.isPastor == true {

                print("Swiper no Swiper !!!!")
                
                

                addSubview(contenedor)
                
                contenedor.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 0)
                contenedor.backgroundColor = .red
                
                let deleteB = UIButton ()
                
                deleteB.addTarget(self, action: #selector(borrar), for: .touchDown)
               // deleteB.titleLabel?.text = "Delete"
              //  deleteB.tintColor = .white
                deleteB.setTitle("Delete", for: .normal)
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
                contenedor.isHidden = true
                delegate?.deletCellD(for: self)
            }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
