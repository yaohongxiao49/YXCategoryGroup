//
//  YXVideoPlayerManager.h
//  RuLiMeiRong
//
//  Created by ios on 2019/7/4.
//  Copyright © 2019 成都美哆网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXResourceLoader.h"

typedef NS_ENUM(NSInteger, YXVideoPlayerManagerState) {
    YXVideoPlayerManagerWaiting,
    YXVideoPlayerManagerPlaying,
    YXVideoPlayerManagerPaused,
    YXVideoPlayerManagerStopped,
    YXVideoPlayerManagerBuffering,
    YXVideoPlayerManagerError
};

@interface YXVideoPlayerManager : NSObject<YXResourceLoaderDelegate>

@property (nonatomic, assign) YXVideoPlayerManagerState state;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat cacheProgress;
@property (nonatomic, assign) BOOL isCycle; //循环播放
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, copy) void(^playerFinshedBlock)(void);

+ (YXVideoPlayerManager *)sharedPlayerManger;

/** 初始化方法，url：歌曲的网络地址或者本地地址 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 *  播放下一首歌曲，url：歌曲的网络地址或者本地地址
 *  逻辑：stop -> replace -> play
 */
- (void)replaceItemWithURL:(NSURL *)url;

/** 播放 */
- (void)play;

/** 暂停 */
- (void)pause;

/** 停止 */
- (void)stop;

/** 正在播放 */
- (BOOL)isPlaying;

/** 跳到某个时间进度 */
- (void)seekToTime:(CGFloat)seconds;

/** 当前歌曲缓存情况 YES：已缓存 NO：未缓存（seek过的歌曲都不会缓存）*/
- (BOOL)currentItemCacheState;

/** 当前歌曲缓存文件完整路径 */
- (NSString *)currentItemCacheFilePath;

/** 清除缓存 */
+ (BOOL)clearCache;

@end
