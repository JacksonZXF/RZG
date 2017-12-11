//
//  VirtualModel.h
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/24.
//  Copyright © 2017年 Bim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VirtualModel : NSObject
    
@property (nonatomic, copy) NSString *belong_type;
@property (nonatomic, copy) NSString *del_flag;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *model_size;
@property (nonatomic, copy) NSString *model_type;
@property (nonatomic, copy) NSString *modelfile;
@property (nonatomic, copy) NSString *modelnamet;
@property (nonatomic, copy) NSString *modelnum;
@property (nonatomic, copy) NSString *modelpic;
@property (nonatomic, copy) NSString *office_id;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *scene_id;

@end
