//
//  MailHomeViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/10.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailHomeViewController.h"
#import "MBProgressHUD+XQ.h"
#import "HTTPInterface+MailBox.h"
#import "UserDefaultsManager.h"
#import "UserMailBoxList.h"
#import "UserSmartMailBoxChildList.h"
#import "SmartFolderTableViewCell.h"
#import "UserInfoManager.h"
//#import <UIViewController+MMDrawerController.h>

#define BOXMAIL_BUTTONWIDTH [UIScreen mainScreen].bounds.size.width * 0.25 * 0.7 * 0.8
#define BOXMAIL_BUTTON_BETWEEN_SPACE [UIScreen mainScreen].bounds.size.width * 0.25 * 0.15 * 0.8

@interface MailHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftMenuTableView;
@property (nonatomic, strong) NSArray<UserSmartMailBoxChildListCell *> *leftMenuTableViewArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMailBoxScrollViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *mailBoxScrollViewContentView;
@property (nonatomic, strong) NSArray<UserMailBoxListCell *> *leftMailBoxArray;
@property (weak, nonatomic) IBOutlet UILabel *leftMenuTitleLabel;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) NSInteger boxID;
@end

@implementation MailHomeViewController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftMenuTableView.estimatedRowHeight = 100;
    self.leftMenuTableView.rowHeight = UITableViewAutomaticDimension;
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0, 0, 25, 25);
    [leftBarButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBarButton setBackgroundColor:[UIColor clearColor]];
    [leftBarButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    [self addNotificationsOfUserMailBoxList];
    [self addNotificationsOfUserSmartMailBoxChildList];
    [self addNotificationsOfUserOtherMailBoxChildList];
    
//    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
//        case AFNetworkReachabilityStatusUnknown: {
//            [self getUserMailBoxListFromDataBaseAndCreateMailBoxButtons];
//            [self getUserSmartMailBoxChildListFromDataBaseAndReloadTableView];
//            [MBProgressHUD showError:@"网络状态未知" toView:nil];
//            [self.hud hideAnimated:NO];
//            break;
//        }
//            
//        case AFNetworkReachabilityStatusNotReachable: {
//            [self getUserMailBoxListFromDataBaseAndCreateMailBoxButtons];
//            [self getUserSmartMailBoxChildListFromDataBaseAndReloadTableView];
//            [MBProgressHUD showError:@"无网络" toView:nil];
//            [self.hud hideAnimated:NO];
//            break;
//        }
//            
//        default: {
//            self.hud = [MBProgressHUD showIndicatorWithText:@"数据获取中" ToView:self.view];
//            NSString *userAcccount = [UserInfoManager sharedUserInfoManager].userAccount;
//            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
//            if (userPassword) {
//                [HTTPInterface getUserMailBoxListWithUserAccount:userAcccount AndMD5Password:userPassword];
//                [HTTPInterface getUserMailBoxChildListByParentID:@"zn" AndUserAccount:userAcccount AndMD5Password:userPassword];
//            }
//            break;
//        }
//    }
    self.hud = [MBProgressHUD showIndicatorWithText:@"数据获取中" ToView:self.view];
    NSString *userAcccount = [UserInfoManager sharedUserInfoManager].userAccount;
    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
    if (userPassword) {
        [HTTPInterface getUserMailBoxListWithUserAccount:userAcccount AndMD5Password:userPassword];
        [HTTPInterface getUserMailBoxChildListByParentID:@"zn" AndUserAccount:userAcccount AndMD5Password:userPassword];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    [self.tabBarController setHidesBottomBarWhenPushed:YES];
}

- (void)dealloc {
    [self removeNotificationsOfUserMailBoxList];
    [self removeNotificationsOfUserSmartMailBoxChildList];
    [self removeNotificationsOfUserOtherMailBoxChildList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarButtonItemClick
- (void)drawerLeftViewPullBack:(UIButton *)sender {
    
}

#pragma mark - BackButtonClick
- (IBAction)backButtonClick:(UIButton *)sender {
//    [self.mm_drawerController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NSNotifications Of UserMailBoxList
- (void)getUserMailBoxListSuccess:(NSNotification *)sender {
    [self getUserMailBoxListFromDataBaseAndCreateMailBoxButtons];
    [self.hud hideAnimated:NO];
//    [self removeNotificationsOfUserMailBoxList];
    
}

- (void)getUserMailBoxListFromDataBaseAndCreateMailBoxButtons {
    NSArray *buttonArray = [self.mailBoxScrollViewContentView subviews];
    if (buttonArray.count > 0) {
        for (UIButton *button in buttonArray) {
            [button removeFromSuperview];
        }
    }
    
    UserMailBoxList *userMailBoxList = [UserMailBoxList objectForPrimaryKey:@(1)];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (UserMailBoxListCell *modelCell in userMailBoxList.userMailBoxList) {
        [mutableArray addObject:modelCell];
    }
    self.leftMailBoxArray = [mutableArray copy];
    for (NSInteger i = 0; i < self.leftMailBoxArray.count + 1; i++) {
        NSString *nameStr = nil;
        if (i == 0) {
            NSString *str = @"智能文件夹";
            nameStr = [str substringToIndex:1];
        } else {
            nameStr = [self.leftMailBoxArray[i - 1].name substringToIndex:1];
        }
        UIButton *button = [self createBoxMailButtonsWithTitle:nameStr Index:i];
        if (i == 0) {
            button.tag = 100;
        } else {
            button.tag = self.leftMailBoxArray[i - 1].id;
        }
        [self.mailBoxScrollViewContentView addSubview:button];
    }
    self.leftMailBoxScrollViewConstraint.constant = BOXMAIL_BUTTONWIDTH * (self.leftMailBoxArray.count + 1) + BOXMAIL_BUTTON_BETWEEN_SPACE * (self.leftMailBoxArray.count + 2);
    [self.view layoutIfNeeded];
}

- (void)getUserMailBoxListFailed:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *back = sender.userInfo[@"back"];
    if (back && ![back isEqualToString:@""]) {
        [MBProgressHUD showError:back toView:self.view];
    }
//    [self removeNotificationsOfUserMailBoxList];
}

- (void)getUserMailBoxListError:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *errorInfo = sender.userInfo[@"NSLocalizedDescription"];
    if (errorInfo && ![errorInfo isEqualToString:@""]) {
        [MBProgressHUD showError:errorInfo toView:self.view];
    }
//    [self removeNotificationsOfUserMailBoxList];
}

- (void)addNotificationsOfUserMailBoxList {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserMailBoxListSuccess:) name:GetUserMailBoxListSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserMailBoxListFailed:) name:GetUserMailBoxListFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserMailBoxListError:) name:GetUserMailBoxListError object:nil];
}

