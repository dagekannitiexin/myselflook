//
//  MailAttachmentViewController.h
//  traderen
//
//  Created by 陈伟杰 on 2017/5/2.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailDetailFileModel.h"
#import "MailHomeMailListCell.h"
@interface MailAttachmentViewController : UIViewController

- (void)getAttachmentCellModel:(MailDetailFileModel *)mailDetailFileModel andMailHomeMailListCell:(MailHomeMailListCell *)mailListCell AndFilePath:(NSString *)filePath;
@end
