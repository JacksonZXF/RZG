//
//  PackageListTableViewCell.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/17.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class PackageListTableViewCell: UITableViewCell {

    @IBOutlet weak var caizhiLab: UILabel!
    @IBOutlet weak var sizeLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var xinghaoLAb: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
