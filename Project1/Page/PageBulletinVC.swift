//
//  PageVC.swift
//  Project1
//
//  Created by Yujin Robot on 24/10/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class PageBulletinVC: UIPageViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        // Do any additional setup after loading the view.
    }
}


