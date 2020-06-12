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

#define timeInterval @(600)
#define tolerance @(0.01)

typedef NS_ENUM(NSUInteger, GifSize) {
    GifSizeVeryLow = 2,
    GifSizeLow = 3,
    GifSizeMedium = 5,
    GifSizeHigh = 7,
    GifSizeOriginal = 10
};

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
    if (getThumbnail) { //缩略图大小
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

#pragma mark - 根据时间、帧率获取视频帧图片集合
- (void)getVideoFrameImageWithUrl:(NSURL *)videoUrl second:(CGFloat)second fps:(float)fps finishBlock:(void(^)(NSMutableArray *arr))finishBlock {
    
    if (!videoUrl) {
        return;
    }
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts];
    CMTime cmtime = audioAsset.duration; //视频时间信息结构体
    Float64 durationSeconds = second > CMTimeGetSeconds(cmtime) ? CMTimeGetSeconds(cmtime) : second; //视频总秒数
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds *fps; //获得视频总帧数
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i, fps); //第i帧 帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    NSInteger timesCount = [times count];
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:audioAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    [imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:
     ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
    
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *frameImg = [UIImage imageWithCGImage:image];
                [imgArr addObject:frameImg];
                if (requestedTime.value == timesCount && finishBlock) {
                    finishBlock(imgArr);
                }
                break;
            }
            default:
                break;
        }
     }];
}

#pragma mark - 合成gif
- (NSString *)yxSyntheticGifByImgArr:(NSMutableArray *)imagePathArray gifNamed:(NSString *)gifNamed targetSize:(CGSize)targetSize {
    
    //创建储存路径
    NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *gifPath = [NSString stringWithFormat:@"%@/%@.gif", savePath, gifNamed];
    NSLog(@"gifPath == %@", gifPath);
    
    //图像目标
    CGImageDestinationRef destination;
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)gifPath, kCFURLPOSIXPathStyle, false);
    //通过一个url返回图像目标
    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imagePathArray.count, NULL);
    
    //设置gif的信息，播放间隔时间、基本数据、delay时间
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.1], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //设置gif信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCGImagePropertyGIFHasGlobalColorMap];
    [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    [dict setObject:[NSNumber numberWithInt:16] forKey:(NSString*)kCGImagePropertyDepth]; //颜色深度
    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifproperty = [NSDictionary dictionaryWithObject:dict forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //合成gif
    for (UIImage *img in imagePathArray) {
        UIImage *imgs = img;
        if (targetSize.width != 0) imgs = [UIImage yxImgCompressForSizeImg:img targetSize:targetSize];
        CGImageDestinationAddImage(destination, imgs.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }

    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifproperty);
    CGImageDestinationFinalize(destination);
    
    CFRelease(destination);
    
    return gifPath;
}

#pragma mark - 分割gif
- (NSMutableArray *)yxSegmentationGifByUrl:(NSURL *)url {
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    size_t imgCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    for (size_t i = 0; i < imgCount; i++) {
        //获取源图片
        CGImageRef imgRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *img = [UIImage imageWithCGImage:imgRef];
        [mutableArr addObject:img];
        CGImageRelease(imgRef);
    }
    
    CFRelease(gifSource);
    
    return mutableArr;
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

#pragma mark - 动态填充图片色值
- (UIImage *)yxFillImgColorByImg:(UIImage *)img showSize:(CGSize)showSize toColor:(UIColor *)color fillWidth:(CGFloat)fillWidth {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(showSize.width, img.size.height), NO, img.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, img.size.height);

    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, showSize.width, img.size.height);

    CGContextClipToMask(context, rect, img.CGImage);
    [color setFill];
    
    CGContextFillRect(context, CGRectMake(0, 0, fillWidth, rect.size.height));
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return colorImage;
}

#pragma mark - 视频转为gif
+ (void)yxCreateGifByUrl:(NSURL *)videoUrl frameCount:(int)frameCount delayTime:(float)delayTime loopCount:(int)loopCount boolNeedCompression:(BOOL)boolNeedCompression compressionWidth:(float)compressionWidth compressionHight:(float)compressionHight filleName:(NSString *)filleName completionBlock:(void(^)(NSString *gifPath))completionBlock {
    
    NSDictionary *fileProperties = [self filePropertiesWithLoopCount:loopCount];
    NSDictionary *frameProperties = [self framePropertiesWithDelayTime:delayTime];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
    
    float videoLength = (float)asset.duration.value /asset.duration.timescale;
    float increment = (float)videoLength /frameCount;
    
    NSMutableArray *timePoints = [NSMutableArray array];
    for (int currentFrame = 0; currentFrame<frameCount; ++currentFrame) {
        float seconds = (float)increment * currentFrame;
        CMTime time = CMTimeMakeWithSeconds(seconds, [timeInterval intValue]);
        [timePoints addObject:[NSValue valueWithCMTime:time]];
    }
    
    dispatch_group_t gifQueue = dispatch_group_create();
    dispatch_group_enter(gifQueue);
    
    __block NSString *gifPath;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        gifPath = [weakSelf createGifByTimePoints:timePoints url:videoUrl fileProperties:fileProperties frameProperties:frameProperties frameCount:frameCount gifSize:GifSizeMedium boolNeedCompression:boolNeedCompression compressionWidth:compressionWidth compressionHight:compressionHight filleName:filleName];
        
        dispatch_group_leave(gifQueue);
    });
    
    dispatch_group_notify(gifQueue, dispatch_get_main_queue(), ^{
        //Return GIF URL
        completionBlock(gifPath);
    });
}

