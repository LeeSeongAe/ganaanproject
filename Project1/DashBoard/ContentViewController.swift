//
//  ContentViewController.swift
//  Project1
//
//  Created by Yujin Robot on 26/08/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import SDWebImage

class ContentViewController: UIViewController {
    
    // MARK: - variable
    @IBOutlet weak var contentImageView: UIImageView!
    
    var pageIndex = Int()
    var contentImage = UIImage()
    var imageUrl:URL? = nil
    // MARK: - variable End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = imageUrl {
            contentImageView?.sd_setImage(with: url, completed: nil)
        }
        
        contentImageView?.contentMode = .scaleAspectFit
    }

}
