//
//  AlbumCollectionViewController.swift
//  Project1
//
//  Created by Yujin Robot on 27/08/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker

class AlbumCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    var cellReaders:Array = ["교회마크.png","수빈.png","이삭.png","다은.png","아형.png","현지.png","예원.png","성애.png","경석.png","김지원.png","해리.png","김예슬.png","우지원.png","숙영.png","지애.png","민정.png","다함.png"]
    var photoArray = [UIImage]()
    var selectedAssets = [PHAsset]()
    var selectedImageIndex = Int()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoArray = [UIImage(named: "교회마크.png")] as! [UIImage]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
//        albumCell.ganaanImage.image = UIImage(named: photoArray[indexPath.item])

        albumCell.ganaanImage.image = photoArray[indexPath.item]
        
        albumCell.ganaanImage.tag = indexPath.item
        
        return albumCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let senderTag = indexPath.item
        
        if senderTag == 0 {
            getImageFromLibrary()
        } else {
            self.performSegue(withIdentifier: "ToDashBoard", sender: senderTag)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DashBoardViewController {
            viewController.contentImageData = photoArray as NSArray
            viewController.selectedImageIndex = sender as! Int
        }
    }
    
    func getImageFromLibrary() {
        let vc = BSImagePickerViewController()
        self.bs_presentImagePickerController(vc, animated: true,
                                             select: {(asset: PHAsset) -> Void in },
                                             deselect: {(asset: PHAsset) -> Void in },
                                             cancel: {(asset: [PHAsset]) -> Void in },
                                             finish: {(asset: [PHAsset]) -> Void in
                                                for i in 0..<asset.count {
                                                    self.selectedAssets.append(asset[i])
                                                }
                                                self.convertAssetToImages()         },
                                             completion: nil)
    }
    
    func convertAssetToImages() {
        if selectedAssets.count != 0 {
            for i in 0..<selectedAssets.count {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                
                var thumbnail = UIImage()
                
                option.isSynchronous = true
                
                manager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
                    thumbnail = result!
                })
                
                let data = thumbnail.pngData()
                let newImage = UIImage(data: data!)
                self.photoArray.append(newImage! as UIImage)
            }
        }
        self.collectionView.reloadData()
        self.selectedAssets.removeAll()
    }
    
}
