//
//  UserDefaultsManager.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/7.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "UserDefaultsManager.h"

@implementation UserDefaultsManager
+ (void)setUserAccount:(NSString * _Nonnull)account {
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"userAccount"];
}

+ (NSString * _Nullable)getUserAccount {
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccount"];
    if (!account || [account isEqualToString:@""]) {
        return nil;
    }
    return account;
}

+ (void)setUserPassword:(NSString *_Nonnull)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"userPassword"];
}

+ (NSString * _Nullable)getUserPassword {
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"];
    if (!password || [password isEqualToString:@""]) {
        return nil;
    }
    return password;
}

+ (void)setUserServerAddress:(NSString *_Nonnull)serverAddress {
    [[NSUserDefaults standardUserDefaults] setObject:serverAddress forKey:@"userServerAddress"];
}

+ (NSString * _Nullable)getUserServerAddress {
    NSString *serverAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"userServerAddress"];
    if (!serverAddress || [serverAddress isEqualToString:@""]) {
        return nil;
    }
    return serverAddress;
}

+ (void)setUserId:(NSNumber *_Nonnull)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
}

+ (NSNumber *_Nullable)getUserId {
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if (!userId) {
        return nil;
    }
    return userId;
}
@end
