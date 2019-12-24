//
//  CellCheckCell.swift
//  Project1
//
//  Created by Yujin Robot on 10/06/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit


protocol CellCheckCellDelegate {
    func cellCheckCell(_ cell: CellCheckCell, didBeginEditingFor textView: UITextView, tag indexPathRow: Int)
}

class CellCheckCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var cellMemList: UILabel!
    @IBOutlet weak var cellMemStatus: UITextView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var worshipComeCheckButton: UIButton!
    @IBOutlet weak var cellComeCheckButton: UIButton!
    @IBOutlet weak var noComeCheckButton: UIButton!
    @IBOutlet weak var departmentLabel: UILabel!
    
    var delegate: CellCheckCellDelegate?
    var textFieldIndexPath = Int()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellMemStatus.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.cellMemStatus.endEditing(true)
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing🥰 \(textView.tag)")
        textFieldIndexPath = textView.tag
        delegate?.cellCheckCell(self, didBeginEditingFor: textView, tag: textFieldIndexPath)
    }
    
}


