//
//  YXCardShowImgV.m
//  MuchProj
//
//  Created by Augus on 2023/3/17.
//

#import "YXCardShowImgV.h"

@interface YXCardShowImgV ()

@property (nonatomic, strong) UIImageView *imgV;

@end

@implementation YXCardShowImgV

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - setting
- (void)setModel:(BannerJumpModel *)model {
    
    _model = model;
    
    [self.imgV st_setImageWithURLString:_model.advertisementImgUrl];
}

#pragma mark - 初始化视图
- (void)initView {
    
    
}

#pragma mark - 懒加载
- (UIImageView *)imgV {
    
    if (!_imgV) {
        _imgV = [[UIImageView alloc] init];
        _imgV.layer.cornerRadius = 8;
        _imgV.layer.masksToBounds = YES;
        [self addSubview:_imgV];
        
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self);
        }];
    }
    return _imgV;
}

@end
