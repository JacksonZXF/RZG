//
//  HomeListCollectionViewCell.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/5.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class HomeListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    
    @IBOutlet weak var subTitleLab: UILabel!
    
    
    @IBOutlet weak var styleLab: UILabel! //大字标题
    
    
    @IBOutlet weak var faceImg: UIImageView!

    
    @IBOutlet weak var headPic: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

    
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
   
    }
    
    override func layoutSubviews() {
        let tool =  BCZTool()
        
        tool.cornerRadius(cornerView: faceImg, cornerSize: 8)
    }

}
