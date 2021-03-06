//
//  AlbumCell.swift
//  Project1
//
//  Created by Yujin Robot on 27/08/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import SDWebImage

class AlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var ganaanImage: UIImageView!
    
    override func awakeFromNib() {
        setupCell()
    }
    
    private func setupCell() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    
    func configure(image: UIImage?) {
        self.ganaanImage.image = image
        
        if image != nil {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }
    }
}
