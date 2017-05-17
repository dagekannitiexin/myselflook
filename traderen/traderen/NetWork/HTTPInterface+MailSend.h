//
//  HTTPInterface+MailSend.h
//  traderen
//
//  Created by 陈伟杰 on 2017/5/10.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface.h"

UIKIT_EXTERN NSString * const CreateMailBeforeSendSuccess;
UIKIT_EXTERN NSString * const CreateMailBeforeSendFailed;
UIKIT_EXTERN NSString * const CreateMailBeforeSendError;

UIKIT_EXTERN NSString * const SendMailSuccess;
UIKIT_EXTERN NSString * const SendMailFailed;
UIKIT_EXTERN NSString * const SendMailError;

@interface HTTPInterface (MailSend)
//发送邮件之前先创建
+ (void)createMailOnServerBeforeSendingWithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userPassword Check:(NSInteger)check MailId:(NSInteger)mailId MailBoxID:(NSInteger)mailBoxId FromName:(NSString *)fromName Subject:(NSString *)subject SendDate:(NSString *)sendDate MailType:(NSString *)mailType ItFrom:(NSString *)itFrom ItTo:(NSString *)itTo Bcc:(NSString *)bcc Cc:(NSString *)cc mailLabel:(NSString *)mailLabel HtmlBody:(NSString *)htmlBody BoxBase:(NSString *)boxBase Box:(NSString *)box MailDate:(NSString *)mailDate;

+ (void)createMailOnServerBeforeSendingWithParameters:(NSMutableDictionary *)parameters;

//发送邮件
+ (void)sendMailWithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userPassword mailId:(NSInteger)mailId;
@end
