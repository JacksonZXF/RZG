//
//  CloudFitTool.m
//  CloudFit_B2.0
//
//  Created by 卜成哲 on 16/9/12.
//  Copyright © 2016年 卜成哲. All rights reserved.
//

#import "CloudFitTool.h"


#define KFacialSizeWidth    32

#define KFacialSizeHeight   32

#define KCharacterWidth     8

#define VIEW_LINE_HEIGHT    32

#define VIEW_LEFT           0

#define VIEW_RIGHT          5

#define VIEW_TOP            8

#define VIEW_WIDTH_MAX      238

#define FACE_NAME_HEAD  @"["

// 表情转义字符的长度（ /s占2个长度，xxx占3个长度，共5个长度 ）
#define FACE_NAME_LEN   4


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>

#include <ctype.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <dirent.h>
#import <CommonCrypto/CommonDigest.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/sockio.h>
#import <objc/runtime.h>

#define PATTERN_STR         @"\\[[^\\[\\]]*\\]"



@implementation CloudFitTool


+(NSDictionary*)dictionaryFromBundleWithName:(NSString*)fileName withType:(NSString*)typeName
{
    NSDictionary * dict = nil;
    NSString *infoPlist = [[NSBundle mainBundle] pathForResource:fileName ofType:typeName];
    
    if ([[NSFileManager defaultManager] isReadableFileAtPath:infoPlist]) {
        NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:infoPlist];
        return dict;
    }
    return dict;
}


//MD5转换
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

+(void)removeLoadingViewAndLabelInView:(UIView*)viewToLoadData
{
    //viewToLoadData.hidden = NO;
    UIActivityIndicatorView * breakingLoadingView = (UIActivityIndicatorView*)[viewToLoadData  viewWithTag:10087];
    [breakingLoadingView stopAnimating];
    
    [[viewToLoadData  viewWithTag:10086] removeFromSuperview];
}



+(void)addLoadingViewAndLabelInView:(UIView*)viewToLoadData usingOrignalYPosition:(CGFloat)yPosition
{
    
    UIView * loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, yPosition, viewToLoadData.frame.size.width , 60)];
    loadingView.tag = 10086;
    
    
    UIFont * labelFont = [UIFont systemFontOfSize:14.0f];
    
    //    NSString *string = @"加载中";
    CGSize  labelSize = [@"加载中" sizeWithFont:labelFont];
    //    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]};
    //    CGSize labelSize = [string sizeWithAttributes:attributes];
    if (![viewToLoadData viewWithTag:10087]) {
        UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.frame = CGRectMake(( loadingView.frame.size.width - labelSize.width-20-5)/2, 15.0f, 20.0f, 20.0f);
        activityIndicatorView.tag = 10087;
        [loadingView addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
    }
    
    
    if (![viewToLoadData viewWithTag:10088]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([loadingView viewWithTag:10087] .frame.origin.x + 20+5, 10.0f, labelSize.width, 30.0f)];
        label.tag = 10088;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = labelFont;
        label.textColor = [UIColor whiteColor];
        // label.shadowColor = [UIColor colorWithWhite:.9f alpha:1.0f];
        //label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        //        label.textAlignment = UITextAlignmentLeft;
        label.text = @"加载中";
        [loadingView addSubview:label];
    }
    [viewToLoadData addSubview:loadingView];
    
}



#pragma mark - Only ActivityView

+(void)addLoadingViewInView:(UIView*)viewToLoadData usingUIActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)aStyle usingColor:(UIColor*)color
{
    UIActivityIndicatorView * breakingLoadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:aStyle];
    breakingLoadingView.tag = 99;
    breakingLoadingView.center = CGPointMake( (viewToLoadData.frame.size.width-40)/2+20, (viewToLoadData.frame.size.height-40)/2+20);
    breakingLoadingView.color = color;
    [breakingLoadingView startAnimating];
    [viewToLoadData addSubview:breakingLoadingView];
    
    
}


