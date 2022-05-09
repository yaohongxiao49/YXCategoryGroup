//
//  YXBadgeShowButton.m
//  MuchProj
//
//  Created by Augus on 2022/1/10.
//

#import "YXBadgeShowButton.h"

@interface YXBadgeShowButton ()


@end

@implementation YXBadgeShowButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    return self;
}

- (YXBadgeButton *)badgeBtn {
    
    if (!_badgeBtn) {
        _badgeBtn = [[YXBadgeButton alloc] init];
        _badgeBtn.userInteractionEnabled = NO;
        _badgeBtn.boolBadgeTop = NO;
        _badgeBtn.isRedBall = YES;
        [self addSubview:_badgeBtn];
        
        [_badgeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(self.imageView).with.offset(2);
            make.top.equalTo(self.imageView).with.offset(-2);
            make.height.and.width.mas_equalTo(5);
        }];
    }
    return _badgeBtn;
}

@end
