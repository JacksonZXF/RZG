//
//  FindPageViewController.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/27.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit


class FindPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    
    
    
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    var topDataArr : NSArray = ["All","柜子","沙发", "茶几", "床", "桌子", "灯具", "窗帘", "架子", "其他"];
    
    var feedItems: NSArray = NSArray()
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        
        self.itemCollectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.handelData();
        
        self.topCollectionView.reloadData();
    }
    
    func handelData() {
        
        itemsDownloaded(items: VirtualObjectManager.availableObjects as NSArray);
        print((VirtualObjectManager.availableObjects as NSArray).count)
        
        self.itemCollectionView.reloadData();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.topCollectionView.delegate = self;
        
        self.topCollectionView.dataSource = self;
        
        self.itemCollectionView.delegate = self;
        
        self.itemCollectionView.dataSource = self;
        
        self.itemCollectionView.register(UINib.init(nibName: "FindEmpCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FindEmpCollectionViewCell");
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 0 {
            
            return CGSize.init(width: 70 * Const().BLWidth, height: 70 * Const().BLWidth);
            
        } else {
            
            
            return CGSize.init(width: (self.itemCollectionView.frame.size.width - 50) / 4, height:(self.itemCollectionView.frame.size.height - 30) / 2);
            
        }
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView.tag  == 1 {
            
            
            if (VirtualObjectManager.availableObjects as NSArray).count < 8  && (VirtualObjectManager.availableObjects as NSArray).count != 0{
                
                return 1;
                
            } else {
                
                if feedItems.count % 8 > 0 {
                    
                    
                    return Int((feedItems as NSArray).count / 8) + 1;
                    
                } else {
                    
                    return ((feedItems as NSArray).count / 8);
                    
                }
                
            }
        } else {
            
            return 1;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 0 {
            
            return topDataArr.count;
            
        } else {
            
            return 8;
            
            
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            
            let cell : FindTopCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindTopCollectionViewCell", for: indexPath) as! FindTopCollectionViewCell;
            
            cell.img.image = UIImage.init(named: self.topDataArr.object(at: indexPath.item) as! String);
            
            return cell;
            
        } else {
            
            if (indexPath.item + indexPath.section * 8) < feedItems.count{
                
                let cell : Find1ItemListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Find1ItemListCollectionViewCell", for: indexPath) as! Find1ItemListCollectionViewCell;
                
                let definition : VirtualObjectDefinition  = feedItems[(indexPath.item + indexPath.section * 8)] as! VirtualObjectDefinition
                
                cell.model = definition;
                
                return cell;
                
            } else {
                
                //占位Cell
                let cell : FindEmpCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindEmpCollectionViewCell", for: indexPath) as! FindEmpCollectionViewCell;
                
                return cell;
                
            }
            
            
            
        }
        
        
    }
    
    var virtualObjectManager: VirtualObjectManager!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 0 {
            
            var  str : String = self.topDataArr.object(at: indexPath.item) as! String;
            
            
            let resArr = NSMutableArray.init(capacity: 0);
            
            for object in  VirtualObjectManager.availableObjects{
                
                
                if str == "All" {
                    
                    resArr.add(object);
                    
                } else {
                    
                    if object.Category == str {
                        
                        resArr.add(object);
                    }
                }
                
                
                
            }
            
            itemsDownloaded(items: resArr);
            
            if feedItems.count != 0 {
                self.itemCollectionView.scrollToItem(at: NSIndexPath.init(row: 0, section: 0) as IndexPath, at: UICollectionViewScrollPosition.left, animated: false);
                
            };
            
        } else {
            
            
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
