//
//  MailHomeCenterViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/14.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailHomeCenterViewController.h"
//#import <UIViewController+MMDrawerController.h>
#import "HTTPInterface+Mail.h"
#import "UserInfoManager.h"
#import "MailHomeMailList.h"
#import "MailTableViewCell.h"
#import <MJRefresh.h>
#import "UserSmartMailBoxChildListCell.h"
#import "MBProgressHUD+XQ.h"
#import <AFNetworkReachabilityManager.h>
#import "UITableViewRowAction+JZExtension.h"
#import "MailMoveFolderViewController.h"
#import "MailFolderCell.h"
#import "MailDetailModel.h"
#import "MailDetailViewController.h"
#import "MailFolderViewController.h"
#import "MailSendViewController.h"

#define pageMax 15

@interface MailHomeCenterViewController ()<UITableViewDelegate, UITableViewDataSource, SelectButtonOfCellClickDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *littleMoreViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *littleMoreView;
@property (weak, nonatomic) IBOutlet UIView *maskView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightConstraint;
@property (weak, nonatomic) IBOutlet MailTableView *mailListTableView;
@property (nonatomic, strong) UIButton *rightBarButton;
@property (nonatomic, strong) UIButton *secondRightBarButton;
@property (nonatomic, strong) UIButton *leftBarButton;
@property (nonatomic, strong) NSArray<MailHomeMailListCell *> *mailHomeMailArray;
@property (nonatomic, assign) NSInteger boxID;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSString *act;
@property (nonatomic, assign) NSInteger mailCount;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIBarButtonItem *completeBarButtonItem;
@property (nonatomic, strong) NSArray<MailHomeMailListCell *> *mutableCellModelArray;
@property (nonatomic, strong) NSArray<NSIndexPath *> *mutableIndexPathArray;
@property (weak, nonatomic) IBOutlet UIView *mailFolderBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mailFolderBackViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *mailFolderPreviousBackView;
@property (weak, nonatomic) IBOutlet UIView *mailFolderSameLevelBackView;
@property (weak, nonatomic) IBOutlet UIImageView *mailFolderImageView;
@property (nonatomic, strong) NSArray<MailFolderCell *> *mailFolderChildArray;
@property (nonatomic, strong) NSMutableArray<NSArray<MailFolderCell *> *> *oldMailFolderArrayArray;
@property (nonatomic, assign) NSUInteger folderLevel;
@property (nonatomic, strong) UserSmartMailBoxChildListCell *mailBoxChildListCell;
@property (nonatomic, assign) BOOL folderBackViewIsExist;
@property (weak, nonatomic) IBOutlet UIButton *lotUpdateButton;
@end

@implementation MailHomeCenterViewController

#pragma mark - LazyLoad
- (UIBarButtonItem *)completeBarButtonItem {
    if (!_completeBarButtonItem) {
        _completeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeButtonClick:)];
        [_completeBarButtonItem setTintColor:[UIColor colorWithRed:1/255.0 green:147/255.0 blue:221/255.0 alpha:1.0]];
    }
    return _completeBarButtonItem;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mailListTableView.isEditing = NO;
    
    self.boxID = 0;
    self.pageIndex = 1;
    self.act = @"ALL";
    self.folderLevel = 0;
    self.folderBackViewIsExist = NO;
    
    self.title = @"全部邮件";
    
    self.mailListTableView.estimatedRowHeight = 100;
    self.mailListTableView.rowHeight = UITableViewAutomaticDimension;
    self.mailListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerViewRefresh)];
    self.mailListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerViewRefresh)];
    
    [self addNotificationsOfMailHomeMailList];
    [self addNotificationOfLeftMenuTableViewCellSelect];
    [self addNotificationsOfMailMove];
    [self addNotificationOfMoveMailToAnotherFolder];
    [self addNotificationOfMailFolderChildArrayTableViewCellSelect];
    [self addNotificationOfBackToRootMailArray];
    
    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
    NSString *userMD5Password = [UserInfoManager sharedUserInfoManager].userMD5Password;
    [HTTPInterface getUserMailListWithUserAccount:userAccount UserPassword:userMD5Password BoxID:self.boxID PageIndex:self.pageIndex PageMax:pageMax AndAct:self.act];
    [self addNotificationsOfMailHomeMailList];
    self.hud = [MBProgressHUD showIndicatorWithText:@"数据获取中" ToView:self.view];
