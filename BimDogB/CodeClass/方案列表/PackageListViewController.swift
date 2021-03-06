//
//  PackageListViewController.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/17.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit

class PackageListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

   
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true);
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PackageListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PackageListTableViewCell") as! PackageListTableViewCell
        
        
        return cell;
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
