//
//  YXOpenThirdMapManager.h
//  MuchProj
//
//  Created by Augus on 2023/11/13.
//

#import <Foundation/Foundation.h>
#import "YXOpenThirdMapModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXOpenThirdMapManagerShowType) {
    /** 根据系统所能打开的三方地图进行选择 */
    YXOpenThirdMapManagerShowTypeAll,
    /** 只打开高德地图 */
    YXOpenThirdMapManagerShowTypeGaoDe,
    /** 只打开百度地图 */
    YXOpenThirdMapManagerShowTypeBaidu,
};

@interface YXOpenThirdMapManager : NSObject

/** 单例 */
+ (YXOpenThirdMapManager *)shareIncetance;

/** 打开三方地图 */
- (void)openThirdMapByModel:(YXOpenThirdMapModel *)model baseVC:(UIViewController *)baseVC type:(YXOpenThirdMapManagerShowType)type;

@end

NS_ASSUME_NONNULL_END
