//
//  IntroduceViewController.swift
//  Project1
//
//  Created by Yujin Robot on 07/06/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class IntroduceViewController: UIViewController, TitleStackViewDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleStackView: TitleStackView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let nameList = ["김지훈 목사님","이새로미 간사님","정현승 집사님","이지애","최수빈","김지원","문상준","박해리"]
    let readersImage:Array = ["목사님.png","간사님.png","집사님.png","지애.png","수빈.png","김지원.png","상준.png","해리.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController()?.panGestureRecognizer()
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleStackView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        }
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "introduceCell", for: indexPath) as! IntroduceCell
        
        if indexPath.section == 0 {
            cell.introduceImage.image = UIImage(named: readersImage[indexPath.row])
            cell.introduceName.text = nameList[indexPath.row]
        } else if indexPath.section == 1 {
            cell.introduceImage.image = UIImage(named: readersImage[indexPath.row + 3])
            cell.introduceName.text = nameList[indexPath.row + 3]
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "사역자"
        case 1:
            return "임원단"
        default:
            return ""
        }
    }

}


extension IntroduceViewController {
    
    func title(for titleStackView: TitleStackView) -> String? {
        return "Information of Youth 👫"
    }
    
//    func subtitle(for titleStackView: TitleStackView) -> String? {
//        return nil
//    }
}
