//
//  IntroduceCell.swift
//  Project1
//
//  Created by Yujin Robot on 17/10/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class IntroduceCell: UITableViewCell {

    @IBOutlet weak var introduceImage: UIImageView!
    @IBOutlet weak var introduceName: customLabel!
    
    @IBOutlet weak var introduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
