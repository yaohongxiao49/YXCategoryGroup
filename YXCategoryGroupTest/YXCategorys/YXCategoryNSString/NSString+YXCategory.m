//
//  NSString+YXCategory.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "NSString+YXCategory.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation NSString (YXCategory)

#pragma mark - 是否有值
- (BOOL)yxHasValue {
    
    return ([self isKindOfClass:[NSString class]] && self.length > 0);
}

#pragma mark - 判断手机号分区
- (BOOL)yxBoolVaildMobile {
    
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$"; //移动
    NSString *CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$"; //联通
    NSString *CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$"; //电信
    NSString *PHS = @"^0(10|2[0-57-9]|\\d{3})\\d{7,8}$"; //小灵通
    
    BOOL CMRex = [self yxBoolValidateByRegex:CM];
    BOOL CURex = [self yxBoolValidateByRegex:CU];
    BOOL CTRex = [self yxBoolValidateByRegex:CT];
    BOOL PHSRex = [self yxBoolValidateByRegex:PHS];
    
    return (CMRex || CURex || CTRex || PHSRex);
}
#pragma mark - 手机号有效性
- (BOOL)yxBoolMobileNumber {
    
    NSString *mobileNoRegex = @"^1((3\\d|5[0-35-9]|8[025-9])\\d|70[059]|)\\d{7}$";
    NSString *phsRegex = @"^0(10|2[0-57-9]|\\d{3})\\d{7,8}$";
    
    BOOL ret = [self yxBoolValidateByRegex:mobileNoRegex];
    BOOL ret1 = [self yxBoolValidateByRegex:phsRegex];
    
    return (ret || ret1);
}
- (BOOL)yxBoolValidateByRegex:(NSString *)regex {
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pre evaluateWithObject:self];
}

#pragma mark - 手机号隐藏中间四位
- (NSString *)yxPhoneNumHiddenCenter {
    
    if (![self yxBoolMobileNumber]) {
        return @"";
    }
    NSString *startStr = [self substringWithRange:NSMakeRange(0, 3)];
    NSString *endStr = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
    NSString *hiddenStr = [NSString stringWithFormat:@"%@****%@", startStr, endStr];
    
    return hiddenStr;
}

#pragma mark - 邮箱有效性
- (BOOL)yxBoolEmail {
    
    NSString *regex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    return [self yxBoolValidateByRegex:regex];
}

#pragma mark - 身份证号有效性
- (BOOL)yxBoolIdCard {
    
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    BOOL isRex = [self yxBoolValidateByRegex:regex];
    if (!isRex) {
         //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0; //保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) { //将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [self substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] *[weightingArray[i] integerValue];
    }
    
    NSInteger modNum = sum %11; //总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [self.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) { //等于2时 idCardMod为10 身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    }
    
    return NO;
}

#pragma mark - 车牌号有效性
- (BOOL)yxBoolCarNumber {
    
    //车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    NSString *carRegex = @"^[\u4e00-\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fff]$"; //其中\u4e00-\u9fa5表示unicode编码中汉字已编码部分，\u9fa5-\u9fff是保留部分，将来可能会添加
    
    return [self yxBoolValidateByRegex:carRegex];
}

