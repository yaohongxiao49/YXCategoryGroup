//
//  NSString+YXCategary.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "NSString+YXCategary.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>

@implementation NSString (YXCategary)

#pragma mark - 是否有值
- (BOOL)yxHasValue {
    
    return ([self isKindOfClass:[NSString class]] && self.length > 0);
}

#pragma mark - 判断手机号有效性
- (BOOL)isVaildMobile:(NSString *)mobile {
    
    NSString *phoneRegex = @"^((1[3456789]))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark - 获取设备唯一标识
+ (NSString *)yxGetUUID {
    
    NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    return uuid;
}

#pragma mark - 获取app版本号
+ (NSString *)yxGetAppVersion:(BOOL)boolSpecific {
    
    NSDictionary *infoDic= [[NSBundle mainBundle] infoDictionary];
    NSString *keyStr = boolSpecific ? @"CFBundleShortVersionString" : @"CFBundleVersion";
    NSString *appVersion = [infoDic objectForKey:keyStr];
    
    return appVersion;
}

#pragma mark - 字典转Json字符串
+ (NSString *)yxConvertToJsonDataByDic:(id)dic {
    
    NSError *error;
    if (!dic) {
        return @"";
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0, jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0, mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

#pragma mark - 图文混排
+ (NSMutableAttributedString *)yxGraphicMixedText:(NSString *)value imgUrl:(NSString *)imgUrl bounds:(CGRect)bounds lab:(UILabel *)lab lineSpace:(NSInteger)lineSpace {
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:value];
    
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    if ([imgUrl containsString:@"http"]) {
        attch.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
    }
    else {
        attch.image = [UIImage imageNamed:imgUrl];
    }
    attch.bounds = bounds;
    
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    
    NSRange range = [value rangeOfString:value];
    [attri addAttribute:NSFontAttributeName value:lab.font range:range];
    [attri addAttribute:NSForegroundColorAttributeName value:lab.textColor range:range];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace - (lab.font.lineHeight - lab.font.pointSize);
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [attri addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attri;
}


#pragma mark - 获取当前时间
+ (NSString *)yxGetCurrentDateByFormat:(NSString *)format {
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy:MM:dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
}

#pragma mark - 获取当前时间戳
+ (NSString *)yxGetCurrentTheTimeStamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    return timeString;
}

#pragma mark - 判断指定日期是星期几（参数格式:yyyy-MM-dd）
+ (NSString *)yxJudgeSpecifiedDateIsDayOfTheWeek:(NSString *)specifiedDate format:(NSString *)format {
    
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    dateFromatter.dateFormat = format.yxHasValue ? format : @"yyyy-MM-dd";
    NSDate *date = specifiedDate.yxHasValue ? [dateFromatter dateFromString:specifiedDate] : [NSDate date];
    
    return [self yxCurrentDayOfTheWeek:date];
}

#pragma mark - 当前日是星期几
+ (NSString *)yxCurrentDayOfTheWeek:(NSDate *)day {
    
    NSString *week;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:day];
    NSInteger weekInt = [comps weekday];
    switch (weekInt) {
        case 1:
            week = @"周日";
            break;
        case 2:
            week = @"周一";
            break;
        case 3:
            week = @"周二";
            break;
        case 4:
            week = @"周三";
            break;
        case 5:
            week = @"周四";
            break;
        case 6:
            week = @"周五";
            break;
        case 7:
            week = @"周六";
            break;
        default:
            break;
    }
    
    return week;
}

#pragma mark - 时间比较
+ (BOOL)yxCompareDate:(NSString *)aDateStr withDate:(NSString *)bDateStr {
    
    BOOL isOk = NO;
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *aDate = [[NSDate alloc] init];
    NSDate *bDate = [[NSDate alloc] init];
    
    aDate = [dateformater dateFromString:aDateStr];
    bDate = [dateformater dateFromString:bDateStr];
    NSComparisonResult result = [aDate compare:bDate];
    if (result == NSOrderedSame) {
        isOk = NO;
    }
    else if (result == NSOrderedDescending) {
        isOk = NO;
    }
    else if (result == NSOrderedAscending) {
        isOk = YES;
    }
    
    return isOk;
}

#pragma mark - 获取设备名称
+ (NSString *)yxGetDeviceName {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([platform isEqualToString:@"x86_64"])     return @"Simulator";
    if ([platform isEqualToString:@"i386"])       return @"Simulator";
    if ([platform isEqualToString:@"iPhone1,1"])  return @"iPhone";
    if ([platform isEqualToString:@"iPhone1,2"])  return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])  return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])  return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])  return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])  return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,3"])  return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])  return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])  return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])  return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])  return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])  return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])  return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])  return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])  return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])  return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])  return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])  return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    
    return platform;
}

@end
