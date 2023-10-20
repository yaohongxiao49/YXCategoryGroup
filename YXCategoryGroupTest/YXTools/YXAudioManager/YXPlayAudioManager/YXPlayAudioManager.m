//
//  YXPlayAudioManager.m
//  MuchProj
//
//  Created by Augus on 2023/9/14.
//

#import "YXPlayAudioManager.h"

@implementation YXPlayAudioManager

+ (YXPlayAudioManager *)shareIncetance {
    
    static YXPlayAudioManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXPlayAudioManager alloc] init];
    });
    return manager;
}

#pragma mark - 计时器回调
- (void)updateProgress {
    
    _audioTimeValue ++;

    NSString *numValue = [NSString stringWithFormat:@"%.f", self.audioPlayer.duration * 100];
    if (_audioTimeValue == numValue.floatValue) {
        _audioTimeValue = 0;
        if (self.yxPlayAudioManagerPlayTimeEndBlock) {
            [self stopPlay];
            self.yxPlayAudioManagerPlayTimeEndBlock(NO);
        }
    }
    else {
        if (self.yxPlayAudioManagerPlayTimeEndBlock) {
            self.yxPlayAudioManagerPlayTimeEndBlock(YES);
        }
        if (self.yxPlayAudioManagerPlayTimeBlock) {
            self.yxPlayAudioManagerPlayTimeBlock(self.audioPlayer.duration, _audioTimeValue/100, _audioTimeValue);
        }
    }
}

#pragma mark - 开始播放
- (void)startPlay {
    
    self.audioPlayer = [self audioPlayer];
    [self.audioPlayer play];
    
    _audioTimeValue = 0;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      
        weakSelf.audioTimer.fireDate = [NSDate distantPast];
    });
}

#pragma mark - 暂停播放
- (void)pausePlay {
    
    [self.audioPlayer pause];
    self.audioTimer.fireDate = [NSDate distantFuture];
}

#pragma mark - 停止播放
- (void)stopPlay {
    
    [_audioPlayer stop];
    _audioPlayer = nil;
    [_audioTimer invalidate];
    _audioTimer = nil;
    
    if (self.yxPlayAudioManagerPlayTimeEndBlock) {
        self.yxPlayAudioManagerPlayTimeEndBlock(NO);
    }
}

#pragma mark - <AVAudioPlayerDelegate>
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
}

#pragma mark - setting
- (void)setUrl:(NSURL *)url {
    
    _url = url;
}

#pragma mark - 懒加载
- (AVAudioPlayer *)audioPlayer {
    
    if (!_audioPlayer) {
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_url error:&error];
        if (_audioPlayer == nil) {
            NSData *audioData = [NSData dataWithContentsOfURL:_url];
            _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        }
        //代理
        _audioPlayer.delegate = self;
        //范围为0到1
        _audioPlayer.volume = 0.5;
        //设置循环次数，如果为负数，就是无限循环
        _audioPlayer.numberOfLoops = -1;
        //设置播放进度
        _audioPlayer.currentTime = 0;
        //准备播放
        [_audioPlayer prepareToPlay];
        
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@", error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}
- (NSTimer *)audioTimer {
    
    if (!_audioTimer) {
        _audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_audioTimer forMode:NSRunLoopCommonModes];
    }
    return _audioTimer;
}

@end
