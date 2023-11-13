//
//  YXOpenThirdMapManager.m
//  MuchProj
//
//  Created by Augus on 2023/11/13.
//

#import "YXOpenThirdMapManager.h"

@implementation YXOpenThirdMapManager

+ (YXOpenThirdMapManager *)shareIncetance {
    
    static YXOpenThirdMapManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[YXOpenThirdMapManager alloc] init];
    });
    return manager;
}

#pragma mark - 打开三方地图
- (void)openThirdMapByModel:(YXOpenThirdMapModel *)model baseVC:(UIViewController *)baseVC type:(YXOpenThirdMapManagerShowType)type {
    
    NSMutableArray *mapsArr = [NSMutableArray array];
    
    //苹果原生地图-苹果原生地图方法和其他不一样
    YXOpenThirdMapModel *thirdModel = [[YXOpenThirdMapModel alloc] init];
    thirdModel.mapName = @"苹果地图";
    [mapsArr addObject:thirdModel];
    
    if (type == YXOpenThirdMapManagerShowTypeGaoDe) {
        //高德地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            YXOpenThirdMapModel *thirdModel = [[YXOpenThirdMapModel alloc] init];
            thirdModel.mapName = @"高德地图";
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://viewMap?sourceApplication=%@&poiname=%@&lat=%f&lon=%f&dev=0&style=2", @"我的位置", model.localName, model.latitude, model.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            thirdModel.thirdUrl = urlString;
            [mapsArr addObject:thirdModel];
        }
    }
    else if (type == YXOpenThirdMapManagerShowTypeBaidu) {
        //百度地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            YXOpenThirdMapModel *thirdModel = [[YXOpenThirdMapModel alloc] init];
            thirdModel.mapName = @"百度地图";
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(model.latitude - 0.00328, model.longitude - 0.01185);
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=@{%@}&destination=latlng:%f,%f|name:%@&mode=driving", @"我的位置", coordinate.latitude, coordinate.longitude, model.localName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            thirdModel.thirdUrl = urlString;
            [mapsArr addObject:thirdModel];
        }
    }
    else {
        //百度地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            YXOpenThirdMapModel *thirdModel = [[YXOpenThirdMapModel alloc] init];
            thirdModel.mapName = @"百度地图";
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(model.latitude - 0.00328, model.longitude - 0.01185);
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=@{%@}&destination=latlng:%f,%f|name:%@&mode=driving", @"我的位置", coordinate.latitude, coordinate.longitude, model.localName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            thirdModel.thirdUrl = urlString;
            [mapsArr addObject:thirdModel];
        }
        //高德地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            YXOpenThirdMapModel *thirdModel = [[YXOpenThirdMapModel alloc] init];
            thirdModel.mapName = @"高德地图";
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://viewMap?sourceApplication=%@&poiname=%@&lat=%f&lon=%f&dev=0&style=2", @"我的位置", model.localName, model.latitude, model.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            thirdModel.thirdUrl = urlString;
            [mapsArr addObject:thirdModel];
        }
        //谷歌地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            YXOpenThirdMapModel *thirdModel = [[YXOpenThirdMapModel alloc] init];
            thirdModel.mapName = @"谷歌地图";
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving", @"我的位置", model.localName, model.latitude, model.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            thirdModel.thirdUrl = urlString;
            [mapsArr addObject:thirdModel];
        }
        //腾讯地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
            YXOpenThirdMapModel *thirdModel = [[YXOpenThirdMapModel alloc] init];
            thirdModel.mapName = @"腾讯地图";
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=%@&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0", @"我的位置", model.latitude, model.longitude, model.localName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            thirdModel.thirdUrl = urlString;
            [mapsArr addObject:thirdModel];
        }
    }
    
    YXOpenThirdMapModel *cancelModel = [[YXOpenThirdMapModel alloc] init];
    cancelModel.mapName = @"取消";
    [mapsArr addObject:cancelModel];
    
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *typeArr = [NSMutableArray array];
    for (YXOpenThirdMapModel *thirdModel in mapsArr) {
        [titleArr addObject:thirdModel.mapName];
        [typeArr addObject:@"0"];
    }
    
    [YXToolAlert yxShowAlertWithTitle:@"温馨提示" message:@"请选择您要使用的地图" style:YXToolAlertTypeDefault buttonTitles:titleArr buttonTypes:typeArr preferredStyle:UIAlertControllerStyleActionSheet tapBlock:^(YXToolAlert * _Nonnull alertView, NSInteger buttonIndex) {
       
        if (buttonIndex == 0) { //苹果自带地图
            [self appleMapLocationByModel:model];
        }
        else {
            YXOpenThirdMapModel *model = mapsArr[buttonIndex];
            if (model.thirdUrl.yxHasValue) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.thirdUrl] options:@{} completionHandler:nil];
            }
        }
    }];
}

#pragma mark - 苹果地图导航
- (void)appleMapLocationByModel:(YXOpenThirdMapModel *)model {
    
    //终点坐标
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];

    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil]];
    toLocation.name = model.localName;

    NSArray *items = @[currentLoc,toLocation];
    //第一个
    NSDictionary *dic = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,       MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard), MKLaunchOptionsShowsTrafficKey : @(YES)};
    //第二个，都可以用
    // NSDictionary * dic = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
//    MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

#pragma mark - 百度地图经纬度转换为高德地图经纬度
- (CLLocationCoordinate2D)getGaoDeCoordinateByBaiDuCoordinate:(CLLocationCoordinate2D)coordinate {
    
    return CLLocationCoordinate2DMake(coordinate.latitude - 0.006, coordinate.longitude - 0.0065);
}

#pragma mark - 高德地图经纬度转换为百度地图经纬度
- (CLLocationCoordinate2D)getBaiDuCoordinateByGaoDeCoordinate:(CLLocationCoordinate2D)coordinate {
    
    return CLLocationCoordinate2DMake(coordinate.latitude + 0.006, coordinate.longitude + 0.0065);
}

@end
