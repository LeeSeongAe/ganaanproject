//
//  Common.swift
//  Project1
//
//  Created by Yujin Robot on 28/10/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

struct CurrentUser {
    
    static var shared = CurrentUser()
    
    var loginCheck: Bool?
    
    func currentUserEmail(email currentEmail:String) -> Bool {
        if currentEmail == Auth.auth().currentUser?.email?.lowercased() {
            return true
        }
        return false
    }
    
    func currentUserUid() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    
    private init() {
        loginCheck = false
    }
    
}
