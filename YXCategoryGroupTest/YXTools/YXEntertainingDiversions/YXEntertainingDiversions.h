//
//  YXEntertainingDiversions.h
//  RuLiMeiRong
//
//  Created by ios on 2019/12/9.
//  Copyright © 2019 成都美哆网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScrollViewLabMargin 5 //间距
#define kScrollViewTime 1 //间隔时间
#define kScrollViewSpace 20 //移动距离

NS_ASSUME_NONNULL_BEGIN

/** 滚动文字视图显示位置类型 */
typedef NS_ENUM(NSUInteger, YXEntertainingDiversionsType) {
    /** 弹窗 */
    YXEntertainingDiversionsTypeAlert,
    /** 导航栏 */
    YXEntertainingDiversionsTypeNav,
};
/** 滚动文字视图对齐方式类型 */
typedef NS_ENUM(NSUInteger, YXScrollLabelAlignment) {
    /** 左对齐 */
    YXScrollLabelAlignmentLeft = 0,
    /** 居中对齐 */
    YXScrollLabelAlignmentCenter,
    /** 右对齐 */
    YXScrollLabelAlignmentRight
};

@interface YXEntertainingDiversions : UIView

@property (nonatomic, assign) YXEntertainingDiversionsType type;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *text;

/** 滚动总时长，默认为10秒 */
@property (nonatomic, assign) CGFloat scrollDuration;
/** 滚动速率，默认为20(pt/s)。赋值必须大于0，否则速率默认为20 */
@property (nonatomic, assign) CGFloat scrollVelocity;
/** 两个label之间的距离，默认为20 */
@property (nonatomic, assign) CGFloat paddingBetweenLabels;
/** 当文字长度未超过Frame宽度时的对齐方式：左，中，右。默认为居中对齐 */
@property (nonatomic, assign) YXScrollLabelAlignment labelAlignment;

/** 延迟开始第一次滚动(单位：秒)，默认为3秒 */
@property (nonatomic, assign) CGFloat delayInterval;
/** 循环滚动时，中间停止的时长(单位：秒)， 默认为3秒 */
@property (nonatomic, assign) CGFloat pauseInterval;

/** 是否自动开始滚动，默认为YES */
@property (nonatomic, assign) BOOL autoBeginScroll;
/** 是否在滚动 */
@property (nonatomic, assign, getter=isScrolling) BOOL scrolling;

/** 开始动画 */
- (void)startScrollAnimation;
/** 停止动画 */
- (void)stopScrollAnimation;

@end

NS_ASSUME_NONNULL_END