//    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
//        case AFNetworkReachabilityStatusUnknown:
//        case AFNetworkReachabilityStatusNotReachable:
//            [MBProgressHUD showError:@"无网络" toView:self.view];
//            [self getMailHomeMailListWithPageIndex:@(self.pageIndex)];
//            break;
//            
//        default: {
//            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
//            NSString *userMD5Password = [UserInfoManager sharedUserInfoManager].userMD5Password;
//            [HTTPInterface getUserMailListWithUserAccount:userAccount UserPassword:userMD5Password BoxID:self.boxID PageIndex:self.pageIndex PageMax:pageMax AndAct:self.act];
//            [self addNotificationsOfMailHomeMailList];
//            self.hud = [MBProgressHUD showIndicatorWithText:@"数据获取中" ToView:self.view];
//            break;
//        }
//    }
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0, 0, 25, 25);
    [leftBarButton setImage:[UIImage imageNamed:@"左导航"] forState:UIControlStateNormal];
    [leftBarButton setBackgroundColor:[UIColor clearColor]];
    [leftBarButton addTarget:self action:@selector(slidingMenuPullOutOrPullBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.frame = CGRectMake(0, 0, 25, 25);
    [rightBarButton setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [rightBarButton setBackgroundColor:[UIColor clearColor]];
    [rightBarButton addTarget:self action:@selector(callOutTheLittleMoreView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    UIButton *secondRightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondRightBarButton.frame = CGRectMake(0, 0, 25, 25);
    [secondRightBarButton setImage:[UIImage imageNamed:@"写信"] forState:UIControlStateNormal];
    [secondRightBarButton setBackgroundColor:[UIColor clearColor]];
    [secondRightBarButton addTarget:self action:@selector(writeNewMail:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *secondRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:secondRightBarButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem, secondRightBarButtonItem];;
    self.rightBarButton = rightBarButton;
    self.secondRightBarButton = secondRightBarButton;
    self.leftBarButton = leftBarButton;
    
//    UIView *tapView = [[UIView alloc] initWithFrame:<#(CGRect)#>];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [self removeNotificationsOfMailMove];
    [self removeNotificationsOfMailStateChange];
    [self removeNotificationOfMoveMailToAnotherFolder];
    [self removeNotificationOfLeftMenuTableViewCellSelect];
    [self removeNotificationOfMailFolderChildArrayTableViewCellSelect];
    [self removeNotificationOfBackToRootMailArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MJRefresh
- (void)headerViewRefresh {
    self.pageIndex = 1;
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            [self getMailHomeMailListWithPageIndex:@(self.pageIndex)];
            break;
            
        default: {
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userMD5Password = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [HTTPInterface getUserMailListWithUserAccount:userAccount UserPassword:userMD5Password BoxID:self.boxID PageIndex:self.pageIndex PageMax:pageMax AndAct:self.act];
            [self addNotificationsOfMailHomeMailList];
            break;
        }
    }
//    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
//    NSString *userMD5Password = [UserInfoManager sharedUserInfoManager].userMD5Password;
//    [HTTPInterface getUserMailListWithUserAccount:userAccount UserPassword:userMD5Password BoxID:self.boxID PageIndex:0 PageMax:15 AndAct:self.act];
//    [self addNotificationsOfMailHomeMailList];
}

- (void)footerViewRefresh {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            [self endRefreshing];
            break;
            
        default: {
            if ((self.pageIndex + 1) * 15 > self.mailCount) {
                [MBProgressHUD showError:@"没有更多邮件了" toView:self.view];
                [self endRefreshing];
            } else {
                LRLog(@"%ld",self.pageIndex);
                self.pageIndex += 1;
                LRLog(@"%ld",self.pageIndex);
                NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
                NSString *userMD5Password = [UserInfoManager sharedUserInfoManager].userMD5Password;
                [HTTPInterface getUserMailListWithUserAccount:userAccount UserPassword:userMD5Password BoxID:self.boxID PageIndex:self.pageIndex PageMax:pageMax AndAct:self.act];
                [self addNotificationsOfMailHomeMailList];
                break;
            }
            
        }
    }
}

- (void)endRefreshing {
    [self.mailListTableView.mj_header endRefreshing];
    [self.mailListTableView.mj_footer endRefreshing];
}
//- (IBAction)tapViewToggle:(UITapGestureRecognizer *)sender {
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    LRLog(@"tap++++++++tap");
//}

#pragma mark - MailFolderViewButtonClick
- (IBAction)mailFolderSameLevelButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default: {
            MailFolderViewController *mailFolderVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailFolderViewController"];
            if (self.mailFolderChildArray) {
                [mailFolderVC getMailFolderChildArray:self.mailFolderChildArray OldMailFolderChildArrayArray:self.oldMailFolderArrayArray AndFolderLevel:self.folderLevel];
                [self.drawerVC.tabBarController.navigationController pushViewController:mailFolderVC animated:YES];
            }
            break;
        }
    }
}

- (IBAction)mailFolderViewPreviousButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default: {
//            self.mailFolderChildArray = self.oldMailFolderArrayArray[self.folderLevel - 1];
//            if (self.folderLevel - 1 == 0) {
//                self.oldMailFolderArrayArray = nil;
//            }
            MailFolderViewController *mailFolderVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailFolderViewController"];
            [mailFolderVC getMailFolderChildArray:self.oldMailFolderArrayArray[self.folderLevel - 1] OldMailFolderChildArrayArray:self.oldMailFolderArrayArray AndFolderLevel:self.folderLevel - 1];
            [self.drawerVC.tabBarController.navigationController pushViewController:mailFolderVC animated:YES];
            break;
        }
    }
}


#pragma mark - NSNotifications Of MoveMailToAnotherFolder
- (void)addNotificationOfMoveMailToAnotherFolder {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comfirmToMoveMailToAnotherFolder:) name:@"MoveMailToAnotherFolder" object:nil];
}

- (void)removeNotificationOfMoveMailToAnotherFolder {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MoveMailToAnotherFolder" object:nil];
}

- (void)comfirmToMoveMailToAnotherFolder:(NSNotification *)sender {
    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
    id obj = sender.userInfo[@"folderCellModel"];
    if ([obj isKindOfClass:[MailFolderCell class]]) {
        MailFolderCell *folderCellModel = (MailFolderCell *)obj;
        NSString *mutableStr = @"";
        for (int i = 0; i < self.mutableCellModelArray.count; i++) {
            MailHomeMailListCell *cellModel = self.mutableCellModelArray[i];
            if (i == 0) {
                mutableStr = [mutableStr stringByAppendingFormat:@"%ld", cellModel.Id];
            } else {
                mutableStr = [mutableStr stringByAppendingFormat:@",%ld", cellModel.Id];
            }
        }
        [HTTPInterface moveMailToBoxID:folderCellModel.mailboxId FromMailID:mutableStr RootID:folderCellModel.id OrBoxStr:nil WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:self.mutableIndexPathArray];
    } else if ([obj isKindOfClass:[UserSmartMailBoxChildListCell class]]) {
        UserSmartMailBoxChildListCell *mailBoxChildListCell = (UserSmartMailBoxChildListCell *)obj;
        NSInteger row = [sender.userInfo[@"row"] integerValue];
        NSInteger boxId = [sender.userInfo[@"boxId"] integerValue];
        LRLog(@"%@ /n %ld /n %ld ",mailBoxChildListCell, row, boxId);
        NSString *mutableStr = @"";
        for (int i = 0; i < self.mutableCellModelArray.count; i++) {
            MailHomeMailListCell *cellModel = self.mutableCellModelArray[i];
            if (i == 0) {
                mutableStr = [mutableStr stringByAppendingFormat:@"%ld", cellModel.Id];
            } else {
                mutableStr = [mutableStr stringByAppendingFormat:@",%ld", cellModel.Id];
            }
        }
        NSString *mailFolderId = [mailBoxChildListCell.id componentsSeparatedByString:@"_"].lastObject;
        if (row < 5) {
            [HTTPInterface moveMailToBoxID:boxId FromMailID:mutableStr RootID:0 OrBoxStr:mailFolderId WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:self.mutableIndexPathArray];
        } else {
            [HTTPInterface moveMailToBoxID:boxId FromMailID:mutableStr RootID:[mailFolderId integerValue] OrBoxStr:nil WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:self.mutableIndexPathArray];
        }
    }
}

#pragma mark - NSNotifications Of LeftMenuTableViewCellSelect
- (void)addNotificationOfLeftMenuTableViewCellSelect {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTheObjectFromLeftMenuTableViewCell:) name:@"leftMenuTableViewCellSelect" object:nil];
}

- (void)removeNotificationOfLeftMenuTableViewCellSelect {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"leftMenuTableViewCellSelect" object:nil];
}

