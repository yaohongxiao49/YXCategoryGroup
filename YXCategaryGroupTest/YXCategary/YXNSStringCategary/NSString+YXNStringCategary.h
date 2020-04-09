//
//  NSString+YXNStringCategary.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YXNStringCategary)

/** 是否有值 */
- (BOOL)yxHasValue;

/** 获取设备唯一标识 */
+ (NSString *)yxGetUUID;

/**
 * 获取app版本号
 * @param boolSpecific 是否具体 YES：具体版本号，NO：模糊版本号
 */
+ (NSString *)yxGetAppVersion:(BOOL)boolSpecific;

/**
 * 字典转字符串
 * @param dic 字典
 */
+ (NSString *)yxConvertToJsonDataByDic:(id)dic;

/**
 * 图文混排
 * @param value 显示文字
 * @param imgUrl 图片地址/命名
 * @param bounds 图片位置
 * @param lab 文字控件
 * @param lineSpace 文字间距
 */
+ (NSMutableAttributedString *)yxGraphicMixedText:(NSString *)value
                                           imgUrl:(NSString *)imgUrl
                                           bounds:(CGRect)bounds
                                              lab:(UILabel *)lab
                                        lineSpace:(NSInteger)lineSpace;

/**
 * 获取当前时间
 * @param format 格式（可不填，默认YYYY:MM:dd hh:mm:ss）
 */
+ (NSString *)yxGetCurrentDateByFormat:(NSString *)format;

/** 获取当前时间戳 */
+ (NSString *)yxGetCurrentTheTimeStamp;

/**
 * 判定指定日期是星期几
 * @param specifiedDate 指定日期（可不传，默认日期为当前日期）
 * @param format 指定格式（可不穿，默认为yyyy-MM-dd）
 */
+ (NSString *)yxJudgeSpecifiedDateIsDayOfTheWeek:(NSString *)specifiedDate
                                          format:(NSString *)format;

/** 获取设备名称 */
+ (NSString *)yxGetDeviceName;

@end

NS_ASSUME_NONNULL_END
