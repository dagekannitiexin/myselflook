//
//  MailFolderChildArrayTableViewCell.m
//  traderen
//
//  Created by 陈伟杰 on 2017/5/4.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailFolderChildArrayTableViewCell.h"

@implementation MailFolderChildArrayTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailFolderChildArrayTableViewCellStateChange:) name:@"MailFolderChildArrayTableViewCellStateChange" object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MailFolderChildArrayTableViewCellStateChange" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)mailFolderChildArrayTableViewCellStateChange:(NSNotification *)sender {
    NSString *str = sender.userInfo[@"state"];
    if ([str isEqualToString:@"编辑"]) {
        self.selectButton.hidden = !self.selectButton.hidden;
        if (self.selectButton.selected) {
            self.selectButton.selected = NO;
        }
    } else {
        self.selectButton.hidden = !self.selectButton.hidden;
        if (self.selectButton.selected) {
            self.selectButton.selected = NO;
        }
    }
}

- (IBAction)selectButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.buttonDelegate respondsToSelector:@selector(mailFolderChildArrayTableViewCellButtonClick:)]) {
        [self.buttonDelegate mailFolderChildArrayTableViewCellButtonClick:sender.tag];
    }
}
@end
