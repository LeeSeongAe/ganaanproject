//
//  TitleStackView.swift
//  Project1
//
//  Created by Yujin Robot on 23/08/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

@objc protocol TitleStackViewDataSource {
    @objc optional func title(for titleStackView: TitleStackView) -> String?
    @objc optional func subtitle(for titleStackView: TitleStackView) -> String?
}

@objc protocol TitleStackViewDelegate {
    func titleStackView(_ titleStackView: TitleStackView, longPressedTitleLabel titleLabel: UILabel)
}

class TitleStackView: UIStackView {
    
    @IBOutlet var delegate: TitleStackViewDelegate?
    private var _dataSource: TitleStackViewDataSource?
    @IBOutlet var dataSource: TitleStackViewDataSource? {
        get {
            return _dataSource
        }
        set {
            _dataSource = newValue
            setup()
        }
    }
    
    var titleLabel: UILabel?
    var subTitleLabel: UILabel?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        print("initcoder")
        initialize()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("initframe")
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
        initialize()
    }
    
    func initialize() {
        print("initialize")
        self.spacing = 10.0
        self.axis = .horizontal
    }
    
    private func setup() {
        
        if let subtitle = dataSource?.subtitle?(for: self) {
            if subTitleLabel == nil {
                addSubTitleLabel(withSubtitle: subtitle)
            }
        }
        
        if let title = dataSource?.title?(for: self) {
            if titleLabel == nil {
                addTitleLabel(withTitle: title)
            }
        }
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        guard let label = titleLabel else {
            return
        }
        delegate?.titleStackView(self, longPressedTitleLabel: label)
    }
    
    
    func addTitleLabel(withTitle title: String) {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        label.font = UIFont(name: "Chalkduster", size: 22)
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        self.insertArrangedSubview(label, at: 0)
//        label.topAnchor.constraint(equalTo: label.superview!.topAnchor, constant: 25.0).isActive = true
        
        self.titleLabel = label
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        label.addGestureRecognizer(longPress)
    }
    
    func addSubTitleLabel(withSubtitle subtitle: String) {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 1
        
        label.text = "subtitle"
        self.insertArrangedSubview(label, at: 0)
        
        self.subTitleLabel = label
    }
    
    func reloadData() {
        setup()
        if let subtitle = dataSource?.subtitle?(for: self) {
            subTitleLabel?.text = subtitle
        }
        
        if let title = dataSource?.title?(for: self) {
            titleLabel?.text = title
        }
    }
}
