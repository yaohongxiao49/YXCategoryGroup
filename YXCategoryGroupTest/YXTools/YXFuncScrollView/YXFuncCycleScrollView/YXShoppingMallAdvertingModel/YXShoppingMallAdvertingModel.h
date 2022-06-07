//
//  YXShoppingMallAdvertingModel.h
//  MuchProj
//
//  Created by Augus on 2021/12/14.
//

//#import "JSONModel.h"
#import "YXShoppingMallCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YXShoppingMallAdvertingJumpModel;
@class YXShoppingMallAdvertingJumpModel;

@interface YXShoppingMallAdvertingModel : NSObject//JSONModel

/**
 * 跳转id
 * 1：商品，2：福袋，3：搜索，4：分类，5/9：领券中心(二级页)/福利中心(一级页)，6：首页，7：直购商城，8：个人中心
 */
@property (nonatomic, assign) NSInteger jumpType;
/** 显示的广告图 */
@property (nonatomic, copy) NSString *advertisementImgUrl;
/** 显示的广告标题 */
@property (nonatomic, copy) NSString *title;
/** h5跳转页 */
@property (nonatomic, copy) NSString *htmlUrl;
/** 跳转数据 */
@property (nonatomic, strong) YXShoppingMallAdvertingJumpModel *jumpValueObj;

@end

/** 跳转数据 */
@interface YXShoppingMallAdvertingJumpModel : NSObject;//JSONModel

/** 搜索关键字 */
@property (nonatomic, copy) NSString *value;
/** 福袋id */
@property (nonatomic, copy) NSString *luckyBagId;
/** 商品id */
@property (nonatomic, copy) NSString *shopId;
/** 分类数据 */
@property (nonatomic, strong) YXShoppingMallCategoryModel *classifyId;
/** 跳转外链链接 */
@property (nonatomic, copy) NSString *withinUrl;

@end

NS_ASSUME_NONNULL_END
