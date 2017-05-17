//
//  MailSendViewController.h
//  traderen
//
//  Created by 陈伟杰 on 2017/5/3.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailDetailModel.h"
#import "MailDetailFileModel.h"

typedef NS_ENUM(NSUInteger, MailSendType) {
    MailSendTypeNew,
    MailSendTypeReply,
    MailSendTypeForward
};

@interface MailSendViewController : UIViewController
- (void)recieveTheMailDetailModel:(MailDetailModel *)mailDetailModel AndAttachmentArray:(NSArray<MailDetailFileModel *> *)attachmentArray AndType:(MailSendType)type AndMailBoxId:(NSInteger)mailBoxId;
@end