#pragma mark - 创建gif
+ (NSString *)createGifByTimePoints:(NSArray *)timePoints url:(NSURL *)url fileProperties:(NSDictionary *)fileProperties frameProperties:(NSDictionary *)frameProperties frameCount:(int)frameCount gifSize:(GifSize)gifSize boolNeedCompression:(BOOL)boolNeedCompression compressionWidth:(float)compressionWidth compressionHight:(float)compressionHight filleName:(NSString *)filleName {
    
    NSString *temporaryFile = [NSTemporaryDirectory() stringByAppendingString:filleName];
    NSURL *fileURL = [NSURL fileURLWithPath:temporaryFile];
    if (fileURL == nil) {
        return nil;
    }
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF , frameCount, NULL);

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    CMTime tol = CMTimeMakeWithSeconds([tolerance floatValue], [timeInterval intValue]);
    generator.requestedTimeToleranceBefore = tol;
    generator.requestedTimeToleranceAfter = tol;
    
    NSError *error = nil;
    CGImageRef previousImageRefCopy = nil;
    for (NSValue *time in timePoints) {
        CGImageRef imageRef;
        
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        imageRef = (float)gifSize/10 != 1 ? createImageWithScale([generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error], (float)gifSize/10) : [generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error];
#elif TARGET_OS_MAC
        imageRef = [generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error];
#endif
        
        if (error) {
            NSLog(@"Error copying image: %@", error);
        }
        if (imageRef) {
            CGImageRelease(previousImageRefCopy);
            previousImageRefCopy = CGImageCreateCopy(imageRef);
        }
        else if (previousImageRefCopy) {
            imageRef = CGImageCreateCopy(previousImageRefCopy);
        }
        else {
            NSLog(@"Error copying image and no previous frames to duplicate");
            return nil;
        }
        if (boolNeedCompression) {
            UIImage *img = [UIImage imageWithCGImage:imageRef];
            
            CGSize targetSize = CGSizeMake(compressionWidth, compressionHight);
            UIImage *sourceImage = img;
            UIImage *newImage = nil;
            CGSize imageSize = sourceImage.size;
            CGFloat width = imageSize.width;
            CGFloat height = imageSize.height;
            CGFloat targetWidth = targetSize.width;
            CGFloat targetHeight = targetSize.height;
            CGFloat scaleFactor = 0.0;
            CGFloat scaledWidth = targetWidth;
            CGFloat scaledHeight = targetHeight;
            CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
            
            if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
                
                CGFloat widthFactor = targetWidth /width;
                CGFloat heightFactor = targetHeight /height;
                
                if (widthFactor > heightFactor) {
                    scaleFactor = widthFactor; //scale to fit height
                }
                else {
                    scaleFactor = heightFactor; //scale to fit width
                }
                scaledWidth = width *scaleFactor;
                scaledHeight = height *scaleFactor;
                
                //center the image
                if (widthFactor > heightFactor) {
                    thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
                }
                else if (widthFactor < heightFactor) {
                    thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
                }
            }
            
            UIGraphicsBeginImageContext(targetSize); //this will crop
            
            CGRect thumbnailRect = CGRectZero;
            thumbnailRect.origin = thumbnailPoint;
            thumbnailRect.size.width= scaledWidth;
            thumbnailRect.size.height = scaledHeight;
            [sourceImage drawInRect:thumbnailRect];
            
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            if(newImage == nil) {
                NSLog(@"could not scale image");
            }
                
            //pop the context to get back to the default
            UIGraphicsEndImageContext();
            
            CGImageRef imageRef1 = newImage.CGImage;
            NSLog(@"开始add，%@", time);
            CGImageDestinationAddImage(destination, imageRef1, (CFDictionaryRef)frameProperties);
            NSLog(@"当此add完成，%@", time);
        }
        else {
            CGImageDestinationAddImage(destination, imageRef, (CFDictionaryRef)frameProperties);
        }
        
        CGImageRelease(imageRef);
    }
    CGImageRelease(previousImageRefCopy);
    NSLog(@"取出imageRef完成");
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)fileProperties);
    //Finalize the GIF
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to finalize GIF destination: %@", error);
        if (destination != nil) {
            CFRelease(destination);
        }
        return nil;
    }
    CFRelease(destination);
    
    return temporaryFile;
}

#pragma mark - Helpers
CGImageRef createImageWithScale(CGImageRef imageRef, float scale) {
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    CGSize newSize = CGSizeMake(CGImageGetWidth(imageRef) *scale, CGImageGetHeight(imageRef) *scale);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    
    //Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    //Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    //Release old image
    CFRelease(imageRef);
    //Get the resized image from the context and a UIImage
    imageRef = CGBitmapContextCreateImage(context);
    
    UIGraphicsEndImageContext();
#endif
    return imageRef;
}

#pragma mark - Properties
+ (NSDictionary *)filePropertiesWithLoopCount:(int)loopCount {
    
    return @{(NSString *)kCGImagePropertyGIFDictionary:@{(NSString *)kCGImagePropertyGIFLoopCount:@(loopCount)}};
}
+ (NSDictionary *)framePropertiesWithDelayTime:(float)delayTime {
    
    return @{(NSString *)kCGImagePropertyGIFDictionary:@{(NSString *)kCGImagePropertyGIFDelayTime: @(delayTime)}, (NSString *)kCGImagePropertyColorModel:(NSString *)kCGImagePropertyColorModelRGB};
}

@end
