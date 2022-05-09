//
//  PaymentManagerModel.h
//  RuLiMeiRong
//
//  Created by ios on 2019/8/27.
//  Copyright © 2019 成都美哆网络科技有限公司. All rights reserved.
//
/// 支付模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentManagerModel : NSObject

/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, copy) NSString *sign;
/** 时间戳 */
@property (nonatomic, copy) NSString *timeStamp;
/** 随机串 */
@property (nonatomic, copy) NSString *nonceStr;
/** 商家向财付通申请的商家id */
@property (nonatomic, copy) NSString *partnerId;
/** 预支付订单 */
@property (nonatomic, copy) NSString *prePayId;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, copy) NSString *packageName;
/** 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录 */
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *notifyUrl;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
