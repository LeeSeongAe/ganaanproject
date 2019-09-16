//
//  Storage+Extensions.swift
//  Project1
//
//  Created by Yujin Robot on 16/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation
import FirebaseStorage

extension Storage {
    func images() -> StorageReference {
        return self.reference(withPath: "images")
    }
    
    func image(id: String) -> StorageReference {
        return self.images().child(id)
    }
}
