//
//  PhotoViewController.swift
//  Project1
//
//  Created by Yujin Robot on 07/06/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PhotoViewController: UIViewController, TitleStackViewDataSource, TitleStackViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CustomAlertViewDelegate
{
    
    
    func titleStackView(_ titleStackView: TitleStackView, longPressedTitleLabel titleLabel: UILabel) {
        
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var albums: [AlbumEntity]?
    var queryListener: ListenerRegistration!
    var imageEntities: [ImageEntity]?
//    var imageTasks = [String: ImageTask]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albumNameArr = [AlbumDTO]()
    var uidKey : [String] = []
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var albumAddButton: UIBarButtonItem!
    //    @IBOutlet weak var photoStackView: PhotoStackView!
    @IBOutlet weak var titleStackView: TitleStackView!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width - 10
        screenHeight = screenSize.height
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController()?.panGestureRecognizer()
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        titleStackView.backgroundColor = .yellow
        
        self.albumNameArr.removeAll()
        
//        Database.database().reference().child("Photo").observe(.childAdded, with: {(snapshot) in
//            print(snapshot.value!)
//            print(snapshot.key)
//
//            let albumDTO = AlbumDTO()
//            albumDTO.albumName = (snapshot.value as! [String:String])["AlbumName"]
//
//            self.albumNameArr.append(albumDTO)
//            self.uidKey.append(snapshot.key)
//            print("albumNameArr : \(self.albumNameArr)")
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleStackView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        queryListener = AlbumService.shared.getAll { albums in
            self.albums = albums
            
            if albums.isEmpty {
                self.collectionView.addNoDataLabel(text: "No Albums added\n\nPlease press the + button above to start")
            } else {
                self.collectionView.removeNoDataLabel()
            }
            
            self.collectionView.reloadData()
//            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        queryListener.remove()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return albumNameArr.count
        return albums?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cellWidth = collectionView.bounds.width/2 - 10
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        photoCell.layer.borderColor = UIColor.black.cgColor
        photoCell.layer.borderWidth = 0.5
        photoCell.layer.cornerRadius = 10
//        photoCell.albumName.text = albumNameArr[indexPath.item].albumName
        if let album = albums?[indexPath.item] {
            photoCell.configure(albumName: album.name, createdOn: album.dataCreated, numberOfPhotos: album.numberOfPhotos)
        }
        
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToAlbumStory", sender: self)
    }
    
    
    @IBAction func albumAdd(_ sender: Any) {
        let alertController = UIAlertController(title: "Add new album", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Album name"
        }
        
        let textField = alertController.textFields![0] as UITextField
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
//            self.activityIndicator.startAnimating()
            AlbumService.shared.addAlbumWith(name: textField.text ?? "No Name")
            alertController.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true)
        
//        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertView
//        customAlert.providesPresentationContextTransitionStyle = true
//        customAlert.definesPresentationContext = true
//        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        customAlert.delegate = self
//        self.present(customAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAlbumStory", let index = sender as? Int, let albumCollectionViewController = segue.destination as? AlbumCollectionViewController, let album = albums?[index] {
            albumCollectionViewController.album = album
        }
    }

}


//Datasource
extension PhotoViewController {
    
    func title(for titleStackView: TitleStackView) -> String? {
        return "송가청 앨범"
    }
    
    func subtitle(for titleStackView: TitleStackView) -> String? {
        return nil
    }
}
