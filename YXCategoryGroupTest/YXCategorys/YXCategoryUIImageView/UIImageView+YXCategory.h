//
//  UIImageView+YXCategory.h
//  MuchProj
//
//  Created by Ausus on 2021/11/10.
//

#import <UIKit/UIKit.h>

#pragma mark - 图片
#define kYXImage(imageName) [UIImage imageNamed:imageName]

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (YXCategory)

#pragma mark - 加载网络图片(支持GIF需要继承YYAnimatedImageView)
- (void)st_setImageWithURLString:(NSString *)urlString;
- (void)st_setImageWithURLString:(NSString *)urlString placeholderImage:(NSString *)placeholder finishedBlock:(void(^)(UIImage *img))finishedBlock;

#pragma mark - 加载本地GIF图片(支持GIF需要继承YYAnimatedImageView)
- (void)st_setGIFImageWithPath:(NSString *)path;

#pragma mark - 使用oss自动设置尺寸
- (NSString *)ossSetImgSizeByUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
