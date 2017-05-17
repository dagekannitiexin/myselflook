//
//  MailFolderViewController.h
//  traderen
//
//  Created by 陈伟杰 on 2017/5/3.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailFolderCell.h"

typedef NS_ENUM(NSUInteger, MailFolderLevel) {
    MailFolderLevelSameLevel,
    MailFolderLevelNextLevel,
    MailFolderLevelPreviousLevel
};

@interface MailFolderViewController : UIViewController

- (void)getMailFolderChildArray:(NSArray<MailFolderCell *> *)mailFolderChildArray OldMailFolderChildArrayArray:(NSMutableArray<NSArray<MailFolderCell *> *> *)oldMailFolderChildArrayArray AndFolderLevel:(NSInteger)folderLevel;

@end
