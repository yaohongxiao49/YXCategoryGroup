//
//  YXListCountDown.m
//  MuchProj
//
//  Created by Augus on 2021/11/19.
//

#import "YXListCountDown.h"

@interface YXListCountDown ()

@property (nonatomic, strong) NSMutableArray *timerArr;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) CGFloat passTime;
@property (nonatomic, assign) BOOL boolSec;
@property (nonatomic, assign) BOOL boolSecCell;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YXListCountDown

#pragma mark - 单例
+ (YXListCountDown *)shareManager {
    
    static YXListCountDown *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[YXListCountDown alloc] init];
    });
    
    return manager;
}

#pragma mark - 移除定时器
- (void)removeAllTimer {
    
    [self.timerArr enumerateObjectsUsingBlock:^(NSTimer *  _Nonnull timer, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
    }];
    [self.timerArr removeAllObjects];
}

#pragma mark - 创建定时器
- (void)initTimerByTableView:(UITableView *)tableView boolSec:(BOOL)boolSec boolSecCell:(BOOL)boolSecCell {
    
    _tableView = tableView;
    _boolSec = boolSec;
    _boolSecCell = boolSecCell;
    _passTime = 0.0f;
    
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)timerAction {
    
    NSArray *cells = _tableView.visibleCells;
    _passTime += 1000.f;
    
    if (_boolSec) {
        for (NSInteger i = 0; i < _tableView.numberOfSections; i ++) {
            NSInteger remainTime = [_timeArr[i] integerValue];

            if (remainTime - _passTime >= 0) {
                NSString *date = [NSString stringWithFormat:@"%d", (int)((remainTime - _passTime) / 1000 / 60 / 60) / 24];
                NSString *hour = [NSString stringWithFormat:@"%02d", (int)((remainTime - _passTime) / 1000 / 60 / 60) % 24];
                NSString *minute = [NSString stringWithFormat:@"%02d", (int)((remainTime - _passTime) / 1000 / 60) % 60];
                NSString *second = [NSString stringWithFormat:@"%02d", ((int)(remainTime - _passTime)) / 1000 % 60];
                CGFloat millisecond = ((int)((remainTime - _passTime))) % 1000 / 10;
                NSString *millisecondValue = [NSString stringWithFormat:@"%.2f", millisecond];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(yxTimeChangeByView:index:date:hour:minute:second:millisecondValue:)]) {
                    [self.delegate yxTimeChangeByView:[_tableView headerViewForSection:i] index:i date:date hour:hour minute:minute second:second millisecondValue:millisecondValue];
                }
            }
        }
    }
    else {
        for (UITableViewCell *cell in cells) {
            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
            NSInteger index = _boolSecCell ? indexPath.section : indexPath.row;
            NSInteger remainTime = [_timeArr[index] integerValue];
            
            if (remainTime - _passTime >= 0) {
                NSString *date = [NSString stringWithFormat:@"%d", (int)((remainTime - _passTime) / 1000 / 60 / 60) / 24];
                NSString *hour = [NSString stringWithFormat:@"%02d", (int)((remainTime - _passTime) / 1000 / 60 / 60) % 24];
                NSString *minute = [NSString stringWithFormat:@"%02d", (int)((remainTime - _passTime) / 1000 / 60) % 60];
                NSString *second = [NSString stringWithFormat:@"%02d", ((int)(remainTime - _passTime)) / 1000 % 60];
                CGFloat millisecond = ((int)((remainTime - _passTime))) % 1000 / 10;
                NSString *millisecondValue = [NSString stringWithFormat:@"%.2f", millisecond];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(yxTimeChangeByCell:date:hour:minute:second:millisecondValue:)]) {
                    [self.delegate yxTimeChangeByCell:cell date:date hour:hour minute:minute second:second millisecondValue:millisecondValue];
                }
            }
        }
    }
}

#pragma mark - 懒加载
- (NSTimer *)timer {
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [self.timerArr addObject:_timer];
    }
    return _timer;
}
- (NSMutableArray *)timerArr {
    
    if (!_timerArr) {
        _timerArr = [[NSMutableArray alloc] init];
    }
    return _timerArr;
}

@end
