//
//  UIImageView+YXCategory.h
//  MuchProj
//
//  Created by Ausus on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (YXCategory)

#pragma mark - 加载网络图片(支持GIF需要继承YYAnimatedImageView)
- (void)st_setImageWithURLString:(NSString *)urlString;
- (void)st_setImageWithURLString:(NSString *)urlString placeholderImage:(NSString *)placeholder finishedBlock:(void(^)(UIImage *img))finishedBlock;

#pragma mark - 加载本地GIF图片(支持GIF需要继承YYAnimatedImageView)
- (void)st_setGIFImageWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
