//
//  FirstViewController.swift
//  Project1
//
//  Created by Yujin Robot on 06/11/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    let nameList = ["김지훈 목사님","이새로미 간사님","정현승 집사님","이지애","최수빈","김지원","문상준","박해리"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        let tableView = UITableView(frame: UIScreen.main.bounds)
        tableView.backgroundColor = .yellow
        view.addSubview(tableView)
        
    }
}

