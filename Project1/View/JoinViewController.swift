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


class JoinViewController: UIViewController {
    
    @IBOutlet weak var joinEmail: MadokaTextField!
    @IBOutlet weak var joinPW: MadokaTextField!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var joinNav: UINavigationBar!
    @IBOutlet weak var joinCancelBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = false
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    
    @IBAction func joinCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinAction(_ sender: Any) {
        
        
            if joinEmail.text == "" {
                print("이메일을 입력하세요!")
                return
            }
            
            if joinPW.text == "" {
                print("비밀번호를 입력하세요!")
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
                print("회원가입 성공!!!")
                dump(user)
                self.performSegue(withIdentifier: "JoinEnd", sender: nil)
            }
            
            })
    }
    
    func showAlert(message:String){
        
        let alert = UIAlertController(title: "회원가입 실패",message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

