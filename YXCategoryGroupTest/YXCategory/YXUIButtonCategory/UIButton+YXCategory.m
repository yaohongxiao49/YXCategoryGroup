//
//  UIButton+YXCategory.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/9.
//  Copyright © 2020 August. All rights reserved.
//

#import "UIButton+YXCategory.h"
#import <objc/runtime.h>

@implementation UIButton (YXCategory)

static NSString *keyOfUseCategoryMethod; //用分类方法创建的button，关联对象的key
static NSString *keyOfBlock;

//因category不能添加属性，只能通过关联对象的方式。
static const char *UIControlAcceptEventInterval = "UIControl_acceptEventInterval";

static const char *UIControlAcceptEventTime = "UIControl_acceptEventTime";

#pragma mark - 通过block对button的点击事件封装
+ (UIButton *)yxCreateBtnByFrame:(CGRect)frame title:(NSString *)title nomalImgName:(NSString *)nomalImgName selectedImgName:(NSString *)selectedImgName highlightedImgName:(NSString *)highlightedImgName bgImgName:(NSString *)bgImgName action:(YXBtnTapActionBlock)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    if (highlightedImgName != nil) [button setImage:[UIImage imageNamed:highlightedImgName] forState:UIControlStateHighlighted];
    if (nomalImgName != nil) [button setImage:[UIImage imageNamed:nomalImgName] forState:UIControlStateNormal];
    if (selectedImgName != nil) [button setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
    if (bgImgName != nil) [button setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
    [button addTarget:button action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     * 用runtime中的函数通过key关联对象
     * objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
     * id object 表示关联者，是一个对象，变量名理所当然也是object
     * const void *key 获取被关联者的索引key
     * id value 被关联者，这里是一个block
     * objc_AssociationPolicy policy 关联时采用的协议，有assign，retain，copy等协议，一般使用OBJC_ASSOCIATION_RETAIN_NONATOMIC
     */
    objc_setAssociatedObject (button, &keyOfUseCategoryMethod, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return button;
}

#pragma mark - 按钮点击事件
- (void)tapAction:(UIButton *)sender {
    
    /**
     * 通过key获取被关联对象
     * objc_getAssociatedObject(id object, const void *key)
     */
    YXBtnTapActionBlock block = (YXBtnTapActionBlock)objc_getAssociatedObject (sender, &keyOfUseCategoryMethod);
    
    if (block) {
        block(sender);
    }
}

- (void)setYxBtnTapActionBlock:(YXBtnTapActionBlock)yxBtnTapActionBlock {
    
    objc_setAssociatedObject(self, &keyOfBlock, yxBtnTapActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (YXBtnTapActionBlock)yxBtnTapActionBlock {
    
    return objc_getAssociatedObject(self, &keyOfBlock);
}

#pragma mark - 设置button的titleLab和ImgView的布局样式，及间距
- (void)yxLayoutBtnWithEdgeInsetsStyle:(YXBtnEdgeInsetsStyle)style imgTitleSpace:(CGFloat)imgTitleSpace {
    
    CGFloat imgWith = self.imageView.frame.size.width;
    CGFloat imgHeight = self.imageView.frame.size.height;
    
    CGFloat labWidth = 0.0;
    CGFloat labHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) { //由于iOS8中titlelab的size为0，用下面的这种设置
        labWidth = self.titleLabel.intrinsicContentSize.width;
        labHeight = self.titleLabel.intrinsicContentSize.height;
    }
    else {
        labWidth = self.titleLabel.frame.size.width;
        labHeight = self.titleLabel.frame.size.height;
    }
    
    UIEdgeInsets imgEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labEdgeInsets = UIEdgeInsetsZero;
    
    switch (style) {
        case YXBtnEdgeInsetsStyleTop: {
            imgEdgeInsets = UIEdgeInsetsMake(-labHeight - imgTitleSpace /2.0, 0, 0, -labWidth);
            labEdgeInsets = UIEdgeInsetsMake(0, -imgWith, -imgHeight - imgTitleSpace /2.0, 0);
        }
            break;
        case YXBtnEdgeInsetsStyleLeft: {
            imgEdgeInsets = UIEdgeInsetsMake(0, -imgTitleSpace /2.0, 0, imgTitleSpace /2.0);
            labEdgeInsets = UIEdgeInsetsMake(0, imgTitleSpace /2.0, 0, -imgTitleSpace /2.0);
        }
            break;
        case YXBtnEdgeInsetsStyleBottom: {
            imgEdgeInsets = UIEdgeInsetsMake(0, 0, -labHeight - imgTitleSpace /2.0, -labWidth);
            labEdgeInsets = UIEdgeInsetsMake(-imgHeight - imgTitleSpace /2.0, -imgWith, 0, 0);
        }
            break;
        case YXBtnEdgeInsetsStyleRight: {
            imgEdgeInsets = UIEdgeInsetsMake(0, labWidth + imgTitleSpace /2.0, 0, -labWidth - imgTitleSpace /2.0);
            labEdgeInsets = UIEdgeInsetsMake(0, -imgWith - imgTitleSpace /2.0, 0, imgWith + imgTitleSpace /2.0);
        }
            break;
        default:
            break;
    }
    
    self.titleEdgeInsets = labEdgeInsets;
    self.imageEdgeInsets = imgEdgeInsets;
}

#pragma mark - 倒计时
- (void)yxBtnCountdownByTimeAmount:(NSInteger)timeAmount title:(NSString *)title beforeSubTitle:(NSString *)beforeSubTitle countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color isCerificationCode:(BOOL)isCerificationCode startWithTimeIsEndBlock:(YXStartWithTimeIsEndBlock)startWithTimeIsEndBlock {
    
    __weak typeof(self) weakSelf = self;
    //倒计时时间
    __block NSInteger timeOut = timeAmount;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.backgroundColor = mColor;
                [weakSelf setTitle:title forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = YES;
                if (startWithTimeIsEndBlock) {
                    startWithTimeIsEndBlock(@"完");
                }
            });
        }
        else {
            int allTime = (int)timeAmount + 1;
            int seconds = timeOut %allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.backgroundColor = color;
                if (beforeSubTitle != nil) {
                    [weakSelf setTitle:[NSString stringWithFormat:@"%@%@%@", beforeSubTitle, timeStr, subTitle] forState:UIControlStateNormal];
                }
                else {
                    [weakSelf setTitle:[NSString stringWithFormat:@"%@%@", timeStr, subTitle] forState:UIControlStateNormal];
                }
                weakSelf.userInteractionEnabled =! isCerificationCode;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 使用runtime 防止按钮被重复点击
- (NSTimeInterval)repeatClickEventInterval {
    
    return  [objc_getAssociatedObject(self, UIControlAcceptEventInterval) doubleValue];
}
- (void)setRepeatClickEventInterval:(NSTimeInterval)repeatClickEventInterval {
    
    objc_setAssociatedObject(self, UIControlAcceptEventInterval, @(repeatClickEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)acceptEventTime {
    
    return  [objc_getAssociatedObject(self, UIControlAcceptEventTime) doubleValue];
}
- (void)setAcceptEventTime:(NSTimeInterval)acceptEventTime {
    
    objc_setAssociatedObject(self, UIControlAcceptEventTime, @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 在load时执行hook
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        //分别获取
        SEL beforeSelector = @selector(sendAction:to:forEvent:);
        SEL afterSelector = @selector(cs_sendAction:to:forEvent:);
        
        Method beforeMethod = class_getInstanceMethod(class, beforeSelector);
        Method afterMethod = class_getInstanceMethod(class, afterSelector);
        //先尝试给原来的方法添加实现，如果原来的方法不存在就可以添加成功。返回为YES，否则
        //返回为NO。
        //UIButton 真的没有sendAction方法的实现，这是继承了UIControl的而已，UIControl才真正的实现了。
        BOOL didAddMethod = class_addMethod(class, beforeSelector, method_getImplementation(afterMethod), method_getTypeEncoding(afterMethod));
        if (didAddMethod) {
            //如果之前不存在，但是添加成功了，此时添加成功的是cs_sendAction方法的实现
            //这里只需要方法替换
            class_replaceMethod(class, afterSelector, method_getImplementation(beforeMethod), method_getTypeEncoding(beforeMethod));
        }
        else {
            //本来如果存在就进行交换
            method_exchangeImplementations(afterMethod, beforeMethod);
        }
    });
}

- (void)cs_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if ([NSDate date].timeIntervalSince1970 - self.acceptEventTime < self.repeatClickEventInterval) {
        return;
    }

    if (self.repeatClickEventInterval > 0) {
        self.acceptEventTime = [NSDate date].timeIntervalSince1970;
    }

    [self cs_sendAction:action to:target forEvent:event];
}

@end
