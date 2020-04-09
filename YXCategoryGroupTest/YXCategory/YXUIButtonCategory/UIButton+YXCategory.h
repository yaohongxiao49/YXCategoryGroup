//
//  UIButton+YXCategory.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/9.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 按钮文字、图片显示类型枚举 */
typedef NS_ENUM(NSUInteger, YXBtnEdgeInsetsStyle) {
    /** img在上，lab在下 */
    YXBtnEdgeInsetsStyleTop,
    /** img在左，lab在右 */
    YXBtnEdgeInsetsStyleLeft,
    /** img在下，lab在上 */
    YXBtnEdgeInsetsStyleBottom,
    /** img在右，lab在左 */
    YXBtnEdgeInsetsStyleRight,
};

typedef void(^YXBtnTapActionBlock)(UIButton *button);
typedef void(^YXStartWithTimeIsEndBlock)(id);

@interface UIButton (YXCategory)

@property(nonatomic, copy) YXBtnTapActionBlock yxBtnTapActionBlock;

/** 防止按钮重复点击 */
@property (nonatomic, assign) NSTimeInterval repeatClickEventInterval; //重复点击的间隔
@property (nonatomic, assign) NSTimeInterval acceptEventTime;

/**
 * 通过block对button的点击事件封装
 * @param frame frame
 * @param title 标题
 * @param bgImgName 背景图片
 * @param action 点击事件回调block
 * @return button
 */
+ (UIButton *)yxCreateBtnByFrame:(CGRect)frame
                           title:(NSString *)title
                    nomalImgName:(NSString *)nomalImgName
                 selectedImgName:(NSString *)selectedImgName
              highlightedImgName:(NSString *)highlightedImgName
                       bgImgName:(NSString *)bgImgName
                          action:(YXBtnTapActionBlock)action;

/**
 * 设置button的titleLab和ImgView的布局样式，及间距
 * @param style titleLab和ImgView的布局样式
 * @param imgTitleSpace titleLabel和ImgView的间距
 */
- (void)yxLayoutBtnWithEdgeInsetsStyle:(YXBtnEdgeInsetsStyle)style
                         imgTitleSpace:(CGFloat)imgTitleSpace;

/**
 * 倒计时按钮
 * @param timeAmount 倒计时总时间
 * @param title 还没倒计时的title
 * @param beforeSubTitle 时间之前的描述
 * @param subTitle 倒计时中的子名字，如时、分
 * @param mColor 还没倒计时的颜色
 * @param color 倒计时中的颜色
 * @param isCerificationCode 是否为验证码
 */
- (void)yxBtnCountdownByTimeAmount:(NSInteger)timeAmount
                             title:(NSString *)title
                    beforeSubTitle:(NSString *)beforeSubTitle
                    countDownTitle:(NSString *)subTitle
                         mainColor:(UIColor *)mColor
                        countColor:(UIColor *)color
                isCerificationCode:(BOOL)isCerificationCode
           startWithTimeIsEndBlock:(YXStartWithTimeIsEndBlock)startWithTimeIsEndBlock;

@end

NS_ASSUME_NONNULL_END
