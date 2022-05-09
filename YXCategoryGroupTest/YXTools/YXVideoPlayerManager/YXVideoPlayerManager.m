//
//  YXVideoPlayerManager.m
//  RuLiMeiRong
//
//  Created by ios on 2019/7/4.
//  Copyright © 2019 成都美哆网络科技有限公司. All rights reserved.
//

#import "YXVideoPlayerManager.h"
#import "YXResourceLoader.h"

@interface YXVideoPlayerManager ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) AVPlayerItem *currentItem;
@property (nonatomic, strong) YXResourceLoader *resourceLoader;

@property (nonatomic, strong) id timeObserve;

@end

@implementation YXVideoPlayerManager

+ (YXVideoPlayerManager *)sharedPlayerManger {
    
    static YXVideoPlayerManager *playerManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        playerManger = [[YXVideoPlayerManager alloc] init];
    });
    return playerManger;
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    
    if (self) {
        self.url = url;
        [self reloadCurrentItem];
    }
    return self;
}

- (void)reloadCurrentItem {
    
    if ([self.url.absoluteString hasPrefix:@"http"]) {
        //有缓存播放缓存文件
        NSString *cacheFilePath = [YXFileHandle cacheFileExistsWithURL:self.url];
        if (cacheFilePath) {
            NSURL *url = [NSURL fileURLWithPath:cacheFilePath];
            self.currentItem = [AVPlayerItem playerItemWithURL:url];
            NSLog(@"有缓存，播放缓存文件");
        }
        else {
            //没有缓存播放网络文件
            self.resourceLoader = [[YXResourceLoader alloc] init];
            self.resourceLoader.delegate = self;
            
            AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[self.url customSchemeURL] options:nil];
            [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
            self.currentItem = [AVPlayerItem playerItemWithAsset:asset];
            NSLog(@"无缓存，播放网络文件");
        }
    }
    else {
        self.currentItem = [AVPlayerItem playerItemWithURL:self.url];
        NSLog(@"播放本地文件");
    }
    
    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
    
    //音频打断的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
    
    //进入后台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotice:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    //返回前台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotice:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //Observer
    [self addObserver];
    
    //State
    _state = YXVideoPlayerManagerWaiting;
}

- (void)replaceItemWithURL:(NSURL *)url {
    
    self.url = url;
    [self reloadCurrentItem];
}

- (void)play {
    
    if (self.state == YXVideoPlayerManagerPaused || self.state == YXVideoPlayerManagerWaiting) {
        [self.player play];
    }
}

- (void)pause {
    
    if (self.state == YXVideoPlayerManagerPlaying) {
        [self.player pause];
    }
}

- (BOOL)isPlaying {
    
    if (self.state == YXVideoPlayerManagerPlaying) {
        return YES;
    }
    return NO;
}

- (void)stop {
    
    if (self.player) {
        self.player = nil;
    }
}

- (void)seekToTime:(CGFloat)seconds {
    
    if (self.state == YXVideoPlayerManagerPlaying || self.state == YXVideoPlayerManagerPaused) {
        //暂停后滑动slider后 暂停播放状态
        //播放中后滑动slider后 自动播放状态
        self.resourceLoader.seekRequired = YES;
        [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
            
            NSLog(@"seekComplete!!");
            if ([self isPlaying]) {
                [self.player play];
            }
        }];;
    }
}

#pragma mark - NSNotification 打断处理
- (void)audioSessionInterrupted:(NSNotification *)notification {
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSString *type = [NSString stringWithFormat:@"%@", [interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey]];
    NSUInteger interuptionType = [type integerValue];
    if (interuptionType == AVAudioSessionInterruptionTypeBegan && [self isPlaying]) {
        [self.player play];
    }
    else {
        [self.player pause];
    }
}

#pragma mark - 进入后台的通知
- (void)applicationDidEnterBackgroundNotice:(NSNotification *)notice {
    
    [self.player pause];
}

#pragma mark - 返回前台的通知
- (void)applicationDidBecomeActiveNotice:(NSNotification *)notice {
    
    [self.player play];
}

#pragma mark - 循环播放
- (void)rerunPlay {
    
    if (!self.player) {
        return;
    }
    CGFloat a = 0;
    NSInteger dragedSeconds = floorf(a);
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.player seekToTime:dragedCMTime];
    [self.player play];
}

#pragma mark - KVO
- (void)addObserver {
    
    AVPlayerItem *songItem = self.currentItem;
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    
    AVPlayerItem *songItem = self.currentItem;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    [songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}

#pragma mark - 通过KVO监控播放器状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    AVPlayerItem *songItem = object;
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        NSLog(@"共缓冲%.2f", totalBuffer);
    }
    if ([keyPath isEqualToString:@"rate"]) {
        if (self.player.rate == 0.0) {
            _state = YXVideoPlayerManagerPaused;
        }
        else {
            _state = YXVideoPlayerManagerPlaying;
        }
    }
}

- (void)playbackFinished {
    
    NSLog(@"播放完成");
    if (_isCycle) {
        [self rerunPlay];
    }
    else {
        [self stop];
        if (self.playerFinshedBlock) {
            self.playerFinshedBlock();
        }
    }
}

#pragma mark - YXResourceLoaderDelegate
- (void)loader:(YXResourceLoader *)loader cacheProgress:(CGFloat)progress {
    
    self.cacheProgress = progress;
}

#pragma mark - Property Set
- (void)setProgress:(CGFloat)progress {
    
    [self willChangeValueForKey:@"progress"];
    _progress = progress;
    [self didChangeValueForKey:@"progress"];
}

- (void)setState:(YXVideoPlayerManagerState)state {
    
    [self willChangeValueForKey:@"progress"];
    _state = state;
    [self didChangeValueForKey:@"progress"];
}

- (void)setCacheProgress:(CGFloat)cacheProgress {
    
    [self willChangeValueForKey:@"progress"];
    _cacheProgress = cacheProgress;
    [self didChangeValueForKey:@"progress"];
}

- (void)setDuration:(CGFloat)duration {
    
    if (duration != _duration && !isnan(duration)) {
        [self willChangeValueForKey:@"duration"];
        NSLog(@"duration %f", duration);
        _duration = duration;
        [self didChangeValueForKey:@"duration"];
    }
}

#pragma mark - CacheFile
- (BOOL)currentItemCacheState {
    
    if ([self.url.absoluteString hasPrefix:@"http"]) {
        if (self.resourceLoader) {
            return self.resourceLoader.cacheFinished;
        }
        return YES;
    }
    return NO;
}

- (NSString *)currentItemCacheFilePath {
    
    if (![self currentItemCacheState]) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@", [NSString cacheFolderPath], [NSString fileNameWithURL:self.url]];;
}

+ (BOOL)clearCache {
    
    [YXFileHandle clearCache];
    return YES;
}
@end

