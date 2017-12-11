//
//  RootTabBarViewController.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/13.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RootTabBarViewController: UIViewController ,UINavigationControllerDelegate{

    @IBOutlet weak var homeBtn: UIButton!
    
    @IBOutlet weak var mineBtn: UIButton!
    
    @IBOutlet weak var arBtn: UIButton!
    
    @IBOutlet weak var findBtn: UIButton!
    
    
    let homeVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController");
    
    
    let mineVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MineViewController");
    
        let findVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FindPageViewController");
    
    let cuurentVc = UIViewController.init();
    
    func layoutUI() {
        
        let _width = self.view.frame.width
        let _height = self.view.frame.height - 49;
        
        self.homeVc.view.frame = CGRect.init(x: 0, y: 0, width: _width, height: _height);

        self.mineVc.view.frame = CGRect.init(x: 0, y: 0, width: _width, height: _height);
        
        self.findVc.view.frame = CGRect.init(x: 0, y: 0, width: _width, height: _height);
        
        
        
        //注册controller
        self.addChildViewController(self.homeVc)

        self.addChildViewController(self.findVc)
        
        self.addChildViewController(self.mineVc)
        

        self.view.addSubview(self.homeVc.view)
        
        self.view.bringSubview(toFront: self.arBtn);
        
        //为按钮添加阴影
        self.arBtn.layer.shadowOpacity = 0.3
        self.arBtn.layer.shadowColor = UIColor.lightGray.cgColor
        self.arBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.sharedManager().enable = true;
        
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true;
        
        
        
        self.layoutUI()
        
        
        let udf = UserDefaults.standard
        
        if  udf.value(forKey: "userInfo") != nil {
            
            let logoSingle =  SingleOnce.shared;
            
            let user : UserInfoModel = UserInfoModel()
            
            user.mj_setKeyValues(udf.value(forKey: "userInfo"));
            
            logoSingle.userInfo = user;
            
        } else {
            
            // Do any additional setup after loading the view.
            let logo : LogoInViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogoInViewController") as! LogoInViewController;
            
            self.navigationController?.pushViewController(logo, animated: true);
            
        }
        

    }
    
    
    @IBAction func didClickHeadButtonAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            self.homeBtn.setImage(UIImage.init(named: "首页1"), for: UIControlState.normal);
          
         
            
            self.findBtn.setImage(UIImage.init(named: "发现1"), for: UIControlState.normal);
            
            
        } else if sender.tag == 1 {
            
            self.homeBtn.setImage(UIImage.init(named: "首页"), for: UIControlState.normal);
          
          
            
            self.findBtn.setImage(UIImage.init(named: "发现1"), for: UIControlState.normal);
            
            
        } else if sender.tag == 2 {
            
            self.homeBtn.setImage(UIImage.init(named: "首页"), for: UIControlState.normal);
            
            self.findBtn.setImage(UIImage.init(named: "发现2"), for: UIControlState.normal);
            
        }
        
        
        
        if (sender.tag == 0 && self.cuurentVc == self.homeVc) || (sender.tag == 1 && self.cuurentVc == self.mineVc) {
            
            
            return;
            
        } else {
            
            switch sender.tag {
                
            case 0 : self.replaceController(newController: self.homeVc); break;
                
            case 1 : self.replaceController(newController: self.mineVc); break;
                
            case 2 : self.replaceController(newController: self.findVc); break;
                
            default : break;
                
                
            }
        }
        
        
    }
    

    
    //Mark --- Ar
    @IBAction func showArVc(_ sender: UIButton) {
        
        
        let ARVC : ARScanningViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ARScanningViewController") as! ARScanningViewController;
        
        
        self.navigationController?.delegate = self;
        
        
        let tran = CATransition.init()
        tran.duration = CFTimeInterval.init(0.5);
        tran.type = "cameraIrisHollowOpen";
        tran.subtype = kCATransitionFade;
        self.navigationController?.view.layer.add(tran, forKey: nil);
        
        
        self.navigationController?.pushViewController(ARVC, animated: false);
        
    }
    
    

    
    func replaceController(newController: UIViewController) {
        //判断即将显示的controller是否已经压入栈
        if (newController.view.isDescendant(of: self.view)) {
            //将该controller放到容器最上面显示出来
            self.view.bringSubview(toFront: newController.view);
            
            
        }
            
        else{
            
            self.view.addSubview(newController.view)
            
        }
        
        self.view.bringSubview(toFront: self.arBtn);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



