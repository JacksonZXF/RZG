//
//  HomeCollectionReusableView.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/13.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class HomeCollectionReusableView: UICollectionReusableView {
    
    var titleLabel:UILabel?//title
    
    var subLabel:UILabel?//title
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    func initView(){
        
        titleLabel = UILabel.init(frame: CGRect.init(x: 50, y: 10, width: 100, height: 45))
        
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.init(3.0))
        titleLabel?.textColor = UIColor.withHex(hexString: "#666666");
        
        self .addSubview(titleLabel!)
        
        subLabel = UILabel.init(frame: CGRect.init(x: self.center.x - 150, y: 10, width: 300, height: 45))
        
        subLabel?.font = UIFont.systemFont(ofSize: 14)
        
        subLabel?.textColor = UIColor.withHex(hexString: "#bbbbbb");

        self.addSubview(subLabel!)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
}
