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
    var imageId: String!
    var pageIndex = Int()
    var contentImage = UIImage()
    var imageUrl:URL? = nil
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - variable End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = imageUrl {
            contentImageView?.sd_setImage(with: url, completed: nil)
            activityIndicator.stopAnimating()
        }
        
        contentImageView?.contentMode = .scaleAspectFit
        contentImageView.isMultipleTouchEnabled = true
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let pinchZoom = UIPinchGestureRecognizer(target: self, action: #selector(zoomAction(_:)))
        self.view.addGestureRecognizer(pinchZoom)
        
//        let dragImage = UIPanGestureRecognizer(target: self, action: #selector(dragAction(_:)))
//        self.view.addGestureRecognizer(dragImage)
    }
    
    @objc func zoomAction(_ sender: UIPinchGestureRecognizer) {
        self.view.transform = self.view.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
        print("sender.scale: \(sender.scale)")
    }
    
    @objc func dragAction(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: self.view)
        let changedX = self.view.center.x + transition.x
        let changedY = self.view.center.y + transition.y
        self.view.center = CGPoint(x: changedX, y: changedY)
        
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        let velocity = sender.velocity(in: self.view)
        
        //        if abs(velocity.x) > abs(velocity.y) {
        //            velocity.x < 0 ? log.debug("Left") : log.debug("Right")
        //        } else if abs(velocity.y) > abs(velocity.x) {
        //            velocity.y < 0 ? log.debug("Up") : log.debug("Down")
        //        }
    }
    
}
