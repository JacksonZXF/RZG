//
//  Find1ItemListCollectionViewCell.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/27.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit
import IBAnimatable

class Find1ItemListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var signId: UILabel!
    @IBOutlet weak var sizeLab: UILabel!
    @IBOutlet weak var proName: UILabel!
    @IBOutlet weak var caizhi: UILabel!
    
    var model : VirtualObjectDefinition!  {
        didSet {
           
            img.image = UIImage.init(named: model.FaceImage);
            caizhi.text =  String.init(format: "型号: %@", model.Id);
            proName.text =  String.init(format: "产品: %@", model.displayName);
            signId.text =  String.init(format: "尺寸: %@", model.Size);
            sizeLab.text =  String.init(format: "材质: %@", model.Material);
            
        }
    }
    
    @IBOutlet weak var backView: AnimatableView!
    @IBOutlet weak var img: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        
        
    }

    override func layoutSubviews() {
        super.layoutSubviews();
        
        let tool =  BCZTool()
        
        tool.cornerRadius(cornerView: backView, cornerSize: 8)

    }
    

    
}
