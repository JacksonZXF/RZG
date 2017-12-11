//
//  MineViewController.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/13.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit
import SCLAlertView
import DaisyNet
import Alamofire
import SwiftyJSON
import Cache

class MineViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var storage: Storage?
    
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var virtualArr : NSMutableArray!
    
    @IBOutlet weak var settingBtn: UIButton!
    
    @IBOutlet weak var textBtn: UIButton!
    
    @IBOutlet weak var singleitemBtn: UIButton!
    
    @IBOutlet weak var itemNumLab: UILabel!
    
    @IBOutlet weak var textNumLab: UILabel!
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    
    
    
    
    
    @IBOutlet weak var eidtBtn: UIButton!//编辑已经保存的
    
    @IBOutlet weak var collectionView2: UICollectionView!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        handelUserData()
    
        handelModelData()
    }
    
    func handelUserData() {
        
        let userinfo = SingleOnce.shared
        
        self.nameLab.text = userinfo.userInfo.name;
        
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
                        
                        
                        self.storage?.async.setObject(self.virtualArr , forKey: "AllVirtualModel", completion: { _ in
                            
                        })
                        
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

        // Do any additional setup after loading the view.
        self.virtualArr = NSMutableArray.init(capacity: 0);
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        collectionView2.delegate = self;
        collectionView2.dataSource = self;
        
        
        self.logoImg.layer.cornerRadius = self.logoImg.frame.width / 2;
        self.logoImg.layer.masksToBounds = true;
        self.settingBtn.layer.cornerRadius = 4;
        self.settingBtn.layer.masksToBounds = true;
        
 
    }

    @IBAction func signOUTAccount(_ sender: UIButton) {
    
        self.showLogo();
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
             return virtualArr.count;
        } else {
             return 1 + 1;
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            
            return CGSize.init(width: 137 * Const().BLWidth, height: 137 * Const().BLWidth);
            
            
        } else {
            
            return CGSize.init(width: 137 * Const().BLWidth, height: 137 * Const().BLWidth);
            
        }
     
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {

                
                let cell : MySaveSceneCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MySaveSceneCollectionViewCell", for: indexPath) as! MySaveSceneCollectionViewCell
                 let definition = VirtualObjectManager.availableObjects[indexPath.row]
                cell.img.image = UIImage.init(named: definition.FaceImage)
                return cell;
            
        } else {
            
            if indexPath.item == 1 {
                
                let cell : SingleItemAll_AddCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleItemAll_AddCollectionViewCell", for: indexPath) as! SingleItemAll_AddCollectionViewCell
                

                
                return cell;
                
            } else {
                
                let cell : SingleItemAllCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleItemAllCollectionViewCell", for: indexPath) as! SingleItemAllCollectionViewCell
                
                return cell;
                
            }
        }
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
     
            
        } else {
            
            if indexPath.item == 1{
                
                let ARVC : ARScanningViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ARScanningViewController") as! ARScanningViewController;

                self.navigationController?.pushViewController(ARVC, animated: false);
                
            } else {
                
                let vc : PackageListViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PackageListViewController") as! PackageListViewController
                
                
                self.navigationController?.pushViewController(vc, animated: true);
                
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
 

}
