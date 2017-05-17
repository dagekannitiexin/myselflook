//
//  HTTPInterface+Attachment.m
//  traderen
//
//  Created by 陈伟杰 on 2017/5/2.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface+Attachment.h"
#import "UserInfoManager.h"

#define USER_ID       @"admin"
#define USER_PASSWORD @"96E79218965EB72C92A549DD5A330112"
#define RAN           @"123"
#define SIGN          @"4297F44B13955235245B2497399D7A93"
#define URLSTR        @"120.26.137.208:9898"
//#define URLSTR        @"120.26.63.189:9898"

NSString * const DownloadAttachmentSuccess = @"downloadAttachmentSuccess";
NSString * const DownloadAttachmentFailed = @"downloadAttachmentFailed";
NSString * const DownloadAttachmentError = @"downloadAttachmentError";

@implementation HTTPInterface (Attachment)
+ (void)downloadAttachmentWithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userPassword AttachmentFileId:(NSInteger)fileId AndPosition:(NSInteger)position {
    LRLog(@"当前线程为%@",[NSThread currentThread]);
    NSString *userServerAddress = [UserInfoManager sharedUserInfoManager].userServerAddress;
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/api/file/Download", userServerAddress];
    NSDictionary *parameters = @{
                                 @"UserId": userAccount,
                                 @"Password": userPassword,
                                 @"Ran": RAN,
                                 @"Sign": SIGN,
                                 @"fileid": @(fileId),
                                 @"position": @(position)
                                 };
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"]) {
//            LRLog(@"%@",responseObject);
            NSString *data = responseObject[@"back"][@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:DownloadAttachmentSuccess object:nil userInfo:@{@"data": data}];
        } else {
            NSString *back = responseObject[@"back"];
            [[NSNotificationCenter defaultCenter] postNotificationName:DownloadAttachmentFailed object:nil userInfo:@{@"back": back}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *userInfo = error.userInfo[@"NSLocalizedDescription"];
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadAttachmentError object:nil userInfo:@{@"userInfo": userInfo}];
    }];
}
@end
