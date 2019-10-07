//
//  CellCollectionViewController.swift
//  Project1
//
//  Created by Yujin Robot on 04/05/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class CellCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TitleStackViewDataSource {
 
    var navTitle = ""
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var titleStackView: TitleStackView!
    
    let cellTotal = ["요셉1","요셉2","요셉3","요셉4","요셉5","요셉6","여호수아1","여호수아2","여호수아3","여호수아4","여호수아5","여호수아6","갈렙1","갈렙2", "갈렙3", "갈렙4"]
    let cellReaders:Array = ["수빈.png","이삭.png","다은.png","아형.png","현지.png","예원.png","성애.png","경석.png","김지원.png","해리.png","김예슬.png","우지원.png","숙영.png","지애.png","민정.png","다함.png",]
    
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
    
}

extension CellCollectionViewController {
    
    func title(for titleStackView: TitleStackView) -> String? {
        return "CELL 😘"
    }
    
    func subtitle(for titleStackView: TitleStackView) -> String? {
        return nil
    }
}
