//
//  YXTextFiled.m
//  MuchProj
//
//  Created by Augus on 2021/12/15.
//

#import "YXTextFiled.h"

@implementation YXTextFiled

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10; //向右边偏10
    return iconRect;
}

#pragma mark - UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 35, 0);
    
}

#pragma mark - 控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 35, 0);
}

@end
