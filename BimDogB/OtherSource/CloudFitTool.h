//
//  CloudFitTool.h
//  CloudFit_B2.0
//
//  Created by 卜成哲 on 16/9/12.
//  Copyright © 2016年 卜成哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <UIKit/UIKit.h>
#import <Foundation/NSObject.h>



typedef void(^ChooseAsheet)(NSString * _Nullable actionTittle);


typedef enum {
    Adding,
    Subtracting,
    Multiplying,
    Dividing,
}calucateWay;




@interface CloudFitTool : NSObject



+ (NSDictionary*_Nullable)dictionaryFromBundleWithName:(NSString*_Nullable)fileName withType:(NSString*_Nullable)typeName;
//字符串MD5转换
+ (NSString *_Nullable)md5HexDigest:(NSString*_Nullable)input;
+(NSString *_Nullable)fileMd5sum:(NSString * _Nullable )filename; //md5转换

//时间格式
+ (NSDate *_Nullable)getNowTime;
+ (NSString *_Nullable)getyyyymmdd;
+(NSString *_Nullable)getyyyymmddHHmmss;
+ (NSString *_Nullable)get1970timeString;
+ (NSString *_Nullable)getTimeString:(NSDate *_Nullable)date;
+ (NSString *_Nullable)gethhmmss;
+(NSString *_Nullable)getyyyy_mm_dd_HHmmss;
+(NSString *_Nullable)gethhmm;
+(NSString *_Nullable)getyyyymm;


//+ (NetworkStatus)getCurrentNetworkStatus;
+ (void)showNotReachabileTips;

+ (NSDate *_Nullable)dateFromString:(NSString *_Nullable)dateString usingFormat:(NSString*_Nullable)format;
+ (NSDate *_Nullable)dateFromString:(NSString *_Nullable)dateString;
+ (NSString *_Nullable)stringFromDate:(NSDate *_Nullable)date;
+ (NSString *_Nullable)stringFromDate:(NSDate *_Nullable)date usingFormat:(NSString*_Nullable)format;
//时间计算
+ (NSString *_Nullable)caculateWithAtime:(NSString *_Nullable)Atime SubBTime:(NSString *_Nullable)Btime;


/**
 根据当前日期获取区间内的日期

 @param dayCount 前几天
 @param afterDaycount 后几天
 @return 时间数组
 */
+ (NSMutableArray *_Nullable)getDaysWithBeforeDayCount:(NSInteger)dayCount AfterDayCount:(NSInteger)afterDaycount WithFormat:(NSString *_Nullable)format;



//获取后台服务器主机名
//+(NSString*)readFromUmengOlineHostname;

//loadingView方法集
+(void)addLoadingViewInView:(UIView*_Nullable)viewToLoadData usingUIActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)aStyle;
+(void)removeLoadingViewInView:(UIView*_Nullable)viewToLoadData;
+(void)addLoadingViewInView:(UIView*_Nullable)viewToLoadData usingUIActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)aStyle usingColor:(UIColor*_Nullable)color;
+(void)removeLoadingViewAndLabelInView:(UIView*_Nullable)viewToLoadData;
+(void)addLoadingViewAndLabelInView:(UIView* _Nullable)viewToLoadData usingOrignalYPosition:(CGFloat)yPosition;
+(void)showProgessInView:(UIView * _Nullable)view withExtBloc_Nullablek:(void (^_Nullable)())exBlock withComBlock:(void (^_Nullable)())comBlock;
+ (UIImage * _Nullable)image:(UIImage * _Nullable)image rotation:(UIImageOrientation)orientation; //图片旋转

//将图片保存到应用程序沙盒中去,imageNameString的格式为 @"upLoad.png"
+ (void)saveImagetoLocal:(UIImage* _Nullable)image imageName:(NSString * _Nullable)imageNameString;
+ (NSString * _Nullable)getDeviceOSType;


/**判断字符串长度*/
+ (int)convertToInt:(NSString* _Nullable)strtemp;
//end

+(NSMutableArray *_Nullable)decorateString:(NSString * _Nullable)string;
//正则表达式部分
+ (BOOL) validateEmail:(NSString * _Nullable)email;
//手机号码验证
+ (BOOL) validateMobile:(NSString * _Nullable)mobile;
//用户名
+ (BOOL) validateUserName:(NSString * _Nullable)name;
//密码
+ (BOOL) validatePassword:(NSString * _Nullable)passWord;
//昵称
+ (BOOL) validateNickname:(NSString * _Nullable)nickname;
//身份证号
+ (BOOL) validateIdentityCard: (NSString * _Nullable)identityCard;
//银行卡
+ (BOOL) validateBankCardNumber: (NSString * _Nullable)bankCardNumber;
//银行卡后四位
+ (BOOL) validateBankCardLastNumber: (NSString * _Nullable)bankCardNumber;
//CVN
+ (BOOL) validateCVNCode: (NSString * _Nullable)cvnCode;
//month
+ (BOOL) validateMonth: (NSString * _Nullable)month;
//year
+ (BOOL) validateYear: (NSString * _Nullable)year;
//verifyCode
+ (BOOL) validateVerifyCode: (NSString * _Nullable)verifyCode;

//money
+ (BOOL) validateMoney:(NSString * _Nullable)money;

