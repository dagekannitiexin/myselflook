//
//  MailHomeDrawerViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/13.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailHomeDrawerViewController.h"
#import "MailHomeCenterViewController.h"

@interface MailHomeDrawerViewController ()

@end

@implementation MailHomeDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
//    UINavigationController *leftVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailHomeViewControllerNavi"];
//    UINavigationController *centerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailHomeCenterTableViewControllerNavi"];
////    MailHomeDrawerViewController *drawerController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailHomeDrawerViewController"];
//    self.centerViewController = centerVC;
//    self.leftDrawerViewController = leftVC;
//    self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//    self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//    self.maximumLeftDrawerWidth = SCREEN_WIDTH * 0.8;
////    [self.tabBarController setHidesBottomBarWhenPushed:NO];
//    self
    LRLog(@"load---------");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = NO;
    self.scaleContentView = NO;
    self.scaleMenuView = NO;
    self.contentViewInPortraitOffsetCenterX = SCREEN_WIDTH * 0.3;
//    self.contentViewScaleValue = 0.8;
    
    UINavigationController *contentVCNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"MailHomeCenterTableViewControllerNavi"];
    for (UIViewController *VC in contentVCNavi.viewControllers) {
        if ([VC isKindOfClass:[MailHomeCenterViewController class]]) {
            MailHomeCenterViewController *mailCenterVC = (MailHomeCenterViewController *)VC;
            mailCenterVC.drawerVC = self;
            break;
        }
    }

    self.contentViewController = contentVCNavi;
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MailHomeViewControllerNavi"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftMenuCallOut:) name:@"leftMenuCallOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftMenuCallBack:) name:@"leftMenuCallBack" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotification Of LeftMenuCallOutOrCallBack
- (void)leftMenuCallOut:(NSNotification *)sender {
    [self presentLeftMenuViewController];
}

- (void)leftMenuCallBack:(NSNotification *)sender {
    [self hideMenuViewController];
}

#pragma mark - NSNotification Of HideOrCallOutTabBar
- (void)hideTabBar:(NSNotification *)sender {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)callOutTabBar:(NSNotification *)sender {
    self.tabBarController.tabBar.hidden = NO;
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
