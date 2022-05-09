//
//  YXListCountDown.h
//  MuchProj
//
//  Created by Augus on 2021/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YXListCountDownDelegate <NSObject>

/** cell定时器 */
@optional
- (void)yxTimeChangeByCell:(UITableViewCell *)cell hour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second millisecondValue:(NSString *)millisecondValue;

/** 组定时器 */
@optional
- (void)yxTimeChangeByView:(UITableViewHeaderFooterView *)view index:(NSInteger)index hour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second millisecondValue:(NSString *)millisecondValue;

@end

@interface YXListCountDown : NSObject

@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, assign) id <YXListCountDownDelegate> delegate;

/** 单例 */
+ (YXListCountDown *)shareManager;

/** 初始化定时器落地视图 */
- (void)initTimerByTableView:(UITableView *)tableView boolSec:(BOOL)boolSec;

/** 移除所有定时器 */
- (void)removeAllTimer;

@end

NS_ASSUME_NONNULL_END