+(void)addLoadingViewInView:(UIView*)viewToLoadData usingUIActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)aStyle
{
    
    //    [self addLoadingViewInView:viewToLoadData usingUIActivityIndicatorViewStyle:aStyle usingColor:[UIColor redColor]];
}

+(void)removeLoadingViewInView:(UIView*)viewToLoadData
{
    UIActivityIndicatorView * breakingLoadingView = (UIActivityIndicatorView*)[viewToLoadData  viewWithTag:99];
    [breakingLoadingView stopAnimating];
    [breakingLoadingView removeFromSuperview];
}

+ (NSDate *)getNowTime
{
    return [NSDate date];
}

+(NSString *)getyyyymmddHHmmss{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyyMMddHHmmss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}

+(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}


+(NSString *)getyyyymm{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}

+(NSString *)gethhmmss{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatTime = [[NSDateFormatter alloc] init];
    formatTime.dateFormat = @"HH:mm:ss";
    NSString *timeStr = [formatTime stringFromDate:now];
    
    return timeStr;
    
}

+(NSString *)gethhmm{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatTime = [[NSDateFormatter alloc] init];
    formatTime.dateFormat = @"HH:mm";
    NSString *timeStr = [formatTime stringFromDate:now];
    
    return timeStr;
    
}


+(NSString *)getyyyy_mm_dd_HHmmss{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}




+ (NSMutableArray *)getDaysWithBeforeDayCount:(NSInteger)dayCount AfterDayCount:(NSInteger)afterDaycount WithFormat:(NSString *)format{
    
    NSMutableArray *daysArr = [NSMutableArray arrayWithCapacity:0];
    
    
    NSInteger bef = dayCount; //前的天数
    
    NSInteger aft = afterDaycount; //后的天数
    
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度

    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *nowDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"enddate=%@",nowDate);

    //把前一天装入数组
    if (bef != 0) {
        
        for (int a = 1; a < dayCount + 1; a ++) {
            
           NSDate *befDate = [nowDate initWithTimeIntervalSinceNow: - oneDay * a];
   
            
        [daysArr addObject:[CloudFitTool stringFromDate:[befDate  dateByAddingTimeInterval:interval] usingFormat:format]];
            
        }
        
        
    }
    
    [daysArr addObject:@"今天"];
    
    //把后一天装入数组
    if (aft != 0) {
        
        for (int a = 1; a < aft + 1; a ++) {
            
            if (a == 1) {
                [daysArr addObject:@"明天"];
            } else {
            
                NSDate *aftDate = [nowDate initWithTimeIntervalSinceNow: + oneDay * a];
            
                [daysArr addObject:[CloudFitTool stringFromDate:[aftDate  dateByAddingTimeInterval:interval] usingFormat:@"MM.dd"]];
            }
        }
        
        
    }


    return daysArr;
    
    

}


+ (NSString *)get1970timeString{
    return [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970] * 1000];
}
+ (NSString *)getTimeString:(NSDate *)date{
    return [NSString stringWithFormat:@"%lld",(long long)[date timeIntervalSince1970] * 1];
}
+ (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return documentsDirectoryPath;
}







+ (void)showNotReachabileTips
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"与服务端连接已断开,请检查您的网络连接是否正常."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

+(NSDate *)dateFromString:(NSString *)dateString usingFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (NSString *)stringFromDate:(NSDate *)date usingFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
+ (NSString *)getDeviceOSType
{
    NSString *systemVersion =  [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
    return systemVersion;
}
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation //图片旋转
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

//将图片保存到应用程序沙盒中去,imageNameString的格式为 @"upLoad.png"
+ (void)saveImagetoLocal:(UIImage*)image imageName:(NSString *)imageNameString
{
    if (image == nil || imageNameString.length == 0) {
        return;
    }
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *saveImagePath=[documentsDirectory stringByAppendingPathComponent:imageNameString];
    NSData *imageDataJPG=UIImageJPEGRepresentation(image, 0);//将图片大小进行压缩
    //    NSData *imageData=UIImagePNGRepresentation(image);
    [imageDataJPG writeToFile:saveImagePath atomically:YES];
}

//md5转换
+ (NSString *) fileMd5sum:(NSString * )filename
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filename];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}


