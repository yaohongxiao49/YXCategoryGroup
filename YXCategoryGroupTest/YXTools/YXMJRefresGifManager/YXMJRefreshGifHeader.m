//
//  YXMJRefreshGifHeader.m
//  MuchProj
//
//  Created by Augus on 2022/1/10.
//

#import "YXMJRefreshGifHeader.h"

@implementation YXMJRefreshGifHeader

#pragma mark - 实现父类的方法
- (void)placeSubviews {
    [super placeSubviews];
    
    //隐藏状态显示文字
    self.stateLabel.hidden = YES;
    //隐藏更新时间文字
    self.lastUpdatedTimeLabel.hidden = YES;
}

#pragma mark - 实现父类的方法
- (void)prepare {
    [super prepare];
    
    //GIF数据
    NSArray *idleImages = [self getRefreshingImageArrayWithStartIndex:1 endIndex:1];
    NSArray *refreshingImages = [self getRefreshingImageArrayWithStartIndex:3 endIndex:32];
    //普通状态
    [self setImages:idleImages forState:MJRefreshStateIdle];
    //即将刷新状态
    [self setImages:idleImages forState:MJRefreshStatePulling];
    //正在刷新状态
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    SEL originalSelector = @selector(endRefreshing);
    SEL swizzledSelector = @selector(swiz_endRefreshing);
    [YXCategoryBaseManager swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
}

#pragma mark - 获取资源图片
- (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"YXMJRefreshBundle0%@", @(i)]];
        if (img) {
            [imgArr addObject:img];
        }
    }
    return imgArr;
}

- (void)swiz_endRefreshing {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        MJRefreshDispatchAsyncOnMainQueue(self.state = MJRefreshStateIdle;)
    });
}

@end
