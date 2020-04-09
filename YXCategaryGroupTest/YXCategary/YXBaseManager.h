//
//  YXBaseManager.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXBaseManager : NSObject

+ (YXBaseManager *)instanceManager;

/**
 * 指定两个日期的间隔天数
 * @param fromDateValue 开始日期
 * @param toDateValue 结束日期
 * @param format 格式（如yyyy-MM-dd）
 */
- (NSInteger)yxNumberOfDaysByFromDateValue:(NSString *)fromDateValue
                               toDateValue:(NSString *)toDateValue
                                    format:(NSString *)format;

/**
 * 判断当前设备是否开启相机功能
 * @param vc 控制器
 * @param resultBlock 结果回调
 */
- (void)yxJudgeAVCaptureDevice:(UIViewController *)vc
                   resultBlock:(void(^)(BOOL boolSuccess))resultBlock;

/**
 * 输入框输入字数限制
 * @param view UITextField/UITextView
 * @param maxNum 最大输入字数
 * @param resultBlock 结果回调
 */
- (void)yxLimitInputByView:(id)view
                    maxNum:(NSInteger)maxNum
               resultBlock:(void(^)(BOOL boolSuccess))resultBlock;

/**
 * 替换控制器
 * @param vc 父视图控制器
 * @param toReplace 替换后的控制器
 * @param beReplaceVCName 替换前的控制器名称
 */
- (void)yxReplaceVCByVC:(UIViewController *)vc
              toReplace:(UIViewController *)toReplace
        beReplaceVCName:(NSString *)beReplaceVCName;

@end

NS_ASSUME_NONNULL_END
