//
//  UIImage+YXCategory.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "UIImage+YXCategory.h"
#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (YXCategory)

#pragma mark - 获取视频缩略图
+ (UIImage *)yxGetVideoThumbnailWithVideoUrl:(NSString *)videoUrl second:(CGFloat)second {

    if (!videoUrl) {
        return nil;
    }
    NSURL *url;
    if ([videoUrl containsString:@"http"]) {
        url = [NSURL URLWithString:videoUrl];
    }
    else {
        url = [NSURL fileURLWithPath:videoUrl];
    }
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:audioAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    BOOL getThumbnail = YES;
    if (getThumbnail) { //缩略图及cell大小
        CGFloat width = [UIScreen mainScreen].scale *75;
        imageGenerator.maximumSize = CGSizeMake(width, width);
    }
    NSError *error = nil;
    //一秒想取多少帧
    CMTime time = CMTimeMake(second, 1);
    CMTime actucalTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"ERROR:获取视频图片失败, %@", error.description);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}

#pragma mark - 获取启动图
+ (UIImage *)yxGetLaunchImage {

    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait"; //方向
    NSString *imgName = [[NSString alloc] init];
    NSArray *lauchImages = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in lauchImages) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(viewSize, imageSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            imgName = dict[@"UILaunchImageName"];
        }
    }
    
    return [UIImage imageNamed:imgName];
}

#pragma mark - 合并图片
+ (UIImage *)yxComposeImgWithBgImgValue:(id)bgImgValue bgImgFrame:(CGRect)bgImgFrame topImgValue:(id)topImgValue topImgFrame:(CGRect)topImgFrame saveToFileWithName:(NSString *)saveToFileWithName boolByBgView:(BOOL)boolByBgView {
    
    //底图
    UIImage *bgImg = [[UIImage alloc] init];
    if ([bgImgValue isKindOfClass:[UIImage class]]) {
        bgImg = bgImgValue;
    }
    else {
        bgImg = [UIImage imageNamed:bgImgValue];
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGImageRef bgImgRef = bgImg.CGImage;
    CGFloat bgImgW = CGImageGetWidth(bgImgRef) > width ? width : CGImageGetWidth(bgImgRef);
    CGFloat bgImgH = CGImageGetWidth(bgImgRef) > width ? CGImageGetHeight(bgImgRef) *(width /CGImageGetWidth(bgImgRef)) : CGImageGetHeight(bgImgRef);
    
    //顶图
    UIImage *topImg = [[UIImage alloc] init];
    if ([topImgValue isKindOfClass:[UIImage class]]) {
        topImg = topImgValue;
    }
    else {
        topImg = [UIImage imageNamed:topImgValue];
    }
    CGImageRef topImgRef = topImg.CGImage;
    CGFloat topImgW = CGImageGetWidth(topImgRef) > width ? width : CGImageGetWidth(topImgRef);
    CGFloat topImgH = CGImageGetWidth(topImgRef) > width ? CGImageGetHeight(topImgRef) *(width /CGImageGetWidth(topImgRef)) : CGImageGetHeight(topImgRef);

    //设置底图最终坐标
    CGRect endBgFrame = bgImgFrame.size.width != 0 ? bgImgFrame : CGRectMake(0, 0, bgImgW, bgImgH);
    //设置顶图最终坐标
    CGRect endTopFrame = topImgFrame.size.width != 0 ? topImgFrame : CGRectMake(0, 0, topImgW, topImgH);
    
    //绘制上下文
    if (boolByBgView) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(endBgFrame.size.width, endBgFrame.size.height), YES, 0);
    }
    else {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(endTopFrame.size.width, endTopFrame.size.height), YES, 0);
    }
    
    //先把底图画到上下文中
    [bgImg drawInRect:endBgFrame];
    //把顶图放在上下文中
    [topImg drawInRect:endTopFrame];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext(); //从当前上下文中获得最终图片
    UIGraphicsEndImageContext(); //关闭上下文
    
    if ([saveToFileWithName isKindOfClass:[NSString class]] && saveToFileWithName.length > 0) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", path, saveToFileWithName, @".png"];
        [UIImagePNGRepresentation(resultImg) writeToFile:filePath atomically:YES]; //保存图片到沙盒
        //TODO 如果崩溃，则删除一下代码。
        CGImageRelease(bgImgRef);
        CGImageRelease(topImgRef);
    }
    
    return resultImg;
}

#pragma mark - 按比例缩放/压缩图片
+ (UIImage *)yxImgCompressForSizeImg:(id)imgValue targetSize:(CGSize)targetSize {
    
    UIImage *img = [[UIImage alloc] init];
    if ([imgValue isKindOfClass:[UIImage class]]) {
        img = imgValue;
    }
    else {
        img = [UIImage imageNamed:imgValue];
    }
    UIImage *newImg = nil;
    CGSize imgSize = img.size;
    CGFloat width = imgSize.width;
    CGFloat height = imgSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imgSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth /width;
        CGFloat heightFactor = targetHeight /height;

        scaleFactor = widthFactor > heightFactor ? widthFactor : heightFactor;
        scaledWidth = width *scaleFactor;
        scaledHeight = height *scaleFactor;

        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, 0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [img drawInRect:thumbnailRect];
    newImg = UIGraphicsGetImageFromCurrentImageContext();

    if (newImg == nil) {
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    
    return newImg;
}

#pragma mark - 根据颜色创建图片
+ (UIImage *)yxCreateImgByColor:(UIColor *)color imgSize:(CGSize)imgSize {
    
    CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - 动态拉伸图片
+ (UIImage *)yxGetTensileImgByImgName:(NSString *)imgName tensileTop:(NSString *)tensileTop tensileLeft:(NSString *)tensileLeft tensileBottom:(NSString *)tensileBottom tensileRight:(NSString *)tensileRight {
    
    UIImage *img;
    if ([imgName containsString:@"http"]) {
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgName]]];
    }
    else {
        img = [UIImage imageNamed:imgName];
    }
    //设置端盖的值
    CGFloat top = img.size.height;
    CGFloat left = img.size.width;
    CGFloat bottom = img.size.height;
    CGFloat right = img.size.width;
    if ([tensileTop isKindOfClass:[NSString class]] && tensileTop.length > 0) {
        top = [tensileTop floatValue];
    }
    if ([tensileLeft isKindOfClass:[NSString class]] && tensileLeft.length > 0) {
        left = [tensileLeft floatValue];
    }
    if ([tensileBottom isKindOfClass:[NSString class]] && tensileBottom.length > 0) {
        bottom = [tensileBottom floatValue];
    }
    if ([tensileRight isKindOfClass:[NSString class]] && tensileRight.length > 0) {
        right = [tensileRight floatValue];
    }
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImageResizingMode mode = UIImageResizingModeStretch;
    //拉伸图片
    UIImage *newImage = [img resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    
    return newImage;
}

@end
