//
//  UIImageView+YXCategory.m
//  MuchProj
//
//  Created by Ausus on 2021/11/10.
//

#import "UIImageView+YXCategory.h"

@implementation UIImageView (YXCategory)

#pragma mark - 加载网络图片(支持GIF需要继承YYAnimatedImageView)
- (void)st_setImageWithURLString:(NSString *)urlString {
    
    if ([urlString containsString:@"gif"]) {
        [self yy_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation | YYWebImageOptionRefreshImageCache];
    }
    else {
        [self yy_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
    }
}
- (void)st_setImageWithURLString:(NSString *)urlString placeholderImage:(NSString *)placeholder finishedBlock:(void(^)(UIImage *img))finishedBlock {
    
    if (finishedBlock) {
        if (placeholder.length == 0) {
            [self yy_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] placeholder:[UIImage new] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                    finishedBlock(image);
            }];
        }
        else {
            [self yy_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] placeholder:[UIImage imageNamed:placeholder] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                    finishedBlock(image);
            }];
        }
    }
    else {
        if (placeholder.length == 0) {
            [self yy_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
        }
        else {
            [self yy_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] placeholder:[UIImage imageNamed:placeholder] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
        }
    }
}

#pragma mark - 加载本地GIF图片(支持GIF需要继承YYAnimatedImageView)
- (void)st_setGIFImageWithPath:(NSString *)path {
    
    [self yy_setImageWithURL:[NSURL fileURLWithPath:path] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
}

@end
