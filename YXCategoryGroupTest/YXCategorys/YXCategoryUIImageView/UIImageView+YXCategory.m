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
        [self sd_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] placeholderImage:kYXImage(@"") options:SDWebImageQueryDiskDataSync];
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
//            [self yy_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
            [self sd_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] placeholderImage:kYXImage(@"") options:SDWebImageQueryDiskDataSync];
        }
        else {
//            [self yy_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] placeholder:[UIImage imageNamed:placeholder] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
            [self sd_setImageWithURL:[NSURL URLWithString:[urlString yxUrlEncoded]] placeholderImage:[UIImage imageNamed:placeholder] options:SDWebImageQueryDiskDataSync];
        }
    }
}

#pragma mark - 加载本地GIF图片(支持GIF需要继承YYAnimatedImageView)
- (void)st_setGIFImageWithPath:(NSString *)path {
    
    [self yy_setImageWithURL:[NSURL fileURLWithPath:path] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
}

#pragma mark - 使用oss自动设置尺寸
- (NSString *)ossSetImgSizeByUrl:(NSString *)url {
    
    NSRange found = [url rangeOfString:@"?"];
    if (found.location != NSNotFound) {
        return [NSString stringWithFormat:@"%@&x-oss-process=image/resize,m_mfit,w_360,h_360,limit_0/crop,x_0,y_0,w_360,h_360,g_north", url];
    }
    else {
        return [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_mfit,w_360,h_360,limit_0/crop,x_0,y_0,w_360,h_360,g_north", url];
    }
}

@end
