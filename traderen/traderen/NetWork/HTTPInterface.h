//
//  HTTPInterface.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

UIKIT_EXTERN NSString * const GetUserInfoSuccess;
UIKIT_EXTERN NSString * const GetUserInfoFailed;
UIKIT_EXTERN NSString * const GetUserInfoError;

@interface HTTPInterface : NSObject
/** 获取用户信息 */
+ (void)getUserInfoWithUserAccount:(NSString *)account MD5Password:(NSString *)password RememberPassWord:(BOOL)rememberPassword;

/** 获取用户所有权限 */
+ (void)getUserAllPower;

/** 获取用户使用模块 */
+ (void)getUserMenu;

/** 获取用户公海分类 */
+ (void)getUserPubLimit;

@end
