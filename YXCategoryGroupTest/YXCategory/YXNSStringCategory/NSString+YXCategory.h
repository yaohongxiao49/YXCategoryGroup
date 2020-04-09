//
//  NSString+YXCategory.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YXCategory)

/** 是否有值 */
- (BOOL)yxHasValue;

/**
 * 判断手机号有效性
 * @param mobile 手机号
 */
- (BOOL)yxBoolVaildMobile:(NSString *)mobile;

/**
 * 判断是否能打开第三方平台
 * @param platformId 如（weixin://，sinaweibo://）
 */
+ (BOOL)yxJudgeCanOpenUrlByPlatformId:(NSString *)platformId;

/** 获取设备唯一标识 */
+ (NSString *)yxGetUUID;

/**
 * 获取app版本号
 * @param boolSpecific 是否具体 YES：具体版本号，NO：模糊版本号
 */
+ (NSString *)yxGetAppVersion:(BOOL)boolSpecific;

/**
 * 字典/数组转字符串
 * @param data 字典/数组
 */
+ (NSString *)yxConvertToJsonDataByData:(id)data;

/**
 * 计算字符串所占大小
 * @param str 字符串
 * @param size 控件大小
 * @param font 控件字体
 */
+ (CGSize)yxSizeOfValueByStr:(NSString *)str
                        size:(CGSize)size
                        font:(UIFont *)font;

/**
 * 计算字符串所占大小
 * @param attStr attri字符串
 * @param size 控件大小
 */
+ (CGSize)yxSizeOfValueByAttriStr:(NSAttributedString *)attStr
                             size:(CGSize)size;

/**
 * 设置三变属性文字
 * @param text 整体文字
 * @param font 整体字体
 * @param color 整体色值
 * @param subString 第一种不同的文字
 * @param subFont 第一种不同的字体
 * @param subColor 第一种不同的色值
 * @param thirdString 第二种不同的文字
 * @param thirdFont 第二种不同的字体
 * @param thirdColor 第二种不同的色值
 * @param lineSpaceValue 文字间距（如不需要，可不填）
 * @param alignment 对齐方式
 * @param underLineColor 下划线色值（如不需要，可不填）
 * @param strikethroughColor 删除线色值（如不需要，可不填）
 */
+ (NSMutableAttributedString *)yxAttributedStringThirdByText:(NSString *)text
                                                        font:(UIFont *)font
                                                       color:(UIColor *)color
                                                   subString:(NSString *)subString
                                                     subFont:(UIFont *)subFont
                                                    subColor:(UIColor *)subColor
                                                 thirdString:(NSString *)thirdString
                                                   thirdFont:(UIFont *)thirdFont
                                                  thirdColor:(UIColor *)thirdColor
                                              lineSpaceValue:(NSString *)lineSpaceValue
                                                   alignment:(NSTextAlignment)alignment
                                              underLineColor:(UIColor *)underLineColor
                                          strikethroughColor:(UIColor *)strikethroughColor;


/**
 * 设置属性文字
 * @param text 整体文字
 * @param font 整体字体
 * @param color 整体色值
 * @param subStringArr 显示不同的文字
 * @param subFontArr 显示不同的字体
 * @param subColorArr 显示不同的色值
 * @param lineSpaceValue 文字间距（如不需要设置，可不填）
 * @param alignment 对齐方式
 * @param underLineColor 下划线色值（如不需要，可不填）
 * @param strikethroughColor 删除线色值（如不需要，可不填）
 */
+ (NSMutableAttributedString *)yxAttributedStringSecondByText:(NSString *)text
                                                         font:(UIFont *)font
                                                        color:(UIColor *)color
                                                    subString:(NSArray *)subStringArr
                                                      subFont:(NSArray *)subFontArr
                                                     subColor:(NSArray *)subColorArr
                                               lineSpaceValue:(NSString *)lineSpaceValue
                                                    alignment:(NSTextAlignment)alignment
                                               underLineColor:(UIColor *)underLineColor
                                           strikethroughColor:(UIColor *)strikethroughColor;

/**
 * 设置文字行间距
 * @param text 整体文字
 * @param lineSpace 间距
 * @param font 字体
 * @param color 色值
 * @param alignment 对齐方式
 * @param underLineColor 下划线色值（如不需要，可不填）
 * @param strikethroughColor 删除线色值（如不需要，可不填）
 */
+ (NSMutableAttributedString *)yxAttributedStringLineByText:(NSString *)text
                                                  lineSpace:(CGFloat)lineSpace
                                                       font:(UIFont *)font
                                                      color:(UIColor *)color
                                                  alignment:(NSTextAlignment)alignment
                                             underLineColor:(UIColor *)underLineColor
                                         strikethroughColor:(UIColor *)strikethroughColor;

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
 * 指定两个日期的间隔天数
 * @param fromDateValue 开始日期
 * @param toDateValue 结束日期
 * @param format 格式（如yyyy-MM-dd）
 */
+ (NSString *)yxNumberOfDaysByFromDateValue:(NSString *)fromDateValue
                                toDateValue:(NSString *)toDateValue
                                     format:(NSString *)format;

/**
 * 判定指定日期是星期几
 * @param specifiedDate 指定日期（可不传，默认日期为当前日期）
 * @param format 指定格式（可不穿，默认为yyyy-MM-dd）
 */
+ (NSString *)yxJudgeSpecifiedDateIsDayOfTheWeek:(NSString *)specifiedDate
                                          format:(NSString *)format;

/**
 * 时间比较（格式 yyyy-MM-dd HH:mm:ss）
 * @param aDateStr 时间1
 * @param bDateStr 时间2
 */
+ (BOOL)yxCompareDate:(NSString *)aDateStr
             withDate:(NSString *)bDateStr;

/**
 * 时间转差距天数
 * @param dateStr 指定时间（格式 yyyy-MM-dd HH:mm:ss）
 */
+ (NSString *)yxTimeLagByDateStr:(NSString *)dateStr;

/**
 * 秒转时间
 * @param secondTime 秒
 */
+ (NSString *)yxTurnSecondTimeBySeconds:(NSString *)secondTime;

/**
 * 时间戳转时间
 * @param timeStamp 时间戳
 * @param format 格式（yyyy-MM-dd HH:mm:ss）
 */
- (NSString *)yxTimeStampTurnsTimeByTimeStamp:(NSString *)timeStamp
                                       format:(NSString *)format;

/** 获取设备名称 */
+ (NSString *)yxGetDeviceName;

@end

NS_ASSUME_NONNULL_END
