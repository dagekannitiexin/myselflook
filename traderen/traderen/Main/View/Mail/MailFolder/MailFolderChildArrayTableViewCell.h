//
//  MailFolderChildArrayTableViewCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/5/4.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MailFolderChildArrayTableViewCellButtonClickDelegate <NSObject>

- (void)mailFolderChildArrayTableViewCellButtonClick:(NSInteger)tag;

@end

@interface MailFolderChildArrayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *mailFolderNameLabel;
@property (nonatomic, weak) id<MailFolderChildArrayTableViewCellButtonClickDelegate> buttonDelegate;
@end