- (void)didReceiveTheObjectFromLeftMenuTableViewCell:(NSNotification *)sender {
    NSString *oldAct = self.act;
    NSInteger oldBoxID = self.boxID;
    NSDictionary *dic = sender.userInfo;
    NSInteger boxID = [dic[@"boxID"] integerValue];
    UserSmartMailBoxChildListCell *cellModel = dic[@"cellModel"];
    self.act = NSLocalizedString(cellModel.name, nil);
    self.boxID = boxID;
    self.pageIndex = 1;
    self.folderLevel = 0;
    LRLog(@"oldAct = %@", oldAct);
    LRLog(@"oldBoxId = %ld", oldBoxID);
    LRLog(@"%ld",self.boxID);
    LRLog(@"%@",self.act);
    if ([self.act isEqualToString:cellModel.name]) {
        NSString *str = @"WJJ";
        NSArray<NSString *> *strArray = [cellModel.id componentsSeparatedByString:@"_"];
        NSString *IdString = strArray[strArray.count - 1];
        self.act = [str stringByAppendingFormat:@"%@",IdString];
    }
    if ([oldAct isEqualToString:self.act] && oldBoxID == self.boxID) {
        return;
    }
    self.mailBoxChildListCell = cellModel;
    if (self.boxID == 0) {
        self.folderBackViewIsExist = NO;
        self.mailFolderBackViewTopConstraint.constant = -50;
        self.mailFolderBackView.hidden = YES;
        self.mailFolderPreviousBackView.hidden = YES;
        self.mailFolderSameLevelBackView.hidden = NO;
        self.mailFolderImageView.hidden = NO;
    } else {
        RLMResults<MailFolderCell *> *results = [MailFolderCell objectsWhere:[NSString stringWithFormat:@"parentid = '%@'", cellModel.id]];
        LRLog(@"%@", cellModel.id);
        LRLog(@"%ld", results.count);
        if (results.count > 0) {
            self.folderBackViewIsExist = YES;
            self.mailFolderBackViewTopConstraint.constant = 0;
            self.mailFolderBackView.hidden = NO;
            self.mailFolderPreviousBackView.hidden = YES;
            self.mailFolderSameLevelBackView.hidden = NO;
            self.mailFolderImageView.hidden = NO;
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (MailFolderCell *folderCell in results) {
                [mutableArray addObject:folderCell];
            }
            self.mailFolderChildArray = [mutableArray copy];
        } else {
            self.folderBackViewIsExist = NO;
            self.mailFolderBackViewTopConstraint.constant = -50;
            self.mailFolderBackView.hidden = YES;
            self.mailFolderPreviousBackView.hidden = YES;
            self.mailFolderSameLevelBackView.hidden = NO;
            self.mailFolderImageView.hidden = NO;
        }
    }
    self.title = cellModel.name;
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable: {
            [MBProgressHUD showError:@"无网络" toView:self.view];
//            [self getMailHomeMailListWithPageIndex:@(self.pageIndex)];
//            NSString *str = nil;
//            if ([self.act containsString:@"WJJ"]) {
//                NSString *rootIdStr = [self.act stringByReplacingOccurrencesOfString:@"WJJ" withString:@""];
//                str = [NSString stringWithFormat:@"MailBoxId = %ld AND RootId = %@", self.boxID, rootIdStr];
//            } else {
//                str = [NSString stringWithFormat:@"MailBoxId = %ld AND BoxBase = %@", self.boxID, self.act];
//            }
//            RLMResults<MailHomeMailListCell *> *results = [MailHomeMailListCell objectsWhere:[NSString stringWithFormat:@"MailBoxId = %ld AND ", self.boxID]];
            break;
        }
            
        default: {
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userMD5Password = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [HTTPInterface getUserMailListWithUserAccount:userAccount UserPassword:userMD5Password BoxID:self.boxID PageIndex:self.pageIndex PageMax:pageMax AndAct:self.act];
            [self addNotificationsOfMailHomeMailList];
            break;
        }
    }
}

#pragma mark - NSNotification Of MailFolderChildArrayTableViewCellSelect
- (void)addNotificationOfMailFolderChildArrayTableViewCellSelect {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailFolderChildArrayTableViewCellSelect:) name:@"MailFolderChildArrayTableViewCellSelect" object:nil];
}

- (void)removeNotificationOfMailFolderChildArrayTableViewCellSelect {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MailFolderChildArrayTableViewCellSelect" object:nil];
}

- (void)mailFolderChildArrayTableViewCellSelect:(NSNotification *)sender {
    NSString *oldAct = self.act;
    NSInteger oldBoxID = self.boxID;
    NSDictionary *dic = sender.userInfo;
    MailFolderCell *cellModel = dic[@"cellModel"];
    NSMutableArray<NSArray<MailFolderCell *> *> *mutableArrayArray = dic[@"oldFolderArrayArray"];
    self.act = NSLocalizedString(cellModel.name, nil);
    self.boxID = cellModel.mailboxId;
    self.pageIndex = 1;
    NSInteger folderLevel = [dic[@"folderLevel"] integerValue];
    self.folderLevel = folderLevel;
    LRLog(@"oldAct = %@", oldAct);
    LRLog(@"oldBoxId = %ld", oldBoxID);
    LRLog(@"%ld",self.boxID);
    LRLog(@"%@",self.act);
    if ([self.act isEqualToString:cellModel.name]) {
        NSString *str = @"WJJ";
        self.act = [str stringByAppendingFormat:@"%zi",cellModel.id];
    }
    if ([oldAct isEqualToString:self.act] && oldBoxID == self.boxID) {
        return;
    }
    if (self.boxID == 0) {
        self.mailFolderBackViewTopConstraint.constant = -50;
        self.mailFolderBackView.hidden = YES;
    } else {
        RLMResults<MailFolderCell *> *results = [MailFolderCell objectsWhere:[NSString stringWithFormat:@"parentid CONTAINS '%ld_%ld'", cellModel.mailboxId, cellModel.id]];
        LRLog(@"%ld", cellModel.id);
        LRLog(@"%ld", results.count);
        if (results.count > 0) {
            self.folderBackViewIsExist = YES;
            self.mailFolderBackViewTopConstraint.constant = 0;
            self.mailFolderBackView.hidden = NO;
            if (self.folderLevel == 0) {
                self.mailFolderSameLevelBackView.hidden = NO;
                self.mailFolderPreviousBackView.hidden = YES;
                self.mailFolderImageView.hidden = NO;
            } else {
                self.mailFolderSameLevelBackView.hidden = NO;
                self.mailFolderPreviousBackView.hidden = NO;
                self.mailFolderImageView.hidden = YES;
            }
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (MailFolderCell *folderCell in results) {
                [mutableArray addObject:folderCell];
            }
            if (!self.oldMailFolderArrayArray) {
                self.oldMailFolderArrayArray = [NSMutableArray array];
            }
            self.oldMailFolderArrayArray = mutableArrayArray;
            self.mailFolderChildArray = [mutableArray copy];
        } else {
            if (self.folderLevel == 0) {
                self.mailFolderBackViewTopConstraint.constant = -50;
                self.mailFolderBackView.hidden = YES;
                self.mailFolderPreviousBackView.hidden = YES;
                self.mailFolderSameLevelBackView.hidden = NO;
                self.mailFolderImageView.hidden = NO;
            } else {
                self.mailFolderSameLevelBackView.hidden = YES;
                self.mailFolderPreviousBackView.hidden = NO;
                self.mailFolderImageView.hidden = YES;
            }
            if (!self.oldMailFolderArrayArray) {
                self.oldMailFolderArrayArray = [NSMutableArray array];
            }
            self.oldMailFolderArrayArray = mutableArrayArray;
            self.mailFolderChildArray = @[];
        }
    }
    self.title = cellModel.name;
    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
    NSString *userMD5Password = [UserInfoManager sharedUserInfoManager].userMD5Password;
    [HTTPInterface getUserMailListWithUserAccount:userAccount UserPassword:userMD5Password BoxID:self.boxID PageIndex:self.pageIndex PageMax:pageMax AndAct:self.act];
    [self addNotificationsOfMailHomeMailList];
}

