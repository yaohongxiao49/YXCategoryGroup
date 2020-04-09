//
//  UIColor+YXUIColorCategary.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YXUIColorCategary)

/**
 * 绘制渐变色
 * @param view 基础视图
 * @param colorArr 色值数组
 * @param startPoint 开始点
 * @param endPoint 结束点
 * @param locations 设置颜色变化点（分割点），取值范围 0.0 ~ 1.0。默认@[@0, @1]
 */
+ (CAGradientLayer *)yxDrawGradient:(UIView *)view
                           colorArr:(NSArray *)colorArr
                         startPoint:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint
                          locations:(NSArray *)locations;

@end

NS_ASSUME_NONNULL_END
