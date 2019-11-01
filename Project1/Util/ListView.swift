//
//  ListView.swift
//  Project1
//
//  Created by Yujin Robot on 30/10/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class ListView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let view = UIView()
        view.backgroundColor = .yellow
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
