//
//  MailFolderTableViewCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/22.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MailFolderTableViewCellButtonClickDelegate <NSObject>

- (void)mailFolderTableViewCellButtonClick:(NSInteger)tag;

@end

@interface MailFolderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, weak) id<MailFolderTableViewCellButtonClickDelegate> buttonDelegate;
@end
