//
//  DashBoardViewController.swift
//  Project1
//
//  Created by Yujin Robot on 26/08/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController, UIPageViewControllerDataSource {
//  MARK: - variable
    @IBOutlet weak var pageView: UIView!
    
    var contentImageData = NSArray()
    var selectedImageIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DATA
        print("contentImageData : \(contentImageData),, \(selectedImageIndex)")
        
        //Layout
        let initialView = ContentVCIndex(index: selectedImageIndex) as ContentViewController
        let viewController = NSArray(object: initialView)
        
        let pageVC = self.storyboard?.instantiateViewController(withIdentifier: "pageVC") as! UIPageViewController
        
        pageVC.view.frame = pageView.bounds
        pageView.addSubview(pageVC.view)
        addChild(pageVC)
        pageVC.didMove(toParent: self)
        pageVC.dataSource = self
        pageVC.setViewControllers(viewController as? [UIViewController], direction: .forward, animated: true, completion: nil)
    }
    
    
    //MARK: - Page view
    
    func ContentVCIndex(index: Int) -> ContentViewController {
        print("index : \(index)")
        if contentImageData.count == 0 || index >= contentImageData.count {
            return ContentViewController()
        }
        
        let ContentVC = self.storyboard?.instantiateViewController(withIdentifier: "contentViewController") as! ContentViewController
        
        ContentVC.pageIndex = index
        ContentVC.contentImage = contentImageData[index] as! UIImage
        
        return ContentVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let contentVC = viewController as! ContentViewController
        var pageIndex = contentVC.pageIndex as Int
        
        if pageIndex == 1 || pageIndex == NSNotFound {
            return nil
        }
        
        pageIndex -= 1
        
        return ContentVCIndex(index: pageIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let contentVC = viewController as! ContentViewController
        var pageIndex = contentVC.pageIndex as Int
        
        if pageIndex == NSNotFound {
            return nil
        }
            
        pageIndex += 1
        
        if pageIndex == contentImageData.count {
            return nil
        }
        
        return ContentVCIndex(index: pageIndex)
    }
    //MARK: -


}
