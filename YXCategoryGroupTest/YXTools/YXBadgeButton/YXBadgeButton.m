//
//  YXBadgeButton.m
//  RuLiMeiRong
//
//  Created by ios on 2019/8/8.
//  Copyright © 2019 成都美哆网络科技有限公司. All rights reserved.
//

#import "YXBadgeButton.h"

@interface YXBadgeButton ()

@end

@implementation YXBadgeButton

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.badgeLab = [[UILabel alloc] init];
        self.badgeLab.backgroundColor = [UIColor redColor];
        self.badgeLab.font = [UIFont boldSystemFontOfSize:10];
        self.badgeLab.textColor = [UIColor greenColor];
        self.badgeLab.clipsToBounds = YES;
        self.badgeLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.badgeLab];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self setSubFrame];
}

- (void)setIsRedBall:(BOOL)isRedBall {
    
    _isRedBall = isRedBall;
    [self setSubFrame];
}

- (void)setBoolBadgeTop:(BOOL)boolBadgeTop {
    
    _boolBadgeTop = boolBadgeTop;
}

- (void)setSubFrame {
    
    CGFloat badgeH = 0.0;
    CGFloat badgeW = 0.0;
    
    [self showText];
    if (_isRedBall) {
        badgeH = 8;
        badgeW = 8;
    }
    else {
        badgeH = 15;
        badgeW = [self.badgeLab sizeThatFits:CGSizeMake(MAXFLOAT, badgeH)].width + 5;
        if (badgeW > 40) {
            badgeW = 40;
        }
        if (badgeW < badgeH) {
            badgeW = badgeH;
        }
    }
    self.badgeLab.frame = CGRectMake(0, 0, badgeW, badgeH);
    self.badgeLab.layer.cornerRadius = badgeH /2;
    
    if (self.boolBadgeTop) {
        if (self.imageView.image) {
            CGPoint center = CGPointMake(CGRectGetMaxX(self.imageView.frame) - self.badgeLab.width /3, self.imageView.frame.origin.y + self.badgeLab.height /3);
            self.badgeLab.center = center;
        }
        else {
            CGPoint center = CGPointMake(self.bounds.size.width - self.badgeLab.width /3, self.bounds.origin.y + self.badgeLab.height /3);
            self.badgeLab.center = center;
        }
    }
    else {
        if (self.imageView.image) {
            CGPoint center = CGPointMake(CGRectGetMaxX(self.imageView.frame), self.imageView.frame.origin.y);
            self.badgeLab.center = center;
        }
        else {
            CGPoint center = CGPointMake(self.bounds.size.width, self.bounds.origin.y);
            self.badgeLab.center = center;
        }
    }
}

- (void)setBadgeValue:(NSInteger)badgeValue {
    
    _badgeValue = badgeValue;
    [self setSubFrame];
}

- (void)showText {
    
    if (_badgeValue <= 0) {
        self.badgeLab.hidden = YES;
    }
    else {
        self.badgeLab.hidden = NO;
    }
    
    if (_isRedBall) {
        self.badgeLab.hidden = NO;
        self.badgeLab.text = @"";
    }
    else {
        if (_badgeValue > 99) {
            self.badgeLab.text = @"99+";
        }
        else {
            self.badgeLab.text = [NSString stringWithFormat:@"%ld", (long)_badgeValue];
        }
    }
}

@end
