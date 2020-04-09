//
//  YXBaseManager.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXBaseManager : NSObject

+ (YXBaseManager *)instanceManager;

/**
 * 钩子方法
 * @param cls 类
 * @param originalSelector 原始
 * @param swizzledSelector 新鲜
 */
+ (void)swizzlingInClass:(Class)cls
        originalSelector:(SEL)originalSelector
        swizzledSelector:(SEL)swizzledSelector;

/**
 * 拨打电话
 * @param mobile 电话号码
 */
+ (void)yxCallMobile:(NSString *)mobile;

/**
 * 发短信
 * @param mobile 电话号码
 */
- (void)yxSendSMSByMobile:(NSString *)mobile;

/** 打开app设置页面 */
- (void)yxOpenAppSetting;

/**
 * 打开safari
 * @param url 打开地址
 */
- (void)yxOpenSafariByUrl:(NSString *)url;

/**
 * 打开app商店
 * @param ident appStore中的id
 * @param boolDetail 是否打开商店详情（评价）
 */
- (void)yxOpenAppStoreByIdent:(NSString *)ident
                   boolDetail:(BOOL)boolDetail;

/**
 * 获取录音时长
 * @param path 地址
 */
- (NSString *)yxGetVoiceTime:(NSString *)path;

/**
 * 判断当前设备是否开启相机功能
 * @param vc 控制器
 * @param resultBlock 结果回调
 */
- (void)yxJudgeAVCaptureDevice:(UIViewController *)vc
                   resultBlock:(void(^)(BOOL boolSuccess))resultBlock;

/**
 * 输入框输入字数限制
 * @param view UITextField/UITextView
 * @param maxNum 最大输入字数
 * @param resultBlock 结果回调
 */
- (void)yxLimitInputByView:(id)view
                    maxNum:(NSInteger)maxNum
               resultBlock:(void(^)(BOOL boolSuccess))resultBlock;

/**
 * 替换控制器
 * @param vc 父视图控制器
 * @param toReplace 替换后的控制器
 * @param beReplaceVCName 替换前的控制器名称
 */
- (void)yxReplaceVCByVC:(UIViewController *)vc
              toReplace:(UIViewController *)toReplace
        beReplaceVCName:(NSString *)beReplaceVCName;

@end

NS_ASSUME_NONNULL_END
