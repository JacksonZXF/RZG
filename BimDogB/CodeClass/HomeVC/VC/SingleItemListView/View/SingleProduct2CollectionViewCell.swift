//
//  SingleProduct2CollectionViewCell.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/17.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class SingleProduct2CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var xinghaoLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var sizeLab: UILabel!
    @IBOutlet weak var caizhiLab: UILabel!
    
    var model : VirtualObjectDefinition = VirtualObjectDefinition.init(modelName: "", displayName: "") {
        didSet {
            nameLab.text = String.init(format: "产品:%@", arguments: [model.modelName])
            xinghaoLab.text =  String.init(format: "型号:N%@", arguments: [model.Id])
            sizeLab.text = String.init(format: "规格:%@", arguments:  [model.Size]);
            caizhiLab.text = String.init(format: "材质:%@", arguments:  [model.Material]);
        }
    }
    
    override func awakeFromNib() {


        
    }
    
    
    
    override func layoutSubviews() {
        let tool =  BCZTool()
        
        tool.cornerRadius(cornerView: img, cornerSize: 8)
        
        tool.cornerRadius(cornerView: self, cornerSize: 8)
    }
}
