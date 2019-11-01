//
//  FirstViewController.swift
//  Project1
//
//  Created by Yujin Robot on 29/10/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    let listArr = ["김지훈 목사님","이새로미 간사님","정현승 집사님","이지애","최수빈","김지원"]
    
    @IBOutlet weak var tableview: UITableView!
    
    init(index: Int) {
        super.init(nibName: nil, bundle: nil)
        title = "View \(index)"
        
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.thin)
        label.textColor = UIColor(red: 95/255, green: 102/255, blue: 108/255, alpha: 1)
        label.text = "\(index)"
        label.sizeToFit()
        
        view.addSubview(label)
        view.constrainCentered(label)
        view.backgroundColor = .white
    }
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.thin)
        label.textColor = UIColor(red: 95/255, green: 102/255, blue: 108/255, alpha: 1)
        label.text = title
        label.sizeToFit()
        
        view.addSubview(label)
        view.constrainCentered(label)
        view.backgroundColor = .white
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let tableview = UITableView(frame: CGRect(x: 20, y: 20, width: 100, height: 100), style: .plain)
        tableview.backgroundColor = .yellow
        view.addSubview(tableview)
        view.constrainCentered(tableview)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
}

