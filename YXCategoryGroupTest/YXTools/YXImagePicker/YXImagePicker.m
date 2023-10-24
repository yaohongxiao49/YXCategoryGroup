//
//  YXImagePicker.m
//  MuchProj
//
//  Created by Augus on 2023/9/25.
//

#import "YXImagePicker.h"

@interface YXImagePicker ()

@property (nonatomic, strong) HXPhotoManager *allManager; //照片、视频综合
@property (nonatomic, strong) HXPhotoManager *photoManager; //照片
@property (nonatomic, strong) HXPhotoManager *videoManager; //视频
@property (nonatomic, strong) NSArray *okImages;
@property (nonatomic, strong) NSArray *okModelList;

@end

@implementation YXImagePicker

+ (YXImagePicker *)shareIncetance {
    
    static YXImagePicker *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXImagePicker alloc]init];
    });
    return manager;
}

#pragma mark - 清理选择器
- (void)cleanPicker {
    
    [self.photoManager clearSelectedList];
}

#pragma mark - 弹出相册
- (void)presentChooseViewByBaseVC:(YXBaseVC *)baseVC type:(NSInteger)type limitNum:(NSInteger)limitNum finishBlock:(void(^)(NSArray *modelList, NSArray *imgArr, HXPhotoManager *manager))finishBlock {
    
    __weak typeof(self) weakSelf = self;
    HXPhotoManager *manager = [[HXPhotoManager alloc] init];
    switch (type) {
        case 1: { //照片
            manager = self.photoManager;
            if (limitNum != 0) self.photoManager.configuration.photoMaxNum = limitNum;
            break;
        }
        case 2: { //视频
            manager = self.videoManager;
            if (limitNum != 0) self.videoManager.configuration.videoMaxNum = limitNum;
            break;
        }
        default: { //综合
            manager = self.allManager;
            if (limitNum != 0) self.allManager.configuration.maxNum = limitNum;
            break;
        }
    }
    [baseVC hx_presentSelectPhotoControllerWithManager:manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {

        if (allList.count > 0) {
            [SVProgressHUD showWithStatus:@"请稍后..."];
            [allList hx_requestImageWithOriginal:YES completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
                
                [SVProgressHUD dismiss];
                finishBlock(allList, imageArray, manager);
            }];
        }
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        
        [weakSelf didSelectedCancelPhotoAlbum];
    }];
}

- (void)afterSelectedListdeletePhotos:(NSArray *)arr {
    
    for (HXPhotoModel *model in arr) {
        if (model.subType == HXPhotoModelMediaSubTypePhoto) {
            [self.photoManager afterSelectedListdeletePhotoModel:model];
        }
        else {
            [self.videoManager afterSelectedListdeletePhotoModel:model];
        }
    }
}
- (void)didSelectedCancelPhotoAlbum {}

