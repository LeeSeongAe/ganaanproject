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
import OpalImagePicker
import SDWebImage

class AlbumCollectionViewController: UIViewController, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageTaskDownloadedDelegate, TitleStackViewDataSource {
    
    var album: AlbumEntity!
    var imageEntities: [ImageEntity]?
    var imageTasks = [String: ImageTask]()
    var queryListener: ListenerRegistration!
    
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    var images = [UIImage]()
    var imageURLs: [URL] = []
    var photoArray = [UIImage]()
    var selectedAssets = [PHAsset]()
    var selectedImageIndex = Int()
    
    @IBOutlet weak var titleStackView: TitleStackView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedPhoto: (index: Int, dashBoardViewController: DashBoardViewController)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedPhoto = nil
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleStackView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectedPhoto = nil
        print(album.albumId)
        
        queryListener = ImageService.shared.getAllImagesFor(albumId: album.albumId) { [weak self] images in
            guard let strongSelf = self else { return }
            strongSelf.imageEntities = images
            
            var urls: [URL] = []
            for imageEntity in images {
                if let urlString = imageEntity.url {
                    urls.append(URL(string: urlString)!)
                }
            }
            strongSelf.imageURLs = urls
            //self!.imageURLs = images.map{ URL(string: $0.url)! }
//            strongSelf.updateImageTasks()
            
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

    
    func imageDownloaded(id: String) {
        if let index = imageEntities?.firstIndex(where: { $0.imageId == id }) {
            
            collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            
            let imageTask = imageTasks[(imageEntities?[index].imageId)!]
            _ = imageTask?.image
            //            photoArray.append(image!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageEntities?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        if let imageEntities = imageEntities, imageEntities.count > indexPath.row {
            let imageEntity = imageEntities[indexPath.item]
            if let urlString = imageEntity.url {
                albumCell.ganaanImage?.sd_setImage(with: URL(string: urlString), completed: nil)
            }
        }
        albumCell.ganaanImage?.tag = indexPath.item
        
        return albumCell
    }
    
    @IBAction func photoAddAction(_ sender: Any) {
        getImageFromLibrary()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToDashBoard", let dashBoardViewController = segue.destination as? DashBoardViewController, let index = sender as? Int, imageEntities?.count ?? 0 > index, let imageEntity = imageEntities?[index] {
            selectedPhoto = (index, dashBoardViewController)
            dashBoardViewController.imageId = imageEntity.imageId
            dashBoardViewController.image = imageTasks[imageEntity.imageId]?.image
            dashBoardViewController.contentImageData = photoArray as NSArray
            dashBoardViewController.imageURLs = imageURLs
            dashBoardViewController.selectedImageIndex = sender as! Int
        }
        
    }
    
    func getImageFromLibrary() {
        
        let imagePicker = OpalImagePickerController()
        presentOpalImagePickerController(imagePicker, animated: true,
                                         select: { (assets) in
                                            //Select Assets
                                            let images = self.getImages(fromAssets: assets)
                                            let imagesDataToUpload = images.map{ return $0.jpegData(compressionQuality: 0.5) }
                                            
                                            ImageService.shared.upload(images: imagesDataToUpload as! [Data], albumId: self.album.albumId) {
                                                self.dismiss(animated: true, completion: nil)
                                            }
        }, cancel: {
            //Cancel
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func getImages(fromAssets assets: [PHAsset]) -> [UIImage] {
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        // this one is key
        requestOptions.isSynchronous = true
        
        var images:[UIImage] = []
        
        for asset in assets
        {
            if (asset.mediaType == PHAssetMediaType.image)
            {
                
                PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: requestOptions, resultHandler: { (pickedImage, info) in
                    if let image = pickedImage {
                        images.append(image)
                    }
                })
                
            }
        }
        return images
    }
    
}


extension AlbumCollectionViewController {
    
    func title(for titleStackView: TitleStackView) -> String? {
        return album?.name
    }
    
    //    func subtitle(for titleStackView: TitleStackView) -> String? {
    //        return nil
    //    }
}
