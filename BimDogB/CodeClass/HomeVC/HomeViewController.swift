//
//  HomeViewController.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/5.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var showMenu : Bool = false;
    
    
    var urlArr : NSArray = ["艺术与生活的优雅邂逅", "艺术与生活的优雅邂逅", "都市LOFT", "总有一款休闲椅适合你", "绿色", "印象·波士顿", "艺术与生活的优雅邂逅", "都市LOFT", "绿色"];
    
    
    var ImgArr : NSArray = ["艺术与生活的优雅邂逅icon", "简易小清新风", "都市LOFT风", "总有一款休闲椅适合你icon", "绿色iocn", "印象·波士顿-1", "款式2", "款式3", "款式4"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView .reloadData()
        
        collectionView.layer.shadowOpacity = 0.3
        
        collectionView.layer.shadowColor = UIColor.black.cgColor
        
        collectionView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        //注册header
        self.collectionView.register(HomeCollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeCollectionReusableView")
        
    }
    
    
    //右上角菜单
    @IBAction func showMenuList(_ sender: Any) {
        
        if showMenu == false {
            

            
            showMenu = true;
            
            
        } else {
            

            
            
            showMenu = false;
            
        }
        
        
        
    }
    
    //发布内容
    @IBAction func editCont(_ sender: Any) {
        
        
        
    }
    
    
    
    @IBAction func toARPage(_ sender: Any) {
        
        
    }
    //设置HeadView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: self.view.frame.size.width, height: 75)
    }
    
    
    //返回自定义HeadView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var v = HomeCollectionReusableView()
        if kind == UICollectionElementKindSectionHeader{
            v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionReusableView", for: indexPath as IndexPath) as! HomeCollectionReusableView
            let title:String = "产品展示"
            v.titleLabel?.text = title
            v.subLabel?.text = "———— Customer Upload ————";
        }
        return v
        
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item % 4 == 0 || (indexPath.item + 1) % 4 == 0{
            
            return CGSize.init(width: 540 * Const().BLWidth, height: 342 * Const().BLWidth);
            
        } else {
            
            return CGSize.init(width: 325  * Const().BLWidth , height: 342 *  Const().BLWidth);
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImgArr.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item % 4 == 0 || (indexPath.item + 1) % 4 == 0{
            
            let cell : HomeListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeListCollectionViewCell", for: indexPath) as! HomeListCollectionViewCell

            cell.faceImg.image = UIImage.init(named: ImgArr.object(at: indexPath.item) as! String);
            
            return cell;
        } else {
            
            let cell : HomeList2CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeList2CollectionViewCell", for: indexPath) as! HomeList2CollectionViewCell
            
            cell.img.image = UIImage.init(named: ImgArr.object(at: indexPath.item) as! String);
            
            return cell;
        }
        
        
    }
    
    @IBOutlet weak var topBaseView: UIView!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let vc :  ManuscriptsViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManuscriptsViewController") as! ManuscriptsViewController
//
//        self.navigationController?.pushViewController(vc, animated: true);
        

//
        
        let cell = collectionView.cellForItem(at: indexPath);
        
        UIView.animate(withDuration: 0.1) {
            
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8);
        }) { (finish) in
            
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform.init(scaleX:1.0, y: 1.0);
            }) { (finish) in
                
                let cellRect = collectionView.convert((cell?.frame)!, to: collectionView);
                
                let location = collectionView.convert(cellRect, to: self.view);
                
                
                let pop : MerchantsViewController =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MerchantsViewController") as! MerchantsViewController

                pop.showLoc = CGRect.init(x: (location.origin.x), y: (location.origin.y), width: (cell?.frame.size.width)!, height: (cell?.frame.size.height)!);
                pop.url = self.urlArr.object(at: indexPath.item) as! NSString
                
                let tran = CATransition.init()
                tran.duration = CFTimeInterval.init(0.1);
                tran.subtype = kCATransitionReveal;
                self.navigationController?.view.layer.add(tran, forKey: nil);
                self.navigationController?.pushViewController(pop, animated: false);
            }
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

