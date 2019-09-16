//
//  ContentViewController.swift
//  Project1
//
//  Created by Yujin Robot on 26/08/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    // MARK: - variable
    @IBOutlet weak var contentImageView: UIImageView!
    
    var pageIndex = Int()
    var contentImage = UIImage()
    var contentImageArray = [UIImage]()
    // MARK: - variable End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentImageView.image = contentImage
        contentImageView.contentMode = .scaleAspectFit
    }

}
