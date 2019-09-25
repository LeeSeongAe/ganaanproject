//
//  Settings.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation

class Settings : BSImagePickerSettings {
    var maxNumberOfSelections: Int = Int.max
    var selectionCharacter: Character? = nil
    var selectionFillColor: UIColor = UIView().tintColor
    var selectionStrokeColor: UIColor = UIColor.white
    var selectionShadowColor: UIColor = UIColor.black
    var selectionTextAttributes: [NSAttributedString.Key: AnyObject] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        return [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10.0),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }()
    var backgroundColor: UIColor = UIColor.white
    var cellsPerRow: (_ verticalSize: UIUserInterfaceSizeClass, _ horizontalSize: UIUserInterfaceSizeClass) -> Int = {(verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int in
        switch (verticalSize, horizontalSize) {
        case (.compact, .regular): // iPhone5-6 portrait
            return 3
        case (.compact, .compact): // iPhone5-6 landscape
            return 5
        case (.regular, .regular): // iPad portrait/landscape
            return 7
        default:
            return 3
        }
    }
    
    var takePhotos: Bool = false
    
    var takePhotoIcon: UIImage? = UIImage(named: "add_photo", in: BSImagePickerViewController.bundle, compatibleWith: nil)
}
