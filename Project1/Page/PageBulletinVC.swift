//
//  PageVC.swift
//  Project1
//
//  Created by Yujin Robot on 24/10/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class PageBulletinVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    
    
    lazy var vcArray:[UIViewController] = {
        return [self.VCInstance(name: "FirstVC"),
                self.VCInstance(name: "SecondVC"),
                self.VCInstance(name: "ThirdVC")]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.delegate = self
        self.dataSource = self
        
        if let firstVC = vcArray.first{setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)}
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = vcArray.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return self.vcArray.last
        }
        
        guard vcArray.count > previousIndex else {
            return nil
        }
        
        return vcArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = vcArray.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < vcArray.count else {
            return vcArray.first
        }
        
        guard vcArray.count > nextIndex else {
            return nil
        }
        
        return vcArray[nextIndex]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcArray.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = vcArray.firstIndex(of: firstViewController) else {
            return 0
        }
        
        return firstViewControllerIndex
    }
    
}


