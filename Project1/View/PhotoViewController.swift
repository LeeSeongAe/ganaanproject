//
//  PhotoViewController.swift
//  Project1
//
//  Created by Yujin Robot on 07/06/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import Firebase

class PhotoViewController: UIViewController, TitleStackViewDataSource, TitleStackViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CustomAlertViewDelegate
{
    
    
    func titleStackView(_ titleStackView: TitleStackView, longPressedTitleLabel titleLabel: UILabel) {
        
    }
    
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
        
        Database.database().reference().child("Photo").observe(.childAdded, with: {(snapshot) in
            print(snapshot.value!)
            print(snapshot.key)
            
            let albumDTO = AlbumDTO()
            albumDTO.albumName = (snapshot.value as! [String:String])["AlbumName"]
            
            self.albumNameArr.append(albumDTO)
            self.uidKey.append(snapshot.key)
            print("albumNameArr : \(self.albumNameArr)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleStackView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumNameArr.count
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
        photoCell.albumName.text = albumNameArr[indexPath.item].albumName
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToAlbumStory", sender: self)
    }
    
    
    @IBAction func albumAdd(_ sender: Any) {
        
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
    
    func okButtonTapped(textFieldValue: String, profileImage: UIImage) {
        
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            if let newData = textFieldValue as? String, newData != "" {
                
                // Create a root reference
                let storageRef = Database.database().reference()
                
                let reversRef = storageRef.child("Photo").childByAutoId()
                
                let now = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
//                let currDate = dateFormatter.string(from: now as Date)
                
                reversRef.setValue([
                    "AlbumName" : textFieldValue
                    ])
            }
            
//            self.albumNameArr.append(textFieldValue)
            
//            let indexPath = IndexPath(row: self.albumNameArr.count - 1, section: 0)
//            self.collectionView.insertItems(at: [indexPath])
//
//            CATransaction.commit()
//
//            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            self.collectionView.reloadData()
        }
    }
    
    func cancelButtonTapped() {
        
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
