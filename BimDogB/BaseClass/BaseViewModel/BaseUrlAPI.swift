//
//  BaseUrlAPI.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/14.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit
import Alamofire

// API 接口定义
struct ConstAPI {
    
    static let kAPIBaseURL: String = "http://47.96.173.104:8092/design/"
//    static let kAPIBaseURL: String = "http://192.168.1.116:8080/design/"
    
    //登录
    static let kAPILogoIn: String = kAPIBaseURL + "buslogin?"
    
    // 首页目的地
    static let kAPIGetModelList: String = kAPIBaseURL + "getmodels?"
    
    
}

class BaseUrlAPI: NSObject {
    
    static let defult = BaseUrlAPI()
    
    private override init() {
        // 单例模式，防止出现多个实例
    }
    
    func getRequestWithURL(path :String,parameter:[String: AnyObject]?, success: @escaping (_ result: [String: AnyObject]) -> Void ,failure: @escaping (_ error: Error) -> Void ) -> Void {
        
        Alamofire.request(path, method: .get, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
            
            if response.error != nil {
                failure(response.error!)
                return;
            }
            
            
            if let JSON = response.result.value {
                success(JSON as! [String: AnyObject])
            }
            
            
            
            return
        }
    }
    
    func postRequestWithURL(path :String,parameter:[String: AnyObject]?, complection: @escaping (_ result: [String: AnyObject]) -> Void,failure: @escaping (_ error: Error) -> Void  ) -> Void {
        
        Alamofire.request(path, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
            
            if response.error != nil {
                
                failure(response.error!)
                
                return;
            }
            
            if let JSON = response.value {
                
                complection(JSON as! [String : AnyObject])
            }
            
            return
        }
    }
    
    
    // delete、put 请求自己添加
}

// 用户相关常用 HTTP
extension BaseUrlAPI {
    
    func doLogout(success: @escaping (_ result: [String: AnyObject]) -> Void , failure: @escaping (_ error: Error) -> Void ) {
        
        
    }
    
    func doLogin(success: @escaping (_ result: [String: AnyObject]) -> Void , failure: @escaping (_ error: Error) -> Void ) {
        
    }
    
    func authorizationCheck(success: @escaping (_ result: [String: AnyObject]) -> Void , failure: @escaping (_ error: Error) -> Void ) {
        
    }

}
