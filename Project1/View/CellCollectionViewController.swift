//
//  CellCollectionViewController.swift
//  Project1
//
//  Created by Yujin Robot on 04/05/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class CellCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
//    let josepe = ["요셉1","요셉2","요셉3","요셉4"]
//    let joshua = ["여호수아1","여호수아2","여호수아3","여호수아4"]
//    let caleb = ["갈렙1","갈렙2", "갈렙3", "갈렙4"]
    var navTitle = ""
//    var cellReaders = [UIImage]()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let cellTotal = ["요셉1","요셉2","요셉3","요셉4","요셉5","요셉6","여호수아1","여호수아2","여호수아3","여호수아4","여호수아5","여호수아6","갈렙1","갈렙2", "갈렙3", "갈렙4"]
    let cellReaders:Array = ["수빈.png","이삭.png","다은.png","아형.png","현지.png","예원.png","성애.png","경석.png","김지원.png","해리.png","김예슬.png","우지원.png","숙영.png","지애.png","민정.png","다함.png",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController()?.panGestureRecognizer()
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
//        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        return josepe.count + joshua.count + caleb.count
        return cellTotal.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CellCollectionViewCell

        cell.cellName.text = cellTotal[indexPath.item]
        cell.readerImage.image = UIImage(named: cellReaders[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navTitle = cellTotal[indexPath.row]
        self.performSegue(withIdentifier: "CellCheckCell", sender: nil)
        print("\(navTitle)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
        if segue.identifier == "CellCheckCell" {
            let vc = segue.destination as! CellCheckTableViewController
            vc.navTitle = navTitle
        }
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

