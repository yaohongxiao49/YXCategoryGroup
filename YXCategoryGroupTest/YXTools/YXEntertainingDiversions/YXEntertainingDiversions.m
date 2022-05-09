//
//  YXEntertainingDiversions.m
//  RuLiMeiRong
//
//  Created by ios on 2019/12/9.
//  Copyright © 2019 成都美哆网络科技有限公司. All rights reserved.
//

#import "YXEntertainingDiversions.h"

#define kDefaultScrollDuration 10 //动画时间
#define kDefaultSrollVelocity 20 //默认滚动速度
#define kDefaultPauseTime 3.0 //间隔时间
#define kDefaultPadding 20.0 //间隔距离
#define kDefaultDelay 1.0 //延迟

@interface YXEntertainingDiversions ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelCopy;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL manualStop;

@end

@implementation YXEntertainingDiversions

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollLab];
    }
    return self;
}

- (void)initScrollLab {
    
    self.layer.masksToBounds = YES;
    self.label = [self customLabel];
    self.labelCopy = [self customLabel];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.labelCopy];
    [self addSubview:self.contentView];
    
    _scrollDuration = kDefaultScrollDuration;
    _scrollVelocity = kDefaultSrollVelocity;
    _pauseInterval = kDefaultPauseTime;
    _delayInterval = kDefaultDelay;
    _paddingBetweenLabels = kDefaultPadding;
    _autoBeginScroll = YES;
    _manualStop = NO;
    _labelAlignment = YXScrollLabelAlignmentCenter;
    self.userInteractionEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldAutoScollLabel) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 懒加载
- (UIView *)contentView {
    
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}
- (UILabel *)customLabel {
    
    UILabel *commenLabel = [[UILabel alloc] init];
    commenLabel.backgroundColor = [UIColor clearColor];
    [commenLabel sizeToFit];
    return commenLabel;
}

#pragma mark - setter
- (void)setText:(NSString *)text {
    
    _text = text;
    self.label.text = text;
    self.labelCopy.text = text;
    [self stopScrollAnimation];
    [self setLabelsFrame];
}
- (void)setTextColor:(UIColor *)textColor {
    
    _textColor = textColor;
    self.label.textColor = textColor;
    self.labelCopy.textColor = textColor;
}
- (void)setFont:(UIFont *)font {
    
    _font = font;
    self.label.font = font;
    self.labelCopy.font = font;
}
- (void)setScrollVelocity:(CGFloat)scrollVelocity {
    
    if (scrollVelocity <= 0) {
        scrollVelocity = kDefaultSrollVelocity;
    }
    _scrollVelocity = scrollVelocity;
}
- (void)setLabelAlignment:(YXScrollLabelAlignment)labelAlignment {
    
    _labelAlignment = labelAlignment;
    [self setLabelsFrame];
}
- (void)setType:(YXEntertainingDiversionsType)type {
    
    _type = type;
    UIFont *titleFont = _type == YXEntertainingDiversionsTypeNav ? [UIFont systemFontOfSize:14] : [UIFont systemFontOfSize:15];
    UIColor *titleColor = _type == YXEntertainingDiversionsTypeNav ? [UIColor yxColorByHexString:@"#EEEEEE"] : [UIColor yxColorByHexString:@"#000000"];
    self.label.font = titleFont;
    self.labelCopy.font = titleFont;
    self.label.textColor = titleColor;
    self.labelCopy.textColor = titleColor;
    
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    if (_type == YXEntertainingDiversionsTypeNav) {
//        layer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor];
//        layer.locations = @[@(0.0f), @(0.3f), @(0.7f), @(1.0)]; //设置颜色的范围
//        layer.startPoint = CGPointMake(0, 0); //设置颜色渐变的起点
//        layer.endPoint = CGPointMake(1, 0); //设置颜色渐变的终点，与 startPoint 形成一个颜色渐变方向
        layer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor];
        layer.locations = @[@0, @0.4]; //设置颜色的范围
        layer.startPoint = CGPointMake(1, 0); //设置颜色渐变的起点
        layer.endPoint = CGPointMake(0.5, 0); //设置颜色渐变的终点，与 startPoint 形成一个颜色渐变方向
    }
    else {
        layer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor];
        layer.locations = @[@0, @0.4]; //设置颜色的范围
        layer.startPoint = CGPointMake(1, 0); //设置颜色渐变的起点
        layer.endPoint = CGPointMake(0.5, 0); //设置颜色渐变的终点，与 startPoint 形成一个颜色渐变方向
    }
    layer.frame = self.bounds;
    self.layer.mask = layer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.mask.frame = self.bounds;
}

