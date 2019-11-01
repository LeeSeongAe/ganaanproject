//
//  SecondViewController.swift
//  Project1
//
//  Created by Yujin Robot on 29/10/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        view.backgroundColor = .purple
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
