//
//  YXCardAnimationView.h
//  MuchProj
//
//  Created by Augus on 2023/3/17.
//

#import <UIKit/UIKit.h>
/** 类探探的卡片式效果 */
#import "ZLSwipeableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCardAnimationView : UIView

@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, copy) void(^yxCardAnimationViewTapBlock)(YXShoppingMallAdvertingModel *model);

@end

NS_ASSUME_NONNULL_END
