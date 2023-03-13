//
//  ViewController.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/9.
//  Copyright © 2020 August. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self downloadFile];
//    [self getVideoImgArr];
}

#pragma mark - 下载
- (void)downloadFile {
    
    [[YXBigFileDownloadRequest sharedManager] startDownloadByFileUrl:@"http://220.249.115.46:18080/wav/day_by_day.mp4"];
    [[YXBigFileDownloadRequest sharedManager] setYxBigFileDownloadRequestProgressBlock:^(double progress) {
       
        NSLog(@"当前进度 == %.2f", progress);
    }];
    [[YXBigFileDownloadRequest sharedManager] setYxBigFileDownloadRequestBlock:^(NSString * _Nonnull savePath, NSString * _Nonnull fileName) {

        NSLog(@"存储地址 == %@, 文件名 == %@", fileName, savePath);
    }];
}

#pragma mark - 生成gif
- (void)getVideoImgArr {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mov"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.animationDuration = 5;
    [self.view addSubview:imgV];
    
    [[UIImage alloc] getVideoFrameImageWithUrl:url second:3 fps:20 durationSec:1 finishBlock:^(NSMutableArray * _Nonnull arr) {
        
        NSString *path = [UIImage yxSyntheticGifByImgArr:arr gifNamed:@"test" targetSize:CGSizeMake(100, 100)];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            imgV.animationImages = [[UIImage alloc] yxSegmentationGifByUrl:[NSURL fileURLWithPath:path]];
            [imgV startAnimating];
        });
        
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

@end
