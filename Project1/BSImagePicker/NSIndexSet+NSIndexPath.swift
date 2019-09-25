//
//  NSIndexSet+NSIndexPath.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation

extension IndexSet {
    /**
     - parameter section: The section for the created NSIndexPaths
     - return: An array with NSIndexPaths
     */
    func bs_indexPathsForSection(_ section: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        
        for value in self {
            indexPaths.append(IndexPath(item: value, section: section))
        }
        
        return indexPaths
    }
}
