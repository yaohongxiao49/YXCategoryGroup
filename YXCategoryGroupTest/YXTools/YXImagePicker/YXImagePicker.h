//
//  YXImagePicker.h
//  MuchProj
//
//  Created by Augus on 2023/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXImagePicker : NSObject

/** 单例 */
+ (YXImagePicker *)shareIncetance;

/** 清理选择器 */
- (void)cleanPicker;

/**
 * 弹出相册
 * - Parameters:
 *   - baseVC: 基础控制器
 *   - type: 类型，0：综合，1：照片，2：视频
 *   - limitNum: 限制数量，综合默认限制数量 9，照片默认限制数量 9，视频默认限制数量 1
 */
- (void)presentChooseViewByBaseVC:(YXBaseVC *)baseVC
                             type:(NSInteger)type
                         limitNum:(NSInteger)limitNum
                      finishBlock:(void(^)(NSArray *modelList, NSArray *imgArr, HXPhotoManager *manager))finishBlock;

@end

NS_ASSUME_NONNULL_END
