//
//  SecneChirldNodesListHeaderView.swift
//  BimDog
//
//  Created by Chengzhe Bu on 2017/11/7.
//  Copyright © 2017年 Bim. All rights reserved.
//

import UIKit



class SecneChirldNodesListHeaderView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layer.cornerRadius = 8;
        //为按钮添加阴影
        self.layer.shadowOpacity = 0.8
        
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
    }
   
    static func newInstance() -> SecneChirldNodesListHeaderView?{
        
        let nibView = Bundle.main.loadNibNamed("SecneChirldListHeader", owner: nil, options: nil)
        if let view = nibView?.first as? SecneChirldNodesListHeaderView{
            
            view.layer.cornerRadius = 8;
            //为按钮添加阴影
            view.layer.shadowOpacity = 0.8
            
            view.layer.shadowColor = UIColor.black.cgColor
            
            view.layer.shadowOffset = CGSize(width: 1, height: 1)
            
            return view
        }
        return nil
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        load_init()
      
    }
    
    func load_init(){
        
        
    }
    

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
