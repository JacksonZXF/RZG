//
//  CornerBorderView.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/14.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class CornerBorderView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        
        self.layer.cornerRadius = 4;
        
        self.layer.borderWidth = 1;
        
        self.layer.borderColor = UIColor.lightGray.cgColor;
        
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
