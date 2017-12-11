//
//  UserInfoModel.h
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/23.
//  Copyright © 2017年 Bim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *office_id;
@property (nonatomic, copy) NSString *login_name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *login_ip;
@property (nonatomic, copy) NSString *login_date;
@property (nonatomic, copy) NSString *login_flag;
@property (nonatomic, copy) NSString *create_date;
@property (nonatomic, copy) NSString *del_flag;
@property (nonatomic, copy) NSString *imei;



@end
