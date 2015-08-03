//
//  XLUtility.h
//  XLUtilityClass
//
//  Created by shenma on 15/7/23.
//  Copyright (c) 2015年 shenma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h> //md5
#import "Reachability.h" //判断网络连接状态
@interface XLUtility : NSObject

//验证手机号码
+ (BOOL)validateMobile:(NSString *)mobileNum;
//md5加密
+ (NSString *)md5:(NSString *)str;
//base64加密
+ (NSString * )getBase64StringWithoutSpace:(NSString *) preBase64String;
//Unicode替换
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

//获取时间戳
+ (NSString * )getTimestampSince1970;
//获取添加时间戳的请求
+ (NSURLRequest *)loadRequestWithURLString:(NSString *)URLString;
//归档
+ (BOOL)archiverWithObjectArray:(NSArray *)objectArray keyArray:(NSArray *)keyArray;
//解档
+ (NSMutableArray *)unarchiverWithKeyArray:(NSArray *)keyArray;

@end