- (void)removeNotificationsOfUserMailBoxList {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetUserMailBoxListSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetUserMailBoxListFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetUserMailBoxListError object:nil];
}

- (UIButton *)createBoxMailButtonsWithTitle:(NSString *)title Index:(NSInteger)index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:28.0 weight:1.5];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0/255.0 green:141/255.0 blue:221/255.0 alpha:1.0] forState:UIControlStateSelected];
    if (index == 0) {
        button.selected = YES;
        button.layer.borderWidth = 2.0;
        button.tag = 100;
    }
    button.layer.borderColor = [UIColor colorWithRed:0/255.0 green:141/255.0 blue:221/255.0 alpha:1.0].CGColor;
    button.layer.cornerRadius = 8.0;
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(mailBoxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(BOXMAIL_BUTTON_BETWEEN_SPACE, BOXMAIL_BUTTON_BETWEEN_SPACE * (index + 1) + BOXMAIL_BUTTONWIDTH * index, BOXMAIL_BUTTONWIDTH, BOXMAIL_BUTTONWIDTH);
    return button;
}

- (void)mailBoxButtonClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    } else {
        NSArray *buttonArray = [self.mailBoxScrollViewContentView subviews];
        for (UIButton *button in buttonArray) {
            if (button.selected) {
                button.selected = NO;
                button.layer.borderWidth = 0;
                break;
            }
        }
        sender.selected = YES;
        sender.layer.borderWidth = 2;
        for (NSInteger i = 0; i < buttonArray.count; i++) {
            UIButton *button = buttonArray[i];
            if (button.selected) {
                if (button.tag == 100) {
                    self.leftMenuTitleLabel.text = @"智能文件夹";
                } else {
                    self.leftMenuTitleLabel.text = self.leftMailBoxArray[i - 1].email;
                }
                break;
            }
        }
        if (sender.tag == 100) {
            switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
                case AFNetworkReachabilityStatusUnknown: {
                    [self getUserSmartMailBoxChildListFromDataBaseAndReloadTableView];
                    [MBProgressHUD showError:@"网络状态未知" toView:nil];
                    break;
                }
                    
                case AFNetworkReachabilityStatusNotReachable: {
                    [self getUserSmartMailBoxChildListFromDataBaseAndReloadTableView];
                    [MBProgressHUD showError:@"无网络" toView:nil];
                    break;
                }
                    
                default: {
                    NSString *userAcccount = [UserInfoManager sharedUserInfoManager].userAccount;
                    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
                    if (userPassword) {
                        [HTTPInterface getUserMailBoxListWithUserAccount:userAcccount AndMD5Password:userPassword];
                        [HTTPInterface getUserMailBoxChildListByParentID:@"zn" AndUserAccount:userAcccount AndMD5Password:userPassword];
                        break;
                    }
                }
            }
            
        } else if (sender.tag < 100) {
            switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
                case AFNetworkReachabilityStatusUnknown:
                    [self getUserOtherMailBoxChildListFromDataBaseAndReloadTableViewWithMailBoxID:sender.tag];
                    [MBProgressHUD showError:@"网络状态未知" toView:nil];
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                    [self getUserOtherMailBoxChildListFromDataBaseAndReloadTableViewWithMailBoxID:sender.tag];
                    [MBProgressHUD showError:@"无网络" toView:nil];
                    break;
                    
                default: {
                    NSString *parentID = [NSString stringWithFormat:@"m_%ld",sender.tag];
                    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
                    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
                    [HTTPInterface getUserMailBoxChildListByParentID:parentID AndUserAccount:userAccount AndMD5Password:userPassword];
                    break;
                }
            }
            
        } else {
            [self getUserOtherMailBoxChildListFromDataBaseAndReloadTableViewWithMailBoxID:sender.tag - 100];
        }
    }
}

