//
//  HTTPInterface+Attachment.h
//  traderen
//
//  Created by 陈伟杰 on 2017/5/2.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "HTTPInterface.h"

UIKIT_EXTERN NSString * const DownloadAttachmentSuccess;
UIKIT_EXTERN NSString * const DownloadAttachmentFailed;
UIKIT_EXTERN NSString * const DownloadAttachmentError;

@interface HTTPInterface (Attachment)
+ (void)downloadAttachmentWithUserAccount:(NSString *)userAccount UserPassword:(NSString *)userPassword AttachmentFileId:(NSInteger)fileId AndPosition:(NSInteger)position;
@end
