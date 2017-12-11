//
//  SecneChildNodesListTableViewCell.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/7.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class SecneChildNodesListTableViewCell: UITableViewCell {

    @IBOutlet weak var chooseBtn: UIButton!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var subTitleLab: UILabel!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var oldPriceLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
