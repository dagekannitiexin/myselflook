//
//  MoreViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/10.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreCollectionViewCell.h"
#import "KGModal.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface MoreViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *yearAndMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *weakLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *cellNameArray;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellNameArray = @[@"写邮件", @"写报告", @"写动态", @"建客户", @"建报价", @"建商机"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 3.0, SCREEN_WIDTH / 3.0);
    self.collectionView.collectionViewLayout = layout;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonClick:(UIButton *)sender {
    [[KGModal sharedInstance] hide];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoreCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"moreCollectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.cellNameArray[indexPath.row]];
    cell.nameLabel.text = self.cellNameArray[indexPath.row];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
