//
//  TabBarViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "TabBarViewController.h"
#import "CustomTabBar.h"
#import "MoreViewController.h"
#import "KGModal.h"
#import "HTTPInterface+Folder.h"
#import "UserInfoManager.h"

@interface TabBarViewController ()<TabBarCenterButtonClickDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomTabBar *tabbar = [[CustomTabBar alloc] initWithFrame:self.tabBar.frame];
    tabbar.centerButtonDelegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
    self.selectedIndex = 0;
    [self.navigationController setNavigationBarHidden:YES];
    [HTTPInterface getUserAllFoldersWithUserAccount:[UserInfoManager sharedUserInfoManager].userAccount UserPassword:[UserInfoManager sharedUserInfoManager].userMD5Password];
    [HTTPInterface getUserInfoWithUserAccount:[UserInfoManager sharedUserInfoManager].userAccount MD5Password:[UserInfoManager sharedUserInfoManager].userMD5Password RememberPassWord:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TabBarCenterButtonClickDelegate
- (void)tabBarCenterButtonClick {
    MoreViewController *moreVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"moreVC"];
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
    [[KGModal sharedInstance] showWithContentViewController:moreVC andAnimated:YES];
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
