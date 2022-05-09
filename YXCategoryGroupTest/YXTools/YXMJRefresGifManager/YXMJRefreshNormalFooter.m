//
//  YXMJRefreshNormalFooter.m
//  MuchProj
//
//  Created by Augus on 2022/3/7.
//

#import "YXMJRefreshNormalFooter.h"

@implementation YXMJRefreshNormalFooter

#pragma mark - 实现父类的方法
- (void)placeSubviews {
    [super placeSubviews];
    
}

#pragma mark - 实现父类的方法
- (void)prepare {
    [super prepare];
    
    [self setTitle:@"到底啦" forState:MJRefreshStateNoMoreData];
}

@end
