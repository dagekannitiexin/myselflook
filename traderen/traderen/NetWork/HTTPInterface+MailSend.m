//
//  HTTPInterface+MailSend.m
//  traderen
//
//  Created by 陈伟杰 on 2017/5/10.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface+MailSend.h"
#import "UserInfoManager.h"

NSString * const CreateMailBeforeSendSuccess = @"createMailBeforeSendSuccess";
NSString * const CreateMailBeforeSendFailed = @"createMailBeforeSendFailed";
NSString * const CreateMailBeforeSendError = @"createMailBeforeSendError";

NSString * const SendMailSuccess = @"sendMailSuccess";
NSString * const SendMailFailed = @"sendMailFailed";
NSString * const SendMailError = @"sendMailError";

#define USER_ID       @"admin"
#define USER_PASSWORD @"96E79218965EB72C92A549DD5A330112"
#define RAN           @"123"
#define SIGN          @"4297F44B13955235245B2497399D7A93"
#define URLSTR        @"120.26.137.208:9898"
//#define URLSTR        @"120.26.63.189:9898"

@implementation HTTPInterface (MailSend)
+ (void)createMailOnServerBeforeSendingWithUserAccount:(NSString *)userAccount
                                        UserPassword:(NSString *)userPassword
                                               Check:(NSInteger)check
                                              MailId:(NSInteger)mailId
                                           MailBoxID:(NSInteger)mailBoxId
                                            FromName:(NSString *)fromName
                                             Subject:(NSString *)subject
                                            SendDate:(NSString *)sendDate
                                            MailType:(NSString *)mailType
                                              ItFrom:(NSString *)itFrom
                                                ItTo:(NSString *)itTo
                                                 Bcc:(NSString *)bcc
                                                  Cc:(NSString *)cc
                                           mailLabel:(NSString *)mailLabel
                                            HtmlBody:(NSString *)htmlBody
                                             BoxBase:(NSString *)boxBase
                                                 Box:(NSString *)box
                                            MailDate:(NSString *)mailDate
{
    NSString *userServerAddress = [UserInfoManager sharedUserInfoManager].userServerAddress;
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/api/mail/Add", userServerAddress];
    NSDictionary *parameters = @{
                                 @"UserId": userAccount,
                                 @"Password": userPassword,
                                 @"Ran": RAN,
                                 @"Sign": SIGN,
                                 @"check": @(check),
                                 @"mailid": @(mailId),
                                 @"MailBoxId":@(mailBoxId),
                                 @"FromName":fromName,
                                 @"Subject":subject,
                                 @"SendDate":sendDate,
                                 @"MailType":mailType,
                                 @"itFrom":itFrom,
                                 @"itTo":itTo,
                                 @"cc":cc,
                                 @"Bcc":bcc,
                                 @"MailLabel":mailLabel,
                                 @"HtmlBody":htmlBody,
                                 @"BoxBase":boxBase,
                                 @"Box":box,
                                 @"MailDate":mailDate
                                 };
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LRLog(@"%@",responseObject);
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CreateMailBeforeSendSuccess object:nil userInfo:nil];
        } else {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:CreateMailBeforeSendFailed object:nil userInfo:@{@"back": back}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *userInfo = error.userInfo[@"NSLocalizedDescription"];
        [[NSNotificationCenter defaultCenter] postNotificationName:CreateMailBeforeSendError object:nil userInfo:@{@"userInfo": userInfo}];
    }];
}

+ (void)createMailOnServerBeforeSendingWithParameters:(NSMutableDictionary *)parameters {
    parameters[@"Ran"] = RAN;
    parameters[@"Sign"] = SIGN;
    NSDictionary *realParameters = [parameters copy];
//    NSString *userServerAddress = [UserInfoManager sharedUserInfoManager].userServerAddress;
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/api/mail/Add", @"120.26.137.208:9898"];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager POST:urlStr parameters:realParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LRLog(@"%@",responseObject);
        NSString *code = responseObject[@"code"];
        NSNumber *beCreateMailId = responseObject[@"back"][@"id"];
        NSString *msg = responseObject[@"back"][@"msg"];
        LRLog(@"%@",msg);
        if ([code isEqualToString:@"0000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CreateMailBeforeSendSuccess object:nil userInfo:@{@"beCreateMailId":beCreateMailId}];
        } else {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:CreateMailBeforeSendFailed object:nil userInfo:@{@"back": back}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *userInfo = error.userInfo[@"NSLocalizedDescription"];
        [[NSNotificationCenter defaultCenter] postNotificationName:CreateMailBeforeSendError object:nil userInfo:@{@"userInfo": userInfo}];
    }];
}

+ (void)sendMailWithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userPassword mailId:(NSInteger)mailId {
    NSString *userServerAddress = [UserInfoManager sharedUserInfoManager].userServerAddress;
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/api/mail/send", userServerAddress];
    NSDictionary *parameters = @{@"UserId": userAccount,
                                 @"Password": userPassword,
                                 @"Ran": RAN,
                                 @"Sign": SIGN,
                                 @"mailid": @(mailId)};
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = responseObject[@"code"];
        NSDictionary *back = responseObject[@"back"];
        if ([code isEqualToString:@"0000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SendMailSuccess object:nil userInfo:@{@"back":back}];
        } else {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SendMailFailed object:nil userInfo:@{@"back": back}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *userInfo = error.userInfo[@"NSLocalizedDescription"];
        [[NSNotificationCenter defaultCenter] postNotificationName:SendMailError object:nil userInfo:@{@"userInfo": userInfo}];
    }];
}
@end
