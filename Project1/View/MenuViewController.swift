//
//  MenuViewController.swift
//  Project1
//
//  Created by Yujin Robot on 08/05/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var menuListArray = ["Home", "Introduce", "Schedule", "Photo", "Q&A", "Cell"]
    var menuListArray = ["Home", "Introduce", "Photo", "Cell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width - 70
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.menuList.text = menuListArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let listRow = indexPath.row
        print("👉\(menuListArray[indexPath.row])")
        performSegue(withIdentifier: menuListArray[indexPath.row], sender: self)
        
    }
    
}
