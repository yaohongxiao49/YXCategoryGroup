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

/** 判断手机号有效性 */
- (BOOL)yxBoolMobileNumber;
/** 判断手机号分区 */
- (BOOL)yxBoolVaildMobile;

/** 隐藏手机号中间四位 */
- (NSString *)yxPhoneNumHiddenCenter;

/** 邮箱有效性 */
- (BOOL)yxBoolEmail;

/** 身份证号有效性 */
- (BOOL)yxBoolIdCard;

/** 车牌号有效性 */
- (BOOL)yxBoolCarNumber;

/** 是否是链接 */
- (BOOL)yxBoolUrl;

/**
 * 校验密码
 * @param max 最大位数
 * @param min 最小位数
 */
- (BOOL)yxCheackPassByMax:(NSInteger)max
                      min:(NSInteger)min;

/** 编码 */
- (NSString *)yxUrlEncoded;
- (NSString *)yxUrlEncodeByUrl:(NSString *)url;

/** 解码 */
- (NSString *)yxUrlDecoded;

/** 转换成请求本地服务器的url */
+ (NSString *)convertToProxyUrlString:(NSString *)urlString;

/**
 * 判断是否能打开第三方平台
 * @param platformId 如（weixin://，sinaweibo://）
 */
+ (BOOL)yxJudgeCanOpenUrlByPlatformId:(NSString *)platformId;

/** 获取设备唯一标识 */
+ (void)yxGetUUIDBlock:(void(^)(NSString *uuid, BOOL boolSure))uuidBlock;

/**
 * 获取app版本号
 * @param boolSpecific 是否具体 YES：具体版本号，NO：模糊版本号
 */
+ (NSString *)yxGetAppVersion:(BOOL)boolSpecific;

/** 版本号比较 */
+ (BOOL)yxGetNeedUpdate:(NSString *)v2;

/**
 * 与商店应用版本号比较
 * @param url 应用商店地址
 */
+ (void)yxGetAppStoreVersionByUrl:(NSString *)url
                      finishBlock:(void(^)(BOOL boolUp))finishBlock;

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
 * 设置属性文字
 * @param baseText 基础文字（显示的全部文字）
 * @param baseFont 基础字体
 * @param baseColor 基础色值
 * @param changeTextArr 需要改变的文字数组集合
 * @param changeFontArr 需要改变的字体数组集合
 * @param changeColorArr 需要改变的色值数组集合
 * @param lineSpaceValue 行间距
 * @param alignment 对齐方式
 * @param underLineColor 下划线
 * @param strikethroughColor 删除线
 * @param lineOffset 对齐基准线数值
 * @param lineBreakMode 文字显示方式
 */
+ (NSMutableAttributedString *)yxAttributedStringByBaseText:(NSString *)baseText
                                                   baseFont:(UIFont *)baseFont
                                                  baseColor:(UIColor *)baseColor
                                              changeTextArr:(NSArray *)changeTextArr
                                              changeFontArr:(NSArray *)changeFontArr
                                             changeColorArr:(NSArray *)changeColorArr
                                             lineSpaceValue:(nullable NSString *)lineSpaceValue
                                              lineBreakMode:(NSLineBreakMode)lineBreakMode
                                                  alignment:(NSTextAlignment)alignment
                                                 lineOffset:(CGFloat)lineOffset
                                             underLineColor:(nullable UIColor *)underLineColor
                                         strikethroughColor:(nullable UIColor *)strikethroughColor;

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
+ (NSString *)yxTimeStampTurnsTimeByTimeStamp:(NSString *)timeStamp
                                       format:(NSString *)format;

/**
 * 时间转时间戳
 * @param time 时间
 * @param format 格式（yyyy-MM-dd HH:mm:ss）
 */
+ (NSString *)yxTimeTurnsTimeStampByTime:(NSString *)time
                                 format:(NSString *)format;

/**
 * 判断间隔时间
 * @param logo 页面标识
 * @param boolIn 是否进入
 */
+ (NSInteger)yxJudgeTimeIntervalByLogo:(NSString *)logo
                                boolIn:(BOOL)boolIn;

/** 使用oss自动设置尺寸 */
- (NSString *)ossSetImgSizeByUrl:(NSString *)url;

/** 保留两位小数，没有时出去 */
+ (NSString *)yxFloatKeepTwoBitsAndRemoveAllZero:(double)floatnum;

/**
 * 格式化显示，填充数据（如11000 -> 1.1w）
 * @param num 需改变的数据
 * @param segmentationNum 以什么单位数据分割（如11000，以10000为分割）
 * @param splice 拼接数据（如1.1w中的w）
 */
+ (NSString *)yxGetNumberWithNum:(double)num
                 segmentationNum:(CGFloat)segmentationNum
                          splice:(NSString *)splice;

/** 获取设备名称 */
+ (NSString *)yxGetDeviceName;

@end

NS_ASSUME_NONNULL_END
