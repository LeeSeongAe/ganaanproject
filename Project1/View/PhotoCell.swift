//
//  PhotoCell.swift
//  Project1
//
//  Created by Yujin Robot on 23/08/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.dateFormat = "YYYY-MM-dd"
    }
    
    func configure(albumName: String, createdOn: Date, numberOfPhotos: Int) {
        albumNameLabel.text = albumName
        createdOnLabel.text = dateFormatter.string(from: createdOn)
    }
    
}
