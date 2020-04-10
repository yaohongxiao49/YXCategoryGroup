//
//  YXToolAppBaseMessage.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXToolAppBaseMessage.h"
#import "YXToolLocalSaveBySqlite.h"

#define kYXToolSqliteUserDefaultHandle [NSUserDefaults standardUserDefaults]

#define userInfos @"userInfos"
#define userNames @"userNames"
#define userPassWords @"userPassWords"

@implementation YXToolAppBaseMessage

+ (id)sharedInstance {
    
    static YXToolAppBaseMessage *yxBaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        yxBaseManager = [YXToolAppBaseMessage new];
    });
    
    return yxBaseManager;
}

+ (void)synchronize {
    
    [kYXToolSqliteUserDefaultHandle synchronize];
}

+ (void)registerUserDefaults {
    
    YXToolAppBaseMessage *defaults = [YXToolAppBaseMessage sharedInstance];
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *settingVersion = [defaults versionString];
    if (nil == settingVersion) { //初次使用应用
        [defaults setVersionString:bundleVersion];
        defaults.appState = PublicAppStateFirstUse;
    }
    else if (![bundleVersion isEqualToString:settingVersion]) { //通过版本和bundleVersion进行匹配来判断是否进行了更新
        [defaults setVersionString:bundleVersion];
        defaults.appState = PublicAppStateUpgrade;
    }
    else { //正常情况
        defaults.appState = PublicAppStateNormal;
    }
    [YXToolAppBaseMessage synchronize];
}

#pragma mark - saved key&value
- (NSString *)versionString {
    
    return [YXToolLocalSaveBySqlite yxReadUserDefaultsByKey:@"PublicVersionString"];
}

- (void)setVersionString:(NSString *)versionString {
    
    return [YXToolLocalSaveBySqlite yxSaveUserDefaultsByValue:versionString Key:@"PublicVersionString"];
}

- (NSString *)username {
    
    return [YXToolLocalSaveBySqlite yxReadKeychainsByKey:userNames keychainKey:userInfos];
}

- (void)setUsername:(NSString *)username {
    
    [YXToolLocalSaveBySqlite yxSaveKeychainsByValue:username dicKey:userNames keychainKey:userInfos];
}

- (NSString *)password {
    
    return [YXToolLocalSaveBySqlite yxReadKeychainsByKey:userPassWords keychainKey:userInfos];
}

- (void)setPassword:(NSString *)password {
    
    [YXToolLocalSaveBySqlite yxSaveKeychainsByValue:password dicKey:userPassWords keychainKey:userInfos];
}

- (BOOL)rememberLogin {
    
    return [kYXToolSqliteUserDefaultHandle boolForKey:@"PublicRememberLogin"];
}

- (void)setRememberLogin:(BOOL)rememberLogin {
    
    [kYXToolSqliteUserDefaultHandle setBool:rememberLogin forKey:@"PublicRememberLogin"];
}

- (BOOL)boolNotInHomeFirstUse {
    
    return [kYXToolSqliteUserDefaultHandle boolForKey:@"BoolNotInHomeFirstUse"];
}

- (void)setBoolNotInHomeFirstUse:(BOOL)boolNotInHomeFirstUse {
    
    [kYXToolSqliteUserDefaultHandle setBool:boolNotInHomeFirstUse forKey:@"BoolNotInHomeFirstUse"];
}

@end
