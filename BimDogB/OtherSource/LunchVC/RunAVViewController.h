//
//  RunAVViewController.h
//  BimDogB
//
//  Created by Chengzhe Bu on 2017/11/13.
//  Copyright © 2017年 Bim. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREEMW [UIScreen mainScreen].bounds.size.width
#define PlayFinishedNotify @"PlayFinishedNotify"

@interface RunAVViewController : UIViewController

@property (nonatomic, copy) void (^playFinished)(void);
@property (nonatomic, strong) NSString *moviePath;//视频路径




@end
