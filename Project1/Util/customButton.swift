//
//  customButton.swift
//  Project1
//
//  Created by Yujin Robot on 15/07/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation

class customButton: UIButton {
    
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
        backgroundColor = UIColor .white
        clipsToBounds = true
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        titleLabel?.font = UIFont(name: "SFProText-Medium", size: 17)
    }
}
