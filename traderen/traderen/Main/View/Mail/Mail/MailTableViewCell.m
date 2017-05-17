//
//  MailTableViewCell.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/15.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailTableViewCell.h"
#import "NSString+CreateTime.h"
#import "NSString+MailLabel.h"
#import "UIView+Extension.h"
//#import "CustomFlowLayout.m"

@implementation MailTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellStateChange:) name:@"cellStateChange" object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cellStateChange:(NSNotification *)sender {
    NSString *str = sender.userInfo[@"state"];
    if ([str isEqualToString:@"编辑"]) {
        if (!self.isReadImageView.hidden) {
            self.isReadImageView.hidden = YES;
        }
        self.selectButton.hidden = !self.selectButton.hidden;
        if (self.selectButton.selected) {
            self.selectButton.selected = NO;
        }
    } else {
        if (!self.isRead) {
            self.isReadImageView.hidden = NO;
        }
        self.selectButton.hidden = !self.selectButton.hidden;
        if (self.selectButton.selected) {
            self.selectButton.selected = NO;
        }
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    NSArray *array = self.subviews;
//    for (int i = 0; i < array.count; i++) {
//        UIView *subView = array[i];
//        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
////            CGSize size = subView.size;
////            size.width = size.width * 2;
////            subView.size = size;
//            UIButton *deleteConfirmationViewButton = (UIButton *)subView.subviews[0];
//            [deleteConfirmationViewButton setImage:[UIImage imageNamed:@"删除cell"] forState:UIControlStateNormal];
//            
//            UIButton *moveConfirmationViewButton = (UIButton *)subView.subviews[1];
//            [moveConfirmationViewButton setImage:[UIImage imageNamed:@"邮件移动cell"] forState:UIControlStateNormal];
//            
//            UIButton *topConfirmationViewButton = (UIButton *)subView.subviews[2];
//            [topConfirmationViewButton setImage:[UIImage imageNamed:@"置顶cell"] forState:UIControlStateNormal];
//            
//            UIButton *starConfirmationViewButton = (UIButton *)subView.subviews[3];
//            [starConfirmationViewButton setImage:[UIImage imageNamed:@"标星cell"] forState:UIControlStateNormal];
//            
//            UIButton *redFlagConfirmationViewButton = (UIButton *)subView.subviews[4];
//            [redFlagConfirmationViewButton setImage:[UIImage imageNamed:@"红旗cell"] forState:UIControlStateNormal];
//        }
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadInputViews {
    [super reloadInputViews];
}

#pragma mark - setMailTableViewCellByModel
+ (instancetype)setMailTableViewCellByModel:(MailHomeMailListCell *)cellModel WithTableView:(MailTableView *)tableView AndIndexPath:(NSIndexPath *)indexPath{
    MailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailHomeCenterViewCell"];
    cell.firstFlagImageView.hidden = NO;
    cell.secondFlagImageView.hidden = NO;
    cell.thirdFlagImageView.hidden = NO;
    cell.forthFlagImageView.hidden = NO;
    
    cell.selectButton.tag = indexPath.row;
    if (!tableView.isEditing) {
        if ([cellModel.Read isEqualToString:@"是"]) {
            cell.isReadImageView.hidden = YES;
            cell.isRead = YES;
        } else {
            cell.isReadImageView.hidden = NO;
            cell.isRead = NO;
        }
        cell.selectButton.hidden = YES;
        cell.selectButton.selected = NO;
    } else {
        if ([cellModel.Read isEqualToString:@"是"]) {
            cell.isReadImageView.hidden = YES;
            cell.isRead = YES;
        } else {
            cell.isReadImageView.hidden = YES;
            cell.isRead = NO;
        }
        cell.selectButton.hidden = NO;
        if (cellModel.isSelect == 100) {
            cell.selectButton.selected = YES;
        } else {
            cell.selectButton.selected = NO;
        }
    }
    
    
    if (cellModel.FromName && ![cellModel.FromName isEqualToString:@""] && cellModel.FromName.length > 0) {
        cell.fromNameLabel.text = cellModel.FromName;
    } else {
        if (cellModel.FromEmail && ![cellModel.FromEmail isEqualToString:@""] && cellModel.FromEmail.length > 0) {
            cell.fromNameLabel.text = cellModel.FromEmail;
        } else {
            cell.fromNameLabel.text = @"未填写";
        }
    }
    
    if (cellModel.Subject && ![cellModel.Subject isEqualToString:@""] && cellModel.Subject.length > 0) {
        cell.mailContentLabel.text = cellModel.Subject;
    } else {
        cell.mailContentLabel.text = @"未填写";
    }
    
    [cell ToShowTheImageByfourImageView:@[cell.firstFlagImageView, cell.secondFlagImageView, cell.thirdFlagImageView, cell.forthFlagImageView] WithCellModel:cellModel];
    
    if (cellModel.MailDate && ![cellModel.MailDate isEqualToString:@""] && cellModel.MailDate.length > 0) {
        NSString *timeText = [NSString createDateStringToCreateTimeFromNow:cellModel.MailDate];
        cell.createTimeLabel.text = timeText;
    } else {
        cell.createTimeLabel.text = @"未填写";
    }
    
    if (cell.tagView.subviews.count > 0) {
        for (UILabel *label in cell.tagView.subviews) {
            [label removeFromSuperview];
        }
    }
    if (cellModel.MailLabel && ![cellModel.MailLabel isEqualToString:@""] && cellModel.MailLabel.length > 0) {
        cell.tagView.hidden = NO;
        NSArray<NSString *> *strArray = [NSString mailLabelStrToLabelStrArray:cellModel.MailLabel];
        [cell.tagView bindTags:strArray];
        cell.tagViewHeightConstraint.constant = cell.tagView.height;
        [cell.contentView layoutIfNeeded];
    } else {
        cell.tagView.hidden = YES;
        cell.tagViewHeightConstraint.constant = 0;
    }
    
    return cell;
}

- (void)ToShowTheImageByfourImageView:(NSArray<UIImageView *> *)imageViewArray WithCellModel:(MailHomeMailListCell *)cellModel {
    BOOL accCount = cellModel.AccCount > 0;
    BOOL redFlag = cellModel.redflag && ![cellModel.redflag isEqualToString:@""] && cellModel.redflag.length > 0;
    BOOL star = cellModel.star && ![cellModel.star isEqualToString:@" "] && ![cellModel.star  isEqualToString:@""] && cellModel.star.length > 0;
    BOOL topTime = cellModel.TopTime && ![cellModel.TopTime isEqualToString:@""] && cellModel.TopTime.length > 0;
    UIImage *accCountImage = [UIImage imageNamed:@"附件"];
    UIImage *redFlagImage = [UIImage imageNamed:@"红旗邮件"];
    UIImage *starImage = [UIImage imageNamed:@"星标邮件"];
    UIImage *topTimeImage = [UIImage imageNamed:@"置顶邮件"];
    for (int i = 0; i < imageViewArray.count; i++) {
        UIImageView *imageView = imageViewArray[i];
        if (accCount && redFlag && star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = redFlagImage;
                    break;
                case 2:
                    imageView.image = starImage;
                    break;
                default:
                    imageView.image = topTimeImage;
                    break;
            }
        } else if (accCount && redFlag && star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = redFlagImage;
                    break;
                case 2:
                    imageView.image = starImage;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && redFlag && !star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = redFlagImage;
                    break;
                case 2:
                    imageView.image = topTimeImage;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && !redFlag && star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = starImage;
                    break;
                case 2:
                    imageView.image = topTimeImage;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && redFlag && star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = redFlagImage;
                    break;
                case 1:
                    imageView.image = starImage;
                    break;
                case 2:
                    imageView.image = topTimeImage;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && redFlag && !star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = redFlagImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && !redFlag && !star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = topTimeImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && !redFlag && star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = starImage;
                    break;
                case 1:
                    imageView.image = topTimeImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && redFlag && star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = redFlagImage;
                    break;
                case 1:
                    imageView.image = starImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && redFlag && !star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = redFlagImage;
                    break;
                case 1:
                    imageView.image = topTimeImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && !redFlag && star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = starImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && !redFlag && !star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.hidden = YES;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && redFlag && !star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = redFlagImage;
                    break;
                case 1:
                    imageView.hidden = YES;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && !redFlag && star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = starImage;
                    break;
                case 1:
                    imageView.hidden = YES;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && !redFlag && !star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = topTimeImage;
                    break;
                case 1:
                    imageView.hidden = YES;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else {
            switch (i) {
                case 0:
                    imageView.hidden = YES;
                    break;
                case 1:
                    imageView.hidden = YES;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        }
    }
}


- (IBAction)selectButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.selectDelegate respondsToSelector:@selector(selectButtonOfCellClick:)]) {
        [self.selectDelegate selectButtonOfCellClick:sender.tag];
    }
}

//#pragma mark - UpdateTheCollectionHeightConstraint
//- (void)updateTheCollectionHeightConstraintWithCell {
//    CGSize collectionCellSize = self.cellCollectionView.contentSize;
//    self.cellCollectionViewHeightConstraint.constant = collectionCellSize.height;
//    self.contentLabelBottomConstraintOne.constant = 8;
//    [self.contentView updateConstraints];
//}

//#pragma mark - SetFlowLayout
//- (void)setFlowLayout {
//    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.minimumLineSpacing = 2.0;
//    flowLayout.minimumInteritemSpacing = 3.0;
//    flowLayout.estimatedItemSize = CGSizeMake(160, 16);
//    flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    self.cellCollectionView.collectionViewLayout = flowLayout;
//}
//
//#pragma mark - UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.collectionArray.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    MailTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MailTagCollectionViewCell" forIndexPath:indexPath];
//    cell.cellLabel.text = self.collectionArray[indexPath.row];
//    return cell;
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        CGSize size = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>)
//    }
//}
@end
