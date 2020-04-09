//
//  UIColor+YXCategary.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "UIColor+YXCategary.h"

@implementation UIColor (YXCategary)

#pragma mark - 视图渐变色
+ (CAGradientLayer *)yxDrawGradient:(UIView *)view colorArr:(NSArray *)colorArr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray *)locations {
    
    //CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    gradientLayer.colors = colorArr;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.locations = locations;
    
    return gradientLayer;
}

#pragma mark - 文字渐变色（基于视图的，如label）
+ (void)yxTextGradientByView:(UIView *)view bgView:(UIView *)bgView colorArr:(NSArray *)colorArr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.frame;
    gradientLayer.colors = colorArr;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    [bgView.layer addSublayer:gradientLayer];
    gradientLayer.mask = view.layer;
    view.frame = gradientLayer.bounds;
}

#pragma mark - 文字渐变色（基于控件的，如button）
+ (void)yxTextGradientByControl:(UIControl *)control bgView:(UIView *)bgView colorArr:(NSArray *)colorArr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = control.frame;
    gradientLayer.colors = colorArr;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    [bgView.layer addSublayer:gradientLayer];
    gradientLayer.mask = control.layer;
    control.frame = gradientLayer.bounds;
}

#pragma mark - 视图阴影
+ (void)yxDrawShadowColorByView:(UIView *)view shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius cornerRadius:(CGFloat)cornerRadius {
    
    view.layer.shadowColor = shadowColor.CGColor;
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = NO; //必须为NO
}

#pragma mark - 文字阴影
+ (void)addTextShadow:(UILabel *)lab shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowBlurRadius:(CGFloat)shadowBlurRadius {
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = shadowColor;
    shadow.shadowOffset = shadowOffset;
    shadow.shadowBlurRadius = shadowBlurRadius;
    
    NSAttributedString *butedStrin = [[NSAttributedString alloc] initWithString:lab.text attributes:@{NSShadowAttributeName:shadow}];
    
    lab.attributedText = butedStrin;
}

@end
