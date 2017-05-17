//
//  MailTableViewCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/15.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailHomeMailListCell.h"
#import "MailTableView.h"
#import "TagLabelView.h"

@protocol SelectButtonOfCellClickDelegate <NSObject>

- (void)selectButtonOfCellClick:(NSInteger)index;

@end

@interface MailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *isReadImageView;
@property (weak, nonatomic) IBOutlet UILabel *fromNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *forthFlagImageView;
@property (weak, nonatomic) IBOutlet TagLabelView *tagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightConstraint;
@property (nonatomic, weak) id<SelectButtonOfCellClickDelegate> selectDelegate;
@property (nonatomic, assign) BOOL isRead;
+ (instancetype)setMailTableViewCellByModel:(MailHomeMailListCell *)cellModel WithTableView:(MailTableView *)tableView AndIndexPath:(NSIndexPath *)indexPath;
@end
