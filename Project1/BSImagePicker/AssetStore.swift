//
//  AssetStore.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation
import Photos

class AssetStore {
    private(set) var assets: [PHAsset]
    
    init(assets: [PHAsset] = []) {
        self.assets = assets
    }
    
    var count: Int {
        return assets.count
    }
    
    func contains(_ asset: PHAsset) -> Bool {
        return assets.contains(asset)
    }
    
    func append(_ asset: PHAsset) {
        guard contains(asset) == false else { return }
        assets.append(asset)
    }
    
    func remove(_ asset: PHAsset) {
        guard let index = assets.firstIndex(of: asset) else { return }
        assets.remove(at: index)
    }
}
