//
//  UIImage+YXUIImageCategary.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YXUIImageCategary)

/**
 * 获取视频缩略图
 * @param videoUrl 视频地址
 * @param second 所需缩略图所在时间
 */
+ (UIImage *)yxGetVideoThumbnailWithVideoUrl:(NSString *)videoUrl
                                      second:(CGFloat)second;

/** 获取启动图 */
+ (UIImage *)yxGetLaunchImage;

/**
 * 合并两张图片
 * @param bgImgValue 背景图
 * @param bgImgFrame 背景图大小（可不传，默认为图片大小）
 * @param topImgValue 顶层图
 * @param topImgFrame 顶层图大小（可不传，默认为图片大小）
 * @param saveToFileWithName 储存至沙盒的名称（如不需要储存，可不传）
 * @param boolByBgView 是否依赖于背景图大小绘制
 */
+ (UIImage *)yxComposeImgWithBgImgValue:(id)bgImgValue
                             bgImgFrame:(CGRect)bgImgFrame
                            topImgValue:(id)topImgValue
                            topImgFrame:(CGRect)topImgFrame
                     saveToFileWithName:(NSString *)saveToFileWithName
                           boolByBgView:(BOOL)boolByBgView;

/**
 * 按比例缩放/压缩图片
 * @param color 颜色
 * @param imgSize 尺寸
 */
+ (UIImage *)yxCreateImgByColor:(UIColor *)color
                        imgSize:(CGSize)imgSize;

/**
 * 动态拉伸图片（默认所表示的方位数值为图片的数值）
 * @param imgName 图片名
 * @param tensileTop 顶部数值
 * @param tensileLeft 左部数值
 * @param tensileBottom 底部数值
 * @param tensileRight 右部数值
 */
+ (UIImage *)yxGetTensileImgByImgName:(NSString *)imgName
                           tensileTop:(NSString *)tensileTop
                          tensileLeft:(NSString *)tensileLeft
                        tensileBottom:(NSString *)tensileBottom
                         tensileRight:(NSString *)tensileRight;

@end

NS_ASSUME_NONNULL_END
