//
//  MailFolderTableViewCell.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/22.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailFolderTableViewCell.h"

@implementation MailFolderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectButtonClick:(UIButton *)sender {
    if ([self.buttonDelegate respondsToSelector:@selector(mailFolderTableViewCellButtonClick:)]) {
        [self.buttonDelegate mailFolderTableViewCellButtonClick:sender.tag];
    }
}
@end
