//
//  BCZTool.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/21.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit


class BCZTool: NSObject {
    
    static func stringToTimeStamp()->String {
        
        //获取当前时间
        let now = NSDate()
        
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("当前日期时间：\(dformatter.string(from: now as Date))")
        
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)

        return String(timeStamp)
        
    }
    

    func cornerRadius(cornerView: UIView , cornerSize:Int) {
        
        let rect = cornerView.bounds
        let radio = CGSize(width: cornerSize, height: cornerSize) // 圆角尺寸
        let corner = UInt8(UIRectCorner.topLeft.rawValue) | UInt8(UIRectCorner.topRight.rawValue) | UInt8(UIRectCorner.bottomLeft.rawValue) | UInt8(UIRectCorner.bottomRight.rawValue)// 这只圆角位置
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(corner)), cornerRadii: radio)
        let masklayer = CAShapeLayer() // 创建shapelayer
        masklayer.frame = cornerView.bounds
        masklayer.path = path.cgPath // 设置路径
        cornerView.layer.mask = masklayer
        
    }

}