#pragma mark - BackToRootMailArray
- (void)addNotificationOfBackToRootMailArray {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BackToRootMailArray:) name:@"BackToRootMailArray" object:nil];
}

- (void)removeNotificationOfBackToRootMailArray {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BackToRootMailArray" object:nil];
}

- (void)BackToRootMailArray:(NSNotification *)sender {
//    NSString *oldAct = self.act;
//    NSInteger oldBoxID = self.boxID;
//    NSDictionary *dic = sender.userInfo;
//    NSInteger boxID = [dic[@"boxID"] integerValue];
//    UserSmartMailBoxChildListCell *cellModel = dic[@"cellModel"];
    self.act = NSLocalizedString(self.mailBoxChildListCell.name, nil);
//    self.boxID = boxID;
    self.pageIndex = 1;
    self.folderLevel = 0;
//    LRLog(@"oldAct = %@", oldAct);
//    LRLog(@"oldBoxId = %ld", oldBoxID);
    LRLog(@"%ld",self.boxID);
    LRLog(@"%@",self.act);
    if ([self.act isEqualToString:self.mailBoxChildListCell.name]) {
        NSString *str = @"WJJ";
        NSArray<NSString *> *strArray = [self.mailBoxChildListCell.id componentsSeparatedByString:@"_"];
        NSString *IdString = strArray[strArray.count - 1];
        self.act = [str stringByAppendingFormat:@"%@",IdString];
    }
    if (self.boxID == 0) {
        self.mailFolderBackViewTopConstraint.constant = -50;
        self.mailFolderBackView.hidden = YES;
    } else {
        RLMResults<MailFolderCell *> *results = [MailFolderCell objectsWhere:[NSString stringWithFormat:@"parentid = '%@'", self.mailBoxChildListCell.id]];
        LRLog(@"%@", self.mailBoxChildListCell.id);
        LRLog(@"%ld", results.count);
        if (results.count > 0) {
            self.mailFolderBackViewTopConstraint.constant = 0;
            self.mailFolderBackView.hidden = NO;
            self.mailFolderPreviousBackView.hidden = YES;
            self.mailFolderSameLevelBackView.hidden = NO;
            self.mailFolderImageView.hidden = NO;
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (MailFolderCell *folderCell in results) {
                [mutableArray addObject:folderCell];
            }
            self.mailFolderChildArray = [mutableArray copy];
            self.oldMailFolderArrayArray = [NSMutableArray array];
        } else {
            self.mailFolderBackViewTopConstraint.constant = -50;
            self.mailFolderBackView.hidden = YES;
            self.mailFolderPreviousBackView.hidden = YES;
            self.mailFolderSameLevelBackView.hidden = NO;
            self.mailFolderImageView.hidden = NO;
        }
    }
    self.title = self.mailBoxChildListCell.name;
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable: {
            [MBProgressHUD showError:@"无网络" toView:self.view];
            //            [self getMailHomeMailListWithPageIndex:@(self.pageIndex)];
            //            NSString *str = nil;
            //            if ([self.act containsString:@"WJJ"]) {
            //                NSString *rootIdStr = [self.act stringByReplacingOccurrencesOfString:@"WJJ" withString:@""];
            //                str = [NSString stringWithFormat:@"MailBoxId = %ld AND RootId = %@", self.boxID, rootIdStr];
            //            } else {
            //                str = [NSString stringWithFormat:@"MailBoxId = %ld AND BoxBase = %@", self.boxID, self.act];
            //            }
            //            RLMResults<MailHomeMailListCell *> *results = [MailHomeMailListCell objectsWhere:[NSString stringWithFormat:@"MailBoxId = %ld AND ", self.boxID]];
            break;
        }
            
        default: {
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userMD5Password = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [HTTPInterface getUserMailListWithUserAccount:userAccount UserPassword:userMD5Password BoxID:self.boxID PageIndex:self.pageIndex PageMax:pageMax AndAct:self.act];
            [self addNotificationsOfMailHomeMailList];
            break;
        }
    }
}

#pragma mark - NSNotifications Of MailHomeMailList
- (void)getMailHomeMailListSuccess:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSNumber *index = sender.userInfo[@"index"];
    LRLog(@"%@",index);
    [self getMailHomeMailListWithPageIndex:index];
}

- (void)getMailHomeMailListWithPageIndex:(NSNumber *)pageIndex {
    MailHomeMailList *mailHomeMailList = [MailHomeMailList objectForPrimaryKey:pageIndex];
    self.mailCount = mailHomeMailList.count;
    NSMutableArray *mutableArray = nil;
    if ([pageIndex integerValue] == 1) {
        mutableArray = [NSMutableArray array];
    } else {
        mutableArray = [self.mailHomeMailArray mutableCopy];
    }
    for (MailHomeMailListCell *cell in mailHomeMailList.mailList) {
        [mutableArray addObject:cell];
    }
    self.mailHomeMailArray = [mutableArray copy];
    [self.mailListTableView reloadData];
    [self removeNotificationsOfMailHomeMailList];
    [self endRefreshing];
}

- (void)getMailHomeMailListFailed:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    [self removeNotificationsOfMailHomeMailList];
    [self endRefreshing];
}

- (void)getMailHomemailListError:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    [self removeNotificationsOfMailHomeMailList];
    [self endRefreshing];
}

- (void)addNotificationsOfMailHomeMailList {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMailHomeMailListSuccess:) name:GetMailHomeMailListSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMailHomeMailListFailed:) name:GetMailHomeMailListFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMailHomemailListError:) name:GetMailHomeMailListError object:nil];
}

