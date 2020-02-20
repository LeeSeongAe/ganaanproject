//
//  JoinViewController.swift
//  Project1
//
//  Created by Yujin Robot on 03/06/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseDatabase
import CryptoSwift
import CryptoTokenKit

class JoinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var joinName: HoshiTextField!
    @IBOutlet weak var joinEmail: HoshiTextField!
    @IBOutlet weak var joinPW: HoshiTextField!
    @IBOutlet weak var joinPwCheck: HoshiTextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var selectedRoll: customLabel!
    
    @IBOutlet weak var selectedRoll2: customLabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var joinNav: UINavigationBar!
    @IBOutlet weak var joinCancelBtn: UIBarButtonItem!
    
    @IBOutlet weak var pickerView1Width: NSLayoutConstraint!
    @IBOutlet weak var pickerView2Width: NSLayoutConstraint!
    
    @IBOutlet weak var selectedLabel1: NSLayoutConstraint!
    @IBOutlet weak var selectedLabel2: NSLayoutConstraint!
    
    var ministryFlag = Int()
    
    let rollMember = ["", "목사님","전도사님","집사님", "요셉1셀","요셉2셀","요셉3셀","요셉4셀","요셉5셀","요셉6셀","요셉7셀","여호수아1셀","여호수아2셀","여호수아3셀","여호수아4셀","여호수아5셀","여호수아6셀","여호수아7셀","갈렙1셀","갈렙2셀", "갈렙3셀장", "갈렙4셀","갈렙5셀", "기타"]
    
    let cellPosition = ["", "셀장", "셀원"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        selectedRoll.text = ""
        
        pickerView.tag = 1
        pickerView2.tag = 2
        
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolBarKeyboard.items = [doneButton]
        toolBarKeyboard.tintColor = .blue
        
        joinPwCheck.inputAccessoryView = toolBarKeyboard
        
        let setWidth = (UIScreen.main.bounds.width - 40) / 2
        
        pickerView1Width.constant = setWidth
        pickerView2Width.constant = setWidth
        selectedLabel1.constant = setWidth
        selectedLabel2.constant = setWidth
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func joinCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinAction(_ sender: Any) {
        
        if joinName.text == "" {
            self.showAlert(message: "이메일을 입력하세요!")
            return
        }
        
        if joinEmail.text == "" {
            self.showAlert(message: "이메일을 입력하세요!")
            return
        }
        
        if joinPW.text == "" {
            self.showAlert(message: "비밀번호를 입력하세요!")
            return
        }
        
        if selectedRoll.text == "" {
            self.showAlert(message: "담당사역을 선택해주세요!")
            return
        }
        
        if joinPwCheck.text == "" {
            self.showAlert(message: "비밀번호를 확인하세요!")
            return
        }
        
        if joinPW.text != "" && joinPwCheck.text != "" {
            if joinPW.text != joinPwCheck.text {
                self.showAlert(message: "비밀번호가 맞지 않습니다!")
                return
            }
        }
        
        signUp(email: joinEmail.text!, password: joinPW.text!)
        
    }
    
    func signUp(email:String, password:String) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch errorCode {
                    case AuthErrorCode.invalidEmail:
                        self.showAlert(message: "유효하지 않은 이메일 입니다.")
                    case AuthErrorCode.emailAlreadyInUse:
                        self.showAlert(message: "이미 가입한 회원입니다.")
                    case AuthErrorCode.weakPassword:
                        self.showAlert(message: "비밀번호는 6자리 이상 이여야 합니다.")
                    default:
                        print(errorCode)
                    }
                }
            } else {
                dump(user)
                let alertController = UIAlertController(title: "회원가입 성공", message: nil, preferredStyle: .alert)
                let saveAction = UIAlertAction(title: "OK", style: .default) { _ in
                    
                    alertController.dismiss(animated: true)
                    self.userUidCheck()
                }
                alertController.addAction(saveAction)
                
                self.present(alertController, animated: true)
            }
            
        })
    }
    
    func showAlert(message:String){
        
        let alert = UIAlertController(title: "회원가입 실패",message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return rollMember.count
        }
        
        return cellPosition.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return rollMember[row]
        } else {
            
            return cellPosition[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedRoll.text = rollMember[row]
        } else {
            selectedRoll2.text = cellPosition[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView.tag == 1 {
            var label = UILabel()
            if let v = view as? UILabel { label = v }
            label.font = UIFont(name: "Courier", size: 15)
            label.text = rollMember[row]
            label.textAlignment = .center
            return label
        } else {
            var label = UILabel()
            if let v = view as? UILabel { label = v }
            label.font = UIFont(name: "Courier", size: 15)
            label.text = cellPosition[row]
            label.textAlignment = .center
            return label
        }
    }
    
    func userUidCheck() {
        
        let currentUid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("Auth").child(currentUid!).childByAutoId().setValue([
            "authName" : joinName.text!,
            "authEmail" : joinEmail.text!,
            "authPassWord" : joinPW.text!,
            "authMinistry" : selectedRoll.text!,
            "authPosition" : selectedRoll2.text!
        ])
        
        self.dismiss(animated: true, completion: nil )
    }
    
}

