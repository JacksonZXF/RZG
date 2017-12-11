//
//  LogoInViewController.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/14.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView


class LogoInViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var passWorldTextField: UITextField!
    
    @IBOutlet weak var logoInAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        logoInAccount.layer.masksToBounds = true;
        logoInAccount.layer.cornerRadius = 5;
        

        accountTextField.attributedPlaceholder = NSAttributedString(string:"请输入账号",attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])

        passWorldTextField.attributedPlaceholder = NSAttributedString(string:"请输入密码",attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logo(_ sender: Any) {
        
        let alert = SCLAlertView.init();
        
        if self.accountTextField.text == "" {
            
            alert.showError("提示", subTitle: "请输入账号",
                            closeButtonTitle: "确定");
            
        } else if self.passWorldTextField.text == "" {
            
            alert.showError("提示", subTitle: "请输入密码",
                            closeButtonTitle: "确定");
            
        } else {
 
            let logoFunc = LogoFuncationViewModel.init()
            
            logoFunc.logoInSuccess(account: self.accountTextField.text!, passWord: self.passWorldTextField.text!) { (res) in
                print(res);
                self.navigationController?.popViewController(animated: true);
            }
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
