//
//  ComposedCollectionViewDataSource.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation

class ComposedCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    let dataSources: [UICollectionViewDataSource]
    
    init(dataSources: [UICollectionViewDataSource]) {
        self.dataSources = dataSources
        
        super.init()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources[section].collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSources[indexPath.section].collectionView(collectionView, cellForItemAt: IndexPath(item: indexPath.row, section: 0))
    }
}
