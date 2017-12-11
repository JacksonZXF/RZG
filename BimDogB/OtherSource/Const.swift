//
//  Const.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/6.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class Const: NSObject {
    
    
    let kScreenHeight = UIScreen.main.bounds.size.height
    
    
    let kScreenWidth = UIScreen.main.bounds.size.width
    
    let BLWidth  = UIScreen.main.bounds.size.width / 1024
    
    //比例高
    let BLHeight =  UIScreen.main.bounds.size.width  / 768

}


extension UIImage {
    
    /// 异步设置圆角图片
    ///
    /// - Parameters:
    ///   - size:       图片大小
    ///   - radius:     圆角值
    ///   - fillColor:  裁切区域填充颜色
    ///   - completion: 回调裁切结果图片
    func cornerImage(size:CGSize, radius:CGFloat, fillColor: UIColor, completion:@escaping ((_ image: UIImage)->())) -> Void {
        
        //异步绘制裁切
        DispatchQueue.global().async {
            //利用绘图建立上下文
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            //设置填充颜色
            fillColor.setFill()
            UIRectFill(rect)
            
            //利用贝塞尔路径裁切
            let path = UIBezierPath.init(roundedRect: rect, cornerRadius: radius)
            path.addClip()
            
            self.draw(in: rect)
            
            //获取结果
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            //关闭上下文
            UIGraphicsEndImageContext()
            
            //主队列回调
            DispatchQueue.main.async {
                completion(resultImage!)
            }
        }
    }
    
}



