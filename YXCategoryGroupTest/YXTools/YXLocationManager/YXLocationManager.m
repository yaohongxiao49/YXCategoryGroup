//
//  YXLocationManager.m
//  MuchProj
//
//  Created by Augus on 2023/9/13.
//

#import "YXLocationManager.h"

@interface YXLocationManager ()

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) CLLocationManager *systemLocationManager;
@property (nonatomic, assign) BOOL boolLocationOnce; //是否单次定位

@end

@implementation YXLocationManager

#pragma mark - 单例
+ (YXLocationManager *)shareIncetance {
    
    static YXLocationManager *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        location = [[YXLocationManager alloc] init];
    });
    return location;
}

#pragma mark - 注册高德地图
- (void)initGaodeMapByKey:(NSString *)key {
    
    [AMapServices sharedServices].apiKey = key;
    [AMapServices sharedServices].enableHTTPS = NO;
}

#pragma mark - 开始定位
- (void)startLocationByBoolLocationOnce:(BOOL)boolLocationOnce {
    
    _boolLocationOnce = boolLocationOnce;
    
    //检查隐私合规
    [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    
    //开启定位
    [self.locationManager startUpdatingLocation];
}

#pragma mark - 停止定位
- (void)stopLocation {
    
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - AMapLocationManagerDelegate
#pragma mark - 定位权限
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        //没有定位权限设置位置相关的信息为默认
        
    }
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        if (self.yxLocationManagerBlock) {
            self.yxLocationManagerBlock(nil, nil, nil);
        }
    }
}
#pragma mark - 定位错误
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (self.yxLocationManagerBlock) {
        self.yxLocationManagerBlock(nil, nil, error);
    }
}
#pragma mark - 定位结果
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    
    _userLocation = location;
    
    if (self.boolLocationOnce) [self stopLocation];
    [self locateAction];
}

#pragma mark - 带逆地理的单次定位
- (void)locateAction {
    
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        //逆地理信息
        if (weakSelf.yxLocationManagerBlock) {
            weakSelf.yxLocationManagerBlock(location, regeocode, error);
        }
    }];
}

#pragma mark - 懒加载
- (AMapLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        
        //设置期望定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //设置是否系统暂停定位
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否在后台定位
        _locationManager.allowsBackgroundLocationUpdates = NO;
        //连续定位是否返回逆地理信息
        _locationManager.locatingWithReGeocode = YES;
        //设置定位超时时间
        _locationManager.locationTimeout = 30;
        //设置逆地理超时时间
        _locationManager.reGeocodeTimeout = 30;
        //更新定位距离
        _locationManager.distanceFilter = 200;
        
        //手动调用申请位置权限
        [self.systemLocationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}
- (CLLocationManager *)systemLocationManager {
    
    if (!_systemLocationManager) {
        _systemLocationManager = [[CLLocationManager alloc] init];
    }
    return _systemLocationManager;
}

@end