- (void)removeNotificationsOfMailHomeMailList {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetMailHomeMailListSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetMailHomeMailListFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetMailHomeMailListError object:nil];
}

#pragma mark - NSNotifications Of MailStateChange
- (void)mailStateChangeSuccess:(NSNotification *)sender {
    NSString *str = sender.userInfo[@"back"];
    NSString *isTrue = sender.userInfo[@"isTrue"];
    LRLog(@"%@",isTrue);
    LRLog(@"%@",str);
    NSString *typeStr = sender.userInfo[@"typeString"];
    LRLog(@"%@",typeStr);
    NSArray<NSIndexPath *> *indexPathArray = sender.userInfo[@"indexPathArray"];
    NSMutableArray *mutableCellModelArray = [self.mailHomeMailArray mutableCopy];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPathArray) {
        MailHomeMailListCell *cell = mutableCellModelArray[indexPath.row];
        [mutableArray addObject:cell];
    }
    if ([typeStr isEqualToString:@"Top"]) {
        for (int i = 0; i < mutableArray.count; i++) {
            MailHomeMailListCell *cellModel = mutableArray[i];
            if ([str isEqualToString:@"取消置顶成功"]) {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    cellModel.TopTime = nil;
                }];
            } else {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
                NSDate *date = [[NSDate alloc] init];
                NSString *dateStr = [format stringFromDate:date];
                NSString *dateString = [dateStr stringByReplacingOccurrencesOfString:@" " withString:@"T"];
                LRLog(@"%@", dateString);
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    cellModel.TopTime = dateString;
                }];
            }
            mutableCellModelArray[indexPathArray[i].row] = cellModel;
            LRLog(@"%@",cellModel);
        }
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@", str] toView:self.view];
        self.mailHomeMailArray = [mutableCellModelArray copy];
        [self.mailListTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    } else if ([typeStr isEqualToString:@"Star"]) {
        for (int i = 0; i < mutableArray.count; i++) {
            MailHomeMailListCell *cellModel = mutableArray[i];
            if ([str isEqualToString:@"取消星标成功"]) {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    cellModel.star = nil;
                }];
            } else {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    cellModel.star = @"1";
                }];
            }
            mutableCellModelArray[indexPathArray[i].row] = cellModel;
        }
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@", str] toView:self.view];
        self.mailHomeMailArray = [mutableCellModelArray copy];
        [self.mailListTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    } else if ([typeStr isEqualToString:@"Redflag"]) {
        for (int i = 0; i < mutableArray.count; i++) {
            MailHomeMailListCell *cellModel = mutableArray[i];
            if ([str containsString:@"取消"]) {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    cellModel.redflag = nil;
                }];
            } else {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    cellModel.redflag = @"1";
                }];
            }
            mutableCellModelArray[indexPathArray[i].row] = cellModel;
        }
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@", str] toView:self.view];
        self.mailHomeMailArray = [mutableCellModelArray copy];
        [self.mailListTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    } else if ([typeStr isEqualToString:@"Read"]) {
        for (int i = 0; i < mutableArray.count; i++) {
            MailHomeMailListCell *cellModel = mutableArray[i];
            if ([str containsString:@"取消"]) {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    cellModel.Read = @"否";
                }];
            } else {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    cellModel.Read = @"是";
                }];
            }
            mutableCellModelArray[indexPathArray[i].row] = cellModel;
            LRLog(@"%@",cellModel);
        }
        [MBProgressHUD showSuccess:str toView:self.view];
        self.mailHomeMailArray = [mutableCellModelArray copy];
        [self.mailListTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    } else if ([typeStr isEqualToString:@"Delete"]) {
        for (int i = 0; i < mutableArray.count; i++) {
            if ([str isEqualToString:@"删除成功"]) {
                MailHomeMailListCell *cellModel = mutableArray[i];
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    [[RLMRealm defaultRealm] deleteObject:cellModel];
                }];
                [mutableCellModelArray removeObjectAtIndex:indexPathArray[i].row];
            }
        }
        [MBProgressHUD showSuccess:str toView:self.view];
        self.mailHomeMailArray = [mutableCellModelArray copy];
        [self.mailListTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationRight];
    }
//    [self removeNotificationsOfMailStateChange];
}

- (void)mailStateChangeFailed:(NSNotification *)sender {
    NSString *str = sender.userInfo[@"back"];
    [MBProgressHUD showError:str toView:self.view];
//    [self removeNotificationsOfMailStateChange];
}

- (void)mailStateChangeError:(NSNotification *)sender {
    NSString *str = sender.userInfo[@"userInfo"];
    [MBProgressHUD showError:str toView:self.view];
//    [self removeNotificationsOfMailStateChange];
}

- (void)addNotificationsOfMailStateChange {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailStateChangeSuccess:) name:MailStateChangeSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailStateChangeFailed:) name:MailStateChangeFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailStateChangeError:) name:MailStateChangeError object:nil];
}

- (void)removeNotificationsOfMailStateChange {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MailStateChangeSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MailStateChangeFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MailStateChangeError object:nil];
}

#pragma mark - NSNotifications Of MailMove
- (void)mailMoveSuccess:(NSNotification *)sender {
    NSString *back = sender.userInfo[@"back"];
    NSArray<NSIndexPath *> *indexPathArray = sender.userInfo[@"indexPath"];
    NSMutableArray *mutableArray = [self.mailHomeMailArray mutableCopy];
    for (NSIndexPath *indexPath in indexPathArray) {
        MailHomeMailListCell *cellModel = self.mailHomeMailArray[indexPath.row];
//        [[RLMRealm defaultRealm] transactionWithBlock:^{
//            [[RLMRealm defaultRealm] deleteObject:cellModel];
//        }];//移动邮件只删除界面，数据库内不删除
        [mutableArray removeObject:cellModel];
    }
    self.mailHomeMailArray = [mutableArray copy];
//    [self.mailListTableView reloadData];
    [self.mailListTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationRight];
    
    
    [MBProgressHUD showSuccess:back toView:self.view];
//    [self removeNotificationsOfMailMove];
}

- (void)mailMoveFailed:(NSNotification *)sender {
    NSString *back = sender.userInfo[@"back"];
    LRLog(@"%@",back);
    [MBProgressHUD showError:back toView:self.view];
//    [self removeNotificationsOfMailMove];
}

- (void)mailMoveError:(NSNotification *)sender {
    NSString *back = sender.userInfo[@"userInfo"];
    LRLog(@"%@", back);
    [MBProgressHUD showError:back toView:self.view];
//    [self removeNotificationsOfMailMove];
}

- (void)addNotificationsOfMailMove {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailMoveSuccess:) name:MailMoveSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailMoveFailed:) name:MailMoveFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailMoveError:) name:MailMoveError object:nil];
}

