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
    var keyboardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressbar.hidesWhenStopped = true
        self.view.bringSubviewToFront(progressbar)
        
//        self.navigationItem.title = navTitle
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        self.array.removeAll()
        
        getInitData()
        
    }
    
    func getInitData() {
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
            userDTO.worship = (snapshot.value as! [String:String])["worship"]
            userDTO.cell = (snapshot.value as! [String:String])["cell"]
            userDTO.noShow = (snapshot.value as! [String:String])["noShow"]
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
    
    @objc func keyboardWillShow(_ sender:Notification){
        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
    }

    @objc func keyboardWillHide(_ sender:Notification){
        self.view.frame.origin.y = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.titleStackView.reloadData()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector:
//            #selector(keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification,
//                                             object: nil)
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
        cell.noComeCheckButton.isSelected = false
        cell.worshipComeCheckButton.isSelected = false
        cell.cellComeCheckButton.isSelected = false
        
        if user.noShow == "1" {
            cell.noComeCheckButton.isSelected = true
        }
        
        if user.worship == "1" {
            cell.worshipComeCheckButton.isSelected = true
        }
        
        if user.cell == "1" {
            cell.cellComeCheckButton.isSelected = true
        }
        
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
//        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 300))
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 300
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

    func cellCheckCell(_ cell: CellCheckCell, didBeginEditingFor textView: UITextView, tag indexPathRow: Int, worship worshipButton: UIButton, cell cellButton: UIButton, noShow noShowButton: UIButton) {
        
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
                    ref.child("Cell").child(self.navTitle).child(currentChildId).child("pray").setValue(newData)

                    #warning("TODO")
                    if worshipButton.isSelected { ref.child("Cell").child(self.navTitle).child(currentChildId).child("worship").setValue("1")
                    }
                    if cellButton.isSelected {
                        ref.child("Cell").child(self.navTitle).child(currentChildId).child("cell").setValue("1")
                    }
                    if noShowButton.isSelected {
                        ref.child("Cell").child(self.navTitle).child(currentChildId).child("noShow").setValue("1")
                    }
                }
            })
        }
    }
    
    
    func okButtonTapped(textFieldValue: String, profileImage: UIImage, birth: String, phoneNumber: String, department: String) {
        
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
                                "worship" : "0",
                                "cell" : "0",
                                "noShow" : "0",
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
    
    @IBAction func worshipAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func cellAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func noshowAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
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

