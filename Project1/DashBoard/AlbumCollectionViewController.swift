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
import FirebaseFirestore

class AlbumCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageTaskDownloadedDelegate {
    
    
    var album: AlbumEntity!
    var imageEntities: [ImageEntity]?
    var imageTasks = [String: ImageTask]()
    var queryListener: ListenerRegistration!
    
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    var selectedPhoto: (index: Int, contentViewController: ContentViewController)?
    
    var images = [UIImage]()
    
    var photoArray = [UIImage]()
    var selectedAssets = [PHAsset]()
    var selectedImageIndex = Int()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = album?.name
        photoArray = [UIImage(named: "교회마크.png")] as! [UIImage]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        queryListener = ImageService.shared.getAllImagesFor(albumId: album.albumId) { [weak self] images in
            guard let strongSelf = self else { return }
            strongSelf.imageEntities = images
            strongSelf.updateImageTasks()
            
            if images.isEmpty {
                strongSelf.collectionView.addNoDataLabel(text: "No Photos added yet.\n\nPlease press the + button to begin")
            } else {
                strongSelf.collectionView.removeNoDataLabel()
            }
            
            strongSelf.collectionView.reloadData()
//            strongSelf.activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParent {
            queryListener.remove()
        }
    }
    
    func updateImageTasks() {
        imageEntities?.forEach { imageEntity in
            if imageEntity.status == .ready, imageTasks[imageEntity.imageId] == nil, let urlStr = imageEntity.url, let url = URL(string: urlStr) {
                imageTasks[imageEntity.imageId] = ImageTask(id: imageEntity.imageId, url: url, session: urlSession, delegate: self)
            }
        }
    }
    
    func imageDownloaded(id: String) {
        if let index = imageEntities?.firstIndex(where: { $0.imageId == id }) {
            collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            
            if let selectedPhoto = self.selectedPhoto, selectedPhoto.index == index, imageEntities?.count ?? 0 > index, let imageEntity = imageEntities?[index], let imageTask = imageTasks[imageEntity.imageId], let image = imageTask.image {
                selectedPhoto.contentViewController.contentImage = image
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageEntities?.count ?? 0
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
//        albumCell.ganaanImage.image = UIImage(named: photoArray[indexPath.item])

        albumCell.ganaanImage.image = photoArray[indexPath.item]
        
//        if let imageEntities = imageEntities, imageEntities.count > indexPath.row {
//            let imageEntity = imageEntities[indexPath.row]
//            albumCell.configure(image: imageTasks[imageEntity.imageId]?.image)
//        }
        
        albumCell.ganaanImage?.tag = indexPath.item
        
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
        
        if segue.identifier == "SelectPhotosSegue", let selectPhotosController =
            segue.destination.children.first as? SelectPhotosViewController {
            selectPhotosController.album = album
        }
        
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
                                                self.convertAssetToImages()
        },
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
//                self.images.append(newImage!)
                
//                DispatchQueue.main.async {
//                    self.imageUploadStorage()
//                }
            }
        }
        self.collectionView.reloadData()
        self.selectedAssets.removeAll()
    }
    
    func imageUploadStorage() {
        if let selectedIndexs = collectionView.indexPathsForSelectedItems {
            let imagesDataToUpload = selectedIndexs
                .map{ $0.row }
                .map{ photoArray[$0] }
                .map{ $0.pngData() }
            
            ImageService.shared.upload(images: imagesDataToUpload as! [Data], albumId: album.albumId) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.collectionView.reloadData()
    }
    
    
}
