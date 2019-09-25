//
//  AlbumTitleView.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation

extension UIButton {
    func setAlbumTitle(_ title: String) {
        guard let imageView = imageView, let titleLabel = titleLabel else  { return }
        // Set image
        setImage(arrowDownImage, for: .normal)
        
        // Set title on button
        setTitle(title, for: .normal)
        
        // Also set title directly to label, since it isn't done right away when setting button title
        // And we need to know its width to calculate insets
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        // Adjust insets to right align image
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageView.bounds.size.width, bottom: 0, right: imageView.bounds.size.width)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: titleLabel.bounds.size.width + 12, bottom: 0, right: -(titleLabel.bounds.size.width + 12))
    }
    
    private var arrowDownImage: UIImage? {
        return UIImage(named: "arrow_down", in: BSImagePickerViewController.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
}
