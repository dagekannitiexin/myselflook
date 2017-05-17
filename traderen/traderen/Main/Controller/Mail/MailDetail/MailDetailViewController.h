//
//  MailDetailViewController.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/24.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailHomeMailList.h"

@interface MailDetailViewController : UIViewController

- (void)recieveTheMailListArray:(NSArray<MailHomeMailListCell *> *)mailListArray AndAct:(NSString *)act;

@end