#pragma mark - 是否为URL
- (BOOL)yxBoolUrl {
    
    NSString *pattern = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *regexArray = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if (regexArray.count > 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 校验密码
- (BOOL)yxCheackPassByMax:(NSInteger)max min:(NSInteger)min {
    
    NSString *regex = [NSString stringWithFormat:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z`~!@#$%^&*()+=|{}':;',//[//].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]{%@,%@}$", @(min), @(max)];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

#pragma mark - 编码
- (NSString *)yxUrlEncoded {
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
- (NSString *)yxUrlEncodeByUrl:(NSString *)url {
    
    return [url stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet]];
}

#pragma mark - 解码
- (NSString *)yxUrlDecoded {
    
    return [self stringByRemovingPercentEncoding];
}

#pragma mark - 转换成请求本地服务器的url
+ (NSString *)convertToProxyUrlString:(NSString *)urlString {
    
    NSString *urlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:urlStr]];
    return url.absoluteString;
}

#pragma mark - 判断是否能打开第三方平台
+ (BOOL)yxJudgeCanOpenUrlByPlatformId:(NSString *)platformId {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:platformId]]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 获取设备唯一标识
+ (void)yxGetUUIDBlock:(void(^)(NSString *uuid, BOOL boolSure))uuidBlock {
    
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
            NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) { //已授权
                uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                uuidBlock(uuid, YES);
            }
            else {
                uuidBlock(uuid, NO);
            }
        }];
    }
    else {
        NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            uuidBlock(uuid, YES);
        }
        else {
            uuidBlock(uuid, NO);
        }
    }
}

#pragma mark - 获取app版本号
+ (NSString *)yxGetAppVersion:(BOOL)boolSpecific {
    
    NSDictionary *infoDic= [[NSBundle mainBundle] infoDictionary];
    NSString *keyStr = boolSpecific ? @"CFBundleShortVersionString" : @"CFBundleVersion";
    NSString *appVersion = [infoDic objectForKey:keyStr];
    
    return appVersion;
}

#pragma mark - 版本号比较
+ (BOOL)yxGetNeedUpdate:(NSString *)v2 {
    
    //都为空，相等，返回0
    NSString *v1 = [NSString yxGetAppVersion:YES];
    if (!v1 && !v2) {
        return NO;
    }
    
    //v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return YES;
    }
    
    //v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return NO;
    }
    
    //获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    
    //取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    for (NSInteger i = 0; i < smallCount; ++i) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            //v1版本字段大于v2版本字段，返回1
            return NO;
        }
        else if (value1 < value2) {
            //v2版本字段大于v1版本字段，返回-1
            return YES;
        }
    }
    
    //版本可比较字段相等，则字段多的版本高于字段少的版本
    if (v1Array.count > v2Array.count) {
        return NO;
    }
    else if (v1Array.count < v2Array.count) {
        return YES;
    }
    else {
        return NO;
    }
    return NO;
}

#pragma mark - 与商店应用版本号比较
+ (void)yxGetAppStoreVersionByUrl:(NSString *)url finishBlock:(void(^)(BOOL boolUp))finishBlock {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *urlValue = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", url]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlValue];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSDictionary *dicValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *results = dicValue[@"results"];
            NSDictionary *dic = results.firstObject;
            NSString *lineVersion = dic[@"version"]; //版本号
            NSString *releaseNotes = dic[@"releaseNotes"]; //更新说明
            NSString *trackViewUrl = dic[@"trackViewUrl"]; //链接
            NSLog(@"App store版本号:%@，更新说明:%@，App下载链接:%@", lineVersion, releaseNotes, trackViewUrl);
            
            BOOL boolUp =! [NSString yxGetNeedUpdate:lineVersion];
            finishBlock(boolUp);
        }
        else {
            finishBlock(NO);
        }
    }];
    
    [dataTask resume];
}

#pragma mark - 字典转Json字符串
+ (NSString *)yxConvertToJsonDataByData:(id)data {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    
    if ([jsonData length] > 0 && error == nil) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        
        NSRange range = {0, jsonString.length};
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        
        NSRange range2 = {0, mutStr.length};
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        
        NSRange range3 = {0, mutStr.length};
        
        NSString *str = @"\\";
        [mutStr replaceOccurrencesOfString:str withString:@"" options:NSLiteralSearch range:range3];
        return mutStr;
    }
    else {
        return nil;
    }
}

#pragma mark - 计算字符串所占大小
+ (CGSize)yxSizeOfValueByStr:(NSString *)str size:(CGSize)size font:(UIFont *)font {
    
    if (str.length == 0) {
        return CGSizeZero;
    }
    
    CGSize newSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
    
    return newSize;
}
+ (CGSize)yxSizeOfValueByAttriStr:(NSAttributedString *)attStr size:(CGSize)size {
    
    if (attStr.length == 0) {
        return CGSizeZero;
    }
    
    CGSize newSize = [attStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;

    return newSize;
}

#pragma mark - 设置属性文字
+ (NSMutableAttributedString *)yxAttributedStringByBaseText:(NSString *)baseText baseFont:(UIFont *)baseFont baseColor:(UIColor *)baseColor changeTextArr:(NSArray *)changeTextArr changeFontArr:(NSArray *)changeFontArr changeColorArr:(NSArray *)changeColorArr lineSpaceValue:(nullable NSString *)lineSpaceValue lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment lineOffset:(CGFloat)lineOffset underLineColor:(nullable UIColor *)underLineColor strikethroughColor:(nullable UIColor *)strikethroughColor {
    
    if (baseText.length == 0) {
        return [NSMutableAttributedString new];
    }
    
    //设置字符串
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:baseText];
    //整个字符串的范围
    NSRange range = [baseText rangeOfString:baseText];
    //整个字符串字体类型和大小
    [attString addAttribute:NSFontAttributeName value:baseFont range:range];
    //整个字符串字体颜色
    [attString addAttribute:NSForegroundColorAttributeName value:baseColor range:range];
    
    //改变某段字符串
    if (changeTextArr.count == changeFontArr.count && changeTextArr.count == changeColorArr.count) {
        for (int i = 0; i < changeTextArr.count; i++) {
            NSString *changeText = changeTextArr[i];
            //计算要改变的范围
            NSRange subRange = [baseText rangeOfString:changeText];
            //改某段字体类型和大小
            [attString addAttribute:NSFontAttributeName value:changeFontArr[i] range:subRange];
            //改某段字体颜色
            [attString addAttribute:NSForegroundColorAttributeName value:changeColorArr[i] range:subRange];
            if (lineOffset != 0) [attString addAttribute:NSBaselineOffsetAttributeName value:@(lineOffset) range:subRange];
        }
    }
    
    //间距
    if (lineSpaceValue.yxHasValue) {
        CGFloat lineSpace = [lineSpaceValue floatValue];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpace - (baseFont.lineHeight - baseFont.pointSize);
        paragraphStyle.lineBreakMode = lineBreakMode;
        paragraphStyle.alignment = alignment;
        [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    }
    
    //下划线
    if (underLineColor) {
        [attString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        [attString addAttribute:NSUnderlineColorAttributeName value:underLineColor range:range];
    }
    
    //删除线
    if (strikethroughColor) {
        [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        [attString addAttribute:NSStrikethroughColorAttributeName value:strikethroughColor range:range];
    }
    
    return attString;
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

#pragma mark - 指定两个日期的间隔天数
+ (NSString *)yxNumberOfDaysByFromDateValue:(NSString *)fromDateValue toDateValue:(NSString *)toDateValue format:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:100000]];
    
    NSDate *fromDate = [dateFormatter dateFromString:fromDateValue];
    NSDate *toDate = [dateFormatter dateFromString:toDateValue];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    
    return [NSString stringWithFormat:@"%@", @(comp.day)];
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
    NSInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:day];
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
    
    NSDate *aDate = [dateformater dateFromString:aDateStr];
    NSDate *bDate = [dateformater dateFromString:bDateStr];

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

#pragma mark - 时间转差距天数
+ (NSString *)yxTimeLagByDateStr:(NSString *)dateStr {
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateformater dateFromString:dateStr];
    double beTime = [date timeIntervalSince1970];
    
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString *distanceStr;
    NSDate *beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *timeStr = [dateFormatter stringFromDate:beDate];
    [dateFormatter setDateFormat:@"dd"];
    
    NSString *nowDay = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastDay = [dateFormatter stringFromDate:beDate];
    
    if (distanceTime < 10) { //小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime < 60 *60) { //时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前", (long)distanceTime /60];
    }
    else if (distanceTime < 24 *60 *60 && [nowDay integerValue] == [lastDay integerValue]) { //时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天%@", timeStr];
    }
    else if (distanceTime < 24 *60 *60 *1.5) {
        distanceStr = @"昨天";
    }
    else if (distanceTime < 24 *60 *60 *2.5) {
        distanceStr = @"两天前";
    }
    else if (distanceTime < 24 *60 *60 *30) {
        distanceStr = @"一个月前";
    }
    else if (distanceTime < 24 *60 *60 *365) {
        distanceStr = @"一年前";
    }
    
    return distanceStr;
}

#pragma mark - 秒转时间
+ (NSString *)yxTurnSecondTimeBySeconds:(NSString *)secondTime {

    NSInteger seconds = [secondTime floatValue];
    NSString *hour = [NSString stringWithFormat:@"%02ld", seconds /3600];
    NSString *minute = [NSString stringWithFormat:@"%02ld", (seconds %3600) /60];
    NSString *second = [NSString stringWithFormat:@"%02ld", seconds %60];
    
    NSString *formatTime = [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
    if ([hour integerValue] == 0) {
        formatTime = [NSString stringWithFormat:@"%@:%@", minute, second];
    }

    return formatTime;
}

#pragma mark - 时间戳转时间
+ (NSString *)yxTimeStampTurnsTimeByTimeStamp:(NSString *)timeStamp format:(NSString *)format {
    
    NSTimeInterval time = [timeStamp doubleValue] /1000;
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate:detailDate];
    return currentDateStr;
}

#pragma mark - 时间转时间戳
+ (NSString *)yxTimeTurnsTimeStampByTime:(NSString *)time format:(NSString *)format {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //创建一个时间格式化对象
    [dateFormatter setDateFormat:format]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:time]; //将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970] *1000]; //字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

#pragma mark - 判断间隔时间
+ (NSInteger)yxJudgeTimeIntervalByLogo:(NSString *)logo boolIn:(BOOL)boolIn {
    
    NSString *defaultsStr = [NSString stringWithFormat:@"%@lastTimeSave", logo];
    NSString *lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:defaultsStr];
    NSString *nowTime = [NSString yxGetCurrentTheTimeStamp];
    NSInteger intervalTime = 0;
    
    if (boolIn) {
        [[NSUserDefaults standardUserDefaults] setObject:nowTime forKey:defaultsStr];
    }
    else {
        if (lastTime.yxHasValue) {
            intervalTime = [nowTime integerValue] - [lastTime integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:defaultsStr];
        }
    }
    
    return intervalTime;
}

#pragma mark - 使用oss自动设置尺寸
+ (NSString *)ossSetImgSizeByUrl:(NSString *)url {
    
    NSRange found = [url rangeOfString:@"?"];
    if (found.location != NSNotFound) {
        return [NSString stringWithFormat:@"%@&x-oss-process=image/resize,m_mfit,w_360,h_360,limit_0/crop,x_0,y_0,w_360,h_360,g_north", url];
    }
    else {
        return [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_mfit,w_360,h_360,limit_0/crop,x_0,y_0,w_360,h_360,g_north", url];
    }
}

#pragma mark - 保留两位小数，没有时出去
+ (NSString *)yxFloatKeepTwoBitsAndRemoveAllZero:(double)floatnum {
    
    //保留2位小数
    NSDecimalNumber *amount = [[NSDecimalNumber alloc] initWithDouble:floatnum];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *endNum = [amount decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    //末尾清零
    return [NSString stringWithFormat:@"%@", endNum];
}

#pragma mark - 格式化显示，填充数据（如11000 -> 1.1w）
+ (NSString *)yxGetNumberWithNum:(double)num segmentationNum:(CGFloat)segmentationNum splice:(NSString *)splice {
    
    NSString *endValue;
    if (num < segmentationNum) {
        endValue = [NSString yxFloatKeepTwoBitsAndRemoveAllZero:num];
    }
    else {
        double value = (num / segmentationNum);
        NSString *valueStr = [NSString yxFloatKeepTwoBitsAndRemoveAllZero:value];
        NSArray *array = [valueStr componentsSeparatedByString:@"."];
        if (array.count > 1) {
            if ([array[1] intValue] > 0) {
                endValue = [NSString stringWithFormat:@"%@%@", valueStr, splice];
            }
            else {
                endValue = [NSString stringWithFormat:@"%d%@", [array[0] intValue], splice];
            }
        }
        else {
            endValue = [NSString stringWithFormat:@"%@%@", valueStr, splice];
        }
    }
    return endValue;
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
