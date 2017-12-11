//
//  RightCombinationCollectionViewCell.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/15.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class RightCombinationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        img.layer.cornerRadius = 4;
        
        img.layer.masksToBounds = true;
        
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = true;
    }
}