- (void)removeNotificationsOfMailMove {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MailMoveSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MailMoveFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MailMoveError object:nil];
}

#pragma mark - BarButtonItemClick
- (void)slidingMenuPullOutOrPullBack:(UIButton *)sender {
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftMenuCallOut" object:nil userInfo:@{@"select": @(sender.selected)}];
//    sender.selected = !sender.selected;
}

- (void)callOutTheLittleMoreView:(UIButton *)sender {
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.littleMoreViewHeightConstraint.constant = 0;
            self.littleMoreView.alpha = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.littleMoreView.hidden = YES;
            self.maskView.hidden = YES;
            sender.selected = !sender.selected;
            self.secondRightBarButton.userInteractionEnabled = YES;
            if (!self.lotUpdateButton.selected) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutTabBar" object:nil];
            }
        }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabBar" object:nil userInfo:nil];
        self.maskView.hidden = NO;
        self.littleMoreView.hidden = NO;
        self.secondRightBarButton.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.littleMoreViewHeightConstraint.constant = 153;
            self.littleMoreView.alpha = 1;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            sender.selected = !sender.selected;
        }];
    }
}

- (void)completeButtonClick:(UIButton *)sender {
    self.lotUpdateButton.selected = NO;
    [self goOutTheBottomView];
    self.mailListTableView.isEditing = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellStateChange" object:nil userInfo:nil];
    self.mailListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerViewRefresh)];
    self.mailListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerViewRefresh)];
//    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    self.leftBarButton.hidden = NO;
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton];
    UIBarButtonItem *secondRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.secondRightBarButton];
    self.navigationItem.rightBarButtonItems= @[rightBarButtonItem, secondRightBarButtonItem];
    NSMutableArray *mutableArray = [self.mailHomeMailArray mutableCopy];
    for (int i = 0; i < self.mailHomeMailArray.count; i++) {
        MailHomeMailListCell *cellModel = mutableArray[i];
        if (cellModel.isSelect == 100) {
            cellModel.isSelect = 0;
            mutableArray[i] = cellModel;
        }
    }
    self.mailHomeMailArray = [mutableArray copy];
    if (self.mailFolderBackViewTopConstraint.constant == -50 && self.folderBackViewIsExist) {
        self.mailFolderBackView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.mailFolderBackViewTopConstraint.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)writeNewMail:(UIButton *)sender {
    MailSendViewController *mailSendVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailSendVC"];
    [mailSendVC recieveTheMailDetailModel:nil AndAttachmentArray:nil AndType:MailSendTypeNew AndMailBoxId:self.boxID];
    UINavigationController *mailSendNavi = [[UINavigationController alloc] initWithRootViewController:mailSendVC];
    
    [self presentViewController:mailSendNavi animated:YES completion:nil];
}

- (void)goOutTheBottomView {
    if (self.bottomViewBottomConstraint.constant == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomViewBottomConstraint.constant = -49;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutTabBar" object:nil userInfo:nil];
        }];
        
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomViewBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - MaskViewTapGesture
- (IBAction)maskViewTap:(UITapGestureRecognizer *)sender {
    [self callOutTheLittleMoreView:self.rightBarButton];
}

#pragma mark - BottomButtomClick
- (void)setMailStateWithIsTrue:(NSString *)istrue AndTypeString:(NSString *)typeString {
    NSMutableArray *mutableCellModelArray = [NSMutableArray array];
    NSMutableArray *mutableIndexPathArray = [NSMutableArray array];
    NSString *mutableStr = @"";
    [self.mailHomeMailArray enumerateObjectsUsingBlock:^(MailHomeMailListCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect == 100) {
            [mutableCellModelArray addObject:obj];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [mutableIndexPathArray addObject:indexPath];
        }
    }];
    if (mutableCellModelArray.count < 1 || mutableIndexPathArray.count < 1) {
        return;
    }
    [self completeButtonClick:nil];
    for (int i = 0; i < mutableCellModelArray.count; i++) {
        MailHomeMailListCell *cellModel = mutableCellModelArray[i];
        if (i == 0) {
            mutableStr = [mutableStr stringByAppendingFormat:@"%ld",cellModel.Id];
        } else {
            mutableStr = [mutableStr stringByAppendingFormat:@",%ld",cellModel.Id];
        }
    }
    LRLog(@"%@",mutableStr);
    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
    NSArray<NSIndexPath *> *indexPathArray = [mutableIndexPathArray copy];
//    [self addNotificationsOfMailStateChange];
    [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:mutableStr AndTrue:istrue AndTypeString:typeString IndexPathArray:indexPathArray];
}

- (IBAction)bottomIsReadButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default:
            [self setMailStateWithIsTrue:@"true" AndTypeString:@"Read"];
            break;
    }
    
}

- (IBAction)bottomIsNotReadButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default:
            [self setMailStateWithIsTrue:@"false" AndTypeString:@"Read"];
            break;
    }
    
}

