//
//  AlbumCollectionViewController.swift
//  Project1
//
//  Created by Yujin Robot on 27/08/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import Photos
import FirebaseFirestore

class AlbumCollectionViewController: UIViewController, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageTaskDownloadedDelegate, TitleStackViewDataSource {
    
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
    
    @IBOutlet weak var titleStackView: TitleStackView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
//        self.title = album?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleStackView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectedPhoto = nil
        
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
        return imageEntities?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        if let imageEntities = imageEntities, imageEntities.count > indexPath.row {
            let imageEntity = imageEntities[indexPath.item]
            albumCell.configure(image: imageTasks[imageEntity.imageId]?.image)
        }
        
        albumCell.ganaanImage?.tag = indexPath.item
        
        return albumCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SelectPhotosSegue" {
            getImageFromLibrary()
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
        },
                                             completion:nil)
    }

        
    func bs_presentImagePickerController(_ imagePicker: BSImagePickerViewController, animated: Bool, select: ((_ asset: PHAsset) -> Void)?, deselect: ((_ asset: PHAsset) -> Void)?, cancel: (([PHAsset]) -> Void)?, finish: (([PHAsset]) -> Void)?, completion: (() -> Void)?, selectLimitReached: ((Int) -> Void)? = nil) {
        BSImagePickerViewController.authorize(fromViewController: self) { (authorized) -> Void in
            // Make sure we are authorized before proceding
            guard authorized == true else { return }
            
            // Set blocks
            imagePicker.photosViewController.selectionClosure = select
            imagePicker.photosViewController.deselectionClosure = deselect
            imagePicker.photosViewController.cancelClosure = cancel
            imagePicker.photosViewController.finishClosure = finish
            imagePicker.photosViewController.selectLimitReachedClosure = selectLimitReached
            imagePicker.photosViewController.album = self.album
            // Present
            self.present(imagePicker, animated: animated, completion: completion)
        }
    }
    
}


extension AlbumCollectionViewController {
    
    func title(for titleStackView: TitleStackView) -> String? {
        return album?.name
    }
    
    func subtitle(for titleStackView: TitleStackView) -> String? {
        return nil
    }
}
