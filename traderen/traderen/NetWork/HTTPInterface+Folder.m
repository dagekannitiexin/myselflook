//
//  HTTPInterface+Folder.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/21.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface+Folder.h"
#import "UserInfoManager.h"
#import "MailFolderCell.h"
#import <MJExtension.h>

#define USER_ID       @"admin"
#define USER_PASSWORD @"96E79218965EB72C92A549DD5A330112"
#define RAN           @"123"
#define SIGN          @"4297F44B13955235245B2497399D7A93"
#define URLSTR        @"120.26.137.208:9898"
//#define URLSTR        @"120.26.63.189:9898"

NSString * const GetUserAllFoldersSuccess = @"getUserAllFoldersSuccess";
NSString * const GetUserAllFoldersFailed = @"getUserAllFoldersFailed";
NSString * const GetUserAllFoldersError = @"getUserAllFoldersError";

@implementation HTTPInterface (Folder)
/** 获取用户所有文件夹 */
+ (void)getUserAllFoldersWithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userPassword {
    NSString *userServerAddress = [UserInfoManager sharedUserInfoManager].userServerAddress;
    NSDictionary *parameters = @{@"UserId": userAccount,
                                 @"Password": userPassword,
                                 @"Ran": RAN,
                                 @"Sign": SIGN};
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/api/Folder/Get",userServerAddress];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *cellArray = responseObject[@"back"];
//            LRLog(@"%@",responseObject[@"back"]);
            NSArray<MailFolderCell *> *mailFolderCell = [MailFolderCell mj_objectArrayWithKeyValuesArray:cellArray];
            
            for (MailFolderCell *cellModel in mailFolderCell) {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    [MailFolderCell createOrUpdateInDefaultRealmWithValue:cellModel];
                }];
                LRLog(@"%@", cellModel);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:GetUserAllFoldersSuccess object:nil userInfo:nil];
        } else {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:GetUserAllFoldersFailed object:nil userInfo:@{@"back": back}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *userInfo = error.userInfo[@"NSLocalizedDescription"];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetUserAllFoldersError object:nil userInfo:@{@"userInfo": userInfo}];
    }];
}
@end
