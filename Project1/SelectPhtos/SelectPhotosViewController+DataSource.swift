//
//  SelectPhotosViewController+DataSource.swift
//  SwiftFirestorePhotoAlbum
//
//  Created by Alex Akrimpai on 16/09/2018.
//  Copyright © 2018 Alex Akrimpai. All rights reserved.
//

import UIKit

extension SelectPhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! SelectPhotosCell
        cell.configure(image: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
}
