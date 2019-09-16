//
//  AlbumEntity.swift
//  Project1
//
//  Created by Yujin Robot on 16/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct AlbumEntity {
    
    let albumId: String
    let name: String
    let dataCreated: Date
    let numberOfPhotos: Int
    
    init(id: String, data: [String: Any]) {
        self.albumId = id
        self.name = data["name"] as? String ?? ""
        let dateTimestamp = data["dateCreated"] as? Timestamp
        self.dataCreated = dateTimestamp?.dateValue() ?? Date.init()
        self.numberOfPhotos = data["numberOfPhotos"] as? Int ?? 0
    }
    
}
