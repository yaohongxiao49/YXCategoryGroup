//
//  YXRequestTask.h
//  MuchProj
//
//  Created by Augus on 2022/1/14.
//

#import <Foundation/Foundation.h>
#import "YXFileHandle.h"

#define RequestTimeout 10.0

NS_ASSUME_NONNULL_BEGIN

@class YXRequestTask;
@protocol YXRequestTaskDelegate <NSObject>

@required
- (void)requestTaskDidUpdateCache; //更新缓冲进度代理方法

@optional
- (void)requestTaskDidReceiveResponse;
- (void)requestTaskDidFinishLoadingWithCache:(BOOL)cache;
- (void)requestTaskDidFailWithError:(NSError *)error;

@end

@interface YXRequestTask : NSObject

@property (nonatomic, weak) id<YXRequestTaskDelegate> delegate;
@property (nonatomic, strong) NSURL *requestURL; //请求网址
@property (nonatomic, assign) NSUInteger requestOffset; //请求起始位置
@property (nonatomic, assign) NSUInteger fileLength; //文件长度
@property (nonatomic, assign) NSUInteger cacheLength; //缓冲长度
@property (nonatomic, assign) BOOL cache; //是否缓存文件
@property (nonatomic, assign) BOOL cancel; //是否取消请求

/** 开始请求 */
- (void)start;

@end

NS_ASSUME_NONNULL_END
