//
//  YXOpenThirdMapModel.h
//  MuchProj
//
//  Created by Augus on 2023/11/13.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXOpenThirdMapModel : JSONModel

#pragma mark - 终点
/** 地址名 */
@property (nonatomic, copy) NSString *localName;
/** 城市 */
@property (nonatomic, copy) NSString *city;
/** 详细地址 */
@property (nonatomic, copy) NSString *address;
/** 经度 */
@property (nonatomic, assign) CGFloat longitude;
/** 纬度 */
@property (nonatomic, assign) CGFloat latitude;

#pragma mark - 内部使用
/** 地图标题 */
@property (nonatomic, copy) NSString *mapName;
/** 三方地址 */
@property (nonatomic, copy) NSString *thirdUrl;

@end

NS_ASSUME_NONNULL_END
