//
//  RightMenuList2CollectionViewCell.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/6.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class RightMenuList2CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var xinghao: UILabel!
    
    @IBOutlet weak var caiziLab: UILabel!
    @IBOutlet weak var sizeLab: UILabel!
    
    var model : VirtualObjectDefinition = VirtualObjectDefinition.init(modelName: "", displayName: "") {
        didSet {
            nameLab.text = String.init(format: "产品:%@", arguments: [model.displayName])
            xinghao.text =  String.init(format: "型号:N%@", arguments: [model.Id])
            sizeLab.text = String.init(format: "规格:%@", arguments:  [model.Size]);
            caiziLab.text = String.init(format: "材质:%@", arguments:  [model.Material]);
        }
    }
    
    public var dic : NSDictionary!{
        
        set{
        
            
            img.image = UIImage.init(named: newValue.object(forKey: "name") as! String)
        }
        
        get{
            
            
            return self.dic
        }
        
    }
    
    override func awakeFromNib() {
        
        img.layer.cornerRadius = 4;

        img.layer.masksToBounds = true;
        
        self.layer.cornerRadius = 4;
        
        self.layer.masksToBounds = true;
    }
}
