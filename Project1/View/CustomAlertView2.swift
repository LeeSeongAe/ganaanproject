//
//  CustomAlertView2.swift
//  Project1
//
//  Created by Yujin Robot on 01/11/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class CustomAlertView2: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var alerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var delegate: CustomAlertView2Delegate?
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selecteLabel: customLabel!
    
    
    let rollMember = ["", "목사님","간사님","부장집사님","셀원", "요셉1셀장","요셉2셀장","요셉3셀장","요셉4셀장","요셉5셀장","요셉6셀장","여호수아1셀장","여호수아2셀장","여호수아3셀장","여호수아4셀장","여호수아5셀장","여호수아6셀장","갈렙1셀장","갈렙2셀장", "갈렙3셀장", "갈렙4셀장"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        selecteLabel.text = ""
        selecteLabel.becomeFirstResponder()
        selecteLabel.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        setupView()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setupView() {
        alerView.layer.borderWidth = 0.5
        alerView.layer.cornerRadius = 5
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alerView.alpha = 0;
        self.alerView.frame.origin.y = self.alerView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alerView.alpha = 1.0;
            self.alerView.frame.origin.y = self.alerView.frame.origin.y - 50
        })
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
        
        selecteLabel.text = rollMember[row]
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        selecteLabel.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        selecteLabel.resignFirstResponder()
        delegate?.okButtonTapped(textFieldValue: selecteLabel.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
}


protocol CustomAlertView2Delegate {
    func okButtonTapped(textFieldValue: String)
    func cancelButtonTapped()
}

