//
//  SingleProduct1CollectionViewCell.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/17.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class SingleProduct1CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib();

    }
    
    
    override func layoutSubviews() {
        
        let tool =  BCZTool()
        
        tool.cornerRadius(cornerView: img, cornerSize: 8)
        
    }
    
}
