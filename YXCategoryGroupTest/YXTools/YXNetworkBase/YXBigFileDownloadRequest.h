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

/** 解压后的文件地址 */
@property (nonatomic, copy, readonly) NSString *openZipPath;
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

/**
 * 解压文件
 * path 压缩文件地址
 * unzipto 解压后的地址
 * openZipBlock 解压进度百分比
 */
- (void)yxOpenZipByPath:(NSString *)path
                unzipto:(NSString *)unzipto
           openZipBlock:(void(^)(NSInteger progress, NSString *unzipPath))openZipBlock;

/** 压缩文件 */
- (void)yxZipFileByPath:(NSString *)path zipToPath:(NSString *)zipToPath;

/** 移除压缩文件 */
- (void)removeZipMethodByPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