#pragma mark - 将字符串中的文字和表情解析出来
+ (NSMutableArray *)decorateString:(NSString *)string
{
    NSMutableArray *array =[NSMutableArray array];
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:PATTERN_STR
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    NSArray* chunks = [regex matchesInString:string options:0
                                       range:NSMakeRange(0, [string length])];
    NSMutableArray *matchRanges = [NSMutableArray array];
    
    for (NSTextCheckingResult *result in chunks) {
        NSString *resultStr = [string substringWithRange:[result range]];
        
        if ([resultStr hasPrefix:@"["] && [resultStr hasSuffix:@"]"]) {
            NSString *name = [resultStr substringWithRange:NSMakeRange(1, [resultStr length]-2)];
            name=[NSString stringWithFormat:@"[%@]",name];
            //   NSLog(@"name:%@",name);
            NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
            if ([[faceMap allValues] containsObject:name]) {
                //                [array addObject:name];
                [matchRanges addObject:[NSValue valueWithRange:result.range]];
            }
        }
    }
    
    NSRange r = NSMakeRange([string length], 0);
    [matchRanges addObject:[NSValue valueWithRange:r]];
    
    NSUInteger lastLoc = 0;
    for (NSValue *v in matchRanges) {
        
        NSRange resultRange = [v rangeValue];
        if (resultRange.location==0) {
            NSString *faceString = [string substringWithRange:resultRange];
            //   NSLog(@"aaaaaaaaa:faceString:%@",faceString);
            if (faceString.length!=0) {
                [array addObject:faceString];
            }
            
            NSRange normalStringRange = NSMakeRange(lastLoc, resultRange.location - lastLoc);
            NSString *normalString = [string substringWithRange:normalStringRange];
            lastLoc = resultRange.location + resultRange.length;
            //   NSLog(@"aaaaaaa:normalString:%@",normalString);
            if (normalString.length!=0) {
                [array addObject:normalString];
            }
        }else{
            NSRange normalStringRange = NSMakeRange(lastLoc, resultRange.location - lastLoc);
            NSString *normalString = [string substringWithRange:normalStringRange];
            lastLoc = resultRange.location + resultRange.length;
            //   NSLog(@"bbbbbbb:normalString:%@",normalString);
            if (normalString.length!=0) {
                [array addObject:normalString];
            }
            
            NSString *faceString = [string substringWithRange:resultRange];
            //   NSLog(@"bbbbbbbb:faceString:%@",faceString);
            if (faceString.length!=0) {
                [array addObject:faceString];
            }
        }
    }
    if ([matchRanges count]==0) {
        if (string.length!=0) {
            [array addObject:string];
        }
    }
    //   NSLog(@"array:%@",array);
    
    return array;
}

