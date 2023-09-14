//
//  YXRecordManager.h
//  MuchProj
//
//  Created by Augus on 2023/9/14.
//

#import <Foundation/Foundation.h>
#import "YXPlayAudioManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXRecordManager : NSObject<AVAudioRecorderDelegate>

/** 音频录音机 */
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
/** 录音声波监控 */
@property (nonatomic, strong) NSTimer *recordTimer;
/** 音频波动 */
@property (nonatomic, strong) UIProgressView *audioPower;
/** 扬声器 */
@property (nonatomic, strong) AVAudioSession *audioSession;
/** 存储地址 */
@property (nonatomic, strong) NSString *pathString;

/** 音频强度更改回调 */
@property (nonatomic, copy) void(^yxRecordManagerAudioPowerChangeBlock)(NSInteger power);

/** 单例 */
+ (YXRecordManager *)shareIncetance;

/** 开始录音 */
- (void)startRecording;
/** 暂停录音 */
- (void)pauseRecording;
/** 恢复继续录音 */
- (void)resumeRecording;
/** 停止录音 */
- (void)stopRecording;
/** 播放录音 */
- (void)playRecording;
/** 播放录音 */
- (void)playRecordingWithPath:(NSString *)path;
/** 删除录音 */
- (void)deleteRecording;
    
#pragma mark - 私有方法
/** 设置音频会话 */
- (void)setAudioSession;

/**
 * 取得录音文件保存路径
 * @return 录音文件路径
 */
- (NSURL *)getSavePath;

/**
 * 取得录音文件设置
 * @return 录音设置
 */
- (NSDictionary *)getAudioSetting;

/** 录音声波状态设置 */
- (void)audioPowerChange;

@end

NS_ASSUME_NONNULL_END
