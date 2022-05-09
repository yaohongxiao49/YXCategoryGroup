//
//  YXPaymentManager.m
//  RuLiMeiRong
//
//  Created by ios on 2019/8/27.
//  Copyright © 2019 成都美哆网络科技有限公司. All rights reserved.
//

#import "YXPaymentManager.h"

#define AlipaySignURL @"http://tchy.pay.nat123.net/payControl/payment?payid=ali"

@implementation YXPaymentManager

#pragma mark - 微信
+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static YXPaymentManager *instance;
    dispatch_once(&onceToken, ^{
        
        instance = [[YXPaymentManager alloc] init];
    });
    return instance;
}

#pragma mark - 微信支付
- (void)wechatPayWithPaymentInfo:(PaymentManagerModel *)paymentInfo {
    
    //调起微信支付
    PayReq *req = [[PayReq alloc] init];
    req.openID = paymentInfo.appId;
    req.partnerId = paymentInfo.partnerId;
    req.prepayId = paymentInfo.prePayId;
    req.nonceStr = paymentInfo.nonceStr;
    req.timeStamp = (UInt32)[paymentInfo.timeStamp longLongValue];
    req.package = paymentInfo.packageName;
    req.sign = paymentInfo.sign;

    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:req completion:^(BOOL success) {}];
    }
    else {
//        [YCAlertView showWithTitle:@"温馨提示" message:@"请先安装微信!" buttonTitles:@[@"确定"] clickBlock:nil];
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    //支付返回结果，实际支付结果需要去微信服务器端查询
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess: {
                NSLog(@"支付成功");
                break;
            }
            default: {
                NSLog(@"支付失败: errCode = %d errStr = %@", resp.errCode, resp.errStr);
                break;
            }
        }
    }
}
- (void)onReq:(BaseReq *)req {
    
}

#pragma mark - 支付宝
- (void)alipayWithPaymentInfoBase:(id)sign payResultCallBack:(void(^)(BOOL state))callBack {
    
    BOOL boolAlipay = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"kaixiangyin://"]];
    if (boolAlipay) {
        [self alipayWithPaymentInfoByApp:sign payResultCallBack:^(BOOL state) {
            
            if (callBack) {
                callBack(state);
            }
        }];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请先安装支付宝！"];
//        //需后台返回url
//        [self alipayWithPaymentInfoByHtml:sign payResultCallBack:^(BOOL state) {
//
//            if (callBack) {
//                callBack(state);
//            }
//        }];
    }
}

#pragma mark - 支付宝App支付
- (void)alipayWithPaymentInfoByApp:(NSString *)sign payResultCallBack:(void(^)(BOOL state))callBack {
    
    NSString *appScheme = @"kaixiangyin";
    [[AlipaySDK defaultService] payOrder:sign fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        NSInteger status = [resultDic[@"resultStatus"] integerValue];
        switch (status) {
            case YXPaymentManagerTypeSuccess: {
//                [YCProgressHUD showSuccessWithStatus:@"支付成功"];
                if(callBack) {
                    callBack(YES);
                }
                return;
                break;
            }
            case YXPaymentManagerTypeProcessing:
//                [YCProgressHUD showErrorWithStatus:@"正在处理中"];
                break;
            case YXPaymentManagerTypeFailed:
//                [YCProgressHUD showErrorWithStatus:@"订单支付失败"];
                break;
            case YXPaymentManagerTypeCancel:
//                [YCProgressHUD showErrorWithStatus:@"取消操作"];
                break;
            case YXPaymentManagerTypeNetProblems:
//                [YCProgressHUD showErrorWithStatus:@"网络异常"];
                break;
            default:
                break;
        }
        if (callBack) {
            callBack(NO);
        }
    }];
}

#pragma mark - 支付宝网页支付/进入当前app时，结果支付宝结果回调
- (void)alipayWithPaymentInfoByHtml:(id)sign payResultCallBack:(void(^)(BOOL state))callBack {
    
//    NSString *msg = sign;
//    NSURL *url = [NSURL URLWithString:msg];
//    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    
    [[AlipaySDK defaultService] processOrderWithPaymentResult:sign standbyCallback:^(NSDictionary *resultDic) {
        
        NSInteger status = [resultDic[@"resultStatus"] integerValue];
        switch (status) {
            case YXPaymentManagerTypeSuccess: {
//                [YCProgressHUD showSuccessWithStatus:@"支付成功"];
                if (callBack) {
                    callBack(YES);
                }
                return;
                break;
            }
            case YXPaymentManagerTypeProcessing:
//                [YCProgressHUD showErrorWithStatus:@"正在处理中"];
                break;
            case YXPaymentManagerTypeFailed:
//                [YCProgressHUD showErrorWithStatus:@"订单支付失败"];
                break;
            case YXPaymentManagerTypeCancel:
//                [YCProgressHUD showErrorWithStatus:@"取消操作"];
                break;
            case YXPaymentManagerTypeNetProblems:
//                [YCProgressHUD showErrorWithStatus:@"网络异常"];
                break;
            default:
                break;
        }
        if (callBack) {
            callBack(NO);
        }
    }];
}

@end
