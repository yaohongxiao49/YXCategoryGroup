//
//  YXShoppingMallCategoryModel.h
//  MuchProj
//
//  Created by Augus on 2021/12/7.
//

//#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXShoppingMallCategoryModel : NSObject//JSONModel

/** 分类id */
@property (nonatomic, copy) NSString *ident;
/** 上级 */
@property (nonatomic, assign) NSInteger parentId;
/** 分类名 */
@property (nonatomic, copy) NSString *name;
/** 分类图片 */
@property (nonatomic, copy) NSString *img;
/** 是否是推荐 */
@property (nonatomic, assign) BOOL isRecommend;

@end

NS_ASSUME_NONNULL_END