#pragma mark - 获取文本尺寸
/*
 + (CGFloat)getContentSize:(NSArray *)messageRange
 {
 @synchronized ( self ) {
 CGFloat upX;
 
 CGFloat upY;
 
 CGFloat lastPlusSize;
 
 CGFloat viewWidth;
 
 CGFloat viewHeight;
 
 BOOL isLineReturn;
 
 //        RelayBottleList *mineBottleListObject = [relayBottleArray objectAtIndex:indexPath.row];
 //        NSArray *messageRange = mineBottleListObject.messageRange;
 
 NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
 
 UIFont *font = [UIFont systemFontOfSize:16.0f];
 
 isLineReturn = NO;
 
 upX = VIEW_LEFT;
 upY = VIEW_TOP;
 
 for (int index = 0; index < [messageRange count]; index++) {
 
 NSString *str = [messageRange objectAtIndex:index];
 if ( [str hasPrefix:FACE_NAME_HEAD] ) {
 
 //NSString *imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
 
 NSArray *imageNames = [faceMap allKeysForObject:str];
 NSString *imageName = nil;
 NSString *imagePath = nil;
 
 if ( imageNames.count > 0 ) {
 
 imageName = [imageNames objectAtIndex:0];
 imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
 }
 
 if ( imagePath ) {
 
 if ( upX > ( VIEW_WIDTH_MAX - KFacialSizeWidth ) ) {
 
 isLineReturn = YES;
 
 upX = VIEW_LEFT;
 upY += VIEW_LINE_HEIGHT;
 }
 
 upX += KFacialSizeWidth;
 
 lastPlusSize = KFacialSizeWidth;
 }
 else {
 
 for ( int index = 0; index < str.length; index++) {
 
 NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
 
 CGSize size = [character sizeWithFont:font
 constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
 
 if ( upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) ) {
 
 isLineReturn = YES;
 
 upX = VIEW_LEFT;
 upY += VIEW_LINE_HEIGHT;
 }
 
 upX += size.width;
 
 lastPlusSize = size.width;
 }
 }
 }
 else {
 
 for ( int index = 0; index < str.length; index++) {
 
 NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
 
 CGSize size = [character sizeWithFont:font
 constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
 
 if ( upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) ) {
 
 isLineReturn = YES;
 
 upX = VIEW_LEFT;
 upY += VIEW_LINE_HEIGHT;
 }
 
 upX += size.width;
 
 lastPlusSize = size.width;
 }
 }
 }
 
 if ( isLineReturn ) {
 
 viewWidth = VIEW_WIDTH_MAX + VIEW_LEFT * 2;
 }
 else {
 
 viewWidth = upX + VIEW_LEFT;
 }
 
 viewHeight = upY + VIEW_LINE_HEIGHT + VIEW_TOP;
 
 NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake( viewWidth, viewHeight )];
 NSLog(@"%@",sizeValue);
 //        [sizeList setObject:sizeValue forKey:indexPath];
 //        [sizeList addObject:sizeValue];
 return viewHeight;
 }
 }
 */
//正则表达式判断～～～
//#define MOBILE_REG "^1[0-9]{10}$"                                                /* 手机号正则表达式     */
//#define EMAIL_REG  "^[a-zA-Z0-9_+.-]{2,}@([a-zA-Z0-9-]+[.])+[a-zA-Z0-9]{2,4}$"    /* 邮箱正则表达式       */
//#define USRNAM_REG "^[A-Za-z0-9_]{6,20}$"                                         /* 用户名正则表达式     */

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
//    手机号以13， 15，18, 17 开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
 
}
//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    //    NSString *userNameRegex = @"^[A-Za-z0-9]{4,20}+$";
    NSString *userNameRegex = @"^[A-Za-z0-9_]{6,20}$";
    
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    
    if (B == NO) {
        
        
    }
    
    return B;
    

    
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{8,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
       
    /**对一个对象评估一个谓词**/
    return [passWordPredicate evaluateWithObject:passWord];
}
//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"([\u4e00-\u9fa5]{2,5})(&middot;[\u4e00-\u9fa5]{2,5})*";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//银行卡
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
//银行卡后四位
+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length != 4) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{4})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
//CVN
+ (BOOL) validateCVNCode: (NSString *)cvnCode
{
    BOOL flag;
    if (cvnCode.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{3})";
    NSPredicate *cvnCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [cvnCodePredicate evaluateWithObject:cvnCode];
}
//month
+ (BOOL) validateMonth: (NSString *)month
{
    BOOL flag;
    if (!(month.length == 2)) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"(^(0)([0-9])$)|(^(1)([0-2])$)";
    NSPredicate *monthPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [monthPredicate evaluateWithObject:month];
}
//year
+ (BOOL) validateYear: (NSString *)year
{
    BOOL flag;
    if (!(year.length == 2)) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^([1-3])([0-9])$";
    NSPredicate *yearPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [yearPredicate evaluateWithObject:year];
}
//verifyCode
+ (BOOL) validateVerifyCode: (NSString *)verifyCode
{
    BOOL flag;
    if (!(verifyCode.length == 6)) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{6})";
    NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [verifyCodePredicate evaluateWithObject:verifyCode];
}