- (IBAction)bottomDeleteButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default: {
            
            NSMutableArray<MailHomeMailListCell *> *mutableCellModelArray = [NSMutableArray array];
            NSMutableArray *mutableIndexPathArray = [NSMutableArray array];
            NSString *mutableStr = @"";
            [self.mailHomeMailArray enumerateObjectsUsingBlock:^(MailHomeMailListCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isSelect == 100) {
                    [mutableCellModelArray addObject:obj];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [mutableIndexPathArray addObject:indexPath];
                }
            }];
            if (mutableCellModelArray.count < 1 || mutableIndexPathArray.count < 1) {
                return;
            }
            [self completeButtonClick:nil];
            for (int i = 0; i < mutableCellModelArray.count; i++) {
                MailHomeMailListCell *cellModel = mutableCellModelArray[i];
                if (i == 0) {
                    mutableStr = [mutableStr stringByAppendingFormat:@"%ld",cellModel.Id];
                } else {
                    mutableStr = [mutableStr stringByAppendingFormat:@",%ld",cellModel.Id];
                }
            }
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
            NSArray<NSIndexPath *> *indexPathArray = [mutableIndexPathArray copy];
            NSMutableSet<NSNumber *> *mailBoxIdMutableSet = [NSMutableSet set];
            NSInteger firstMailBoxId = mutableCellModelArray[0].MailBoxId;
            [mailBoxIdMutableSet addObject:@(firstMailBoxId)];
            NSSet *mailBoxIDSet = [mailBoxIdMutableSet copy];
            for (MailHomeMailListCell *cellModel in mutableCellModelArray) {
                for (NSNumber *mailBoxID in mailBoxIDSet) {
                    if ([mailBoxID integerValue] != cellModel.MailBoxId) {
                        [mailBoxIdMutableSet addObject:@(cellModel.MailBoxId)];
                        mailBoxIDSet = [mailBoxIdMutableSet copy];
                    }
                }
            }
            if ([self.act isEqualToString:NSLocalizedString(@"垃圾箱", nil)]) {
//写移动到已删除邮件的方法
//                [self addNotificationsOfMailMove];
                for (NSNumber *mailBoxId in mailBoxIDSet) {
                    NSMutableArray<NSIndexPath *> *indexPathMutableArray = [NSMutableArray array];
                    NSMutableArray<MailHomeMailListCell *> *cellModelMutableArray = [NSMutableArray array];
                    for (int i = 0; i < mutableCellModelArray.count; i++) {
                        MailHomeMailListCell *cellModel = mutableCellModelArray[i];
                        
                        if ([mailBoxId integerValue] == cellModel.MailBoxId) {
                            [indexPathMutableArray addObject:mutableIndexPathArray[i]];
                            [cellModelMutableArray addObject:cellModel];
                        }
                    }
                    NSString *mailIDString = @"";
                    for (int i = 0; i < cellModelMutableArray.count; i++) {
                        MailHomeMailListCell *cellModelModel = cellModelMutableArray[i];
                        if (i == 0) {
                            mailIDString = [mailIDString stringByAppendingFormat:@"%ld",cellModelModel.Id];
                        } else {
                            mailIDString = [mailIDString stringByAppendingFormat:@",%ld",cellModelModel.Id];
                        }
                    }
                    [HTTPInterface moveMailToBoxID:[mailBoxId integerValue] FromMailID:mailIDString RootID:0 OrBoxStr:NSLocalizedString(@"已删除邮件", nil) WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:indexPathMutableArray];
                }
                
            } else if ([self.act isEqualToString:NSLocalizedString(@"已删除邮件", nil)]) {
//写删除邮件方法
//                [self addNotificationsOfMailStateChange];
                [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:mutableStr AndTrue:@"true" AndTypeString:@"Delete" IndexPathArray:indexPathArray];
            } else {
//写移动到垃圾箱的方法
//                [self addNotificationsOfMailMove];
                for (NSNumber *mailBoxId in mailBoxIDSet) {
                    NSMutableArray<NSIndexPath *> *indexPathMutableArray = [NSMutableArray array];
                    NSMutableArray<MailHomeMailListCell *> *cellModelMutableArray = [NSMutableArray array];
                    for (int i = 0; i < mutableCellModelArray.count; i++) {
                        MailHomeMailListCell *cellModel = mutableCellModelArray[i];
                        
                        if ([mailBoxId integerValue] == cellModel.MailBoxId) {
                            [indexPathMutableArray addObject:mutableIndexPathArray[i]];
                            [cellModelMutableArray addObject:cellModel];
                        }
                    }
                    NSString *mailIDString = @"";
                    for (int i = 0; i < cellModelMutableArray.count; i++) {
                        MailHomeMailListCell *cellModelModel = cellModelMutableArray[i];
                        if (i == 0) {
                            mailIDString = [mailIDString stringByAppendingFormat:@"%ld",cellModelModel.Id];
                        } else {
                            mailIDString = [mailIDString stringByAppendingFormat:@",%ld",cellModelModel.Id];
                        }
                    }
                    [HTTPInterface moveMailToBoxID:[mailBoxId integerValue] FromMailID:mailIDString RootID:0 OrBoxStr:NSLocalizedString(@"垃圾箱", nil) WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:indexPathMutableArray];
                }
            }
            break;
        }
    }
}

- (IBAction)bottomMoveButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default: {
            NSMutableArray<MailHomeMailListCell *> *mutableCellModelArray = [NSMutableArray array];
            NSMutableArray *mutableIndexPathArray = [NSMutableArray array];
            [self.mailHomeMailArray enumerateObjectsUsingBlock:^(MailHomeMailListCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isSelect == 100) {
                    [mutableCellModelArray addObject:obj];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [mutableIndexPathArray addObject:indexPath];
                }
            }];
            
            if (mutableCellModelArray.count < 1 || mutableIndexPathArray.count < 1) {
                return;
            }
            self.mutableCellModelArray = [mutableCellModelArray copy];
            self.mutableIndexPathArray = [mutableIndexPathArray copy];
            [self completeButtonClick:nil];
            MailMoveFolderViewController *mailMoveFolderVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailMoveFolderViewController"];
            [self.navigationController pushViewController:mailMoveFolderVC animated:YES];
            break;
        }
    }
}

#pragma mark - LittleMoreViewButtonClick
- (IBAction)lotUpdateButtonClick:(UIButton *)sender {
    sender.selected = YES;
    [self callOutTheLittleMoreView:self.rightBarButton];
    [self goOutTheBottomView];
    if (self.mailFolderBackViewTopConstraint.constant == 0 && self.folderBackViewIsExist) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mailFolderBackViewTopConstraint.constant = -50;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.mailFolderBackView.hidden = YES;
            
        }];
    }
    
    self.mailListTableView.isEditing = YES;
//    [self.mailListTableView setEditing:YES];
//    self.mailListTableView.isManaging = YES;
    self.mailListTableView.mj_header = nil;
    self.mailListTableView.mj_footer = nil;
//    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    self.leftBarButton.hidden = YES;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = self.completeBarButtonItem;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellStateChange" object:nil userInfo:@{@"state":@"编辑"}];
}

- (IBAction)searchButtonClick:(UIButton *)sender {
    
}

- (IBAction)createFolderButtonClick:(UIButton *)sender {
    
}

