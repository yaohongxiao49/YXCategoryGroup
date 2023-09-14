//
//  YXPlayAudioManager.h
//  MuchProj
//
//  Created by Augus on 2023/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXPlayAudioManager : NSObject<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSTimer *audioTimer;
@property (nonatomic, assign) CGFloat audioTimeValue;
@property (nonatomic, assign) BOOL isPause;

@property (nonatomic, copy) void (^yxPlayAudioManagerPlayTimeBlock) (CGFloat numValue, CGFloat currentValue, CGFloat progressValue);
@property (nonatomic, copy) void (^yxPlayAudioManagerPlayTimeEndBlock) (BOOL endVoice);

/** 单例 */
+ (YXPlayAudioManager *)shareIncetance;

/** 开始播放 */
- (void)startPlay;
/** 暂停播放 */
- (void)pausePlay;
/** 停止播放 */
- (void)stopPlay;

@end

NS_ASSUME_NONNULL_END
