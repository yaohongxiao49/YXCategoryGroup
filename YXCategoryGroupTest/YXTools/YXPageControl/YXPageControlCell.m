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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.imageView.hidden = NO;
}

#pragma mark - 懒加载
- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

@end
