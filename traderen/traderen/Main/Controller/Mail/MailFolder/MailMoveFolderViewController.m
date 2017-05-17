//
//  MailMoveFolderViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/22.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailMoveFolderViewController.h"
#import "UserMailBoxList.h"
#import "MailFolderCell.h"
#import "MailFolderTableViewCell.h"
#import "UserSmartMailBoxChildList.h"
#import "MailHomeDrawerViewController.h"

@interface MailMoveFolderViewController ()<UITableViewDelegate, UITableViewDataSource, MailFolderTableViewCellButtonClickDelegate>
@property (nonatomic, strong) NSArray<UserMailBoxListCell *> *mailBoxList;
@property (nonatomic, strong) NSArray<UserSmartMailBoxChildListCell *> *mailBoxChildList;
@property (nonatomic, strong) NSArray<MailFolderCell *> *mailFolderListArray;
@property (nonatomic, strong) NSArray<MailFolderCell *> *oldMailFolderListArray;
@property (nonatomic, strong) NSMutableArray<NSArray<MailFolderCell *> *> *oldMailFolderListTotalArray;
//@property (nonatomic, assign) BOOL isFolder;
@property (nonatomic, assign) NSUInteger folderLevel;
@property (nonatomic, strong) NSIndexPath *isSelectIndexPath;
@property (weak, nonatomic) IBOutlet UIView *buttonBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITableView *MailMoveTableView;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, assign) NSInteger boxId;
@end

@implementation MailMoveFolderViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UserMailBoxList *userMailBoxList = [UserMailBoxList objectForPrimaryKey:@(1)];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (UserMailBoxListCell *cellModel in userMailBoxList.userMailBoxList) {
            [mutableArray addObject:cellModel];
        }
        self.mailBoxList = [mutableArray copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isFolder = NO;
    self.folderLevel = 0;
    self.oldMailFolderListTotalArray = [NSMutableArray array];
    self.MailMoveTableView.estimatedRowHeight = 100;
    self.MailMoveTableView.rowHeight = UITableViewAutomaticDimension;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    [buttonItem setTintColor:[UIColor colorWithRed:1/255.0 green:147/255.0 blue:221/255.0 alpha:1.0]];
    self.rightBarButtonItem = buttonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabBar" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutTabBar" object:nil];
}

