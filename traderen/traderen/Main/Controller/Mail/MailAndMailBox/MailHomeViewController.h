//
//  MailHomeViewController.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/10.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSmartMailBoxChildListCell.h"

@protocol MailHomeTableViewCellClickDelegate <NSObject>

- (void)MailHomeTableViewCellClickWithBoxID:(NSInteger)boxID AndCellModel:(UserSmartMailBoxChildListCell *)cellModel;

@end

@interface MailHomeViewController : UIViewController
@property (nonatomic, weak) id<MailHomeTableViewCellClickDelegate> cellDelegate;
@end
