//
//  YXPublicShareManager.h
//  YXSharedByUmengTest
//
//  Created by ios on 2020/4/2.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXPublicShareManagerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXPublicShareManager : NSObject

/** 单例 */
+ (YXPublicShareManager *)instanceManager;

/**
 * 初始化分享平台
 * @param platformInfoDic @{@"wechat":@{@"appKey":@"xxx", @"appSecret":@"xxx", @"redirectURL":@""}, @"qq":@{@"appKey":@"xxx", @"appSecret":@"xxx", @"redirectURL":@""}, @"sina":@{@"appKey":@"xxx", @"appSecret":@"xxx", @"redirectURL":@""}, @"alipay":@{@"appKey":@"xxx", @"appSecret":@"", @"redirectURL":@"http://www.0086media.com/"}}
 * @param umengKey 友盟的key
 */
- (void)initSharePlatform:(NSMutableDictionary *)platformInfoDic umengKey:(NSString *)umengKey;

/**
 * 调用友盟分享视图
 * @param platformArr 分享平台数组
 * @param finishedBlock 调起回调
 */
- (void)showUmengShareViewByPlatformArr:(NSArray *)platformArr
                          finishedBlock:(void(^)(UMSocialPlatformType platformType))finishedBlock;

/**
 * 分享链接
 * @param platformType 平台
 * @param title 标题
 * @param text 内容
 * @param img 图片
 * @param shareUrl 链接
 * @param selfVC 父视图控制器
 * @param successBlock 成功回调
 * @param failBlock 失败回调
 */
- (void)shareUrlByPlatformType:(UMSocialPlatformType)platformType
                         title:(NSString *)title
                          text:(NSString *)text
                           img:(id)img
                      shareUrl:(NSString *)shareUrl
                        selfVC:(id)selfVC
                  successBlock:(void(^)(id success))successBlock
                     failBlock:(void(^)(id fail))failBlock;

/**
 * 分享图片
 * @param platformType 平台
 * @param img 图片
 * @param selfVC 父视图控制器
 * @param successBlock 成功回调
 * @param failBlock 失败回调
 */
- (void)shareImgByPlatformType:(UMSocialPlatformType)platformType
                           img:(id)img
                        selfVC:(id)selfVC
                  successBlock:(void(^)(id success))successBlock
                     failBlock:(void(^)(id fail))failBlock;

/**
 * 分享文本
 * @param platformType 平台
 * @param title 标题
 * @param text 内容
 * @param shareUrl 链接
 * @param selfVC 父视图控制器
 * @param successBlock 成功回调
 * @param failBlock 失败回调
 */
- (void)shareTextByPlatformType:(UMSocialPlatformType)platformType
                          title:(NSString *)title
                           text:(NSString *)text
                       shareUrl:(NSString *)shareUrl
                         selfVC:(id)selfVC
                   successBlock:(void(^)(id success))successBlock
                      failBlock:(void(^)(id fail))failBlock;

/**
 * 分享音乐
 * @param platformType 平台
 * @param title 标题
 * @param text 内容
 * @param iconImg icon
 * @param musicUrl 音乐地址
 * @param selfVC 父视图控制器
 * @param successBlock 成功回调
 * @param failBlock 失败回调
 */
- (void)shareMusicByPlatformType:(UMSocialPlatformType)platformType
                           title:(NSString *)title
                            text:(NSString *)text
                         iconImg:(id)iconImg
                        musicUrl:(NSString *)musicUrl
                          selfVC:(id)selfVC
                    successBlock:(void(^)(id success))successBlock
                       failBlock:(void(^)(id fail))failBlock;

/**
 * 分享视屏
 * @param platformType 平台
 * @param title 标题
 * @param text 内容
 * @param iconImg icon
 * @param videoUrl 视频地址
 * @param selfVC 父视图控制器
 * @param successBlock 成功回调
 * @param failBlock 失败回调
 */
- (void)shareVideoByPlatformType:(UMSocialPlatformType)platformType
                           title:(NSString *)title
                            text:(NSString *)text
                         iconImg:(id)iconImg
                        videoUrl:(NSString *)videoUrl
                          selfVC:(id)selfVC
                    successBlock:(void(^)(id success))successBlock
                       failBlock:(void(^)(id fail))failBlock;

/**
 * 分享小程序
 * @param platformType 平台
 * @param title 标题
 * @param text 内容
 * @param iconImg icon
 * @param webpageUrl 兼容旧版微信（分享的网页地址）
 * @param miniProgramName 小程序名
 * @param miniProgramPath 小程序地址（如 pages/page10007/page10007）
 * @param miniProgramImgData 预览图
 * @param miniProgramType 版本类型
 * @param selfVC 父视图控制器
 * @param successBlock 成功回调
 * @param failBlock 失败回调
 */
- (void)shareMiniProgramByPlatformType:(UMSocialPlatformType)platformType
                           title:(NSString *)title
                            text:(NSString *)text
                         iconImg:(id)iconImg
                      webpageUrl:(NSString *)webpageUrl
                miniProgramName:(NSString *)miniProgramName
                miniProgramPath:(NSString *)miniProgramPath
             miniProgramImgData:(NSData *)miniProgramImgData
                 miniProgramType:(UShareWXMiniProgramType)miniProgramType
                          selfVC:(id)selfVC
                    successBlock:(void(^)(id success))successBlock
                       failBlock:(void(^)(id fail))failBlock;

/**
 * 授权并获取用户信息
 * @param platformType 授权平台
 * @param baseVC 基础控制器
 */
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
                        baseVC:(id)baseVC
                      finished:(void(^)(BOOL boolSuccess, UMSocialUserInfoResponse *result))finished;

@end

NS_ASSUME_NONNULL_END
