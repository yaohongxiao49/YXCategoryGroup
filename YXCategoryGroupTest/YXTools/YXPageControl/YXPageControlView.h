//
//  YXPageControl.h
//  MuchProj
//
//  Created by Ausus on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 页码位置 */
typedef NS_ENUM(NSInteger, YXPageControlPosition) {
    /** 靠左 */
    YXPageControlPositionLeft = 0,
    /** 靠右 */
    YXPageControlPositionRight,
    /** 居中 */
    YXPageControlPositionCenter,
};

@interface YXPageControlView : UIView

/** 列表视图 */
@property (nonatomic, strong) UICollectionView *collectionView;

/** 未选中颜色，默认#E6E6E6 */
@property (nonatomic, strong) UIColor *normalColor;
/** 已选中颜色，默认#C2C2C2 */
@property (nonatomic, strong) UIColor *selectedColor;
/** 未选中图片，如果设置优先显示 */
@property (nonatomic, strong) UIImage *normalImage;
/** 已选中图片，如果设置优先显示 */
@property (nonatomic, strong) UIImage *selectedImage;

/** 页码总数，默认0 */
@property (nonatomic, assign) NSInteger pageCount;
/** 当前页码，默认0 */
@property (nonatomic, assign) NSInteger currentPage;
/** 是否单页隐藏，默认NO */
@property (nonatomic, assign) BOOL hideForSinglePage;
/** 是否可以点击页码，默认NO */
@property (nonatomic, assign) BOOL isClickPage;

/** 页码位置，默认居中 */
@property (nonatomic, assign) YXPageControlPosition pagePosition;
/** 页码间距，默认10 */
@property (nonatomic, assign) CGFloat pageSpace;
/** 未选中页码大小，默认7 */
@property (nonatomic, assign) CGSize normalSize;
/** 已选中页码大小，默认7 */
@property (nonatomic, assign) CGSize selectedSize;

/** 点击页码的回调 */
@property (nonatomic, copy) void (^clickPageBlock) (NSInteger currentPage);

@end

NS_ASSUME_NONNULL_END
