//
//  AlbumTableViewDataSource.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation
import Photos

class AlbumTableViewDataSource : NSObject, UITableViewDataSource {
    let fetchResults: [PHFetchResult<PHAssetCollection>]
    
    init(fetchResults: [PHFetchResult<PHAssetCollection>]) {
        self.fetchResults = fetchResults
        
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResults.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResults[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BsAlbumCell.cellIdentifier, for: indexPath) as! BsAlbumCell
        let cachingManager = PHCachingImageManager.default() as? PHCachingImageManager
        cachingManager?.allowsCachingHighQualityImages = false
        
        // Fetch album
        let album = fetchResults[indexPath.section][indexPath.row]
        // Title
        cell.albumTitleLabel.text = album.localizedTitle
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let scale = UIScreen.main.scale
        let imageSize = CGSize(width: 79 * scale, height: 79 * scale)
        let imageContentMode: PHImageContentMode = .aspectFill
        let result = PHAsset.fetchAssets(in: album, options: fetchOptions)
        result.enumerateObjects({ (asset, idx, stop) in
            switch idx {
            case 0:
                PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                    cell.firstImageView.image = result
                    cell.secondImageView.image = result
                    cell.thirdImageView.image = result
                }
            case 1:
                PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                    cell.secondImageView.image = result
                    cell.thirdImageView.image = result
                }
            case 2:
                PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                    cell.thirdImageView.image = result
                }
                
            default:
                // Stop enumeration
                stop.initialize(to: true)
            }
        })
        
        return cell
    }
}

