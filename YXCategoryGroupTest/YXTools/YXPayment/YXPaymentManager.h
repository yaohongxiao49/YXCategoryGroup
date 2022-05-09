//
//  YXPaymentManager.h
//  RuLiMeiRong
//
//  Created by ios on 2019/8/27.
//  Copyright © 2019 成都美哆网络科技有限公司. All rights reserved.
//
/// 支付使用

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
//#import <WXApi.h>
#import <WechatOpenSDK/WXApi.h>
#import "PaymentManagerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct{
    __unsafe_unretained NSString *payChannel;
    __unsafe_unretained NSString *payNo;
} PaymentInfo;

/** 支付结果类型 */
typedef NS_ENUM(NSUInteger, YXPaymentManagerType) {
    /** 支付成功 */
    YXPaymentManagerTypeSuccess = 9000,
    /** 正在处理中 */
    YXPaymentManagerTypeProcessing = 8000,
    /** 支付失败 */
    YXPaymentManagerTypeFailed = 4000,
    /** 取消操作 */
    YXPaymentManagerTypeCancel = 6001,
    /** 网络异常 */
    YXPaymentManagerTypeNetProblems = 6002,
};

@interface YXPaymentManager : NSObject <WXApiDelegate>

+ (instancetype)sharedManager;

#pragma mark - 微信
/**
 * 微信支付
 * @param paymentInfo model
 */
- (void)wechatPayWithPaymentInfo:(PaymentManagerModel *)paymentInfo;

#pragma mark - 支付宝
/**
 * 支付宝支付
 * @param sign 支付宝签名
 */
- (void)alipayWithPaymentInfoBase:(id)sign
                payResultCallBack:(void(^)(BOOL state))callBack;

/**
 * 支付宝支付
 * @param sign 支付宝签名（SDK支付）
 */
- (void)alipayWithPaymentInfoByApp:(NSString *)sign
                 payResultCallBack:(void(^)(BOOL state))callBack;

/**
 * 支付宝网页支付/进入当前app时，结果支付宝结果回调
 * @param sign 支付宝签名（使用的扫码付）
 */
- (void)alipayWithPaymentInfoByHtml:(id)sign
                  payResultCallBack:(void(^)(BOOL state))callBack;

@end

NS_ASSUME_NONNULL_END
