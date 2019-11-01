//
//  BulletinViewController.swift
//  Project1
//
//  Created by Yujin Robot on 30/10/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class BulletinViewController: TabmanViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //    private var viewControllers = [FirstViewController(), SecondViewController(), ThirdViewController()]
    lazy var viewControllers = [FirstViewController(), SecondViewController(), ThirdViewController()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.title = "Bulletin"
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0)
        bar.fadesContentEdges = true
        addBar(bar, dataSource: self, at: .top)
        
        // Do any additional setup after loading the view.
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

extension BulletinViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: "Page No.\(index + 1)")
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

}