#pragma mark - Private
#pragma mark - 设置UILabel的Frame
- (void)setLabelsFrame {
    
    [self.label sizeToFit];
    [self.labelCopy sizeToFit];
    
    //label
    CGPoint center = CGPointMake(self.label.center.x, self.center.y - self.frame.origin.y);
    self.label.center = center;
    if (self.label.frame.size.width > self.frame.size.width) {
        CGRect labelFrame = self.label.frame;
        labelFrame.origin.x = 0;
        self.label.frame = labelFrame;
    }
    
    //labelCopy
    CGPoint copyCenter = CGPointMake(self.labelCopy.center.x, self.center.y - self.frame.origin.y);
    self.labelCopy.center = copyCenter;
    CGRect frame = self.labelCopy.frame;
    frame.origin.x = CGRectGetMaxX(self.label.frame) + _paddingBetweenLabels;
    self.labelCopy.frame = frame;
    
    CGSize size;
    if (self.label.frame.size.width > self.frame.size.width) {
        size.width = CGRectGetWidth(self.label.frame) + CGRectGetWidth(self.frame) + _paddingBetweenLabels;
    }
    else {
        size.width = CGRectGetWidth(self.frame);
    }
    size.height = self.frame.size.height;
    self.contentView.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (self.label.frame.size.width > self.frame.size.width) {
        self.scrollDuration = self.label.frame.size.width /self.scrollVelocity;
        self.label.hidden = NO;
        self.labelCopy.hidden = NO;
        if (self.autoBeginScroll) {
            [self startScrollAnimation];
        }
    }
    else {
        self.scrolling = NO;
        self.labelCopy.hidden = YES;
        CGPoint center = self.label.center;
        if (self.labelAlignment == YXScrollLabelAlignmentLeft) {
            center.x = self.label.frame.size.width /2.0;
        }
        else if (self.labelAlignment == YXScrollLabelAlignmentCenter) {
            center.x = self.center.x - self.frame.origin.x;
        }
        else {
            center.x = self.frame.size.width - self.label.frame.size.width /2.0;
        }
        self.label.center = center;
    }
}

- (void)shouldAutoScollLabel {
    
    if (self.scrolling) {
        return;
    }
    self.scrolling = YES;
    
    CGSize size;
    size.height = self.frame.size.height;
    if (self.label.frame.size.width > self.frame.size.width) {
        size.width = CGRectGetWidth(self.label.frame) + CGRectGetWidth(self.frame) + _paddingBetweenLabels;
    }
    else {
        size.width = CGRectGetWidth(self.frame);
    }
    self.contentView.frame = CGRectMake(0, 0, size.width, size.height);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.scrollDuration animations:^{
        
        if (weakSelf.label.frame.size.width > weakSelf.frame.size.width) {
            weakSelf.contentView.frame = CGRectMake(-(weakSelf.label.frame.size.width + weakSelf.paddingBetweenLabels), 0, size.width, size.height);
        }
        else {
            weakSelf.contentView.frame = CGRectMake(0, 0, size.width, size.height);
        }
    } completion:^(BOOL finished) {
       
        [weakSelf endAnimationg];
    }];
}

- (void)endAnimationg {
    
    self.scrolling = NO;
    if (self.label.frame.size.width > self.frame.size.width) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.pauseInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (weakSelf && !weakSelf.manualStop) {
                [weakSelf shouldAutoScollLabel];
            }
        });
    }
    else {
        [self setLabelsFrame];
    }
}

- (void)startScrollAnimation {
    
    self.manualStop = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (weakSelf) {
            [weakSelf shouldAutoScollLabel];
        }
    });
}

- (void)stopScrollAnimation {
    
    [self.contentView.layer removeAllAnimations];
    self.scrolling = NO;
    self.manualStop = YES;
}

@end
