//
//  SelectPhotosCell.swift
//  SwiftFirestorePhotoAlbum
//
//  Created by Alex Akrimpai on 16/09/2018.
//  Copyright © 2018 Alex Akrimpai. All rights reserved.
//

import UIKit

class SelectPhotosCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            imageView.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.black.cgColor
            imageView.layer.borderWidth = isSelected ? 2: 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 8
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
