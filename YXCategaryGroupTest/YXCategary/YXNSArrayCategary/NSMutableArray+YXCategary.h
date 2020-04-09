//
//  NSMutableArray+YXCategary.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (YXCategary)

/**
 * 转模型
 * @param result 需要转换的参数（数组）
 * @param className 需要转换的对应模型名
 * @param valuePath 需要转换的对应地址（一般跟"className"一致）
 */
+ (NSArray *)yxConversionToModelByResult:(id)result
                               className:(NSString *)className
                               valuePath:(NSString *)valuePath;

@end

NS_ASSUME_NONNULL_END
