//
//  YXToolAppBaseMessage.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXToolLocalSaveBySqlite.h"

/** 应用使用状态 */
typedef NS_ENUM(NSInteger, PublicAppState) {
    /** 通常情况 */
    PublicAppStateNormal = 0,
    /** 首次启动 */
    PublicAppStateFirstUse,
    /** 升级后首次启动 */
    PublicAppStateUpgrade,
};

NS_ASSUME_NONNULL_BEGIN

@interface YXToolAppBaseMessage : NSObject

/** 0，普通情况；1，初次启用；2，系统更新(该值不做保存，每次启动临时使用) */
@property (nonatomic, assign) PublicAppState appState;
/** 版本号（用以区分是否发生更新） */
@property (nonatomic, copy) NSString *versionString;
/** 登录名 */
@property (nonatomic, copy) NSString *username;
/** 登录密码 */
@property (nonatomic, copy) NSString *password;
/** YES:记住登录信息 */
@property (nonatomic, assign) BOOL rememberLogin;
/** 是否未进入首页的首次启动 */
@property (nonatomic, assign) BOOL boolNotInHomeFirstUse;

+ (id)sharedInstance;
+ (void)synchronize;
/** 判断App应用使用状态 */
+ (void)registerUserDefaults;

@end

NS_ASSUME_NONNULL_END
