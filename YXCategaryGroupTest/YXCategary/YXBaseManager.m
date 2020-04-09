//
//  YXBaseManager.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXBaseManager.h"

@implementation YXBaseManager

+ (YXBaseManager *)instanceManager {
    
    static YXBaseManager *yxBaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        yxBaseManager = [YXBaseManager new];
    });
    
    return yxBaseManager;
}

- (NSInteger)numberOfDaysByFromDateValue:(NSString *)fromDateValue toDateValue:(NSString *)toDateValue format:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:100000]];
    NSDate *fromDate = [dateFormatter dateFromString:fromDateValue];
    
    NSDate *toDate = [dateFormatter dateFromString:toDateValue];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    
    return comp.day;
}

@end
