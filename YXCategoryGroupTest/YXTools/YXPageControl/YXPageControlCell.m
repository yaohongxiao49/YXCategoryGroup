//
//  YXPageControlCell.m
//  MuchProj
//
//  Created by Ausus on 2021/11/10.
//

#import "YXPageControlCell.h"

@implementation YXPageControlCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
}

@end
