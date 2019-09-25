//
//  PreviewViewController.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class PreviewViewController : UIViewController {
    
    var imageView: UIImageView?
    private var fullscreen = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.backgroundColor = UIColor.white
        
        imageView = UIImageView(frame: view.bounds)
        imageView?.contentMode = .scaleAspectFit
        imageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(imageView!)
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.addTarget(self, action: #selector(PreviewViewController.toggleFullscreen))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    @objc func toggleFullscreen() {
        fullscreen = !fullscreen
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.toggleNavigationBar()
            self.toggleStatusBar()
            self.toggleBackgroundColor()
        })
    }
    
    @objc func toggleNavigationBar() {
        navigationController?.setNavigationBarHidden(fullscreen, animated: true)
    }
    
    @objc func toggleStatusBar() {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func toggleBackgroundColor() {
        let aColor: UIColor
        
        if self.fullscreen {
            aColor = UIColor.black
        } else {
            aColor = UIColor.white
        }
        
        self.view.backgroundColor = aColor
    }
    
    override var prefersStatusBarHidden : Bool {
        return fullscreen
    }
    
}
