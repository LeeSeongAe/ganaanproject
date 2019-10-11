//
//  IntroViewController.swift
//  Project1
//
//  Created by Yujin Robot on 07/05/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, TitleStackViewDataSource {
    

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var reFreshButton: UIBarButtonItem!
    @IBOutlet weak var titleStackView: TitleStackView!
    
    @IBOutlet weak var photoButton: UIImageView!
//    @IBOutlet weak var imageSlide: UIImageView!
    
    @IBOutlet weak var pageView: UIPageControl!
    
    @IBOutlet weak var scheduleButton: UIButton!
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    var imageData:Array = [UIImage(named: "수련회0"), UIImage(named: "수련회1"), UIImage(named: "수련회3"),UIImage(named: "수련회4")]
//    var imageData:Array = ["수빈.png","이삭.png","지애.png"]
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
//        self.imageData = ["수빈.png","이삭.png","다은.png","아형.png"]
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController()?.panGestureRecognizer()
        }
        
        reFreshButton.action = #selector(refreshAction(_:))
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(clickedInHome))
        
        pageView.numberOfPages = imageData.count
        pageView.currentPage = 0
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleStackView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func changeImage() {
        if counter < imageData.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    }
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LogInView")
        self.navigationController?.setViewControllers([vc], animated: false)
        
    }
    
//    @IBAction func albumClicked(_ sender: UIButton) {
//        clickedInHome(photoButton)
//    }
    
    
//    @IBAction func scheduleClicked(_ sender: UIButton) {
//        clickedInHome(scheduleButton)
//    }
    
    
    @objc func clickedInHome(_ sender: UIImageView) {
        let btnTitle = "Album"
        
        self.revealViewController()?.rearViewController.performSegue(withIdentifier: btnTitle, sender: self.revealViewController()?.rearViewController)
    }
}


extension IntroViewController {

    func title(for titleStackView: TitleStackView) -> String? {
        return "💖 GOD BLESS YOU 💖"
    }

//    func subtitle(for titleStackView: TitleStackView) -> String? {
//        return nil
//    }
}
    
extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? slideCell
        cell?.sliderImage.image = imageData[indexPath.row]

        return cell!
    }
}

extension IntroViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}



