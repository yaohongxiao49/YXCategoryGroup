//
//  YXPublicShareManager.m
//  YXSharedByUmengTest
//
//  Created by ios on 2020/4/2.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXPublicShareManager.h"

@implementation YXPublicShareManager

#pragma mark - 单例
+ (YXPublicShareManager *)instanceManager {
    
    static YXPublicShareManager *yxPublicShareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        yxPublicShareManager = [YXPublicShareManager new];
    });
    return yxPublicShareManager;
}

#pragma mark - 初始化分享平台
- (void)initSharePlatform:(NSMutableDictionary *)platformInfoDic umengKey:(NSString *)umengKey {
   
    [self configUSharePlatforms:platformInfoDic umengKey:umengKey];
    [self confitUShareSettings];
}
- (void)configUSharePlatforms:(NSMutableDictionary *)platformInfoDic umengKey:(NSString *)umengKey {
    
    NSMutableDictionary *wechatDic = [platformInfoDic objectForKey:@"wechat"];
    NSMutableDictionary *qqDic = [platformInfoDic objectForKey:@"qq"];
    NSMutableDictionary *sinaDic = [platformInfoDic objectForKey:@"sina"];
    NSMutableDictionary *alipayDic = [platformInfoDic objectForKey:@"alipay"];
    
    [UMConfigure initWithAppkey:umengKey channel:@"AppStore"];
    if (wechatDic) {
        [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession) : kWechatUniversalLink};
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:[wechatDic objectForKey:@"appKey"] appSecret:[wechatDic objectForKey:@"appSecret"] redirectURL:[[wechatDic objectForKey:@"redirectURL"] yxHasValue] ? [wechatDic objectForKey:@"redirectURL"] : nil];
    }
    if (qqDic) {
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:[qqDic objectForKey:@"appKey"] appSecret:[qqDic objectForKey:@"appSecret"] redirectURL:[qqDic objectForKey:@"redirectURL"]];
    }
    if (sinaDic) {
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:[sinaDic objectForKey:@"appKey"] appSecret:[sinaDic objectForKey:@"appSecret"] redirectURL:[sinaDic objectForKey:@"redirectURL"]];
    }
    if (alipayDic) {
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_APSession appKey:[alipayDic objectForKey:@"appKey"] appSecret:[alipayDic objectForKey:@"appSecret"] redirectURL:[alipayDic objectForKey:@"redirectURL"]];
    }
}
- (void)confitUShareSettings {
    
    /** 打开日志 */
    [[UMSocialManager defaultManager] openLog:NO];
    /** 打开图片水印 */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /** 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名 */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

#pragma mark - 调用友盟分享视图
- (void)showUmengShareViewByPlatformArr:(NSArray *)platformArr finishedBlock:(void(^)(UMSocialPlatformType platformType))finishedBlock {
    
    [UMSocialUIManager setPreDefinePlatforms:platformArr];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
         if (finishedBlock) {
             finishedBlock(platformType);
         }
    }];
}

#pragma mark - 分享链接
- (void)shareUrlByPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title text:(NSString *)text img:(id)img shareUrl:(NSString *)shareUrl selfVC:(id)selfVC successBlock:(void(^)(id success))successBlock failBlock:(void(^)(id fail))failBlock {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (platformType == UMSocialPlatformType_Sina) {
        messageObject.title = [NSString stringWithFormat:@"%@", title];
        messageObject.text = [NSString stringWithFormat:@"%@，%@%@", title, text, shareUrl];
        
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        [shareObject setShareImage:img];
        messageObject.shareObject = shareObject;
    }
    else {
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:img];
        shareObject.webpageUrl = shareUrl;
        messageObject.shareObject = shareObject;
    }
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:selfVC completion:^(id data, NSError *error) {
        
        if (!error) {
            if (successBlock) {
                successBlock(data);
            }
        }
        else {
            if (failBlock) {
                failBlock(error.localizedDescription);
            }
        }
    }];
}

#pragma mark - 分享图片
- (void)shareImgByPlatformType:(UMSocialPlatformType)platformType img:(id)img selfVC:(id)selfVC successBlock:(void(^)(id success))successBlock failBlock:(void(^)(id fail))failBlock {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:img];
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:selfVC completion:^(id data, NSError *error) {
        
        if (!error) {
            if (successBlock) {
                successBlock(data);
            }
        }
        else {
            if (failBlock) {
                failBlock(error.localizedDescription);
            }
        }
    }];
}

