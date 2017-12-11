//
//  RightMenuListCollectionViewCell.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/6.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class RightMenuListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!

    override func awakeFromNib() {
        
        img.layer.cornerRadius = 4;
        
        img.layer.masksToBounds = true;

    }
}
