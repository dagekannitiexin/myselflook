//
//  UserDefaultsManager.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/7.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject
+ (void)setUserAccount:(NSString *_Nonnull)account;
+ (NSString * _Nullable)getUserAccount;

+ (void)setUserPassword:(NSString *_Nonnull)password;
+ (NSString * _Nullable)getUserPassword;

+ (void)setUserServerAddress:(NSString *_Nonnull)serverAddress;
+ (NSString * _Nullable)getUserServerAddress;

+ (void)setUserId:(NSNumber * _Nonnull)userId;
+ (NSNumber *_Nullable)getUserId;
@end
