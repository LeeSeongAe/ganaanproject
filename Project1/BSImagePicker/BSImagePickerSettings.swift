//
//  BSImagePickerSettings.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Photos

public protocol BSImagePickerSettings {
    
    var maxNumberOfSelections: Int { get set }
    
    /**
     Character to use for selection. If nil, selection number will be used
     */
    var selectionCharacter: Character? { get set }
    
    /**
     Inner circle color
     */
    var selectionFillColor: UIColor { get set }
    
    /**
     Outer circle color
     */
    var selectionStrokeColor: UIColor { get set }
    
    /**
     Shadow color
     */
    var selectionShadowColor: UIColor { get set }
    
    /**
     Attributes for text inside circle. Color, font, etc
     */
    var selectionTextAttributes: [NSAttributedString.Key: AnyObject] { get set }
    
    /**
     BackgroundColor
     */
    var backgroundColor: UIColor { get set }
    
    /**
     Return how many cells per row you want to show for the given size classes
     */
    var cellsPerRow: (_ verticalSize: UIUserInterfaceSizeClass, _ horizontalSize: UIUserInterfaceSizeClass) -> Int { get set }
    
    /**
     Toggle take photos
     */
    var takePhotos: Bool { get set }
    
    /**
     Icon to show in take photo cell.
     If you use a black image tint color will be applied to it.
     */
    var takePhotoIcon: UIImage? { get set }
}
