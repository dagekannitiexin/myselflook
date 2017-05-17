//
//  HTTPInterface+MailBox.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/11.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface+MailBox.h"
#import "UserDefaultsManager.h"
#import "UserMailBoxList.h"
#import <MJExtension.h>
#import "UserSmartMailBoxChildList.h"
#import "MBProgressHUD+XQ.h"

#define USER_ID       @"admin"
#define USER_PASSWORD @"96E79218965EB72C92A549DD5A330112"
#define RAN           @"123"
#define SIGN          @"4297F44B13955235245B2497399D7A93"
#define URLSTR        @"120.26.63.189:9898"

NSString * const GetUserMailBoxListSuccess = @"getUserMailBoxListSuccess";
NSString * const GetUserMailBoxListFailed = @"getUserMailBoxListFailed";
NSString * const GetUserMailBoxListError = @"getUserMailBoxListError";

NSString * const GetUserSmartMailBoxChildListSuccess = @"getUserSmartMailBoxChildListSuccess";
NSString * const GetUserSmartMailBoxChildListFailed = @"getUserSmartMailBoxChildListFailed";
NSString * const GetUserSmartMailBoxChildListError = @"getUserSmartMailBoxChildListError";

NSString * const GetUserOtherMailBoxChildListSuccess = @"getUserOtherMailBoxChildListSuccess";
NSString * const GetUserOtherMailBoxChildListFailed = @"getUserOtherMailBoxChildListFailed";
NSString * const GetUserOtherMailBoxChildListError = @"getUserOtherMailBoxChildListError";
@implementation HTTPInterface (MailBox)

/** 获取当前用户邮箱列表目录 */
+ (void)getUserMailBoxListWithUserAccount:(NSString *)account AndMD5Password:(NSString *)password {
    NSString *userServerAddress = [UserDefaultsManager getUserServerAddress];
    if (!userServerAddress || userServerAddress.length == 0 || [userServerAddress isEqualToString:@""]) {
        userServerAddress = URLSTR;
    }
    NSDictionary *parameters = @{@"UserId": account,
                                 @"Password": password,
                                 @"Ran": RAN,
                                 @"Sign": SIGN};
    NSString *urlStr = [NSString stringWithFormat:@"http://%@%@", userServerAddress, @"/api/mailbox/Get"];
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
            UserMailBoxList *model = [UserMailBoxList mj_objectWithKeyValues:responseObject];
            [model mjSaveToRlm];
            model.id = 1;
            
            RLMRealm *realm = [RLMRealm defaultRealm];
//            UserMailBoxList *oldBoxList = [UserMailBoxList objectForPrimaryKey:@(1)];
            [realm beginWriteTransaction];
//            if (oldBoxList) {
//                [realm deleteObject:oldBoxList];
//            }
            [UserMailBoxList createOrUpdateInDefaultRealmWithValue:model];
            [realm commitWriteTransaction];
            [[NSNotificationCenter defaultCenter] postNotificationName:GetUserMailBoxListSuccess object:nil userInfo:nil];
        } else {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:GetUserMailBoxListFailed object:nil userInfo:@{@"back": back}];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"%@",error.userInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:GetUserMailBoxListError object:nil userInfo:@{@"userInfo":error.userInfo[@"NSLocalizedDescription"]}];
    }];
}

/** 获取邮箱列表目录子目录 */
+ (void)getUserMailBoxChildListByParentID:(NSString *)parentIDStr AndUserAccount:(NSString *)account AndMD5Password:(NSString *)password {
    NSString *userServerAddress = [UserDefaultsManager getUserServerAddress];
    if (!userServerAddress || userServerAddress.length == 0 || [userServerAddress isEqualToString:@""]) {
        userServerAddress = URLSTR;
    }
    NSDictionary *parameters = @{@"UserId": account,
                                 @"Password": password,
                                 @"Ran": RAN,
                                 @"Sign": SIGN,
                                 @"parentid": parentIDStr};
    NSString *urlStr = [NSString stringWithFormat:@"http://%@%@", userServerAddress, @"/api/mailbox/Getmenu"];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
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
//        LRLog(@"%@",responseObject);
        if ([code isEqualToString:@"0000"]) {
            if ([parentIDStr containsString:@"zn"]) {
                UserSmartMailBoxChildList *childList = [UserSmartMailBoxChildList mj_objectWithKeyValues:responseObject];
                [childList mjSaveToRlm];
                childList.id = 0;
                
                RLMRealm *realm = [RLMRealm defaultRealm];
                UserSmartMailBoxChildList *oldChildList = [UserSmartMailBoxChildList objectForPrimaryKey:@(0)];
//                LRLog(@"%@",oldChildList);
                [realm beginWriteTransaction];
                if (oldChildList) {
                    [realm deleteObject:oldChildList];
                }
                [UserSmartMailBoxChildList createOrUpdateInDefaultRealmWithValue:childList];
                for (UserSmartMailBoxChildListCell *cellmodel in childList.userSmartMailBoxChildList) {
                    LRLog(@"%@",cellmodel);
                }
                [realm commitWriteTransaction];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:GetUserSmartMailBoxChildListSuccess object:nil userInfo:nil];
            } else {
                UserSmartMailBoxChildList *otherChildList = [UserSmartMailBoxChildList mj_objectWithKeyValues:responseObject];
                
                [otherChildList mjSaveToRlm];
                NSString *idStr = [parentIDStr stringByReplacingOccurrencesOfString:@"m_" withString:@""];
                otherChildList.id = [idStr integerValue];
                
                RLMRealm *realm = [RLMRealm defaultRealm];
                UserSmartMailBoxChildList *oldChildList = [UserSmartMailBoxChildList objectForPrimaryKey:@([idStr integerValue])];
                [realm beginWriteTransaction];
                if (oldChildList) {
                    [realm deleteObject:oldChildList];
                }
                [UserSmartMailBoxChildList createOrUpdateInDefaultRealmWithValue:otherChildList];
                for (UserSmartMailBoxChildListCell *cellmodel in otherChildList.userSmartMailBoxChildList) {
                    LRLog(@"%@",cellmodel);
                }
                [realm commitWriteTransaction];
                [[NSNotificationCenter defaultCenter] postNotificationName:GetUserOtherMailBoxChildListSuccess object:nil userInfo:@{@"id": @(otherChildList.id)}];
            }
        } else {
            NSString *back = responseObject[@"back"];
            if ([parentIDStr containsString:@"zn"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:GetUserSmartMailBoxChildListFailed object:nil userInfo:@{@"back": back}];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:GetUserOtherMailBoxChildListFailed object:nil userInfo:@{@"back": back}];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([parentIDStr containsString:@"zn"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GetUserSmartMailBoxChildListError object:nil userInfo:@{@"userInfo":error.userInfo[@"NSLocalizedDescription"]}];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:GetUserOtherMailBoxChildListError object:nil userInfo:@{@"userInfo": error.userInfo[@"NSLocalizedDescription"]}];
        }
    }];
}
@end
