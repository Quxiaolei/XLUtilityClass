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

//验证手机号码
+ (BOOL)isValidateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,178,182,183,184,187,188
     * 联通：130,131,132,145,155,156,176,185,186
     * 电信：133,153,170,177,180,181,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,178,182,183,184,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|47|5[0127-9]|78|8[23478])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,176,185,186
     */
    NSString * CU = @"^1(3[0-2]|45|5[56]|76|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,153,170,177,180,181,189
     */
    NSString * CT = @"^1((33|53|70|77|8[019])[0-9])\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//利用正则表达式验证邮箱的合法性
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

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
/**
 *  Unicode替换
 *
 */
+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    //NSLog(@"Output = %@", returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
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

#pragma mark ---文件操作---

/**
 *  截屏功能
 *
 *  @param currentView 传入要保存的视图
 *  @param size        传入要保存的视图的尺寸
 */
- (void)getSnapshotFromView:(UIView *)currentView
{
    //currentView:当前的view  创建一个基于位图的图形上下文并指定大小为size
    UIGraphicsBeginImageContext(currentView.bounds.size);
    //renderInContext呈现接受者及其子范围到指定的上下文
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //返回一个基于当前图形上下文的图片
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    //然后将该图片保存到图片库
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
}

/**
 *  获取文件路径
 *
 */
+(NSString *)filePath:(NSString *)FileName
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES)objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:FileName];
    return path;
}
/**
 *  更新用户默认配置文件
 *
 *  @param objectArray 编码对象数组
 *  @param keyArray    编码对象关键字
 *
 *  @return 成功标示:YES
 */

+ (BOOL)setUserDefaultsWithObjectArray:(NSArray *)objectArray keyArray:(NSArray *)keyArray
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < objectArray.count; i++)
    {
        [userDefault setObject:objectArray[i] forKey:keyArray[i]];
    }
    [userDefault synchronize];
    return YES;
}

/**
 *  查询用户默认配置文件
 *
 *  @param keyArray 编码对象关键字
 *
 *  @return 可变编码对象数组
 */

+ (NSMutableArray * )getUserDefaultsWithKeyArray:(NSArray *)keyArray
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:keyArray.count];
    
    for (int i = 0; i < keyArray.count; i++)
    {
        if (![userDefault stringForKey:keyArray[i]]) {
            return nil;
        }
        [array addObject:[userDefault stringForKey:keyArray[i]]];
    }
    return array;
}

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

#pragma mark ---UI附加效果展示---

//消息框
+ (void)showMessageViewWithContent:(NSString *)content inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view addSubview:hud];
    hud.labelText=content;
    hud.mode=MBProgressHUDModeText;
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    hud.yOffset = 130.0f;
    hud.xOffset = 10.0f;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1.0f);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}
//警告窗口
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonString:(NSString *)cancelString delegate:(id)delegate tag:(NSInteger)tag;
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelString otherButtonTitles:@"确定", nil];
    alertView.tag = tag;
    [alertView show];
}

#pragma mark ---网络判断---

/***
 * 此函数用来判断是否网络连接服务器正常
 * 需要导入Reachability类
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
@end
