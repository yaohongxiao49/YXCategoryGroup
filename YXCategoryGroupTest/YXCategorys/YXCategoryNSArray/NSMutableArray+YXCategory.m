//
//  NSMutableArray+YXCategory.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "NSMutableArray+YXCategory.h"

@implementation NSMutableArray (YXCategory)

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

#pragma mark - 去除重复数据
+ (NSMutableArray *)statisticalRepeatNum:(NSMutableArray *)arr {
    
    NSMutableArray *amountArr = [[NSMutableArray alloc] init];
    NSSet *set = [NSSet setWithArray:(NSArray *)arr];

    for (NSString *setStr in set) {
        //需要去掉的元素数组
//        NSMutableArray *filteredArr = [[NSMutableArray alloc] initWithObjects:setStr, nil];

//        NSMutableArray *dataArr = arr;
//        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", filteredArr];
        //过滤数组
//        NSArray *reslutFilteredArr = [dataArr filteredArrayUsingPredicate:filterPredicate];
//        int number = (int)(dataArr.count - reslutFilteredArr.count);
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:setStr forKey:@"title"];
//        [dic setObject:@(number) forKey:@"count"];
        [amountArr addObject:setStr];
    }
    
    return amountArr;
}

#pragma mark - 排序
+ (NSArray *)sortingByArr:(NSArray *)arr type:(NSComparisonResult)type {
    
    NSArray *resultArray = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSNumber *number1 = obj1;
        NSNumber *number2 = obj2;
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == type;
    }];
    return resultArray;
}

@end
