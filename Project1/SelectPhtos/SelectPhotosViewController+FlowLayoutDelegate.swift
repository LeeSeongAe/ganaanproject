//
//  SelectPhotosViewController+FlowLayoutDelegate.swift
//  SwiftFirestorePhotoAlbum
//
//  Created by Alex Akrimpai on 23/09/2018.
//  Copyright © 2018 Alex Akrimpai. All rights reserved.
//

import UIKit

extension SelectPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 50 / 3
        return CGSize(width: width, height: width)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