#pragma mark - 分享文本
- (void)shareTextByPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title text:(NSString *)text shareUrl:(NSString *)shareUrl selfVC:(id)selfVC successBlock:(void(^)(id success))successBlock failBlock:(void(^)(id fail))failBlock {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = [NSString stringWithFormat:@"%@%@%@", title, text, shareUrl];
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:selfVC completion:^(id data, NSError *error) {
        
        if (!error) {
            if (successBlock) {
                successBlock(data);
            }
        }
        else {
            if (failBlock) {
                failBlock(error.localizedDescription);
            }
        }
    }];
}

#pragma mark - 分享音乐
- (void)shareMusicByPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title text:(NSString *)text iconImg:(id)iconImg musicUrl:(NSString *)musicUrl selfVC:(id)selfVC successBlock:(void(^)(id success))successBlock failBlock:(void(^)(id fail))failBlock {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:title descr:text thumImage:[UIImage imageNamed:iconImg]];

    shareObject.musicUrl = musicUrl;
    messageObject.shareObject = shareObject;

    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:selfVC completion:^(id data, NSError *error) {
        
        if (!error) {
            if (successBlock) {
                successBlock(data);
            }
        }
        else {
            if (failBlock) {
                failBlock(error.localizedDescription);
            }
        }
    }];
}

#pragma mark - 分享视频
- (void)shareVideoByPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title text:(NSString *)text iconImg:(id)iconImg videoUrl:(NSString *)videoUrl selfVC:(id)selfVC successBlock:(void(^)(id success))successBlock failBlock:(void(^)(id fail))failBlock {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:text thumImage:iconImg];
    shareObject.videoUrl = videoUrl;
    messageObject.shareObject = shareObject;

    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (!error) {
            if (successBlock) {
                successBlock(data);
            }
        }
        else {
            if (failBlock) {
                failBlock(error.localizedDescription);
            }
        }
    }];
}

#pragma mark - 分享微信小程序
- (void)shareMiniProgramByPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title text:(NSString *)text iconImg:(id)iconImg webpageUrl:(NSString *)webpageUrl miniProgramName:(NSString *)miniProgramName miniProgramPath:(NSString *)miniProgramPath miniProgramImgData:(NSData *)miniProgramImgData miniProgramType:(UShareWXMiniProgramType)miniProgramType selfVC:(id)selfVC successBlock:(void(^)(id success))successBlock failBlock:(void(^)(id fail))failBlock {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:title descr:text thumImage:iconImg];
    shareObject.webpageUrl = webpageUrl;
    shareObject.userName = miniProgramName;
    shareObject.path = miniProgramPath;
    messageObject.shareObject = shareObject;
    shareObject.hdImageData = miniProgramImgData;
    shareObject.miniProgramType = miniProgramType;

    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:selfVC completion:^(id data, NSError *error) {
        
        if (!error) {
            if (successBlock) {
                successBlock(data);
            }
        }
        else {
            if (failBlock) {
                failBlock(error.localizedDescription);
            }
        }
    }];
}

#pragma mark - 授权并获取用户信息
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType baseVC:(id)baseVC finished:(void(^)(BOOL boolSuccess, UMSocialUserInfoResponse *result))finished {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:baseVC completion:^(id result, NSError *error) {
        
        if (error) {
            finished(NO, nil);
        }
        else {
            UMSocialUserInfoResponse *resp = result;
            //第三方登录数据(为空表示平台未提供)
            //授权数据
            NSLog(@"uid: %@", resp.uid);
            NSLog(@"openid: %@", resp.openid);
            NSLog(@"accessToken: %@", resp.accessToken);
            NSLog(@"refreshToken: %@", resp.refreshToken);
            NSLog(@"expiration: %@", resp.expiration);
            //用户数据
            NSLog(@"name: %@", resp.name);
            NSLog(@"iconurl: %@", resp.iconurl);
            NSLog(@"gender: %@", resp.unionGender);
            //第三方平台SDK原始数据
            NSLog(@"originalResponse: %@", resp.originalResponse);
            finished(YES, resp);
        }
    }];
}

@end
