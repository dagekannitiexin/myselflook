//
//  HTTPInterface+Mail.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface.h"
#import <AFNetworking.h>

UIKIT_EXTERN NSString * const GetMailHomeMailListSuccess;
UIKIT_EXTERN NSString * const GetMailHomeMailListFailed;
UIKIT_EXTERN NSString * const GetMailHomeMailListError;

UIKIT_EXTERN NSString * const MailStateChangeSuccess;
UIKIT_EXTERN NSString * const MailStateChangeFailed;
UIKIT_EXTERN NSString * const MailStateChangeError;

UIKIT_EXTERN NSString * const MailMoveSuccess;
UIKIT_EXTERN NSString * const MailMoveFailed;
UIKIT_EXTERN NSString * const MailMoveError;

UIKIT_EXTERN NSString * const GetMailDetailSuccess;
UIKIT_EXTERN NSString * const GetMailDetailFailed;
UIKIT_EXTERN NSString * const GetMailDetailError;

@interface HTTPInterface (Mail)
/** 根据邮箱ID，请求第几页，每页几个数据，参数来请求主页的cellModel */
+ (void)getUserMailListWithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userMD5Password BoxID:(NSInteger)boxID PageIndex:(NSInteger)pageIndex PageMax:(NSInteger)pageMax AndAct:(NSString *)actStr;

/** 删除，置顶，红旗，星标，已读的接口 */
+ (void)changedMailStateWithUserAcount:(NSString *)userAccount UserPassword:(NSString *) userMD5Password ByMailIDString:(NSString *)mailIDString AndTrue:(NSString *)is AndTypeString:(NSString *)typeString IndexPathArray:(NSArray<NSIndexPath *> *)indexPathArray;

/** 邮件移动接口 */
+ (void)moveMailToBoxID:(NSInteger)boxID FromMailID:(NSString *)mailIDStr RootID:(NSInteger)rootID OrBoxStr:(NSString *)boxStr WithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userMD5Password IndexPathArray:(NSArray<NSIndexPath *> *)indexPathArray;

/** 获取邮件详情接口 */
+ (void)getMailDetailByMailID:(NSInteger)mailID IndexPath:(NSIndexPath *)indexPath UserAccount:(NSString *)userAccount UserPassword:(NSString *)userMD5Password;
@end
