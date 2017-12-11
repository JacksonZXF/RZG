//
//  UserLogoInModel.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/14.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class requestModel: NSObject {
    
    var code: String? = "";
    var detail: Array? = [];
    var msg: String? = "";

    
}

class UserLogoInModel: NSObject {
    
    var id: String? = "";
    var office_id: String? = "";
    var login_name: String? = "";
    var password: String? = "";
    var name: String? = "";
    var email: String? = "";
    var mobile: String? = "";
    var login_ip: String? = "";
    var login_date: String? = "";
    var login_flag: String? = "";
    var create_date: String? = "";
    var del_flag: String? = "";
    var imei: String? = "";
    

}

class SingleOnce {
    
    var userInfo = UserInfoModel()
    var request = requestModel()
    // 单例
    static let shared = SingleOnce.init()
    private init(){}

    
    
}
