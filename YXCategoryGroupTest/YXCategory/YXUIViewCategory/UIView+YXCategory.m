//
//  UIView+YXCategory.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/9.
//  Copyright © 2020 August. All rights reserved.
//

#import "UIView+YXCategory.h"
#import <objc/runtime.h>

static const char *YXTapGestureBlock;

@implementation UIView (YXCategory)

#pragma mark - 视图x坐标
- (CGFloat)x {
    
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

#pragma mark - 视图y坐标
- (CGFloat)y {
    
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

#pragma mark - 视图宽
- (CGFloat)width {
    
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

#pragma mark - 视图高
- (CGFloat)height {
    
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - 视图最右边坐标
- (CGFloat)right {
    
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
    
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

#pragma mark - 视图最下边坐标
- (CGFloat)bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

#pragma mark - 视图中心x坐标
- (CGFloat)centerX {
    
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX {
    
    self.center = CGPointMake(centerX, self.center.y);
}

#pragma mark - 视图中心y坐标
- (CGFloat)centerY {
    
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY {
    
    self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark - 视图坐标
- (CGPoint)origin {
    
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

#pragma mark - 视图大小
- (CGSize)size {
    
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - 获取当前视图所在的视图控制器
- (UIViewController *)viewController {
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 添加点击手势
- (void)yxAddTapGestureWithBlock:(void(^)(UIView *view))block {
    
    if (block) {
        self.tapGestureBlock = block;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGesture];
    }
}
- (void)setTapGestureBlock:(void (^)(UIView *))tapGestureBlock {
    
    objc_setAssociatedObject(self, &YXTapGestureBlock, tapGestureBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void(^)(UIView *))tapGestureBlock {
    
    return objc_getAssociatedObject(self, &YXTapGestureBlock);
}
- (void)tapAction {
    
    id block = objc_getAssociatedObject(self, &YXTapGestureBlock);
    if (block == nil) {
        return;
    }
    
    void(^tapGestureBlock)(UIView *) = block;
    tapGestureBlock(self);
}

#pragma mark - 指定圆角
+ (void)yxSpecifiedCornerFilletByView:(UIView *)view corners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

@end
