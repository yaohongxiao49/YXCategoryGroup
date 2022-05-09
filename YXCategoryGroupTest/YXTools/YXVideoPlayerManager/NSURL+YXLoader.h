//
//  NSURL+YXLoader.h
//  MuchProj
//
//  Created by Augus on 2022/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (YXLoader)

/** 自定义scheme */
- (NSURL *)customSchemeURL;

/** 还原scheme */
- (NSURL *)originalSchemeURL;

@end

NS_ASSUME_NONNULL_END
