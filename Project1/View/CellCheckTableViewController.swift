//
//  CellCheckTableViewController.swift
//  Project1
//
//  Created by Yujin Robot on 04/05/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase
import SDWebImage
//import FirebaseStorage

struct cellDataModel {
    
    var sectionTitle: String?
    var cellTitle: String?
    var isExpandable: Bool = false
}

class CellCheckTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellCheckCellDelegate, CustomAlertViewDelegate, TitleStackViewDataSource {
    

    @IBOutlet weak var titleStackView: TitleStackView!
    var ref : DatabaseReference!
    
    @IBOutlet weak var progressbar: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cellNav: UINavigationItem!
    
    
    
    var navTitle = ""
    var addPray = false
    var currentCellIndex:Int? = nil
    var textViewTag:Int? = nil
    var names : [String] = []
    
    var array : [UserDTO] = []
    var uidKey : [String] = []
    var uid = Auth.auth().currentUser?.uid
    var profile = ["icon.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressbar.hidesWhenStopped = true
        self.view.bringSubviewToFront(progressbar)
        
//        self.navigationItem.title = navTitle
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        self.array.removeAll()
        
        Database.database().reference().child("Cell").child(self.navTitle).observe(.childAdded, with: {(snapshot) in
            print(snapshot.value!)
            print(snapshot.key)
            
            let userDTO = UserDTO()
            userDTO.cellMemName = (snapshot.value as! [String:String])["cellMemName"]
            userDTO.imageUrl = (snapshot.value as! [String:String])["imageUrl"]
            userDTO.birth = (snapshot.value as! [String:String])["birth"]
            userDTO.phoneNumber = (snapshot.value as! [String:String])["phoneNumber"]
            userDTO.department = (snapshot.value as! [String:String])["department"]
            userDTO.pray = (snapshot.value as! [String:String])["pray"]
            userDTO.imageName = (snapshot.value as! [String:String])["imageName"]
            
            self.array.append(userDTO)
            self.uidKey.append(snapshot.key)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.titleStackView.reloadData()
    }
    
    
    @IBAction func addCellMem(_ sender: Any) {
       
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCheckCell", for: indexPath) as! CellCheckCell
        let user = array[indexPath.row]
       
        cell.delegate = self
        cell.cellMemStatus.tag = indexPath.row
        
        cell.cellMemList.text = user.cellMemName
        cell.cellMemStatus.text = user.pray
        cell.departmentLabel.text = user.department
        
        URLSession.shared.dataTask(with: URL(string:array[indexPath.row].imageUrl!)!) { (data, response, err) in
            
            if err != nil {
                return
            }
            
            DispatchQueue.main.async {
                cell.profileImg.image = UIImage(data: data!)
            }
            
        }.resume()

        
        if indexPath.row == 0 { //셀장 표시
            cell.backgroundColor = UIColor.init(hex: "#FFFFE4")
        }
        
        cell.saveBtn.addTarget(self, action: #selector(addCellMemStatus), for: .touchUpInside)
        
        progressbar.stopAnimating()
        
        return cell
    }
    
    
    @objc func addCellMemStatus() {
        
        let alertController = UIAlertController(title: "Add Content", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {alert -> Void in
//            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    func cellCheckCell(_ cell: CellCheckCell, didBeginEditingFor textView: UITextView, tag indexPathRow: Int) {
        
        let ref = Database.database().reference()
        
        if let newData = textView.text, newData != "" {
            
            ref.child("Cell").child(self.navTitle).observeSingleEvent(of: .value, with: {(snapshot) in
                self.uidKey.removeAll()
                if let result = snapshot.children.allObjects as? [DataSnapshot] {
                    
                    for child in result {
                        let userKey = child.key
                        self.uidKey.append(userKey)
                    }
                    
                    let currentChildId = self.uidKey[indexPathRow]
                    print("currentChildId : \(currentChildId)")
                    ref.child("Cell").child(self.navTitle).child(currentChildId).child("pray").setValue(newData)
                }
            })
        }
    }
    
    
    func okButtonTapped(textFieldValue: String, profileImage: UIImage, birth: String, phoneNumber: String, department: String) {
        print("####, \(birth),\(phoneNumber),\(department)")
        
        let selectedImage = profileImage.pngData()
        
        let imageName = Auth.auth().currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).png"

        if let newData = textFieldValue as? String, newData != "" {
            
            // Create a root reference
            let storageRef = Storage.storage().reference()
            
            let reversRef = storageRef.child("Cell").child(self.navTitle).child(imageName)
            
            reversRef.putData(selectedImage!, metadata: nil) { metadata, error in
                if error != nil {
                    
                } else {
                    reversRef.downloadURL{ url, error in
                        if let url = url?.absoluteString {
                            Database.database().reference().child("Cell").child(self.navTitle).childByAutoId().setValue([
                                "cellMemName" : newData,
                                "imageUrl" : url,
                                "birth": birth,
                                "phoneNumber": phoneNumber,
                                "department": department,
                                "pray" : "",
                                "imageName" : imageName
                                ])
                        }
                    }
                }
            }
        }
        progressbar.startAnimating()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("😣 \(indexPath.row)")
            
            let storageRef = Storage.storage().reference()
            let reversRef = storageRef.child("Cell").child(self.navTitle).child(array[indexPath.row].imageName!)
            reversRef.delete(completion: { (error) in
                if error != nil {
                    print("삭제 에러")
                } else {
                    print("database 삭제🍏 \(self.uidKey[indexPath.row]), \(indexPath.section)")
                    Database.database().reference().child("Cell").child(self.navTitle).child(self.uidKey[indexPath.row]).removeValue()
                    self.array.remove(at: indexPath.row)
                    tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            })
        }
    
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped-->>")
    }
    
}

extension CellCheckTableViewController {
    
    func title(for titleStackView: TitleStackView) -> String? {
        return navTitle
    }
    
//    func subtitle(for titleStackView: TitleStackView) -> String? {
//        return nil
//    }
}

