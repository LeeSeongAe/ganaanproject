//
//  CameraCollectionViewDataSource.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.


import Foundation


class CameraCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    let cameraAvailable: Bool
    let settings: BSImagePickerSettings
    
    init(settings: BSImagePickerSettings, cameraAvailable: Bool) {
        self.settings = settings
        self.cameraAvailable = cameraAvailable
        
        super.init()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (cameraAvailable && settings.takePhotos) ? 1:0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cameraAvailable && settings.takePhotos) ? 1:0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cameraCell = collectionView.dequeueReusableCell(withReuseIdentifier: CameraCell.cellIdentifier, for: indexPath) as! CameraCell
        cameraCell.accessibilityIdentifier = "camera_cell_\(indexPath.item)"
        cameraCell.takePhotoIcon = settings.takePhotoIcon
        
        return cameraCell
    }
    
    func registerCellIdentifiersForCollectionView(_ collectionView: UICollectionView?) {
        collectionView?.register(CameraCell.self, forCellWithReuseIdentifier: CameraCell.cellIdentifier)
    }
}
