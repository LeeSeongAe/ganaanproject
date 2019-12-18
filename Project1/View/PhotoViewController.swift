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

class PhotoViewController: UIViewController, TitleStackViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var albums: [AlbumEntity]?
    var queryListener: ListenerRegistration!
//    var imageEntities: [ImageEntity]?
//    var imageTasks = [String: ImageTask]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albumNameArr = [AlbumDTO]()
    var uidKey : [String] = []
    
    var flag = false
    
    enum AlBumViewBarType {
        case around, album
    }
    
    var albumViewBarType: AlBumViewBarType = .album
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var albumAddButton: UIBarButtonItem!
    //    @IBOutlet weak var photoStackView: PhotoStackView!
    @IBOutlet weak var titleStackView: TitleStackView!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
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
        
        self.albumNameArr.removeAll()
        
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gesture:))))

        if CurrentUser.shared.currentUserEmail(email: "ganaanadmin@gmail.com") {
            albumAddButton.isEnabled = true
        } else {
            albumAddButton.isEnabled = false
        }
        
        if flag == true {
            self.navigationItem.setHidesBackButton(false, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleStackView.reloadData()

        setNavigationItem(for: getNavigationType())
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
    
    private func getNavigationType() -> AlBumViewBarType {
        
        if flag {
            return .around
        }
        
        return .album
    }
    
    
    private func setNavigationItem(for albumViewBarType: AlBumViewBarType) {
        
        switch albumViewBarType {
        case .album:
            break
        case .around:
            let navView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
            navView.backgroundColor = .white
            
            let backButton = UIButton(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
            backButton.setImage(UIImage(named: "지애"), for: .normal)
            backButton.setTitle("Back", for: .normal)
            backButton.addTarget(self, action: #selector(backIntroView), for: .touchUpInside)
            self.view.addSubview(navView)
            navView.addSubview(backButton)
            break
        }
    }
    
    @objc func backIntroView() {
        self.dismiss(animated: true, completion: nil)
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
            photoCell.configure(albumName: album.name, createdOn: album.dateCreated, numberOfPhotos: album.numberOfPhotos)
        }
        
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToAlbumStory", sender: indexPath.item)
        collectionView.deselectItem(at: indexPath, animated: true)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAlbumStory", let index = sender as? Int, let albumCollectionViewController = segue.destination as? AlbumCollectionViewController, let album = albums?[index] {
            albumCollectionViewController.album = album
        }
    }
    
    @objc func handleLongPressGesture(gesture: UIGestureRecognizer) {
        
        if CurrentUser.shared.currentUserEmail(email: "ganaanadmin@gmail.com") && CurrentUser.shared.loginCheck! == true {
            let location = gesture.location(in: self.collectionView)
            guard let indexPath = collectionView.indexPathForItem(at: location) else {return}
            let item = albums![indexPath.row]
            
            let alert = UIAlertController(title: nil, message: "Remove \(item)", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
                if let albumId = self.albums?[indexPath.row].albumId {
                    AlbumService.shared.deleteAlbumWith(albumId: albumId)
                }
                self.collectionView.deleteItems(at: [indexPath])
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}

//Datasource
extension PhotoViewController {
    
    func title(for titleStackView: TitleStackView) -> String? {
        return "GanaanYouth Album 📸"
    }
    
//    func subtitle(for titleStackView: TitleStackView) -> String? {
//        return nil
//    }
}
