//
//  RightMenuDataSource.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/6.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit


class RightMenuDataSource: NSObject {
    
    public func setLevel1MenuList() -> NSMutableArray {
        
        let arr = NSMutableArray.init(capacity: 0);
        
 
            arr.addObjects(from: ["All","柜子","沙发", "茶几", "床", "桌子", "灯具", "窗帘", "架子", "其他"])
            
            return arr;
        
        
    }
    
    
    public func getDataSourceWithItemType(typeName : String) -> NSMutableArray {
          let arr = NSMutableArray.init(capacity: 0);
      
        //1 data.json文件路径
        let path = Bundle.main.path(forResource: "Test", ofType: "json")
        
        
        
        let jsonData = NSData(contentsOfFile: path!)

        
        
        return arr;
    }
        
        
    

}
