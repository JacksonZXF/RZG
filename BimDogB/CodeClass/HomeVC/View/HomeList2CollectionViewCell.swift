//
//  HomeList2CollectionViewCell.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/10.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class HomeList2CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titlelab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib();

     
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
    
    }
    
    override func layoutSubviews() {
        let tool =  BCZTool()
        
        tool.cornerRadius(cornerView: img, cornerSize: 8)
    }
}
