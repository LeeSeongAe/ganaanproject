//
//  SelectPhotosViewController.swift
//  SwiftFirestorePhotoAlbum
//
//  Created by Alex Akrimpai on 15/09/2018.
//  Copyright © 2018 Alex Akrimpai. All rights reserved.
//

import Foundation
import Photos

class SelectPhotosViewController: UIViewController {
    var album: AlbumEntity!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.allowsMultipleSelection = true
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                let im = PHImageManager.default()
                
                let targetSize = CGSize(width: 350, height: 350)
                
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                allPhotos.enumerateObjects { (asset, count, _) in
                    im.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, _) in
                        if let image = image {
                            self.images.append(image)
                        }
                    })
                    
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.collectionView.reloadData()
                        }
                    }
                }
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                // Should not see this when requesting
                print("Not determined yet")
            default: break
            }
        }
    }
    
    @IBAction func cancelTappedHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTappedHandler(_ sender: Any) {
        if let selectedIndexes = collectionView.indexPathsForSelectedItems {
            let imagesDataToUpload = selectedIndexes
                .map { $0.row }
                .map { images[$0] }
                .map { $0.jpegData(compressionQuality: 1)  }
            
            ImageService.shared.upload(images: imagesDataToUpload as! [Data], albumId: album.albumId) {
                self.dismiss(animated: true, completion: nil)
            }
            
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