//RMB
+ (BOOL) validateMoney:(NSString *)money
{
    
    
    NSString *moneyRegex = @"^[0-9]+(.[0-9]{2})?$";
    NSPredicate *moneyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", moneyRegex];
    return [moneyTest evaluateWithObject:money];
}


//加载XIB
//+(id)loadFromXIB:(NSString *)XIBName{
//    NSArray *array = [[NSBundle mainBundle] loadNibNamed:XIBName owner:nil options:nil];
//    if (array && [array count]) {
//        return array[0];
//    }else {
//        return nil;
//    }
//}
+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }else {
            p++;
        }
    }
    return strlength;
}

- (int)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return (int)[da length];
}
//压缩图片质量
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}
//压缩图片尺寸
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
//自定义字符串长度
+ (CGSize)getWidthByString:(NSString*)string withFont:(UIFont *)stringFont withStringSize:(CGSize)stringSize
{
    NSDictionary *attribute = @{NSFontAttributeName: stringFont};
    CGSize size = [string boundingRectWithSize:stringSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    NSLog(@"withd:%f,height:%f",size.width,size.height);
    return size;
}

+ (BOOL)checkNum:(NSString *)str
{
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}
//一键赋值
+ (NSArray*)propertyKeys:(id)selfObject

{
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([selfObject class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([propertyName isEqualToString:@"selfId"]) {
            propertyName = @"id";
        }
        [keys addObject:propertyName];
        
    }
    
    free(properties);
    
    return keys;
    
}


// View转化为图片
+ (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// imageView转化为图片
+ (UIImage *)getImageFromImageView:(UIImageView *)imageView
{
    UIGraphicsBeginImageContext(imageView.bounds.size);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (NSInteger)getCellMaxNum:(CGFloat)cellHeight maxHeight:(CGFloat)height
{
    CGFloat num=height/cellHeight;
    int num1=(int)(height/cellHeight);
    NSInteger num2;
    if (num>num1*1.0) {
        num2=num1+1;
    }else
    {
        num2=num1;
    }
    return num2;
}
//匹配数字和英文字母
+ (BOOL) isNumberOrEnglish:(NSString *)string
{
    int i=0;
    if (i<string.length) {
        NSString *passWordRegex = @"^[A-Za-z0-9]+$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
        return [passWordPredicate evaluateWithObject:string];
    }
    return YES;
}
//匹配数字
+ (BOOL) isKimiNumber:(NSString *)number
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
//是否存在字段
+ (BOOL)rangeString:(NSString *)string searchString:(NSString *)searchString
{
    NSRange range = [string rangeOfString:searchString];
    if (range.length > 0) {
        return YES;
    } else {
        return NO;
    }
}


+ (NSString *)server_error500Info:(NSError *)err {
    
    
    NSData * data = err.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"服务器的错误原因===>:%@  错误码 ====>  %@",str, err.userInfo[@"NSLocalizedDescription"]);
    
    return str;
    
}





+ (NSString *)judgeNullForStr:(NSString *)str {
    
    
    if ([str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"] || [str isEqualToString:@"null"]) {
        str = @"";
        
        return str;
        
    } else {
        
        return str;
        
    }
    
    
}


+ (void)navigationBackButton {
    
    
    
    /***自定义返回按钮****/
    UIImage *backButtonImage = [[UIImage imageNamed:@"返回"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    
    
}



+ (void)setOffKeyBoard {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}



//判断是否输入了emoji 表情
+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                    
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }else if (hs == 0x200d){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


+ (BOOL)setTextFieldTextLength:(NSInteger)length WithTextField:(UITextField *)textField Range:(NSRange )range String:(NSString *)str {
    
    BOOL returnValue = YES;
    
    //控制在18个字符
    
    if (str.length == 0)
        
        returnValue =  YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = str.length;
    
    if (existedLength - selectedLength + replaceLength > 18) {
        
        returnValue = NO;
        
    }

    
    return returnValue;
    
    
}


- (UIAlertController *)creatActionSheetWithAcionTitle:(NSString *)str Msg:(NSString *)msgStr AndActionTitleArr:(NSArray *)arr{
    
    UIAlertController *al = [UIAlertController alertControllerWithTitle:str message:msgStr preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int a = 0; a < arr.count; a ++) {

        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:arr[a] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            self.block([NSString stringWithFormat:@"%@", arr[a]]);
            
            
            [al dismissViewControllerAnimated:YES completion:^{
               
            }];
            
            
        }];

        
        
        [al addAction:cancel];
        
    }

    
    return al;
    
    
    
}

- (void)ChooseAsheetBlock:(ChooseAsheet)block {
    
    self.block = block;

    NSLog(@"123");
}


+ (NSAttributedString *)settitngNSStringColorWithRange:(NSRange)range Str:(NSString *)str WithColor:(UIColor *)color{
    
    
    NSMutableAttributedString *clolrstr = [[NSMutableAttributedString alloc]initWithString:str];

    [clolrstr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    return clolrstr;
}


+ (void)PageA:(UIViewController *)vcA PopToPageBClass:(Class )vcB INNavigationControllerArray:(NSArray *)NavgationsArray Animated:(BOOL)ani{
    
    
    for (UIViewController *temp in vcA.navigationController.viewControllers) {
        
        if ([temp isKindOfClass:[vcB class]]) {
  
            [vcA.navigationController popToViewController:temp animated:ani];

        }
    }
    
    
    
    
}

+ (NSString *)getTimeChuo {
    
    
    NSDate  *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000;
    NSString *dateString = [NSString stringWithFormat:@"%.0f", a];
    
    return dateString;
    
    
}

#pragma mark 货币计算
- (NSString *)decimalNumberCalucate:(NSString *)originValue1 originValue2:(NSString *)originValue2 calucateWay:(calucateWay)calucateWay
{
    //保留两位小数
    NSDecimalNumberHandler * roundUp = [NSDecimalNumberHandler
                                        
                                        decimalNumberHandlerWithRoundingMode:NSRoundDown // 只舍不入
                                        
                                        scale:2
                                        
                                        raiseOnExactness:NO
                                        
                                        raiseOnOverflow:NO
                                        
                                        raiseOnUnderflow:NO
                                        
                                        raiseOnDivideByZero:YES];

    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:originValue1];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:originValue2];
    NSDecimalNumber *product;
    switch (calucateWay) {
        case Adding:
            //  NSLog(@"+++++++++");
            product = [decimalNumber1 decimalNumberByAdding:decimalNumber2 withBehavior:roundUp];
            break;
            
        case Subtracting:
            //  NSLog(@"---------");
            product = [decimalNumber1 decimalNumberBySubtracting:decimalNumber2 withBehavior:roundUp];
            break;
            
        case Multiplying:
            //  NSLog(@"*********");
            product = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2 withBehavior:roundUp];
            break;
            
        case Dividing:
            // NSLog(@"/////////");
            product = [decimalNumber1 decimalNumberByDividingBy:decimalNumber2 withBehavior:roundUp];
            break;
            
        default:
            break;
    }
    return [product stringValue];
}


+ (NSString *)ToBase64StrWithPicture:(UIImage *)img base64EncodedStringWithOptions:(int) options{
    

    
    //图片转换成data
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    
    return  [NSString stringWithFormat:@"data:image/jpeg;base64,%@", [imageData base64EncodedStringWithOptions:options]];

    
    
    
}


+ (NSString *)caculateWithAtime:(NSString *)Atime SubBTime:(NSString *)Btime {
    

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate= [dateFormatter dateFromString:Atime];

    
    
    NSDateFormatter *dateFormatterB = [[NSDateFormatter alloc] init];
    [dateFormatterB setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate= [dateFormatterB dateFromString:Btime];
    

    NSTimeInterval aTimer = [endDate timeIntervalSinceDate:startDate];
    
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    int second = aTimer - hour*3600 - minute*60;
    NSString *dural = [NSString stringWithFormat:@"%d:%d:%d", hour, minute,second];
    

    return dural;
    
}

- (NSDictionary *)dictionaryFromModel:(NSObject *)model
{
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [model valueForKey:key];
        
        //only add it to dictionary if it is not nil
        if (key && value) {
            if ([value isKindOfClass:[NSString class]]
                || [value isKindOfClass:[NSNumber class]]) {
                // 普通类型的直接变成字典的值
                [dict setObject:value forKey:key];
            }
            else if ([value isKindOfClass:[NSArray class]]
                     || [value isKindOfClass:[NSDictionary class]]) {
                // 数组类型或字典类型
                [dict setObject:[self idFromObject:value] forKey:key];
            }
            else {
                // 如果model里有其他自定义模型，则递归将其转换为字典
                [dict setObject:[value dictionaryFromModel:model] forKey:key];
            }
        } else if (key && value == nil) {
            // 如果当前对象该值为空，设为nil。在字典中直接加nil会抛异常，需要加NSNull对象
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    
    free(properties);
    return dict;
}

- (id)idFromObject:(nonnull id)object WithModelObjcet:(NSObject *)mod
{
    if ([object isKindOfClass:[NSArray class]]) {
        if (object != nil && [object count] > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (id obj in object) {
                // 基本类型直接添加
                if ([obj isKindOfClass:[NSString class]]
                    || [obj isKindOfClass:[NSNumber class]]) {
                    [array addObject:obj];
                }
                // 字典或数组需递归处理
                else if ([obj isKindOfClass:[NSDictionary class]]
                         || [obj isKindOfClass:[NSArray class]]) {
                    [array addObject:[self idFromObject:obj]];
                }
                // model转化为字典
                else {
                    
                    [array addObject:[obj dictionaryFromModel:mod]];
                    
                }
            }
            return array;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        if (object && [[object allKeys] count] > 0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in [object allKeys]) {
                // 基本类型直接添加
                if ([object[key] isKindOfClass:[NSNumber class]]
                    || [object[key] isKindOfClass:[NSString class]]) {
                    [dic setObject:object[key] forKey:key];
                }
                // 字典或数组需递归处理
                else if ([object[key] isKindOfClass:[NSArray class]]
                         || [object[key] isKindOfClass:[NSDictionary class]]) {
                    [dic setObject:[self idFromObject:object[key]] forKey:key];
                }
                // model转化为字典
                else {
                    [dic setObject:[object[key] dictionaryFromModel:mod] forKey:key];
                }
            }
            return dic;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    
    return [NSNull null];
}




//筛选器
+(NSArray *)fliterWithMainArr:(NSArray *)mainArr WithSubArr:(NSArray *)subArr {
    
    
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",mainArr];
    
    NSArray * filter = [subArr filteredArrayUsingPredicate:filterPredicate];
    
    if (filter.count == 0) {
        
//        [SVProgressHUD showInfoWithStatus:@"已经没有啦~~"];
        
    }

    return filter;
}


+ (NSArray *)DictionaryOrderFuncWithDataSource:(id)data {
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *sortArray = [[data allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    
    for (NSString *str in sortArray) {
        
        [tempArr addObject:[data valueForKey:str]];
        
    }

    
    return tempArr;
}



+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = (UIViewController *)window.rootViewController;
    
    return result;
}


+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
@end
