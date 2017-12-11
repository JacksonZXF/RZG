//
//  SceneChildItemListViewController.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/8.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class SceneChildItemListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var saveTuListBtn: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var tabelView: UITableView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true);
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        self.tabelView.delegate = self;
        
        self.tabelView.dataSource = self;
        
        self.backView.layer.cornerRadius = 8;
        //为按钮添加阴影
        self.backView.layer.shadowOpacity = 0.8
        
        self.backView.layer.shadowColor = UIColor.black.cgColor
        
        self.backView.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        
        
        self.saveTuListBtn.layer.cornerRadius = 8;
        //为按钮添加阴影
        self.saveTuListBtn.layer.shadowOpacity = 0.8
        
        self.saveTuListBtn.layer.shadowColor = UIColor.black.cgColor
        
        self.saveTuListBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        

        
        
        self.shareBtn.layer.cornerRadius = 8;
        //为按钮添加阴影
        self.shareBtn.layer.shadowOpacity = 0.8
        
        self.shareBtn.layer.shadowColor = UIColor.black.cgColor
        
        self.shareBtn.layer.shadowOffset = CGSize(width: 1, height: 1)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if let header = SecneChirldNodesListHeaderView.newInstance(){
            
            header.frame = CGRect(x: 0, y: 0, width: self.tabelView.frame.width, height: 50 * Const().BLWidth)
            
            return header;
        }
        
        return nil;
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50 * Const().BLWidth;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SecneChildNodesListTableViewCell = tabelView.dequeueReusableCell(withIdentifier: "SecneChildNodesListTableViewCell") as! SecneChildNodesListTableViewCell;
        
        return cell;
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
