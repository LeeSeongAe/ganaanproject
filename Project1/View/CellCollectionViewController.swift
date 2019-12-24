//
//  CellCollectionViewController.swift
//  Project1
//
//  Created by Yujin Robot on 04/05/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CellCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TitleStackViewDataSource {
    
    var navTitle = ""
    var array : [AuthDTO] = []
    var uidKey : [String] = []
    let authDTO = AuthDTO()
    
    var authMinistry:String = ""
    var authPosition:String = ""
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var titleStackView: TitleStackView!
    
    let cellTotal = ["요셉1셀","요셉2셀","요셉3셀","요셉4셀","요셉5셀","요셉6셀","요셉7", "여호수아1셀","여호수아2셀","여호수아3셀","여호수아4셀","여호수아5셀","여호수아6셀","여호수아7셀","갈렙1셀","갈렙2셀", "갈렙3셀", "갈렙4셀", "갈렙5셀"]
    let cellReaders:Array = ["수빈.png","이삭.png","아형.png","현지.png","예원.png", "대현.png","성철.png","성애.png","경석.png","한제.png","해리.png","김예슬.png","봄이.png","다은.png","숙영.png","지애.png","민정.png","다함.png","성찬.png"]
    
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleStackView.reloadData()
        
        let currentUid = CurrentUser.shared.currentUserUid()
        DispatchQueue.main.async {
            Database.database().reference().child("Auth").child(currentUid).observe(.childAdded, with: {(snapshot) in
                //                print(snapshot.value!)
                //                print(snapshot.key)
                //                self.authDTO.authMinistry = (snapshot.value as! [String:String])["authMinistry"]
                //                self.authDTO.authPosition = (snapshot.value as! [String:String])["authPosition"]
                
                self.authMinistry = (snapshot.value as! [String:String])["authMinistry"]!
                self.authPosition = (snapshot.value as! [String:String])["authPosition"]!
                //                self.array.append(self.authDTO)
                //                self.uidKey.append(snapshot.key)
            })
        }
        
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
        
        if cellTotal[indexPath.row] == self.authMinistry && self.authPosition == "셀장" {
            self.performSegue(withIdentifier: "CellCheckCell", sender: cellTotal[indexPath.row])
        } else if self.authMinistry == "목사님" || self.authMinistry == "간사님" || self.authMinistry == "부장집사님" {
            self.performSegue(withIdentifier: "CellCheckCell", sender: cellTotal[indexPath.row])
        } else {
            let alert = UIAlertController(title: "접근 권한이 없습니다.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
        if segue.identifier == "CellCheckCell" {
            let vc = segue.destination as! CellCheckTableViewController
            vc.navTitle = sender as! String
        }
    }
    
}

extension CellCollectionViewController {
    
    func title(for titleStackView: TitleStackView) -> String? {
        return "CELL 😘"
    }
    
    //    func subtitle(for titleStackView: TitleStackView) -> String? {
    //        return nil
    //    }
}
