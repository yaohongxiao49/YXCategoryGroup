//
//  YXPublicShareModel.h
//  YXSharedByUmengTest
//
//  Created by Augus on 2021/12/23.
//  Copyright © 2021 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

NS_ASSUME_NONNULL_BEGIN

/** 分享类型 */
typedef NS_ENUM(NSUInteger, YXShareContentType) {
    /** 默认 */
    YXShareContentTypeDefault,
    /** 文字 */
    YXShareContentTypeWord,
    /** 图片 */
    YXShareContentTypeImg,
    /** 链接 */
    YXShareContentTypeWeb,
    /** 音乐 */
    YXShareContentTypeMusic,
    /** 视频 */
    YXShareContentTypeVideo,
    /** 小程序 */
    YXShareContentTypeMiniProgram,
};

@interface YXPublicShareManagerModel : NSObject

/** 基础控制器 */
@property (nonatomic, weak) UIViewController *baseVC;
/** 分享数据类型 */
@property (nonatomic, assign) YXShareContentType shareContentType;
/** 分享平台类型 */
@property (nonatomic, assign) UMSocialPlatformType platformType;

#pragma mark - 分享链接/文字
/** 分享标题 */
@property (nonatomic, copy) NSString *title;
/** 分享内容 */
@property (nonatomic, copy) NSString *text;
/** 分享地址 */
@property (nonatomic, copy) NSString *shareUrl;

#pragma mark - 分享图片
/** 分享图片 */
@property (nonatomic, strong) id img;

#pragma mark - 分享音乐/视频
/** icon图片 */
@property (nonatomic, strong) UIImage *iconImg;
/** 音乐地址 */
@property (nonatomic, copy) NSString *musicUrl;
/** 视频地址 */
@property (nonatomic, copy) NSString *videoUrl;

#pragma mark - 分享小程序
/** web页URL */
@property (nonatomic, copy) NSString *webpageUrl;
/** 小程序名 */
@property (nonatomic, copy) NSString *miniProgramName;
/** 小程序详细页 */
@property (nonatomic, copy) NSString *miniProgramPath;
/** 小程序显示图 */
@property (nonatomic, copy) NSData *miniProgramImgData;
/** 小程序类型 */
@property (nonatomic, assign) UShareWXMiniProgramType miniProgramType;

@end

NS_ASSUME_NONNULL_END
