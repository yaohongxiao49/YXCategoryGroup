//
//  YXBaseManager.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXBaseManager.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

@implementation YXBaseManager

+ (YXBaseManager *)instanceManager {
    
    static YXBaseManager *yxBaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        yxBaseManager = [YXBaseManager new];
    });
    
    return yxBaseManager;
}

#pragma mark - 钩子方法
+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
    Class class = cls;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - 打电话
+ (void)yxCallMobile:(NSString *)mobile {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", mobile]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:nil];
    }
}

#pragma mark - 发短信
- (void)yxSendSMSByMobile:(NSString *)mobile {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", mobile]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:nil];
    }
}

#pragma mark - 打开app设置页面
- (void)yxOpenAppSetting {
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:nil];
    }
}

#pragma mark - 打开safari
- (void)yxOpenSafariByUrl:(NSString *)url {
    
    NSURL *urls = [NSURL URLWithString:url];
    if ([[UIApplication sharedApplication] canOpenURL:urls]) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
        [[UIApplication sharedApplication] openURL:urls options:options completionHandler:nil];
    }
}

#pragma mark - 打开app商店
- (void)yxOpenAppStoreByIdent:(NSString *)ident boolDetail:(BOOL)boolDetail {
    
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@", ident];
    if (boolDetail) str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa /wa/viewContentsUserReviews?type=Purple+Software&id=%@", ident];
    
    NSURL *urls = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:urls]) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
        [[UIApplication sharedApplication] openURL:urls options:options completionHandler:nil];
    }
}

#pragma mark - 获取录音时长
- (NSString *)yxGetVoiceTime:(NSString *)path {
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:opts];
    CMTime audioDuration = urlAsset.duration;
    int audioDurationSeconds = ceil(audioDuration.value /audioDuration.timescale);
    return [NSString stringWithFormat:@"%@″", @(audioDurationSeconds)];
}

#pragma mark - 判断当前设备是否开启相机功能
- (void)yxJudgeAVCaptureDevice:(UIViewController *)vc resultBlock:(void(^)(BOOL boolSuccess))resultBlock {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        if (resultBlock) {
                            resultBlock(YES);
                        }
                    });
                }
            }];
        }
        else if (status == AVAuthorizationStatusAuthorized) {
            if (resultBlock) {
                resultBlock(YES);
            }
        }
        else if (status == AVAuthorizationStatusDenied) {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"请在iPhone的”设置-隐私-相机”中，允许访问您的相机" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"确定"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self yxOpenAppSetting];
            }];
            UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"取消"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            
            [alertControl addAction:sureAlert];
            [alertControl addAction:cancelAlert];
            [vc presentViewController:alertControl animated:YES completion:nil];
            
        }
        else if (status == AVAuthorizationStatusRestricted) {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"因为系统原因, 无法访问相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"确定"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
            
            [alertControl addAction:sureAlert];
            [vc presentViewController:alertControl animated:YES completion:nil];
        }
    }
    else {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", @"未检测到您的摄像头"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"确定"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alertControl addAction:sureAlert];
        [vc presentViewController:alertControl animated:YES completion:nil];
    }
}

#pragma mark - 输入框输入字数限制
- (void)yxLimitInputByView:(id)view maxNum:(NSInteger)maxNum resultBlock:(void(^)(BOOL boolSuccess))resultBlock {
    
    if ([view isKindOfClass:[UITextField class]]) {
        UITextField *textField = view;
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxNum) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxNum];
                if (rangeIndex.length == 1) {
                    textField.text = [toBeString substringToIndex:maxNum];
                    if (resultBlock) {
                        resultBlock(YES);
                    }
                }
                else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxNum)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
    else {
        UITextView *textView = view;
        NSString *toBeString = textView.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxNum) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxNum];
                if (rangeIndex.length == 1) {
                    textView.text = [toBeString substringToIndex:maxNum];
                    if (resultBlock) {
                        resultBlock(YES);
                    }
                }
                else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxNum)];
                    textView.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

#pragma mark - 替换控制器
- (void)yxReplaceVCByVC:(UIViewController *)vc toReplace:(UIViewController *)toReplace beReplaceVCName:(NSString *)beReplaceVCName {
    
    NSMutableArray *vcArr = [NSMutableArray arrayWithArray:vc.navigationController.viewControllers];
    [vcArr enumerateObjectsUsingBlock:^(id  _Nonnull vcObj, NSUInteger vcIdx, BOOL * _Nonnull stop) {
       
        if ([beReplaceVCName isKindOfClass:[vcObj class]]) {
            [vcArr replaceObjectAtIndex:vcIdx withObject:toReplace];
        }
    }];
    [toReplace setHidesBottomBarWhenPushed:YES];
    [vc.navigationController setViewControllers:vcArr animated:YES];
}

@end
