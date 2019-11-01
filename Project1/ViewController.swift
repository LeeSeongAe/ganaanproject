//
//  ViewController.swift
//  Project1
//
//  Created by Yujin Robot on 02/05/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Firebase


class ViewController: UIViewController, TitleStackViewDataSource, CustomAlertView2Delegate {

    
    var disposeBag = DisposeBag()
    @IBOutlet weak var progressbar: UIActivityIndicatorView!
    
    @IBOutlet weak var titleStackView: TitleStackView!
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneNumValidView: UIView!
    @IBOutlet weak var pwValidView: UIView!
    
    @IBOutlet weak var joinButton: customButton!
    
    let phoneNumValid : BehaviorSubject<Bool> = BehaviorSubject(value: false) // 스스로 data를 가지고 있는 , 외부에서 data 할당이 가능한
    let phoneNumInputText : BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwInputText : BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var box = UIImageView()
    var remoteConfig : RemoteConfig!
    var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userID💒 :: \(userID)")
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        progressbar.hidesWhenStopped = true
        self.view.bringSubviewToFront(progressbar)
        RemoteConfig.remoteConfig().setDefaults(fromPlist: "RemoteConfigDefaults")
        
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                RemoteConfig.remoteConfig().activate(completionHandler: nil)
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            self.displayWelcome()
        }
        
        bindUI()
        bindOutput()
        self.navigationController?.isNavigationBarHidden = true
        
        currentUserCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CurrentUser.shared.loginCheck = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleStackView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        progressbar.stopAnimating()
    }
    
    func currentUserCheck() {
        if let currentEmail = Auth.auth().currentUser?.email {
            phoneNumField.text = currentEmail
        } else {
            phoneNumField.text = ""
        }
    }
    
    func displayWelcome() {
        
        //        let color = RemoteConfig.remoteConfig().value(forKey: "splash_background")
        _ = RemoteConfig.remoteConfig().configValue(forKey: "splash_background").stringValue
        let caps = RemoteConfig.remoteConfig().configValue(forKey: "splash_message_caps").boolValue
        let message = RemoteConfig.remoteConfig().configValue(forKey: "splash_message").stringValue
        
        if (caps) {
            let alert = UIAlertController(title: "공지사항", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {(action) in
                exit(0)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        //        self.view.backgroundColor = UIColor(hex: color!)
        
    }
    
    func bindUI() {
        phoneNumField.rx.text.orEmpty
            .bind(to: phoneNumInputText)
            .disposed(by: disposeBag)
        
        phoneNumInputText
            .map(checkPhoneNumValid)
            .bind(to: phoneNumValid)
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .bind(to: pwInputText)
            .disposed(by: disposeBag)
        
        pwInputText
            .map(checkPasswordValid)
            .bind(to: pwValid)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        phoneNumValid
            .subscribe(onNext: { b in self.phoneNumValidView.isHidden = b })
            .disposed(by: disposeBag)
        
        pwValid
            .subscribe(onNext: { b in self.pwValidView.isHidden = b })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(phoneNumValid, pwValid, resultSelector: { $0 && $1 })
            .subscribe(onNext: { b in self.loginBtn.isEnabled = b })
            .disposed(by: disposeBag)
    }
    
    func checkPhoneNumValid(_ phoneNum: String) -> Bool {
        return phoneNum.contains("@")
        ////        return (phoneNumField.text?.contains("admin"))!
        //        return true
    }
    //
    func checkPasswordValid(_ password: String) -> Bool {
        return password.count >= 6
        //        return true
    }
    
    
    @IBAction func joinAction(_ sender: Any) {
        performSegue(withIdentifier: "joinVC", sender: nil)
    }
    
    
    @IBAction func testInput(_ sender: Any) {
        phoneNumField.text = "ganaanAdmin@gmail.com"
        pwField.text = "12345678"
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.userDefCheck()
    }
    
    func userDefCheck() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let value = UserDefaults.standard.object(forKey: userID) as? String ?? nil
        print("value:: \(String(describing: value))")
        
        if value == nil {
            let customAlert2 = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertView2") as! CustomAlertView2
            customAlert2.providesPresentationContextTransitionStyle = true
            customAlert2.definesPresentationContext = true
            customAlert2.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlert2.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            customAlert2.delegate = self
            self.present(customAlert2, animated: true, completion: nil)
        } else {
            loginSuccess()
        }
    }
    
    func okButtonTapped(textFieldValue: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        print("userID :: \(userID)")
        UserDefaults.standard.set(textFieldValue, forKey: userID)
    }
    
    func cancelButtonTapped() {
    
    }
    
    func loginSuccess() {
        progressbar.startAnimating()
        Auth.auth().signIn(withEmail: phoneNumField.text!, password: pwField.text!) { (user, error) in
            print("🆖\(String(describing: error))")
            if error == nil { //로그인 성공
                CurrentUser.shared.loginCheck = true
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.changeRootVCToSWRevealVC()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let introVC = storyboard.instantiateViewController(withIdentifier: "IntroViewController")
                self.navigationController?.pushViewController(introVC, animated: true)
                
            } else { //로그인 실패
                self.showAlert(message: "유효하지 않은 이메일 입니다.")
            }
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func showAlert(message:String){
        
        let alert = UIAlertController(title: "로그인 실패",message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1 // 0이면 # 값까지 읽게된다.
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}


extension ViewController {
    
    func title(for titleStackView: TitleStackView) -> String? {
        return "Ganaan Youth 💕"
    }
    
    //    func subtitle(for titleStackView: TitleStackView) -> String? {
    //        return nil
    //    }
}


