//
//  HTTPInterface+Mail.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface+Mail.h"
#import "UserInfoManager.h"
#import "MailHomeMailList.h"
#import <MJExtension.h>
#import "MailDetailModel.h"

#define USER_ID       @"admin"
#define USER_PASSWORD @"96E79218965EB72C92A549DD5A330112"
#define RAN           @"123"
#define SIGN          @"4297F44B13955235245B2497399D7A93"
#define URLSTR        @"120.26.137.208:9898"
//#define URLSTR        @"120.26.63.189:9898"

NSString * const GetMailHomeMailListSuccess = @"getMailHomeMailListSuccess";
NSString * const GetMailHomeMailListFailed = @"getMailHomeMailListFailed";
NSString * const GetMailHomeMailListError = @"getMailHomeMailListError";

NSString * const MailStateChangeSuccess = @"mailStateChangeSuccess";
NSString * const MailStateChangeFailed = @"mailStateChangeFailed";
NSString * const MailStateChangeError = @"mailStateChangeError";

NSString * const MailMoveSuccess = @"mailMoveSuccess";
NSString * const MailMoveFailed = @"mailMoveFailed";
NSString * const MailMoveError = @"mailMoveError";

NSString * const GetMailDetailSuccess = @"getMailDetailSuccess";
NSString * const GetMailDetailFailed = @"getMailDetailFailed";
NSString * const GetMailDetailError = @"getMailDetailError";

@implementation HTTPInterface (Mail)
/** 根据邮箱ID，请求第几页，每页几个数据，以及Act参数来请求主页的cellModel */
+ (void)getUserMailListWithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userMD5Password BoxID:(NSInteger)boxID PageIndex:(NSInteger)pageIndex PageMax:(NSInteger)pageMax AndAct:(NSString *)actStr{
    NSString *userServerAddress = [UserInfoManager sharedUserInfoManager].userServerAddress;
    NSDictionary *parameters = @{@"UserId": userAccount,
                                 @"Password": userMD5Password,
                                 @"Ran": RAN,
                                 @"Sign": SIGN,
                                 @"Boxid": @(boxID),
                                 @"pageindex": @(pageIndex),
                                 @"pagemax": @(pageMax),
                                 @"Act": actStr};
    NSString *urlStr = [NSString stringWithFormat:@"http://%@%@", userServerAddress, @"/api/mail/Getlist"];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"]) {
            MailHomeMailList *model = [MailHomeMailList mj_objectWithKeyValues:responseObject[@"back"]];
            [model mjSaveToRlm];
//            for (MailHomeMailListCell *cellModel in model.list) {
//                LRLog(@"aaaaaaa===%@========",cellModel);
//            }
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [MailHomeMailList createOrUpdateInDefaultRealmWithValue:model];
            for (MailHomeMailListCell *cellModel in model.mailList) {
                [MailHomeMailListCell createOrUpdateInDefaultRealmWithValue:cellModel];
            }
            [realm commitWriteTransaction];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GetMailHomeMailListSuccess object:nil userInfo:@{@"index": @(pageIndex)}];
        } else {
            NSString *back = responseObject[@"back"];
            LRLog(@"%@",back);
            [[NSNotificationCenter defaultCenter] postNotificationName:GetMailHomeMailListFailed object:nil userInfo:@{@"back": back}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"失败的原因:%@", error.userInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:GetMailHomeMailListError object:nil userInfo:@{@"userInfo":error.userInfo[@"NSLocalizedDescription"]}];
    }];
}

