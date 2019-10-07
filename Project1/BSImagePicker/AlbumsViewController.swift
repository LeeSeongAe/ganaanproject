//
//  AlbumsViewController.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class AlbumsViewController: UITableViewController {
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        let visualEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light)))
        visualEffectView.frame = tableView.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        tableView.backgroundView = visualEffectView
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 320, height: 300)
        
        tableView.register(BsAlbumCell.self, forCellReuseIdentifier: BsAlbumCell.cellIdentifier)
        
    }

}
