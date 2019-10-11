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


class ViewController: UIViewController, TitleStackViewDataSource {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        bindOutput()
        self.navigationController?.isNavigationBarHidden = true
        
        phoneNumField.text = "lovemanse7@naver.com"
        pwField.text = "12345678"
        
//        self.view.addSubview(box)
//        box.snp.makeConstraints{(make) in
//            make.center.equalTo(self.view)
//        }
//        box.image = #imageLiteral(resourceName: "icon")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleStackView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        progressbar.stopAnimating()
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
        
//        phoneNumInputText
//            .map(checkPhoneNumValid)
//            .bind(to: phoneNumValid)
//            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .bind(to: pwInputText)
            .disposed(by: disposeBag)
        
//        pwInputText
//            .map(checkPasswordValid)
//            .bind(to: pwValid)
//            .disposed(by: disposeBag)
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
//        let storyboard = UIStoryboard(name: "Join", bundle: nil)
//        let joinVC = storyboard.instantiateViewController(withIdentifier: "joinVC")
//        self.navigationController?.present(joinVC, animated: true
//            , completion: nil)
    }
    
    
    @IBAction func testInput(_ sender: Any) {
        phoneNumField.text = "lovemanse7@naver.com"
        pwField.text = "12345678"
//        self.checkPhoneNumValid("admin")
//        self.checkPasswordValid("123456")
    }
    
    func jsonPost() {
        let userId = self.phoneNumField.text
        let password = self.pwField.text
        let param = ["userId":userId, "password":password]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        let ganaanUrl = URL(string: "")
        
        var request = URLRequest(url: ganaanUrl!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("applicaion/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        DispatchQueue.main.async {
           
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else { // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    self.loginSuccess()
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
            task.resume()
        }
    }
    
    func callCurrentTime() {
        do {
            let testUrl = URL(string: "www.naver.com")
            let response = try String(contentsOf: testUrl!)
            NSLog("CurrentTime : \(response)")
            
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        progressbar.startAnimating()
//        callCurrentTime()
//        jsonPost()
        
//        guard let email = phoneNumField.text, let password = pwField.text else { return }
        
        Auth.auth().signIn(withEmail: phoneNumField.text!, password: pwField.text!) { (user, error) in
            print("🆖\(String(describing: error))")
            if error == nil { //로그인 성공
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.changeRootVCToSWRevealVC()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let introVC = storyboard.instantiateViewController(withIdentifier: "IntroViewController")
                //        self.navigationController?.setViewControllers([introVC], animated: true)
                self.navigationController?.pushViewController(introVC, animated: true)
            } else { //로그인 실패
                self.showAlert(message: "유효하지 않은 이메일 입니다.")
            }
            
        }
        
    }
    
    func loginSuccess() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.changeRootVCToSWRevealVC()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let introVC = storyboard.instantiateViewController(withIdentifier: "IntroViewController")
        self.navigationController?.pushViewController(introVC, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let identifier = segue.identifier {
//            switch identifier {
//
//            case "JoinView":
//                if let vc = segue.destination as? JoinViewController {
//                    vc.navigationController?.isNavigationBarHidden = false
//                }
//
//            default:
//                break
//            }
//        }
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


