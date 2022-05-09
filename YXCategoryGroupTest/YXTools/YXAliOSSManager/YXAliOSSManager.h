//
//  YXAliOSSManager.h
//  MuchProj
//
//  Created by Augus on 2021/12/21.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXAliOSSManager : NSObject

/**
 返回对象

 @return AliUpLoadImageTool
 */
+ (YXAliOSSManager *)shareIncetance;

/** 上传图片 */
- (void)uploadImgByImg:(UIImage *)img
           finishBlock:(YXRequestFinishBlock)finishBlock;
/** 上传图片到oss并获得url*/
- (void)uploadImgToOssByImg:(UIImage *)img finishBlock:(YXRequestFinishBlock)finishBlock;
@end

NS_ASSUME_NONNULL_END