#pragma mark - SelectButtonOfCellClickDelegate
- (void)selectButtonOfCellClick:(NSInteger)index {
    NSMutableArray *mutableArray = [self.mailHomeMailArray mutableCopy];
    MailHomeMailListCell *cell = mutableArray[index];
    if (cell.isSelect == 100) {
        cell.isSelect = 0;
    } else {
        cell.isSelect = 100;
    }
    mutableArray[index] = cell;
    self.mailHomeMailArray = [mutableArray copy];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MailHomeMailListCell *cellModel = self.mailHomeMailArray[indexPath.row];
    LRLog(@"%@", cellModel);
    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default:
            [self addNotificationsOfMailStateChange];
            if (![cellModel.Read isEqualToString:@"是"]) {
                NSString *IDstr = [NSString stringWithFormat:@"%ld", cellModel.Id];
                [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:IDstr AndTrue:@"true" AndTypeString:@"Read" IndexPathArray:@[indexPath]];
            }
            
            self.mutableCellModelArray = @[cellModel];
            self.mutableIndexPathArray = @[indexPath];
            
            MailDetailViewController *mailDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailDetailViewController"];
            [mailDetailVC recieveTheMailListArray:self.mailHomeMailArray AndAct:self.act];
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [HTTPInterface getMailDetailByMailID:cellModel.Id IndexPath:indexPath UserAccount:userAccount UserPassword:userPassword];
            [self.drawerVC.tabBarController.navigationController pushViewController:mailDetailVC animated:YES];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabBar" object:nil];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mailHomeMailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MailHomeMailListCell *cellModel = self.mailHomeMailArray[indexPath.row];
    
    MailTableViewCell *cell = [MailTableViewCell setMailTableViewCellByModel:cellModel WithTableView:(MailTableView *)tableView AndIndexPath:indexPath];
    cell.selectDelegate = self;
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal image:[UIImage imageNamed:@"删除cell"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        LRLog(@"delete");
        if (tableView.isEditing) {
            [MBProgressHUD showError:@"编辑状态中无法使用此功能" toView:self.view];
        } else {
            switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
                case AFNetworkReachabilityStatusUnknown:
                case AFNetworkReachabilityStatusNotReachable:
                    [MBProgressHUD showError:@"无网络" toView:self.view];
                    break;
                    
                default: {
//                    [self addNotificationsOfMailStateChange];
                    [self changCellStateWithTypeString:@"Delete" IndexPath:indexPath UserAccount:userAccount UserPassword:userPassword];
                    break;
                }
            }
        }
        [tableView setEditing:NO animated:YES];
        
    }];

    UITableViewRowAction *moveAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal image:[UIImage imageNamed:@"邮件移动cell"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        if (tableView.isEditing) {
            [MBProgressHUD showError:@"编辑状态中无法使用此功能" toView:self.view];
        } else {
            switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
                case AFNetworkReachabilityStatusUnknown:
                case AFNetworkReachabilityStatusNotReachable:
                    [MBProgressHUD showError:@"无网络" toView:self.view];
                    break;
                    
                default: {
                    self.mutableCellModelArray = @[self.mailHomeMailArray[indexPath.row]];
                    self.mutableIndexPathArray = @[indexPath];
                    MailMoveFolderViewController *mailMoveFolderVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailMoveFolderViewController"];
                    [self.drawerVC.tabBarController.navigationController pushViewController:mailMoveFolderVC animated:YES];
                    break;
                }
            }
        }
        [tableView setEditing:NO animated:YES];
    }];

    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal image:[UIImage imageNamed:@"置顶cell"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        if (tableView.isEditing) {
            [MBProgressHUD showError:@"编辑状态中无法使用此功能" toView:self.view];
        } else {
//            [self addNotificationsOfMailStateChange];
            [self changCellStateWithTypeString:@"Top" IndexPath:indexPath UserAccount:userAccount UserPassword:userPassword];
        }
        [tableView setEditing:NO animated:YES];
    }];

    UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal image:[UIImage imageNamed:@"标星cell"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        if (tableView.isEditing) {
            [MBProgressHUD showError:@"编辑状态中无法使用此功能" toView:self.view];
        } else {
//            [self addNotificationsOfMailStateChange];
            [self changCellStateWithTypeString:@"Star" IndexPath:indexPath UserAccount:userAccount UserPassword:userPassword];
        }
        [tableView setEditing:NO animated:YES];
    }];

    UITableViewRowAction *redFlagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal image:[UIImage imageNamed:@"红旗cell"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        if (tableView.isEditing) {
            [MBProgressHUD showError:@"编辑状态中无法使用此功能" toView:self.view];
        } else {
//            [self addNotificationsOfMailStateChange];
            [self changCellStateWithTypeString:@"Redflag" IndexPath:indexPath UserAccount:userAccount UserPassword:userPassword];
        }
        [tableView setEditing:NO animated:YES];
    }];
    return @[deleteAction, moveAction, topAction, starAction, redFlagAction];
}


#pragma mark - Methods Of Top, Star, RedFlag, Delete, Read
- (void)changCellStateWithTypeString:(NSString *)typeString IndexPath:(NSIndexPath *)indexPath UserAccount:(NSString *)userAccount UserPassword:(NSString *)userPassword {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:nil];
            break;
            
        default: {
            NSInteger Id = self.mailHomeMailArray[indexPath.row].Id;
            NSString *IdStr = [NSString stringWithFormat:@"%ld",Id];
            MailHomeMailListCell *cellModel = self.mailHomeMailArray[indexPath.row];
            NSString * isTrue = @"true";
            NSArray<NSIndexPath *> *indexPathArray = @[indexPath];
            if ([typeString isEqualToString:@"Top"]) {
                NSString *topTime = cellModel.TopTime;
                if (topTime && ![topTime isEqualToString:@""] && topTime.length > 0) {
                    isTrue = @"false";
                }
                [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:IdStr AndTrue:isTrue AndTypeString:typeString IndexPathArray:indexPathArray];
            } else if ([typeString isEqualToString:@"Star"]) {
                NSString *star = cellModel.star;
                if ([star isEqualToString:@"1"]) {
                    isTrue = @"false";
                }
                [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:IdStr AndTrue:isTrue AndTypeString:typeString IndexPathArray:indexPathArray];
            } else if ([typeString isEqualToString:@"Redflag"]) {
                NSString *redFlag = cellModel.redflag;
                if ([redFlag isEqualToString:@"1"]) {
                    isTrue = @"false";
                }
                [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:IdStr AndTrue:isTrue AndTypeString:typeString IndexPathArray:indexPathArray];
            } else if ([typeString isEqualToString:@"Read"]) {
                NSString *read = cellModel.Read;
                if ([read isEqualToString:@"是"]) {
                    isTrue = @"false";
                }
                [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:IdStr AndTrue:isTrue AndTypeString:typeString IndexPathArray:indexPathArray];
            } else if ([typeString isEqualToString:@"Delete"]) {
                NSString *mailIdStr = [NSString stringWithFormat:@"%ld", cellModel.Id];
                if ([self.act isEqualToString:NSLocalizedString(@"垃圾箱", nil)]) {
                    //写移动到已删除邮件的方法
                        [HTTPInterface moveMailToBoxID:cellModel.MailBoxId FromMailID:mailIdStr RootID:0 OrBoxStr:NSLocalizedString(@"已删除邮件", nil) WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:indexPathArray];
                } else if ([self.act isEqualToString:NSLocalizedString(@"已删除邮件", nil)]) {
                    //写删除邮件方法
                    [self addNotificationsOfMailStateChange];
                    [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:mailIdStr AndTrue:@"true" AndTypeString:@"Delete" IndexPathArray:indexPathArray];
                } else {
                    //写移动到垃圾箱的方法
                        [HTTPInterface moveMailToBoxID:cellModel.MailBoxId FromMailID:mailIdStr RootID:0 OrBoxStr:NSLocalizedString(@"垃圾箱", nil) WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:indexPathArray];
                    }
            }
            break;
        }
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    return cell.cellHeight;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
