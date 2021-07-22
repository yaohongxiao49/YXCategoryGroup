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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mov"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.animationDuration = 5;
    [self.view addSubview:imgV];
    
    [[UIImage alloc] getVideoFrameImageWithUrl:url second:3 fps:20 durationSec:1 finishBlock:^(NSMutableArray * _Nonnull arr) {
        
        NSString *path = [[UIImage alloc] yxSyntheticGifByImgArr:arr gifNamed:@"test" targetSize:CGSizeMake(100, 100)];
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
