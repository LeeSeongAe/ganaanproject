//
//  FirstCellTableViewCell.swift
//  Project1
//
//  Created by Yujin Robot on 06/11/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import UIKit

class FirstCell: UITableViewCell {
    
    @IBOutlet weak var labelTest: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
