//
//  HTTPInterface+MailBox.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/11.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface.h"
#import <AFNetworking.h>

UIKIT_EXTERN NSString * const GetUserMailBoxListSuccess;
UIKIT_EXTERN NSString * const GetUserMailBoxListFailed;
UIKIT_EXTERN NSString * const GetUserMailBoxListError;

UIKIT_EXTERN NSString * const GetUserSmartMailBoxChildListSuccess;
UIKIT_EXTERN NSString * const GetUserSmartMailBoxChildListFailed;
UIKIT_EXTERN NSString * const GetUserSmartMailBoxChildListError;

UIKIT_EXTERN NSString * const GetUserOtherMailBoxChildListSuccess;
UIKIT_EXTERN NSString * const GetUserOtherMailBoxChildListFailed;
UIKIT_EXTERN NSString * const GetUserOtherMailBoxChildListError;
@interface HTTPInterface (MailBox)
/** 获取当前用户邮箱列表目录 */
+ (void)getUserMailBoxListWithUserAccount:(NSString *)account AndMD5Password:(NSString *)password;

/** 获取邮箱列表目录子目录 */
+ (void)getUserMailBoxChildListByParentID:(NSString *)parentIDStr AndUserAccount:(NSString *)account AndMD5Password:(NSString *)password;
@end
