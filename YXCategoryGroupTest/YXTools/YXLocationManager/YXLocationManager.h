//
//  YXLocationManager.h
//  MuchProj
//
//  Created by Augus on 2023/9/13.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXLocationManager : NSObject <AMapLocationManagerDelegate>

/** 城市名 */
@property (nonatomic, strong) NSString *cityName;
/** 经纬度 */
@property (nonatomic, assign, readonly) CLLocation *userLocation;

@property (nonatomic, copy) void (^yxLocationManagerBlock) (CLLocation  * _Nullable location, AMapLocationReGeocode  * _Nullable geocode, NSError  * _Nullable error);

+ (YXLocationManager *)shareIncetance;

/** 注册高德地图 */
- (void)initGaodeMapByKey:(NSString *)key;

/**
 开始定位
 - Parameter boolLocationOnce: 是否单次定位
 */
- (void)startLocationByBoolLocationOnce:(BOOL)boolLocationOnce;

/** 停止定位 */
- (void)stopLocation;

@end

NS_ASSUME_NONNULL_END
