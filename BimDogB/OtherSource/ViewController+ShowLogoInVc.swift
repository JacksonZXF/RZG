//
//  ViewController+ShowLogoInVc.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/7.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class ViewController_ShowLogoInVc: NSObject {
    
    

}

extension UIViewController {
    
    
     func showLogo() {
        
        let logoInvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogoInViewController");
        
        
        self.navigationController?.pushViewController(logoInvc, animated: true);
        
    }

}