//压缩图片质量
+(UIImage * _Nullable)reduceImage:(UIImage * _Nullable)image percent:(float)percent;
//压缩图片尺寸
+ (UIImage* _Nullable)imageWithImageSimple:(UIImage* _Nullable)image scaledToSize:(CGSize)newSize;
+ (UIColor * _Nullable) colorWithHexString: (NSString * _Nullable)color;
+ (NSString * _Nullable)documentsDirectoryPath;
/**
 *  返回字符串所占用的尺寸
 *
 *  @param stringFont    字体
 *  @param stringSize 最大尺寸
 */
+ (CGSize)getWidthByString:(NSString* _Nullable)string withFont:(UIFont* _Nullable)stringFont withStringSize:(CGSize)stringSize;
/**
 *  正则表达式验证数字
 */
+ (BOOL)checkNum:(NSString * _Nullable)str;

// View转化为图片
+ (UIImage * _Nullable)getImageFromView:(UIView * _Nullable)view;
// imageView转化为图片
+ (UIImage * _Nullable)getImageFromImageView:(UIImageView * _Nullable)imageView;

+ (BOOL)isLocationOpen;//判断是否打开定位
+ (NSInteger)getCellMaxNum:(CGFloat)cellHeight maxHeight:(CGFloat)height;//得到tableview最大页数
//匹配数字和英文字母
+ (BOOL) isNumberOrEnglish:(NSString * _Nullable)string;
//匹配数字
+ (BOOL) isKimiNumber:(NSString * _Nullable)number;
//是否存在字段
+ (BOOL)rangeString:(NSString * _Nullable)string searchString:(NSString * _Nullable)searchString;


//服务器500
+ (NSString * _Nullable)server_error500Info:(NSError * _Nullable)err;

//AFN请求进度工具
+ (void)AFNResponsePregress:(NSProgress * _Nullable)progress;

//去NUll
+ (NSString * _Nullable)judgeNullForStr:(NSString * _Nullable)str;

//导航栏 返回item
+ (void)navigationBackButton;

//收起键盘
+ (void)setOffKeyBoard;

//判断表情
+ (BOOL)stringContainsEmoji:(NSString * _Nullable)string;


//TextField输入位数控制
+ (BOOL)setTextFieldTextLength:(NSInteger)length WithTextField:(UITextField * _Nullable)textField Range:(NSRange )range String:(NSString * _Nullable)str;


//下弹ActionSheet

- (UIAlertController * _Nullable)creatActionSheetWithAcionTitle:(NSString * _Nullable)str Msg:(NSString * _Nullable)msgStr AndActionTitleArr:(NSArray * _Nullable)arr;

@property (nonatomic, copy) ChooseAsheet _Nullable block;

- (void )ChooseAsheetBlock:(ChooseAsheet  _Nullable)block;



+ (CGSize)CaculateSizeWithYYkitWithStr:(NSString * _Nullable)str;


/**
 字符串颜色分段显示
 
 @param range 要变颜色的字符Range
 @param str   要变颜色的字符串
 
 @return 处理之后的字符串
 */
+ (NSAttributedString * _Nullable)settitngNSStringColorWithRange:(NSRange )range Str:(NSString * _Nullable)str WithColor:(UIColor * _Nullable)color;

/**
 POP到指定页面
 
 @param vcA 当前VC
 @param vcB 目标VC
 @param NavgationsArray 当前VC的NAvigation栈
 */
+ (void)PageA:(UIViewController * _Nullable)vcA PopToPageBClass:(Class                                                                                                                                                                                                                                                                                          _Nullable)vcB INNavigationControllerArray:(NSArray * _Nullable)NavgationsArray Animated:(BOOL)ani;

//时间戳
+ (NSString * _Nullable)getTimeChuo;

#pragma mark 货币计算

/**
 科学计算

 @param originValue1 数值A
 @param originValue2 数值B
 @param calucateWay +-x/
 @return 计算结果
 */
- (NSString *  _Nullable)decimalNumberCalucate:(NSString * _Nullable)originValue1 originValue2:(NSString * _Nullable)originValue2 calucateWay:(calucateWay)calucateWay;



//图片转base64
+ (NSString * _Nullable)ToBase64StrWithPicture:(UIImage * _Nullable)img base64EncodedStringWithOptions:(int) options;


/**
 *  模型转字典
 *
 *  @return 字典
 */
- (NSDictionary * _Nullable)dictionaryFromModel:(NSObject * _Nullable)model ;

/**
 *  带model的数组或字典转字典
 *
 *  @param object 带model的数组或字典转
 *
 *  @return 字典
 */
- (id _Nullable  )idFromObject:(nonnull id)object;


/**
 筛选器
 
 @param mainArr 主容器
 @param subArr 子容器
 @return 返回 一个 在子容器中 主容器不包含的元素
 */
+(NSArray *_Nullable)fliterWithMainArr:(NSArray *_Nullable)mainArr WithSubArr:(NSArray *_Nullable)subArr;



/**
 返回一个字典value排序

 @param data 数据源
 @return 排序后的value
 */
+(NSArray *_Nullable)DictionaryOrderFuncWithDataSource:(id _Nullable )data;


//获取当前显示的 vC
+ (UIViewController *_Nullable)getCurrentVC;

//获取手机IP
+ (NSString *)getIPAddress;

@end
