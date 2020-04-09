//
//  UIView+YXCategory.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/9.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YXCategory)

/**
 * 指定圆角
 * @param view 视图
 * @param corners 圆角方位
 * @param cornerRadii 圆角层度
 */
+ (void)yxSpecifiedCornerFilletByView:(UIView *)view
                              corners:(UIRectCorner)corners
                          cornerRadii:(CGSize)cornerRadii;

@end

NS_ASSUME_NONNULL_END
