//
//  IntroViewController.swift
//  Project1
//
//  Created by Yujin Robot on 07/05/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var reFreshButton: UIBarButtonItem!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController()?.panGestureRecognizer()
        }
        
        reFreshButton.action = #selector(refreshAction(_:))
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LogInView")
        self.navigationController?.setViewControllers([vc], animated: false)
        
    }
    
    @IBAction func albumClicked(_ sender: UIButton) {
        clickedInHome(photoButton)
    }
    
    
    @IBAction func scheduleClicked(_ sender: UIButton) {
        clickedInHome(scheduleButton)
    }
    
    
    func clickedInHome(_ sender: UIButton) {
        let btnTitle = sender.currentTitle!
        
        self.revealViewController()?.rearViewController.performSegue(withIdentifier: btnTitle, sender: self.revealViewController()?.rearViewController)
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    
}
