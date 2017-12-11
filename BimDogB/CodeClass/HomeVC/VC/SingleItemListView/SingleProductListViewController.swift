//
//  SingleProductListViewController.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/14.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit
import SCLAlertView
import DaisyNet
import Alamofire
import SwiftyJSON
import Cache

class SingleProductListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var lookStyle : Int = 1;
    @IBOutlet weak var changeStyleBtn: UIButton!
    
    var virtualArr : NSMutableArray!
    var storage: Storage?
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        handelModelData();
    }
    
    func handelModelData() {
        
        let userinfo = SingleOnce.shared;
        
        let urlName = String.init(format: "username=%@", arguments: [userinfo.userInfo.login_name]);
        //        let tiemstamp = String.init(format: "timestamp=%@", arguments: [BCZTool.stringToTimeStamp()]);
        let tiemstamp = "timestamp=78956"
        let signStr = "sign=4B58D3A1F717E6C703678A7FAD49A96C";
        //1单品 2 场景
        let  type = "type=3";
        //查询类型 0 所有
        let num = "num=1"
        
        let apiUrl = String.init(format: "%@%@&%@&%@&%@&%@", arguments: [ConstAPI.kAPIGetModelList, urlName, tiemstamp, signStr, type, num])
        print(apiUrl);
        
        
        DaisyNet.request(apiUrl, method: .get, encoding: JSONEncoding.default, headers: nil).cache(true).responseCacheAndJson { value in
            
            switch value.result {
                
            case .success(let json):
                
                if value.isCacheData {
                    
                    
                } else {
                    
                    let d : NSDictionary = json as! NSDictionary;
                    
                    if d.value(forKey: "code") as! String ==  "0" {
                        
                        let virtModel = VirtualModel.init()
                        
                        self.virtualArr = NSMutableArray.init(capacity: 0);
                        
                        for dic in (d.value(forKey: "detail") as! Array<Any>) {
                            
                            virtModel.mj_setKeyValues(dic);
                            
                            self.virtualArr.add(virtModel);
                            
                        }
                        
         
                        
                        self.collectionView.reloadData();
                        
                    } else {
                        
                        let v = SCLAlertView.init();
                        
                        v.showError("错误", subTitle: "获取资源失败");
                        
                        self.collectionView.reloadData();
                        
                    }
                    
                }
                
            case .failure(let error):
                
                print(error);
                
                self.collectionView.reloadData();
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.virtualArr = NSMutableArray.init(capacity: 0);
        

        self.collectionView.delegate = self;
        
        self.collectionView.dataSource = self;
        // Do any additional setup after loading the view.
    }

    @IBAction func changeLookStyle(_ sender: Any) {
        
        if self.lookStyle == 1 {
            
            self.lookStyle = 2;
            

        } else {
            
            self.lookStyle = 1;
        }
        self.collectionView .reloadData();
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.virtualArr.count;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if lookStyle == 1 {
            
            
            return CGSize.init(width: 107 * Const().BLWidth, height: 107 * Const().BLWidth)
          
        } else {
            
            return CGSize.init(width: 328 * Const().BLWidth, height: 109 * Const().BLWidth)
            
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if lookStyle == 1 {
            
            
            
            let cell : SingleProduct1CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleProduct1CollectionViewCell", for: indexPath) as! SingleProduct1CollectionViewCell;
            
            let definition : VirtualObjectDefinition = VirtualObjectManager.availableObjects[indexPath.item]
            
            cell.img.image = UIImage.init(named: definition.FaceImage) ;
            
            
            
            return cell;
            
        } else {
            
            let cell : SingleProduct2CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleProduct2CollectionViewCell", for: indexPath) as! SingleProduct2CollectionViewCell;
            
             let definition : VirtualObjectDefinition = VirtualObjectManager.availableObjects[indexPath.item]
            
            cell.img.image = UIImage.init(named: definition.FaceImage);
            
        
            return cell;
            
            
        }
        
        
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