#pragma mark - RightBarButtonItemClick
- (void)rightBarButtonItemClick:(UIBarButtonItem *)sender {
    if (!self.isSelectIndexPath) {
        return;
    }
    if (self.folderLevel == 1) {
        UserSmartMailBoxChildListCell *mailBoxChildListCell = self.mailBoxChildList[self.isSelectIndexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveMailToAnotherFolder" object:nil userInfo:@{@"folderCellModel": mailBoxChildListCell, @"row": @(self.isSelectIndexPath.row), @"boxId": @(self.boxId)}];
    } else {
        MailFolderCell *cellModel = self.mailFolderListArray[self.isSelectIndexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveMailToAnotherFolder" object:nil userInfo:@{@"folderCellModel":cellModel}];
    }
    
    MailHomeDrawerViewController *mailHomeDrawerVC = nil;
    for (UIViewController *VC in self.navigationController.childViewControllers) {
        if ([VC isKindOfClass:[MailHomeDrawerViewController class]]) {
            mailHomeDrawerVC = (MailHomeDrawerViewController *)VC;
            break;
        }
    }
    [self.navigationController popToViewController:mailHomeDrawerVC animated:YES];
}

#pragma mark - FolderBackButtonClick
- (IBAction)backFolderButtonClick:(UIButton *)sender {
    if (self.folderLevel == 1) {
        self.boxId = 0;
        self.folderLevel = 0;
        self.isSelectIndexPath = nil;
        self.buttonBackView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        self.buttonViewTopConstraint.constant = -40;
        [self.MailMoveTableView reloadData];
    LRLog(@"self.folder = %ld", self.folderLevel);
    } else if (self.folderLevel == 2) {
        self.folderLevel = 1;
        self.mailFolderListArray = nil;
        self.isSelectIndexPath = nil;
        [self.MailMoveTableView reloadData];
    }
    else {
        self.mailFolderListArray = self.oldMailFolderListTotalArray[self.folderLevel - 3];
        [self.MailMoveTableView reloadData];
        self.folderLevel -= 1;
        self.isSelectIndexPath = nil;
    }
}

#pragma mark - MailFolderTableViewCellButtonClickDelegate
- (void)mailFolderTableViewCellButtonClick:(NSInteger)tag {
    if (self.isSelectIndexPath) {
        MailFolderTableViewCell *cell = [self.MailMoveTableView cellForRowAtIndexPath:self.isSelectIndexPath];
        cell.selectButton.selected = NO;
    }
    self.isSelectIndexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    MailFolderTableViewCell *cell = [self.MailMoveTableView cellForRowAtIndexPath:self.isSelectIndexPath];
    cell.selectButton.selected = YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.folderLevel == 0) {
        NSInteger boxId = self.mailBoxList[indexPath.row].id;
        LRLog(@"%ld",boxId);
        UserSmartMailBoxChildList *boxChildList = [UserSmartMailBoxChildList objectForPrimaryKey:@(boxId)];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (int i = 0; i < boxChildList.userSmartMailBoxChildList.count; i++) {
            UserSmartMailBoxChildListCell *cellModel = boxChildList.userSmartMailBoxChildList[i];
            [mutableArray addObject:cellModel];
        }
        self.mailBoxChildList = [mutableArray copy];
        if (self.mailBoxChildList.count < 1) {
            return;
        }
        self.boxId = boxId;
        self.folderLevel += 1;
        self.buttonBackView.hidden = NO;
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        self.buttonViewTopConstraint.constant = 0;
//        [self.view layoutIfNeeded];
        [tableView reloadData];
    } else if (self.folderLevel == 1) {
        RLMResults<MailFolderCell *> *results = [MailFolderCell objectsWhere:[NSString stringWithFormat:@"parentid = '%@'", self.mailBoxChildList[indexPath.row].id]];
        NSLog(@"%@", self.mailBoxChildList[indexPath.row].id);
        if (results.count == 0) {
            return;
        }
        self.folderLevel += 1;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (int i = 0; i < results.count; i++) {
            MailFolderCell *cellModel = results[i];
            [mutableArray addObject:cellModel];
        }
        self.mailFolderListArray = [mutableArray copy];
        [tableView reloadData];
    } else {
        NSInteger folderId = self.mailFolderListArray[indexPath.row].id;
        NSInteger boxId = self.mailFolderListArray[indexPath.row].mailboxId;
        RLMResults<MailFolderCell *> *results = [MailFolderCell objectsWhere:[NSString stringWithFormat:@"parentid = 'f_%ld_%ld'",boxId,folderId]];
        if (results.count == 0) {
            return;
        }
        self.folderLevel += 1;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (int i = 0; i < results.count; i++) {
            MailFolderCell *cellModel = results[i];
            [mutableArray addObject:cellModel];
        }
//        self.oldMailFolderListArray = self.mailFolderListArray;
        [self.oldMailFolderListTotalArray addObject:self.mailFolderListArray];
        self.mailFolderListArray = [mutableArray copy];
        [tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.folderLevel == 0) {
        return self.mailBoxList.count;
    } else if (self.folderLevel == 1) {
        return self.mailBoxChildList.count;
    } else {
        return self.mailFolderListArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MailFolderTableViewCell";
    MailFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectButton.tag = indexPath.row;
    cell.buttonDelegate = self;
    if (self.folderLevel == 0) {
        cell.titleLabel.text = self.mailBoxList[indexPath.row].name;
        cell.selectButton.hidden = YES;
    } else if (self.folderLevel == 1){
        cell.titleLabel.text = self.mailBoxChildList[indexPath.row].name;
        cell.selectButton.hidden = NO;
    } else {
        cell.titleLabel.text = self.mailFolderListArray[indexPath.row].name;
        cell.selectButton.hidden = NO;
    }
    if (self.isSelectIndexPath && self.isSelectIndexPath.row == indexPath.row) {
        cell.selectButton.selected = YES;
    } else {
        cell.selectButton.selected = NO;
    }
    
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
