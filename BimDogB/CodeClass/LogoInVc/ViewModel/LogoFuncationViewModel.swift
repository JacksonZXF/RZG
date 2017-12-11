//
//  LogoFuncationViewModel.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/20.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit
import SCLAlertView
import MJExtension
import DaisyNet
import Alamofire
import SwiftyJSON

class LogoFuncationViewModel: NSObject {

    //格式: typealias 闭包名称 = (参数名称: 参数类型) -> 返回值类型
    typealias swiftBlock = () -> Void
    
    //2. 声明一个变量
    var LogoSuccess: swiftBlock?
    
    //3. 定义一个方法,方法的参数为和swiftBlock类型一致的闭包,并赋值给callBack
    func logoInSuccess(account : String,  passWord : String , block: @escaping (_ result : String) -> ())  {
        
        let urlName = String.init(format: "username=%@", arguments: [account]);
        
        let tiemstamp = String.init(format: "timestamp=%@", arguments: [BCZTool.stringToTimeStamp()]);
        
        let signStr = "sign=4B58D3A1F717E6C703678A7FAD49A96C";
        
        let apiUrl = String.init(format: "%@%@&%@&%@", arguments: [ConstAPI.kAPILogoIn, urlName, tiemstamp, signStr])
        
        print("url === ", apiUrl);
        
        let parameters = ["username":  account, "password": passWord, "imei": "564461", "login_ip": String.init(format: "%@", CloudFitTool.getIPAddress()) , "login_date":String.init(format: "%@", CloudFitTool.getyyyymmdd()!)
        ]
        
        
        
        SVProgressHUD.show(withStatus: "登录中");
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark);
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)

        
        DaisyNet.request(apiUrl, method: .post , params: parameters as [String : AnyObject], encoding: JSONEncoding.default).cache(true).responseCacheAndJson { value in
            
         
            
            switch value.result {
                
                
            case .success(let json):
                SVProgressHUD.dismiss();
                if value.isCacheData {
                    print("我是缓存的")
   
                    
                    let d : NSDictionary = json as! NSDictionary;
                    
                    if d.value(forKey: "code") as! String ==   "0" {
                        
                        let logoSingle =  SingleOnce.shared;
                        
                        let user : UserInfoModel = UserInfoModel()
                        
                        user.mj_setKeyValues((d.value(forKey: "detail") as! Array)[0]);
                        
                        logoSingle.userInfo = user;
                        
                        print(logoSingle.userInfo.name);
                        
                        block("success")
                        
                    } else {
                        
                        let v = SCLAlertView.init();
                        
                        v.showError("登陆失败", subTitle: "请确认账号密码是否正确");
                        
                    }
                    
                    
                } else {
                       SVProgressHUD.dismiss();
                    print("我是网络的")
                    let d : NSDictionary = json as! NSDictionary;
                    
                    if d.value(forKey: "code") as! String == "0" {
                        
                        
                        let logoSingle =  SingleOnce.shared;
                        
                        let user : UserInfoModel = UserInfoModel()
                        
                        user.mj_setKeyValues((d.value(forKey: "detail") as! Array)[0]);
                        
                        let udf = UserDefaults.standard
                        
                        udf.setValuesForKeys(["userInfo": (d.value(forKey: "detail") as! Array)[0]]);
                        
                        logoSingle.userInfo = user;
                        
                        print(logoSingle.userInfo.name);
                        
                        block("success")
                        
                    } else {
                        SVProgressHUD.dismiss();
                        
                        let v = SCLAlertView.init();
                        
                        v.showError("登陆失败", subTitle: "请确认账号密码是否正确");
                        
                    }
                    
                    return
                }
                
               

            case .failure(let error):
                SVProgressHUD.dismiss();
                print(error)
                let v = SCLAlertView.init();
                v.showError("注意", subTitle: "无法连接到服务器, 请检查你的网络环境");
            }
        
        }
     
//
//        logo.postRequestWithURL(path: apiUrl, parameter: parameters as [String : AnyObject], complection: { (res) in
//
//            print(res);
//            if let  result = res["code"] {
//
//                if result as! String == "0" {
//                    //登陆成功保存到本地
//                    let userSingle = SingleOnce.shared;
//
//                    userSingle.userInfo.mj_setKeyValues(res["data"]?.object(at: 0))
//
//                    print( userSingle.userInfo.name);
//
//                    block(userSingle.userInfo.name!);
//
//                } else {
//
//                    let alert :  SCLAlertView = SCLAlertView.init();
//                    alert.showNotice("提示", subTitle: "请检查账号密码是否正确",
//                        closeButtonTitle: "确定");
//                }
//
//            } else {
//
//            }
//
//        }) { (err) in
//
//            print(err);
//
//        }
//
        
        
//        DaisyNet.request(apiUrl, method: .post, params: parameters, encoding: URLEncoding.queryString).responseString { response in
//            switch response {
//
//            case .success(let value): print(value)
//            case .failure(let error): print(error)
//            }
//
//        }
//

        
    }
    
    
}
