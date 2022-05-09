//
//  PaymentManagerModel.m
//  RuLiMeiRong
//
//  Created by ios on 2019/8/27.
//  Copyright © 2019 成都美哆网络科技有限公司. All rights reserved.
//

#import "PaymentManagerModel.h"

@implementation PaymentManagerModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {
        _sign = [dic yxObjForKey:@"sign"];
        _partnerId = [dic yxObjForKey:@"partnerid"];
        _packageName = [dic yxObjForKey:@"package"];
        _nonceStr = [dic yxObjForKey:@"noncestr"];
        _timeStamp = [dic yxObjForKey:@"timestamp"];
        _appId = [dic yxObjForKey:@"appid"];
        _prePayId = [dic yxObjForKey:@"prepayid"];
        _notifyUrl = [dic yxObjForKey:@"notifyUrl"];
    }
    return self;
}

@end
