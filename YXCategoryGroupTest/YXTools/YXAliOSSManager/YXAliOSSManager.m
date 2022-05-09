//
//  YXAliOSSManager.m
//  MuchProj
//
//  Created by Augus on 2021/12/21.
//

#import "YXAliOSSManager.h"

@interface YXAliOSSManager ()

@end

@implementation YXAliOSSManager

/** 上传图片到oss并获得url*/
- (void)uploadImgToOssByImg:(UIImage *)img finishBlock:(YXRequestFinishBlock)finishBlock
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"上传中..."];
    [YXNetworkUse yxGetOSSValueByShowText:@"" isShowSuccess:NO isShowError:YES finishBlock:^(id  _Nullable result, BOOL boolSuccess) {
        [SVProgressHUD dismiss];
        if (boolSuccess) {
            OSSFederationCredentialProvider *provider = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * _Nullable {

                OSSFederationToken *token = [OSSFederationToken new];
                token.tAccessKey = [[result yxObjForKey:@"credentials"] yxObjForKey:@"accessKeyId"];
                token.tSecretKey = [[result yxObjForKey:@"credentials"] yxObjForKey:@"accessKeySecret"];
                token.tToken = [[result yxObjForKey:@"credentials"] yxObjForKey:@"securityToken"];
                token.expirationTimeInGMTFormat = [[result yxObjForKey:@"credentials"] yxObjForKey:@"expiration"];
                return token;
            }];
            id<OSSCredentialProvider> credential = provider;
            
            [weakSelf pushImgByOSSOnlyGetUrl:credential img:img finishBlock:^(id  _Nullable result, BOOL boolSuccess) {

                finishBlock(result, boolSuccess);
            }];
        }
    }];
}
- (void)pushImgByOSSOnlyGetUrl:(id)credential img:(UIImage *)img finishBlock:(YXRequestFinishBlock)finishBlock
{
    OSSClient *defaultClient = [[OSSClient alloc] initWithEndpoint:OSS_ENDPOINT credentialProvider:credential];
    
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    //填写Bucket名称，例如examplebucket。
    put.bucketName = kOSSBucketName;
    //填写Object完整路径。Object完整路径中不能包含Bucket名称，例如exampledir/testdir/exampleobject.txt。
    NSString *objectKey = [NSString stringWithFormat:@"img/iosGameGoodsInfo/%@.jpg", [NSString yxGetCurrentTheTimeStamp]];
    put.objectKey = objectKey;
    //直接上传NSData。
//    put.uploadingData = UIImagePNGRepresentation(img);
//    put.uploadingData = UIImageJPEGRepresentation([self fixOrientation:img], 0.1);
    
    UIImage *ysimg = [UIImage imageWithData:UIImageJPEGRepresentation([self fixOrientation:img], 0.1)];
    
    //直接上传NSData。
    if (UIImageJPEGRepresentation([self fixOrientation:img], 0.1).length > 1024)
    {
        put.uploadingData = UIImageJPEGRepresentation(ysimg, 0.1);
    }else
    {
        put.uploadingData = UIImageJPEGRepresentation([self fixOrientation:img], 0.1);
    }
    
    //上传进度
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask *putTask = [defaultClient putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            task = [defaultClient presignPublicURLWithBucketName:put.bucketName withObjectKey:objectKey];

            finishBlock(task.result, YES);
            
        }
        else {
            NSLog(@"error = %@",task.error);
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
        return nil;
    }];
    
    [putTask waitUntilFinished];
}
- (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
+ (YXAliOSSManager *)shareIncetance {
    
    static YXAliOSSManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[YXAliOSSManager alloc] init];
    });
    return manager;
}

#pragma mark - 上传图片
- (void)uploadImgByImg:(UIImage *)img finishBlock:(YXRequestFinishBlock)finishBlock {
    
    kYXWeakSelf;
    [SVProgressHUD showWithStatus:@"上传头像中..."];
    [YXNetworkUse yxGetOSSValueByShowText:@"" isShowSuccess:NO isShowError:YES finishBlock:^(id  _Nullable result, BOOL boolSuccess) {
        
        if (boolSuccess) {
            OSSFederationCredentialProvider *provider = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * _Nullable {

                OSSFederationToken *token = [OSSFederationToken new];
                token.tAccessKey = [[result yxObjForKey:@"credentials"] yxObjForKey:@"accessKeyId"];
                token.tSecretKey = [[result yxObjForKey:@"credentials"] yxObjForKey:@"accessKeySecret"];
                token.tToken = [[result yxObjForKey:@"credentials"] yxObjForKey:@"securityToken"];
                token.expirationTimeInGMTFormat = [[result yxObjForKey:@"credentials"] yxObjForKey:@"expiration"];
                return token;
            }];
            id<OSSCredentialProvider> credential = provider;
            
            [weakSelf pushImgByOSS:credential img:img finishBlock:^(id  _Nullable result, BOOL boolSuccess) {
                
                finishBlock(result, boolSuccess);
            }];
        }
    }];
}

- (void)pushImgByOSS:(id)credential img:(UIImage *)img finishBlock:(YXRequestFinishBlock)finishBlock {
    
    OSSClient *defaultClient = [[OSSClient alloc] initWithEndpoint:OSS_ENDPOINT credentialProvider:credential];
    
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    //填写Bucket名称，例如examplebucket。
    put.bucketName = kOSSBucketName;
    //填写Object完整路径。Object完整路径中不能包含Bucket名称，例如exampledir/testdir/exampleobject.txt。
    NSString *objectKey = [NSString stringWithFormat:@"img/headUrl/%@.png", [NSString yxGetCurrentTheTimeStamp]];
    put.objectKey = objectKey;
    //直接上传NSData。
    put.uploadingData = UIImageJPEGRepresentation(img, 0.5);
    //上传进度
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask *putTask = [defaultClient putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            task = [defaultClient presignPublicURLWithBucketName:put.bucketName withObjectKey:objectKey];
            [YXNetworkUse yxPutUseMsgHTTPByAvaterUrl:task.result nickName:@"" showText:@"" isShowSuccess:NO isShowError:YES finishBlock:^(id  _Nullable result, BOOL boolSuccess) {
                
                if (boolSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    finishBlock(task.result, boolSuccess);
                }
            }];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
        return nil;
    }];
    
    [putTask waitUntilFinished];
}

@end
