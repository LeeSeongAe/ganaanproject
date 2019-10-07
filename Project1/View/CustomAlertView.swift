//
//  customAlertView.swift
//  Project1
//
//  Created by Yujin Robot on 16/07/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var alerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var alertTextField: UITextField!
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var delegate: CustomAlertViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        alertTextField.becomeFirstResponder()
        
        picture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAlbum)))
        picture.isUserInteractionEnabled = true
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
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        alertTextField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        alertTextField.resignFirstResponder()
        delegate?.okButtonTapped(textFieldValue: alertTextField.text!, profileImage: picture.image!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openAlbum() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let uiImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.picture.image = uiImage
        }
    }
}


protocol CustomAlertViewDelegate {
    func okButtonTapped(textFieldValue: String, profileImage: UIImage)
    func cancelButtonTapped()
}
