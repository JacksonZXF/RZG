//
//  SnapViewController.swift
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/15.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit
import Toaster
import AVKit


class SnapViewController: UIViewController {
    
    var image: UIImage!
    
    var avAudioPlayer:AVAudioPlayer!
    
    @IBOutlet weak var sureSaveBtn: BorderCornerBtn!
    
    @IBOutlet weak var cancelBtn: BorderCornerBtn!
    
    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
        self.img.image = image;
        self.img.layer.borderColor = UIColor.white.cgColor;
        self.img.layer.borderWidth = 3;
        
        
        self.view.backgroundColor = UIColor.init(white: 1, alpha: 1);
       
        UIView.animate(withDuration: 0.35) {
            
            self.view.backgroundColor = UIColor.init(white: 1, alpha: 0.3);
            
        }
        
    }
  
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func saveImg(_ sender: Any) {
        

       
    }
    
    
    @IBAction func cancenl(_ sender: Any) {
        
      
        self.view.removeFromSuperview();
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
