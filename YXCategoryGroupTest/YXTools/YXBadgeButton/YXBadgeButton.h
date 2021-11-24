//
//  YXBadgeButton.h
//  RuLiMeiRong
//
//  Created by ios on 2019/8/8.
//  Copyright © 2019 成都美哆网络科技有限公司. All rights reserved.
//
/// 气泡显示按钮

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXBadgeButton : UIButton

/** 气泡数量 */
@property (nonatomic, assign) NSInteger badgeValue;
/** 是否显示气泡 */
@property (nonatomic, assign) BOOL isRedBall;
/** 气泡是否置顶 */
@property (nonatomic, assign) BOOL boolBadgeTop;
/** 显示控件 */
@property (nonatomic, strong) UILabel *badgeLab;

@end

NS_ASSUME_NONNULL_END
