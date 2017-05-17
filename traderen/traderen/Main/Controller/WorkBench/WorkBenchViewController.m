//
//  WorkBenchViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "WorkBenchViewController.h"
#import "HTTPInterface.h"
#import "MenuList.h"
#import "WorkBenchCollectionViewCell.h"
#import "MailHomeViewController.h"
#import "MailHomeDrawerViewController.h"
#import "MailHomeCenterViewController.h"
#import "HTTPInterface+Folder.h"
#import "UserInfoManager.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define USER_ID       @"admin"
#define USER_PASSWORD @"96E79218965EB72C92A549DD5A330112"

@interface WorkBenchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (nonatomic, copy) NSArray *collectionViewCellNameArray;
@property (weak, nonatomic) IBOutlet UILabel *mailManagerBadgeLabel;

@end

@implementation WorkBenchViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionViewCellNameArray = @[@"客户管理", @"公海客户",@"预警",@"待办日程",@"知识库",@"文档管理",@"询价管理",@"供应商",@"商机管理",@"产品管理",@"数据分析"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 2)/ 3.0, (SCREEN_WIDTH - 2)/ 3.0);
    self.menuCollectionView.collectionViewLayout = layout;
    self.menuCollectionView.backgroundColor = [UIColor lightGrayColor];
    [HTTPInterface getUserAllFoldersWithUserAccount:[UserInfoManager sharedUserInfoManager].userAccount UserPassword:[UserInfoManager sharedUserInfoManager].userMD5Password];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews {

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotifications
- (void)getUserMenuSuccess:(NSNotification *)sender {
    RLMResults<MenuListCell *> *results = [MenuListCell allObjects];
    for (MenuListCell *cell in results) {
        LRLog(@"menuList = %@",cell);
    }
}

- (void)getUserMenuFailed:(NSNotification *)sender {
    
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserMenuSuccess:) name:@"getUserMenuSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserMenuFailed:) name:@"getUserMenuFailed" object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ButtonClick
- (IBAction)mailManagerButton:(UIButton *)sender {
//    UINavigationController *leftVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailHomeViewControllerNavi"];
//    UINavigationController *centerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailHomeCenterTableViewControllerNavi"];
//    MailHomeDrawerViewController *drawerController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailHomeDrawerViewController"];
//    drawerController.centerViewController = centerVC;
//    drawerController.leftDrawerViewController = leftVC;
//    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//    drawerController.maximumLeftDrawerWidth = SCREEN_WIDTH * 0.8;
////    [drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
//    [self.navigationController pushViewController:drawerController animated:YES];
}

- (IBAction)dailyJobReportButton:(UIButton *)sender {
    
}

- (IBAction)workDynamicsButton:(UIButton *)sender {
    
}

#pragma mark - UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 11;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WorkBenchCollectionViewCell *cell = [self.menuCollectionView dequeueReusableCellWithReuseIdentifier:@"workBenchCollectionViewCell" forIndexPath:indexPath];
    cell.menuCellImageView.image = [UIImage imageNamed:self.collectionViewCellNameArray[indexPath.row]];
    cell.menuCellNameLabel.text = self.collectionViewCellNameArray[indexPath.row];
//    cell.badgeLabel.text = ;
    cell.badgeLabel.hidden = YES;
    cell.backgroundColor = [UIColor whiteColor];
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