#pragma mark - NSNotifications Of UserOtherMailBoxChildList
- (void)getUserOtherMailBoxChildListSuccess:(NSNotification *)sender {
    NSInteger mailBoxID = [sender.userInfo[@"id"] integerValue];
    self.boxID = mailBoxID;
    [self getUserOtherMailBoxChildListFromDataBaseAndReloadTableViewWithMailBoxID:mailBoxID];
    NSArray *buttonArray = [self.mailBoxScrollViewContentView subviews];
    for (UIButton *button in buttonArray) {
        if (button.tag == mailBoxID) {
            button.tag = mailBoxID + 100;
            break;
        }
    }
//    [self removeNotificationsOfUserOtherMailBoxChildList];
}

- (void)getUserOtherMailBoxChildListFromDataBaseAndReloadTableViewWithMailBoxID:(NSInteger)mailBoxID {
    self.boxID = mailBoxID;
    UserSmartMailBoxChildList *userOtherMailBoxList = [UserSmartMailBoxChildList objectForPrimaryKey:@(mailBoxID)];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (UserSmartMailBoxChildListCell *cell in userOtherMailBoxList.userSmartMailBoxChildList) {
        [mutableArray addObject:cell];
        LRLog(@"%@",cell);
    }
    self.leftMenuTableViewArray = [mutableArray copy];
    [self.leftMenuTableView reloadData];
}

