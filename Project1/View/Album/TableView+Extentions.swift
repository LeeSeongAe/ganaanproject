//
//  TableView+Extentions.swift
//  Project1
//
//  Created by Yujin Robot on 16/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation

extension UITableView {
    func addNoDataLabel(text: String) {
        backgroundView = TableCollectionHelper.getNoDataLabel(text: text)
    }
    
    func removeNoDataLabel() {
        backgroundView = nil
    }
}


extension UICollectionView {
    func addNoDataLabel(text: String) {
        backgroundView = TableCollectionHelper.getNoDataLabel(text: text)
    }
    
    func removeNoDataLabel() {
        backgroundView = nil
    }
}

class TableCollectionHelper {
    static func getNoDataLabel(text: String) -> UIView {
        let view = UIView()
        let noDataLabel = UILabel()
        noDataLabel.text = text
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = .center
        
        view.addSubview(noDataLabel)
        noDataLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        return view
    }
}
