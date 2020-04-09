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

/** 视图x坐标 */
@property (nonatomic, assign) CGFloat x;
/** 视图y坐标 */
@property (nonatomic, assign) CGFloat y;
/** 视图宽 */
@property (nonatomic, assign) CGFloat width;
/** 视图高 */
@property (nonatomic, assign) CGFloat height;

/** 视图最右侧坐标 */
@property (nonatomic, assign) CGFloat right;
/** 视图最底部坐标 */
@property (nonatomic, assign) CGFloat bottom;

/** 视图中心x坐标 */
@property (nonatomic, assign) CGFloat centerX;
/** 视图中心y坐标 */
@property (nonatomic, assign) CGFloat centerY;

/** 视图坐标 */
@property (nonatomic, assign) CGPoint origin;
/** 视图大小 */
@property (nonatomic, assign) CGSize size;

/** 获取当前视图所在的视图控制器 */
- (UIViewController *)viewController;

/**
 * 添加点击手势
 * @param block 点击回调
 */
- (void)yxAddTapGestureWithBlock:(void(^)(UIView *view))block;

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
