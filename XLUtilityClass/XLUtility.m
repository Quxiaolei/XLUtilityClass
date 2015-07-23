//
//  XLUtility.m
//  XLUtilityClass
//
//  Created by shenma on 15/7/23.
//  Copyright (c) 2015年 shenma. All rights reserved.
//

#import "XLUtility.h"

@implementation XLUtility


#pragma mark ---字符串处理---

/**
 *  MD5加密
 *
 *  @param str 未加密字符串
 *
 *  @return 加密字符串
 */
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}
/**
 *  用某个字符替换字符串中的字符
 *
 *  @param preBase64String 传入原始的Base64编码字符串
 *  <28c66a8e 7a589e1e c0cf6757 3ddfb331 135b56a4 92b227ca 1b1bd435 073717b7>
 *
 *  @return 替换后的字符串
 */
+ (NSString * )getBase64StringWithoutSpace:(NSString *) preBase64String
{
    NSString * string = [preBase64String stringByReplacingOccurrencesOfString:@" " withString:@""];
//    去除两端的括号
    NSRange range = {1,64};
    return  [string substringWithRange:range];
}

#pragma mark ---网络操作---

/**
 *  获取时间戳(距1970年的时间间隔)
 *
 *  @return 时间间隔字符串
 */
+ (NSString * )getTimestampSince1970
{
    //获取当前时间
    NSDate *dateNow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:dateNow];
    //转换为本地时间,加上时区
    NSDate *localeDate = [dateNow  dateByAddingTimeInterval: interval];
    //转换时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    NSLog(@"localeDate:%@", localeDate);
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}
/**
 *  获取添加时间戳后的请求
 *
 *  @param URLString 请求的URL路径字符串
 *
 *  @return URL路径的request请求
 */
+ (NSURLRequest *)loadRequestWithURLString:(NSString *)URLString
{
    NSString * newURLString = [NSString stringWithFormat:@"%@?time=%@",URLString,[XLUtility getTimestampSince1970]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:newURLString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
    
    return request;
}
/**
 *  判断网络状态
 *
 *  @return 是否存在网络状态
 */
+ (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];  // 测试服务器状态
    
    switch([reachability currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = TRUE;
            break;
    }
    return  isExistenceNetwork;
}
#pragma mark ---文件操作---

/**
 *  归档
 *
 *  @param objectArray 编码对象数组
 *  @param keyArray    编码对象关键字
 *
 *  @return 成功标示:YES
 */
+ (BOOL)archiverWithObjectArray:(NSArray *)objectArray keyArray:(NSArray *)keyArray
{
    //    NSArray *array = [NSArray arrayWithObjects:@"zhangsan",@"lisi",nil];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //编码
    for (int i = 0; i < objectArray.count; i++)
    {
        [archiver encodeObject:objectArray[i] forKey:keyArray[i]];
    }
    //完成编码，将上面的归档数据填充到data中，此时data中已经存储了归档对象的数据
    [archiver finishEncoding];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/userData"];
    BOOL success = [data writeToFile:filePath atomically:YES];
    if(success)
    {
        NSLog(@"用户信息,归档成功");
        return YES;
    }
    return NO;
}
/**
 *  解档
 *
 *  @param keyArray 编码对象关键字
 *
 *  @return 可变编码对象数组
 */
+ (NSMutableArray *)unarchiverWithKeyArray:(NSArray *)keyArray
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/userData"];
    //读取归档数据
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    //创建解归档对象，对data中的数据进行解归档
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:keyArray.count];
    //解归档
    for (int i = 0; i < keyArray.count; i++)
    {
        [array addObject:[unarchiver decodeObjectForKey:keyArray[i]]];
    }
    return array;
}
@end
