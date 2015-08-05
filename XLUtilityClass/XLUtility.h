//
//  XLUtility.h
//  XLUtilityClass
//
//  Created by shenma on 15/7/23.
//  Copyright (c) 2015年 shenma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h> //md5
#import "Reachability.h" //判断网络连接状态
#import "MBProgressHUD.h" //显示进度条
#import "XLConstants.h" //显示宏定义
@interface XLUtility : NSObject

#pragma mark ---字符串处理---
//验证邮箱
+(BOOL)isValidateEmail:(NSString *)email;
//验证手机号码
+ (BOOL)isValidateMobile:(NSString *)mobileNum;
//md5加密
+ (NSString *)md5:(NSString *)str;
//base64加密
+ (NSString * )getBase64StringWithoutSpace:(NSString *) preBase64String;
//Unicode转换
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
//获得字符串的高度
+ (float)getTextHeightWithFontSize:(int)size andString:(NSString *)string;

#pragma mark ---网络操作---
//获取时间戳
+ (NSString * )getTimestampSince1970;
//获取添加时间戳的请求
+ (NSURLRequest *)loadRequestWithURLString:(NSString *)URLString;

#pragma mark ---文件处理---
//保存视图的文件到本地
- (void)getSnapshotFromView:(UIView *)currentView;
//获取文件路径
+(NSString *)filePath:(NSString *)FileName;
//更新用户默认配置文件
+ (BOOL)setUserDefaultsWithObjectArray:(NSArray *)objectArray keyArray:(NSArray *)keyArray;
//查询用户默认配置文件
+ (NSMutableArray * )getUserDefaultsWithKeyArray:(NSArray *)keyArray;
//归档
+ (BOOL)archiverWithObjectArray:(NSArray *)objectArray keyArray:(NSArray *)keyArray;
//解档
+ (NSMutableArray *)unarchiverWithKeyArray:(NSArray *)keyArray;


#pragma mark ---UI附加效果展示---
//消息框
+ (void)showMessageViewWithContent:(NSString *)content inView:(UIView *)view;
//警告窗口
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonString:(NSString *)cancelString delegate:(id)delegate tag:(NSInteger)tag;
//根据字符串的长度调节label的行数
+ (void)adjust;

#pragma mark ---网络判断---
//判断当前网络是否连通
+ (BOOL)isExistenceNetwork;
@end
