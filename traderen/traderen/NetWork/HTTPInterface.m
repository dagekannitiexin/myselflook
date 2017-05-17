//
//  HTTPInterface.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface.h"
#import <MJExtension.h>
#import "MenuList.h"
#import "UserLoginModel.h"
#import "UserDefaultsManager.h"
#import "MBProgressHUD+XQ.h"

#define USER_ID       @"admin"
#define USER_PASSWORD @"96E79218965EB72C92A549DD5A330112"
#define RAN           @"123"
#define SIGN          @"4297F44B13955235245B2497399D7A93"
#define URLSTR        @"120.26.63.189:9898"

NSString * const GetUserInfoSuccess = @"getUserInfoSuccess";
NSString * const GetUserInfoFailed = @"getUserInfoFailed";
NSString * const GetUserInfoError = @"getUserInfoError";

@implementation HTTPInterface
/** 获取用户信息 */
+ (void)getUserInfoWithUserAccount:(NSString *)account MD5Password:(NSString *)password RememberPassWord:(BOOL)rememberPassword {
    NSString *userServerAddress = [UserDefaultsManager getUserServerAddress];
    if (!userServerAddress || userServerAddress.length == 0 || [userServerAddress isEqualToString:@""]) {
        userServerAddress = URLSTR;
    }
    NSDictionary *parameters = @{@"UserId": account,
                                @"Password": password,
                                @"Ran": RAN,
                                @"Sign": SIGN};
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@%@", userServerAddress, @"/api/user/get"];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
//    switch (sessionManager.reachabilityManager.networkReachabilityStatus) {
//        case AFNetworkReachabilityStatusUnknown:
//            [MBProgressHUD showError:@"网络状态未知" toView:nil];
//            return;
//        case AFNetworkReachabilityStatusNotReachable:
//            [MBProgressHUD showError:@"无网络" toView:nil];
//            return;
//            
//        default:
//            break;
//    }
    
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSDictionary *data = responseObject[@"back"];
            UserLoginModel *model = [UserLoginModel mj_objectWithKeyValues:data];
            [model mjSaveToRlm];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [UserLoginModel createOrUpdateInDefaultRealmWithValue:model];
            [realm commitWriteTransaction];
            [[NSNotificationCenter defaultCenter] postNotificationName:GetUserInfoSuccess object:nil userInfo:@{@"rememberPassword": @(rememberPassword), @"userId":@(model.id)}];
        } else {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:GetUserInfoFailed object:nil userInfo:@{@"back": back}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GetUserInfoError object:nil userInfo:@{@"userInfo":error.userInfo[@"NSLocalizedDescription"]}];
        LRLog(@"失败的原因:%@", error.userInfo);
    }];
}

/** 获取用户所有权限 */
+ (void)getUserAllPower {
    NSDictionary *parameters = @{@"UserId": USER_ID,
                               @"Password": USER_PASSWORD,
                               @"Ran": RAN,
                               @"Sign": SIGN,
                               @"Powername":@"ALL"};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", URLSTR, @"/api/user/allpower"];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        LRLog(@"服务器返回的数据:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"失败的原因:%@", error.userInfo);
    }];
    
}


/** 获取用户使用模块 */
+ (void)getUserMenu {
    NSDictionary *parameters = @{@"UserId": USER_ID,
                               @"Password": USER_PASSWORD,
                               @"Ran": RAN,
                               @"Sign": SIGN};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", URLSTR, @"/api/user/getmenu"];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MenuList* menuList = [MenuList mj_objectWithKeyValues:responseObject];
        [menuList mjSaveToRlm];
        menuList.id = 1;
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
//        [realm deleteObjects:[MenuList allObjects]];
        [MenuList createOrUpdateInDefaultRealmWithValue:menuList];
        [realm commitWriteTransaction];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserMenuSuccess" object:nil userInfo:nil];
        LRLog(@"服务器返回的数据:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserMenuFailed" object:nil userInfo:nil];
        LRLog(@"失败的原因:%@", error.userInfo);
    }];
}

/** 获取用户公海分类 */
+ (void)getUserPubLimit {
    NSDictionary *parameters = @{@"UserId": USER_ID,
                               @"Password": USER_PASSWORD,
                               @"Ran": RAN,
                               @"Sign": SIGN};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", URLSTR, @"/api/user/getpublimit"];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LRLog(@"服务器返回的数据:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"失败的原因:%@", error.userInfo);
    }];
}
@end
