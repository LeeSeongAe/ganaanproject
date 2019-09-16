//
//  FireStore+Extensions.swift
//  Project1
//
//  Created by Yujin Robot on 16/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension Firestore {
    
    class func getFirestore() -> Firestore {
        let db = Firestore.firestore()
        let settings = db.settings
//        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }
    
    func albums() -> CollectionReference {
        return self.collection("albums")
    }
    
    func album(id: String) -> DocumentReference {
        return self.albums().document(id)
    }
    
    func images() -> CollectionReference {
        return self.collection("images")
    }
    
    func image(id: String) -> DocumentReference {
        return self.images().document(id)
    }
    
}