#pragma mark - 懒加载
- (HXPhotoManager *)allManager {
    
    if (!_allManager) {
        _allManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _allManager.configuration.clarityScale = 3.0;
        _allManager.configuration.replaceCameraViewController = NO;
        _allManager.configuration.replacePhotoEditViewController = NO;
        _allManager.configuration.openCamera = YES;
        _allManager.configuration.cameraPhotoJumpEdit = NO;
        _allManager.configuration.defaultFrontCamera = NO;
        _allManager.configuration.saveSystemAblum = NO;
        _allManager.configuration.reverseDate = NO;
        _allManager.configuration.lookGifPhoto = NO;
        _allManager.configuration.lookLivePhoto = NO;
        _allManager.configuration.hideOriginalBtn = NO;
        _allManager.configuration.singleJumpEdit = YES;
        _allManager.configuration.photoCanEdit = YES;
        _allManager.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_None;
        _allManager.configuration.navBarTranslucent = NO;
        _allManager.configuration.singleSelected = NO;
        _allManager.configuration.photoMaxNum = 0;
        _allManager.configuration.videoMaxNum = 0;
        _allManager.configuration.maxNum = 9;
        _allManager.configuration.statusBarStyle = UIStatusBarStyleDarkContent;
        _allManager.configuration.navBarBackgroudColor = [UIColor whiteColor];
        _allManager.configuration.navigationTitleColor = [UIColor blackColor];
        _allManager.configuration.bottomViewTranslucent = NO;
        _allManager.configuration.bottomViewBgColor = [UIColor whiteColor];
        _allManager.configuration.cameraFocusBoxColor = kYXDiyColor(@"#886DFF", 1);
        _allManager.configuration.selectedTitleColor = [UIColor whiteColor];
        _allManager.configuration.cellSelectedBgColor = kYXDiyColor(@"#61A8FF", 1);
        _allManager.configuration.cellSelectedTitleColor = [UIColor whiteColor];
        _allManager.configuration.previewSelectedBtnBgColor = kYXDiyColor(@"#61A8FF", 1);
        _allManager.configuration.photoEditConfigur.themeColor = kYXDiyColor(@"#61A8FF", 1);
        _allManager.configuration.themeColor = kYXDiyColor(@"#61A8FF", 1);
    }
    return _allManager;
}
- (HXPhotoManager *)photoManager {
    
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photoManager.configuration.clarityScale = 3.0;
        _photoManager.configuration.replaceCameraViewController = NO;
        _photoManager.configuration.replacePhotoEditViewController = NO;
        _photoManager.configuration.openCamera = YES;
        _photoManager.configuration.cameraPhotoJumpEdit = NO;
        _photoManager.configuration.defaultFrontCamera = NO;
        _photoManager.configuration.saveSystemAblum = NO;
        _photoManager.configuration.reverseDate = NO;
        _photoManager.configuration.lookGifPhoto = NO;
        _photoManager.configuration.lookLivePhoto = NO;
        _photoManager.configuration.hideOriginalBtn = NO;
        _photoManager.configuration.singleJumpEdit = YES;
        _photoManager.configuration.photoCanEdit = YES;
        _photoManager.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_None;
        _photoManager.configuration.navBarTranslucent = NO;
        _photoManager.configuration.singleSelected = NO;
        _photoManager.configuration.photoMaxNum = 9;
        _photoManager.configuration.videoMaxNum = 0;
        _photoManager.configuration.maxNum = 0;
        _photoManager.configuration.statusBarStyle = UIStatusBarStyleDarkContent;
        _photoManager.configuration.navBarBackgroudColor = [UIColor whiteColor];
        _photoManager.configuration.navigationTitleColor = [UIColor blackColor];
        _photoManager.configuration.bottomViewTranslucent = NO;
        _photoManager.configuration.bottomViewBgColor = [UIColor whiteColor];
        _photoManager.configuration.cameraFocusBoxColor = kYXDiyColor(@"#886DFF", 1);
        _photoManager.configuration.selectedTitleColor = [UIColor whiteColor];
        _photoManager.configuration.cellSelectedBgColor = kYXDiyColor(@"#61A8FF", 1);
        _photoManager.configuration.cellSelectedTitleColor = [UIColor whiteColor];
        _photoManager.configuration.previewSelectedBtnBgColor = kYXDiyColor(@"#61A8FF", 1);
        _photoManager.configuration.photoEditConfigur.themeColor = kYXDiyColor(@"#61A8FF", 1);
        _photoManager.configuration.themeColor = kYXDiyColor(@"#61A8FF", 1);
    }
    return _photoManager;
}
- (HXPhotoManager *)videoManager {
    
    if (!_videoManager) {
        _videoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypeVideo];
        _videoManager.configuration.clarityScale = 3.0;
        _videoManager.configuration.replaceCameraViewController = NO;
        _videoManager.configuration.replacePhotoEditViewController = NO;
        _videoManager.configuration.openCamera = YES;
        _videoManager.configuration.cameraPhotoJumpEdit = NO;
        _videoManager.configuration.defaultFrontCamera = NO;
        _videoManager.configuration.saveSystemAblum = NO;
        _videoManager.configuration.reverseDate = NO;
        _videoManager.configuration.lookGifPhoto = NO;
        _videoManager.configuration.lookLivePhoto = NO;
        _videoManager.configuration.hideOriginalBtn = NO;
        _videoManager.configuration.singleJumpEdit = YES;
        _videoManager.configuration.photoCanEdit = YES;
        _videoManager.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_None;
        _videoManager.configuration.navBarTranslucent = NO;
        _videoManager.configuration.singleSelected = NO;
        _videoManager.configuration.photoMaxNum = 0;
        _videoManager.configuration.videoMaxNum = 1;
        _videoManager.configuration.maxNum = 0;
        _videoManager.configuration.statusBarStyle = UIStatusBarStyleDarkContent;
        _videoManager.configuration.navBarBackgroudColor = [UIColor whiteColor];
        _videoManager.configuration.navigationTitleColor = [UIColor blackColor];
        _videoManager.configuration.bottomViewTranslucent = NO;
        _videoManager.configuration.bottomViewBgColor = [UIColor whiteColor];
        _videoManager.configuration.cameraFocusBoxColor = kYXDiyColor(@"#886DFF", 1);
        _videoManager.configuration.selectedTitleColor = [UIColor whiteColor];
        _videoManager.configuration.cellSelectedBgColor = kYXDiyColor(@"#61A8FF", 1);
        _videoManager.configuration.cellSelectedTitleColor = [UIColor whiteColor];
        _videoManager.configuration.previewSelectedBtnBgColor = kYXDiyColor(@"#61A8FF", 1);
        _videoManager.configuration.photoEditConfigur.themeColor = kYXDiyColor(@"#61A8FF", 1);
        _videoManager.configuration.themeColor = kYXDiyColor(@"#61A8FF", 1);
    }
    return _videoManager;
}

@end
