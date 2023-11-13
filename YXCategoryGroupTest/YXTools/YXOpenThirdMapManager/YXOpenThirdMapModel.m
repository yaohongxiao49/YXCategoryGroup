//
//  YXOpenThirdMapModel.m
//  MuchProj
//
//  Created by Augus on 2023/11/13.
//

#import "YXOpenThirdMapModel.h"

@implementation YXOpenThirdMapModel

+ (JSONKeyMapper *)keyMapper {
    
    //属性名作为key, 字典中的key名 作为 value
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ident":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return true;
}

@end
