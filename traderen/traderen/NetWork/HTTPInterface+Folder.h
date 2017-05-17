//
//  HTTPInterface+Folder.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/21.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface.h"

UIKIT_EXTERN NSString * const GetUserAllFoldersSuccess;
UIKIT_EXTERN NSString * const GetUserAllFoldersFailed;
UIKIT_EXTERN NSString * const GetUserAllFoldersError;

@interface HTTPInterface (Folder)
/** 获取用户所有文件夹 */
+ (void)getUserAllFoldersWithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userPassword;
@end
