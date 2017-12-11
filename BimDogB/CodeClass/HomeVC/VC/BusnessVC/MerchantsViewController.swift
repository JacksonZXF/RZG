//
//  MerchantsViewController.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/16.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class MerchantsViewController: UIViewController, UIGestureRecognizerDelegate {

    //格式: typealias 闭包名称 = (参数名称: 参数类型) -> 返回值类型
    typealias swiftBlock = () -> Void

    //2. 声明一个变量
    var callBack: swiftBlock?

    //3. 定义一个方法,方法的参数为和swiftBlock类型一致的闭包,并赋值给callBack
    func callBackBlock(block: @escaping () -> Void) {

        callBack = block
    }
    
    var url: NSString!
    
    var showLoc: CGRect!
    
    @IBOutlet weak var webView: WKWebView!
    
    var tap = UITapGestureRecognizer();
    
    @IBOutlet weak var showInArBtn: UIButton!
    
    @IBAction func showInAr(_ sender: Any) {
        
        
    }
    
    
    @IBOutlet weak var backView: UIButton!
    
    @IBAction func BackSelf(_ sender: Any) {
        
        let tran = CATransition.init()
        tran.duration = CFTimeInterval.init(0.1);
        tran.subtype = kCATransitionFade;
        self.navigationController?.view.layer.add(tran, forKey: nil);
        
        UIView.animate(withDuration: 0.6, animations: {
            
             self.webView.frame = CGRect.init(x: self.showLoc.origin.x, y: self.showLoc.origin.y, width: self.showLoc.size.width, height: self.showLoc.size.height);
            
        }) { (finish) in
            self.navigationController?.popViewController(animated: false);
        }
       
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(showLoc);
        
        webView.frame = CGRect.init(x: self.showLoc.origin.x, y: self.showLoc.origin.y, width: self.showLoc.size.width, height: self.showLoc.size.height);
        webView.backgroundColor = UIColor.white;
        
        webView.scrollView.backgroundColor = UIColor.white;
        //创建网址
//        let url = NSURL(string: self.url as String)
        
        let  jsonURL = Bundle.main.url(forResource: url as String?, withExtension: "png");
        
        if jsonURL != nil  {
            self.webView.load(URLRequest.init(url: jsonURL!));
            
        }
 
        if url != nil {
            
            //创建请求
            //            let request = NSURLRequest.init(url: url! as URL);
            //            let fileUrl = NSURL.init(fileURLWithPath: Bundle.main.path(forResource: "testPdf", ofType: ".pdf")!);
            //
         
            
        }
        
        self.view.backgroundColor = UIColor.white;
        
        UIView.animate(withDuration: 0.6, animations: {
            
           self.webView.frame = CGRect.init(x: 120, y: 0, width: self.view.frame.size.width - 240, height: self.view.frame.size.height);
            
        }) { (finish) in
            
            
         
            
        }
        
 
      
        

   
   
        
        
//        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
//
//        UIView.animate(withDuration: 0.65) {
//
//            self.view.backgroundColor = UIColor.init(white: 1, alpha: 0.3);
//
//        }
        
        self.webView.layer.cornerRadius = 8;
        
        self.webView.layer.masksToBounds = true;
        
        let config  = WKWebViewConfiguration()
        
        config.selectionGranularity = WKSelectionGranularity.character;
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.webView = nil;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        
    }
    
    @objc func tapGes() {
        
        if tap.state == UIGestureRecognizerState.ended{
            
//            callBack!();
            
//            self.dismiss(animated: true, completion: {
//
//            })
        }
        
    }
    
    

    @IBAction func dmis(_ sender: Any) {
        
//        callBack!();
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