/** 删除，置顶，红旗，星标，已读的接口 */
+ (void)changedMailStateWithUserAcount:(NSString *)userAccount UserPassword:(NSString *)userMD5Password ByMailIDString:(NSString *)mailIDString AndTrue:(NSString *)is AndTypeString:(NSString *)typeString IndexPathArray:(NSArray<NSIndexPath *> *)indexPathArray {
    NSString *userServerAddress = [UserInfoManager sharedUserInfoManager].userServerAddress;
    NSDictionary *parameters = @{@"UserId": userAccount,
                                 @"Password": userMD5Password,
                                 @"Ran": RAN,
                                 @"Sign": SIGN,
                                 @"mailid": mailIDString,
                                 @"is": is};
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/api/mail/%@", userServerAddress, typeString];
    LRLog(@"%@", urlStr);
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        LRLog(@"服务器返回的数据:%@", responseObject);
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:MailStateChangeSuccess object:nil userInfo:@{@"back": back, @"typeString":typeString, @"indexPathArray":indexPathArray,@"isTrue":is}];
        } else {
            NSString *back = responseObject[@"back"];
            LRLog(@"%@",back);
            [[NSNotificationCenter defaultCenter] postNotificationName:MailStateChangeFailed object:nil userInfo:@{@"back": back}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"失败的原因:%@", error.userInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:MailStateChangeError object:nil userInfo:@{@"userInfo":error.userInfo[@"NSLocalizedDescription"]}];
    }];
}

/** 邮件移动接口 */
+ (void)moveMailToBoxID:(NSInteger)boxID FromMailID:(NSString *)mailIDStr RootID:(NSInteger)rootID OrBoxStr:(NSString *)boxStr WithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userMD5Password IndexPathArray:(NSArray<NSIndexPath *> *)indexPathArray {
    NSString *userServerAddress = [UserInfoManager sharedUserInfoManager].userServerAddress;
    
    NSDictionary *parameters = nil;
    if (!boxStr) {
        parameters = @{@"UserId": userAccount,
                       @"Password": userMD5Password,
                       @"Ran": RAN,
                       @"Sign": SIGN,
                       @"mailboxid": @(boxID),
                       @"mailid": mailIDStr,
                       @"Rootid": @(rootID)};
    } else {
        parameters = @{@"UserId": userAccount,
                       @"Password": userMD5Password,
                       @"Ran": RAN,
                       @"Sign": SIGN,
                       @"mailboxid": @(boxID),
                       @"mailid": mailIDStr,
                       @"Box": boxStr
                       };
    }
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/api/mail/move", userServerAddress];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LRLog(@"%@",responseObject);
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:MailMoveSuccess object:nil userInfo:@{@"back": back,@"indexPath": indexPathArray}];
        } else {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:MailMoveFailed object:nil userInfo:@{@"back": back}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MailMoveError object:nil userInfo:@{@"userInfo": error.userInfo[@"NSLocalizedDescription"]}];
    }];
}

/** 获取邮件详情接口 */
+ (void)getMailDetailByMailID:(NSInteger)mailID IndexPath:(NSIndexPath *)indexPath UserAccount:(NSString *)userAccount UserPassword:(NSString *)userMD5Password {
    NSString *userServerAddress = [UserInfoManager sharedUserInfoManager].userServerAddress;
    NSDictionary *parameters = @{@"UserId": userAccount,
                                 @"Password": userMD5Password,
                                 @"Ran": RAN,
                                 @"Sign": SIGN,
                                 @"mailid": @(mailID)};
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/api/mail/Get", userServerAddress];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LRLog(@"%@",responseObject[@"back"][@"htmlbody"]);
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"]) {
            MailDetailModel *model = [MailDetailModel mj_objectWithKeyValues:responseObject[@"back"]];
            [model mjSaveToRlm];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [MailDetailModel createOrUpdateInDefaultRealmWithValue:model];
            for (MailDetailModel *cellModel in model.fileModels) {
                [MailDetailFileModel createOrUpdateInDefaultRealmWithValue:cellModel];
            }
            [realm commitWriteTransaction];
            [[NSNotificationCenter defaultCenter] postNotificationName:GetMailDetailSuccess object:nil userInfo:@{@"mailID": @(mailID), @"indexPath": indexPath}];
        } else {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:GetMailDetailFailed object:nil userInfo:@{@"back": back}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GetMailDetailError object:nil userInfo:@{@"userInfo": error.userInfo[@"NSLocalizedDescription"]}];
    }];
}
@end
