//
//  PhotosDetailViewController.swift
//  Project1
//
//  Created by Yujin Robot on 10/10/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageId: String!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var image: UIImage? {
        didSet {
            if imageView != nil, activityIndicator != nil, let image = image {
                set(image: image)
            }
        }
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            set(image: image)
        }
    }
    
    private func set(image: UIImage) {
        imageView.image = image
        activityIndicator.stopAnimating()
    }
    
    @IBAction func deleteHandler(_ sender: Any) {
        activityIndicator.startAnimating()
        
        ImageService.shared.delete(imageId: imageId) {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
