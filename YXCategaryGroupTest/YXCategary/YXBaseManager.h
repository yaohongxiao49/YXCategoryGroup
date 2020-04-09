//
//  YXBaseManager.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXBaseManager : NSObject

+ (YXBaseManager *)instanceManager;

/**
 * 指定两个日期的间隔天数
 * @param fromDateValue 开始日期
 * @param toDateValue 结束日期
 * @param format 格式（如yyyy-MM-dd）
 */
- (NSInteger)numberOfDaysByFromDateValue:(NSString *)fromDateValue
                             toDateValue:(NSString *)toDateValue
                                  format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
