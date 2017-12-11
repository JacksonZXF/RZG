//
//  LineLabel.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/9.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class LineLabel: UILabel {

    override func awakeFromNib() {
        let priceString = NSMutableAttributedString.init(string: self.text!)
        
        priceString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: priceString.length))
        
        self.attributedText = priceString
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
