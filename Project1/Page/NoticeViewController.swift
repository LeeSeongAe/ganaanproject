//
//  NoticeViewController.swift
//  Project1
//
//  Created by Yujin Robot on 06/11/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import Parchment

@available(iOS 13.0, *)
class NoticeViewController: UIViewController {
    
    fileprivate let tabNames = ["List", "Notice", "Questions", "New People"]
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    lazy var viewPages = [FirstViewController(), SecondViewController(), ThirdTableViewController(), FirstViewController()]
    
    lazy var viewArray:[UIViewController] = {
        return [self.VCInstance(name: "FirstVC"), self.VCInstance(name: "SecondVC"), self.VCInstance(name: "ThirdVC"), self.VCInstance(name: "FirstVC")]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        let pagingViewController = PagingViewController<PagingIndexItem>()
        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController()?.panGestureRecognizer()
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
}

@available(iOS 13.0, *)
extension NoticeViewController: PagingViewControllerDataSource {
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        return PagingIndexItem(index: index, title: tabNames[index]) as! T
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        if index == 0 {
            return FirstViewController()
        } else if index == 1 {
            return SecondViewController()
        } else if index == 2 {
            return ThirdTableViewController()
        }
        return IndexViewController(title: tabNames[index])
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        return viewArray.count
    }
    
}

@available(iOS 13.0, *)
extension NoticeViewController: PagingViewControllerDelegate {
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, widthForPagingItem pagingItem: T, isSelected: Bool) -> CGFloat? {
        guard let item = pagingItem as? PagingIndexItem else { return 0 }
        
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: pagingViewController.menuItemSize.height)
        let attributes = [NSAttributedString.Key.font: pagingViewController.font]
        
        let rect = item.title.boundingRect(with: size,
                                           options: .usesLineFragmentOrigin,
                                           attributes: attributes,
                                           context: nil)
        
        let width = ceil(rect.width) + insets.left + insets.right
        
        if isSelected {
            return width * 1.5
        } else {
            return width
        }
    }
    
}