- (void)getUserOtherMailBoxChildListFailed:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *back = sender.userInfo[@"back"];
    if (back && ![back isEqualToString:@""]) {
        [MBProgressHUD showError:back toView:self.view];
    }
}

- (void)getUserOtherMailBoxChildListError:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *errorInfo = sender.userInfo[@"NSLocalizedDescription"];
    if (errorInfo && ![errorInfo isEqualToString:@""]) {
        [MBProgressHUD showError:errorInfo toView:self.view];
    }
}

- (void)addNotificationsOfUserOtherMailBoxChildList {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserOtherMailBoxChildListSuccess:) name:GetUserOtherMailBoxChildListSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserOtherMailBoxChildListFailed:) name:GetUserOtherMailBoxChildListFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserOtherMailBoxChildListError:) name:GetUserOtherMailBoxChildListError object:nil];
}

- (void)removeNotificationsOfUserOtherMailBoxChildList {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetUserOtherMailBoxChildListSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetUserOtherMailBoxChildListFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetUserOtherMailBoxChildListError object:nil];
}
#pragma mark - NSNotifications Of UserSmartMailBoxChildList
- (void)getUserSmartMailBoxChildListSuccess:(NSNotification *)sender {
    self.boxID = 0;
    [self getUserSmartMailBoxChildListFromDataBaseAndReloadTableView];
}

- (void)getUserSmartMailBoxChildListFromDataBaseAndReloadTableView {
    
    UserSmartMailBoxChildList *userSmartMailBoxList = [UserSmartMailBoxChildList objectForPrimaryKey:@(0)];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (UserSmartMailBoxChildListCell *cell in userSmartMailBoxList.userSmartMailBoxChildList) {
        [mutableArray addObject:cell];
    }
    self.leftMenuTableViewArray = [mutableArray copy];
    [self.leftMenuTableView reloadData];
}

- (void)getUserSmartMailBoxChildListFailed:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *back = sender.userInfo[@"back"];
    if (back && ![back isEqualToString:@""]) {
        [MBProgressHUD showError:back toView:self.view];
    }
}

- (void)getUserSmartMailBoxChildListError:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *errorInfo = sender.userInfo[@"NSLocalizedDescription"];
    if (errorInfo && ![errorInfo isEqualToString:@""]) {
        [MBProgressHUD showError:errorInfo toView:self.view];
    }
}

- (void)addNotificationsOfUserSmartMailBoxChildList {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserSmartMailBoxChildListSuccess:) name:GetUserSmartMailBoxChildListSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserSmartMailBoxChildListFailed:) name:GetUserSmartMailBoxChildListFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserSmartMailBoxChildListError:) name:GetUserSmartMailBoxChildListError object:nil];
}

- (void)removeNotificationsOfUserSmartMailBoxChildList {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetUserSmartMailBoxChildListSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetUserSmartMailBoxChildListFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetUserSmartMailBoxChildListError object:nil];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSmartMailBoxChildListCell *cellModel = self.leftMenuTableViewArray[indexPath.row];
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//        
//    }];
//    LRLog(@"%ld",self.boxID);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftMenuCallBack" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftMenuTableViewCellSelect" object:nil userInfo:@{@"boxID": @(self.boxID),@"cellModel":cellModel}];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftMenuTableViewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSmartMailBoxChildListCell *modelCell = self.leftMenuTableViewArray[indexPath.row];
    SmartFolderTableViewCell *cell = [self.leftMenuTableView dequeueReusableCellWithIdentifier:@"SmartFolderTableViewCell"];
    UIImage *image = [UIImage imageNamed:modelCell.name];
    if (!image) {
        image = [UIImage imageNamed:@"文件夹"];
    }
    cell.cellImageView.image = image;
    cell.cellLabel.text = modelCell.name;
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
