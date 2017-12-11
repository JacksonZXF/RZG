//
//  ItemModel.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/6.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class ItemModel: NSObject {
    
    var Id:String?
    var Category:String?
    var Name:String?
    var FaceImage:String?
    var Material:String?
    var Price:String?
    var Size:String?
    var Brand:String?
    var SourcePatch:String?
    
    
    init(dict:[String:Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }

}
