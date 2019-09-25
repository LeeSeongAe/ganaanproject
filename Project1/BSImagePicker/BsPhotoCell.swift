//
//  BsPhotoCell.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import Photos

class BsPhotoCell: UICollectionViewCell {
    
    static let cellIdentifier = "photoCellIdentifier"
    
    let imageView: UIImageView = UIImageView(frame: .zero)
    
    private let selectionOverlayView: UIView = UIView(frame: .zero)
    private let selectionView: SelectionView = SelectionView(frame: .zero)
    
    weak var asset: PHAsset?
    
    var settings: BSImagePickerSettings {
        get {
            return selectionView.settings
        }
        set {
            selectionView.settings = newValue
        }
    }
    
    var selectionString: String {
        get {
            return selectionView.selectionString
        }
        
        set {
            selectionView.selectionString = newValue
        }
    }
    
    var photoSelected: Bool = false {
        didSet {
            self.updateAccessibilityLabel(photoSelected)
            let hasChanged = photoSelected != oldValue
            if UIView.areAnimationsEnabled && hasChanged {
                UIView.animate(withDuration: TimeInterval(0.1), animations: { () -> Void in
                    // Set alpha for views
                    self.updateAlpha(self.photoSelected)
                    
                    // Scale all views down a little
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: { (finished: Bool) -> Void in
                    UIView.animate(withDuration: TimeInterval(0.1), animations: { () -> Void in
                        // And then scale them back upp again to give a bounce effect
                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: nil)
                })
            } else {
                updateAlpha(photoSelected)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup views
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        selectionOverlayView.backgroundColor = UIColor.lightGray
        selectionOverlayView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(selectionOverlayView)
        contentView.addSubview(selectionView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionOverlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionOverlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectionOverlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionOverlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionView.heightAnchor.constraint(equalToConstant: 25),
            selectionView.widthAnchor.constraint(equalToConstant: 25),
            selectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            selectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAccessibilityLabel(_ selected: Bool) {
        self.accessibilityLabel = selected ? "deselect image" : "select image"
    }
    
    private func updateAlpha(_ selected: Bool) {
        if selected == true {
            self.selectionView.alpha = 1.0
            self.selectionOverlayView.alpha = 0.3
        } else {
            self.selectionView.alpha = 0.0
            self.selectionOverlayView.alpha = 0.0
        }
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
    
}

