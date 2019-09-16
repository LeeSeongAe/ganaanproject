//
//  cellDataModel.swift
//  Project1
//
//  Created by Yujin Robot on 18/06/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation

class cellDataModel {
    var headerName: String?
    var subType = [String]()
    var isExpandable: Bool = false
    
    init(headerName: String, subType: [String], isExpandable: Bool) {
        self.headerName = headerName
        self.subType = subType
        self.isExpandable = isExpandable
    }
}
