//
//  customButton.swift
//  Project1
//
//  Created by Yujin Robot on 15/07/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class customLabel:  UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
    }
}
