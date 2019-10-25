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


class JoinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var joinEmail: MadokaTextField!
    @IBOutlet weak var joinPW: MadokaTextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectedRoll: customLabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var joinNav: UINavigationBar!
    @IBOutlet weak var joinCancelBtn: UIBarButtonItem!
    
    let rollMember = ["", "목사님","간사님","부장집사님","셀원", "요셉1셀장","요셉2셀장","요셉3셀장","요셉4셀장","요셉5셀장","요셉6셀장","여호수아1셀장","여호수아2셀장","여호수아3셀장","여호수아4셀장","여호수아5셀장","여호수아6셀장","갈렙1셀장","갈렙2셀장", "갈렙3셀장", "갈렙4셀장"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        selectedRoll.text = ""
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func joinCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinAction(_ sender: Any) {
        
        
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
                            self.userUidCheck()
                            alertController.dismiss(animated: true)
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
        return rollMember.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rollMember[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedRoll.text = rollMember[row]
    }
    
    func userUidCheck() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        print("userID :: \(userID)")
        
        UserDefaults.standard.set(selectedRoll.text, forKey: userID)
        
        self.dismiss(animated: true, completion: {
            ViewController().userID = userID
        })
    }
    
}

