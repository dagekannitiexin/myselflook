//
//  WorkBenchCollectionViewCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/7.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkBenchCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *menuCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuCellNameLabel;

@end
