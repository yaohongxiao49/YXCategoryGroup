//
//  YXRecordManager.m
//  MuchProj
//
//  Created by Augus on 2023/9/14.
//

#import "YXRecordManager.h"

/** 文件路径 */
#define kLibraryDirectoryPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
#define kUserID @""

@implementation YXRecordManager

#pragma mark - 单例
+ (YXRecordManager *)shareIncetance {

    static YXRecordManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXRecordManager alloc] init];
    });
    return manager;
}

#pragma mark - 开始录音
- (void)startRecording {

    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];
        self.recordTimer.fireDate = [NSDate distantPast];
    }
}

#pragma mark - 暂停录音
- (void)pauseRecording {

    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.recordTimer.fireDate = [NSDate distantFuture];
    }
}

#pragma mark - 恢复录音
- (void)resumeRecording {

    [self startRecording];
}

#pragma mark - 停止录音
- (void)stopRecording {
    
    [self.audioRecorder stop];
    //[self.audioRecorder deleteRecording];// 删除录音
    self.recordTimer.fireDate = [NSDate distantFuture];
    self.audioPower.progress = 0.0;
}

#pragma mark - 删除录音
- (void)deleteRecording {

    [self.audioRecorder deleteRecording];
}

#pragma mark - 更新音量采集
- (void)audioPowerChange {
    
    //NSLog(@"self.audioRecorder.recording == %@", @(self.audioRecorder.recording));
    [self.audioRecorder updateMeters]; //更新测量值
    float power = [self.audioRecorder averagePowerForChannel:0]; //取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress = (1.0 /160.0) *(power + 160.0);
    [self.audioPower setProgress:progress];
    
    double lowPassResults = pow(10, (0.05 *[self.audioRecorder peakPowerForChannel:0]));
    float result = 10 *(float)lowPassResults;
    int nowPower = 0;
    if (result > 0 && result <= 1.3) {
        nowPower = 1;
    }
    else if (result > 1.3 && result <= 2) {
        nowPower = 2;
    }
    else if (result > 2 && result <= 3.0) {
        nowPower = 3;
    }
    else if (result > 3.0 && result <= 5.0) {
        nowPower = 4;
    }
    else if (result > 5.0 && result <= 10) {
        nowPower = 5;
    }
    else if (result > 10 && result <= 40) {
        nowPower = 6;
    }
    else if (result > 40) {
        nowPower = 7;
    }
    
    if (self.yxRecordManagerAudioPowerChangeBlock) {
        self.yxRecordManagerAudioPowerChangeBlock((NSInteger)nowPower);
    }
}

#pragma mark - 获取储存地址
- (NSURL *)getSavePath {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/", [self getCacheSavePath]];
    urlStr = [urlStr stringByAppendingPathComponent:_pathString.yxHasValue ? _pathString : @"MyRecordAudio.aac"];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    return url;
}
- (NSString *)getCacheSavePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@/%@", kLibraryDirectoryPath, @"circleCache", kUserID];
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dirPath;
}

#pragma mark - 播放声音
- (void)playRecording {

    [[YXPlayAudioManager shareIncetance] setUrl:[self getSavePath]];
}

#pragma mark - 播放声音
- (void)playRecordingWithPath:(NSString *)path {
    
    NSURL *url = [NSURL URLWithString:path.yxHasValue ? path : @"MyRecordAudio.aac"];
    
    [[YXPlayAudioManager shareIncetance] stopPlay];
    [[YXPlayAudioManager shareIncetance] setUrl:url];
    [[YXPlayAudioManager shareIncetance] startPlay];
    [[[YXPlayAudioManager shareIncetance] audioPlayer] setNumberOfLoops:0];
}

#pragma mark - <AVAudioRecorderDelegate>
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    //录音完成，flag是否成功
    //[self.audioRecorder stop];
}

#pragma mark - setting
- (void)setAudioSession {
    
   self.audioSession = [self audioSession];
}
- (void)setPathString:(NSString *)pathString {
    
    _pathString = pathString;
    
    //创建录音文件保存路径
    NSURL *url = [self getSavePath];
    //创建录音格式设置
    NSDictionary *setting = [self getAudioSetting];
    //创建录音机
    NSError *error = nil;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
    
    _audioRecorder.delegate = self;
    _audioRecorder.meteringEnabled = YES; //如果要监控声波则必须设置为YES
    [_audioRecorder prepareToRecord];
    if (error) {
        NSLog(@"创建录音机对象时发生错误，错误信息：%@", error.localizedDescription);
    }
}

#pragma mark - 懒加载
- (AVAudioSession *)audioSession {
    
    if (!_audioSession) {
        NSError *error = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //设置为播放和录音状态，以便可以在录制完之后播放录音
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
        [audioSession setActive:YES error:&error];
        
//        //在我们的音视频场景配置，指定其他声音被强制变小
//        AVAudioSession *ses = [AVAudioSession sharedInstance];
//        [ses setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
//
//        //当我们的场景结束时，为了不影响其他场景播放声音变小；
//        AVAudioSession *ses = [AVAudioSession sharedInstance];
//        [ses setActive:NO error:nil];
//        [ses setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
//        [ses setActive:YES error:nil];
        
        if (error) {
            return nil;
        }
    }
    return _audioSession;
}
- (NSTimer *)recordTimer {
    
    if (!_recordTimer) {
        _recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _recordTimer;
}
- (NSDictionary *)getAudioSetting {

    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    //录音格式
    [dicM setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //录音采样率(Hz)如:AVSampleRateKey==8000/44100/96000(影响音频的质量)
    [dicM setValue:[NSNumber numberWithFloat:16000] forKey:AVSampleRateKey];
    //录音通道数 1 或 2
    [dicM setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数 8、16、24、32
    [dicM setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //在内存中音频的存储模式:大端模式还是小端模式
    [dicM setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    //采样信号是整数还是浮点数
    [dicM setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    //录音的质量
    [dicM setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];

    return dicM;
}

@end
