//
//  BottonLineBtn.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/9.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class BottonLineBtn: UIButton {
    
    var lineColor: UIColor!
    
    internal func setColor(color:UIColor) {
        if lineColor == nil {
            lineColor = UIColor.white
        }
        lineColor = color.copy() as! UIColor
        self.setNeedsDisplay()
    }
    


    override func draw(_ rect: CGRect) {
        let textRect: CGRect = self.titleLabel!.frame
        let contextRef: CGContext = UIGraphicsGetCurrentContext()!
        let descender: CGFloat = self.titleLabel!.font.descender
        
        contextRef.setStrokeColor((self.titleLabel?.textColor.cgColor)!);
        
        contextRef.move(to: CGPoint.init(x: textRect.origin.x, y: textRect.origin.y + textRect.size.height + descender + 2))
        
        contextRef.addLine(to: CGPoint.init(x: textRect.origin.x + textRect.size.width, y: textRect.origin.y + textRect.size.height + descender + 1))
        
        
        contextRef.closePath()
        
        contextRef.strokePath();
    }


    

}
