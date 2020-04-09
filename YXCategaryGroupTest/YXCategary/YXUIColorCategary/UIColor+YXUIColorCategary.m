//
//  UIColor+YXUIColorCategary.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "UIColor+YXUIColorCategary.h"

@implementation UIColor (YXUIColorCategary)

#pragma mark - 绘制渐变色
+ (CAGradientLayer *)yxDrawGradient:(UIView *)view colorArr:(NSArray *)colorArr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray *)locations {
    
    //CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = colorArr;//@[(__bridge id)fromColor.CGColor, (__bridge id)toColor.CGColor];
    
    //设置渐变颜色方向，左上点为(0, 0), 右下点为(1, 1)
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    
    //设置颜色变化点（分割点），取值范围 0.0 ~ 1.0
    gradientLayer.locations = @[@0, @1];
    
    return gradientLayer;
}

@end
