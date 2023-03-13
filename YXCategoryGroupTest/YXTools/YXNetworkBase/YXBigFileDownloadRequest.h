//
//  YXBigFileDownloadRequest.h
//  MuchProj
//
//  Created by Augus on 2023/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXBigFileDownloadRequest : NSObject

+ (instancetype)sharedManager;
/** 是否完成 */
@property (nonatomic, copy) void(^yxBigFileDownloadRequestBlock)(NSString *savePath, NSString *fileName);
/** 下载进度 */
@property (nonatomic, copy) void(^yxBigFileDownloadRequestProgressBlock)(double progress);

/**
 * 开始下载
 *
 * fileUrl: 下载地址
 */
- (void)startDownloadByFileUrl:(NSString *)fileUrl;

/** 恢复下载 */
- (void)resumeDownload;

/** 暂停下载 */
- (void)pauseDownload;

@end

NS_ASSUME_NONNULL_END
