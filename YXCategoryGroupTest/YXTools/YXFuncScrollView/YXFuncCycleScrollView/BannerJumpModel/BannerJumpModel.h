//
//  YXShoppingMallAdvertingModel.h
//  MuchProj
//
//  Created by Augus on 2021/12/14.
//

//#import "JSONModel.h"
#import "BannerJumpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerJumpModel : NSObject//JSONModel

@property (nonatomic, copy) NSString *ident;
@property (nonatomic, copy) NSString *createTime;
/** 备注 */
@property (nonatomic, copy) NSString *remark;
/** 图片链接 */
@property (nonatomic, copy) NSString *imgUrl;
/** 跳转类型(1 = 无跳转 2 = 内链 3 = 外链) */
@property (nonatomic, assign) NSInteger jumpType;
/** 跳转 */
@property (nonatomic, copy) NSString *jumpUrl;
/** 优先级排序 */
@property (nonatomic, assign) NSInteger sorted;
/** 是否显示 0否 1是 */
@property (nonatomic, assign) NSInteger display;

/** 展示位置(1=首页 2=广场) */
@property (nonatomic, assign) NSInteger type;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 标题 */
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
