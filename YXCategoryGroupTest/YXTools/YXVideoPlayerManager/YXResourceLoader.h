//
//  YXResourceLoader.h
//  MuchProj
//
//  Created by Augus on 2022/1/14.
//

#import <Foundation/Foundation.h>
#import "YXRequestTask.h"

#define MimeType @"video/mp4"

NS_ASSUME_NONNULL_BEGIN

@class YXResourceLoader;
@protocol YXResourceLoaderDelegate <NSObject>

@required
- (void)loader:(YXResourceLoader *)loader cacheProgress:(CGFloat)progress;

@optional
- (void)loader:(YXResourceLoader *)loader failLoadingWithError:(NSError *)error;

@end

@interface YXResourceLoader : NSObject <AVAssetResourceLoaderDelegate, YXRequestTaskDelegate>

@property (nonatomic, weak) id<YXResourceLoaderDelegate> delegate;
@property (atomic, assign) BOOL seekRequired; //Seek标识
@property (nonatomic, assign) BOOL cacheFinished;

- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
