//
//  NSMutableArray+YXCategary.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "NSMutableArray+YXCategary.h"

@implementation NSMutableArray (YXCategary)

#pragma mark - 转换"className"模型
+ (NSArray *)yxConversionToModelByResult:(id)result className:(NSString *)className valuePath:(NSString *)valuePath {
    
    NSMutableArray *models = [NSMutableArray array];
    Class dataClass = NSClassFromString(className);
    if ([result isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in result) {
            id model = [[dataClass alloc] initWithDictionary:dic];
            [models addObject:model];
        }
    }
    else if ([result isKindOfClass:[NSDictionary class]]) {
        if (valuePath.length == 0) {
            id model = [[dataClass alloc] initWithDictionary:result];
            [models addObject:model];
        }
        else {
            NSArray *paths = [valuePath componentsSeparatedByString:@"."];
            NSDictionary *dic = result;
            for (int i = 0; i < paths.count - 1; i++) {
                NSString *subPath = paths[i];
                dic = dic[subPath];
            }
            for (NSDictionary *dict in dic[paths.lastObject]) {
                id model = [[dataClass alloc] initWithDictionary:dict];
                [models addObject:model];
            }
        }
    }
    
    return models;
}

@end
