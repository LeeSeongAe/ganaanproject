//
//  AlbumCollectionViewController+Delegate.swift
//  Project1
//
//  Created by Yujin Robot on 23/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation

extension AlbumCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "PhotoDetailsSegue", sender: indexPath.row)
        print(indexPath.row)
        self.performSegue(withIdentifier: "ToDashBoard", sender: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if imageEntities?.count ?? 0 > indexPath.row, let imageEntity = imageEntities?[indexPath.row], let imageTask = imageTasks[imageEntity.imageId] {
            imageTask.resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if imageEntities?.count ?? 0 > indexPath.row, let imageEntity = imageEntities?[indexPath.row], let imageTask = imageTasks[imageEntity.imageId] {
            imageTask.pause()
        }
    }
}
