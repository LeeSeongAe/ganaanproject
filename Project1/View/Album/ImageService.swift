//
//  ImageService.swift
//  Project1
//
//  Created by Yujin Robot on 16/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ImageService {
    
    private init() {}
    
    static let shared = ImageService()
    
    func getAllImagesFor(albumId: String, images: @escaping ([ImageEntity]) -> ()) -> ListenerRegistration {
        let imagesCollection = Firestore.getFirestore().images()
            .whereField("albumId", isEqualTo: albumId)
            .order(by: "dateAdded", descending: false)
        
        return imagesCollection.addSnapshotListener { (query, error) in
            guard let query = query else {
                if let error = error {
                    print("error getting images: ", error.localizedDescription)
                }
                return
            }
            
            let imagesEntities = query.documents
                .map { ImageEntity(id: $0.documentID, data: $0.data()) }
            
            DispatchQueue.main.async {
                images(imagesEntities)
            }
        }
    }
    
    func delete(imageId: String, completion: @escaping () -> ()) {
        let imageDocRef = Firestore.getFirestore().image(id: imageId)
        
        imageDocRef.delete { error in
            if let error = error {
                print("error: ", error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
        
        Storage.storage().image(id: imageId).delete()
    }
    
    func deletaAllImagesFor(albumId: String) {
        let firestoreRef = Firestore.getFirestore()
        let imagesDeleteBatch = firestoreRef.batch()
        
        let imagesToDeleteCollections = firestoreRef.images()
            .whereField("albumId", isEqualTo: albumId)
        
        imagesToDeleteCollections.getDocuments { (query, error) in
            if let error = error {
                print("error: ", error.localizedDescription)
                return
            }
            
            guard let query = query else { return }
            
            query.documents.forEach { qds in
                imagesDeleteBatch.deleteDocument(qds.reference)
                Storage.storage().image(id: qds.documentID).delete()
            }
            
            imagesDeleteBatch.commit()
        }
    }
    
    func upload(images:[Data], albumId: String, completion: @escaping () -> ()) {
        
        let imagesCollectionRef = Firestore.getFirestore().images()
        
        let imagesWithDocRefs = images
            .map{ (docRef: imagesCollectionRef.document(), imageData: $0) }
        
        let createImagesBatch = Firestore.getFirestore().batch()
        
        imagesWithDocRefs.forEach { (docRef, _) in
            let data = ["albumId": albumId, "dateAdded": Timestamp(date: Date()), "status": "pending"] as [String : Any]
            createImagesBatch.setData(data, forDocument: docRef)
        }
        
        createImagesBatch.commit { _ in
            completion()
        }
        
        let imagesRef = Storage.storage().images()
        
        imagesWithDocRefs.forEach { (docRef, imageData) in
            let imageRef = imagesRef.child(docRef.documentID)
            
            imageRef.putData(imageData, metadata: nil, completion: { (meta, error) in
                if let error = error {
                    print("error: ", error.localizedDescription)
                    return
                }
                
                imageRef.downloadURL(completion: { (url, error) in
                    imageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print("error: ", error.localizedDescription)
                            return
                        }
                        
                        let data = ["status": "ready", "url": url!.absoluteString] as [String : Any]
                        docRef.updateData(data)
                    })
                })
            })
        }
    }
    
}
