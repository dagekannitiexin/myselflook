//
//  MailFolderViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/5/3.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailFolderViewController.h"
#import "MailFolderChildArrayTableViewCell.h"
#import "MailTableView.h"

@interface MailFolderViewController ()<UITableViewDelegate, UITableViewDataSource, MailFolderChildArrayTableViewCellButtonClickDelegate>
@property (nonatomic, strong) NSArray<MailFolderCell *> *mailFolderChildArray;
@property (nonatomic, strong) NSMutableArray<NSArray<MailFolderCell *> *> *oldMailFolderChildArrayArray;
@property (nonatomic, assign) MailFolderLevel level;
@property (nonatomic, assign) NSInteger folderLevel;
@property (weak, nonatomic) IBOutlet UIView *mailFolderBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mailFolderBackViewTopConstraint;
@property (nonatomic, strong) MailFolderCell *parentCellModel;
@property (weak, nonatomic) IBOutlet MailTableView *mailFolderTabelView;

@property (weak, nonatomic) IBOutlet UILabel *mailFolderLabel;
@property (nonatomic, strong) UIButton *rightBarButton;
@property (weak, nonatomic) IBOutlet UIView *littleMoreView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *littleMoreViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (nonatomic, strong) UIBarButtonItem *completeBarButtonItem;
@end

@implementation MailFolderViewController

#pragma mark - LazyLoad
- (NSMutableArray<NSArray<MailFolderCell *> *> *)oldMailFolderChildArrayArray {
    if (!_oldMailFolderChildArrayArray) {
        _oldMailFolderChildArrayArray = [NSMutableArray array];
    }
    return _oldMailFolderChildArrayArray;
}

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
    if (self.folderLevel > 0) {
        self.mailFolderLabel.text = @"返回上一级";
    }
    self.mailFolderTabelView.rowHeight = UITableViewAutomaticDimension;
    self.mailFolderTabelView.estimatedRowHeight = 100;
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.frame = CGRectMake(0, 0, 25, 25);
    [rightBarButton setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [rightBarButton setBackgroundColor:[UIColor clearColor]];
    [rightBarButton addTarget:self action:@selector(callOutTheLittleMoreView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.rightBarButton = rightBarButton;
    
//    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
//    blackView.backgroundColor = [UIColor blackColor];
//    blackView.alpha = 0.5;
//    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - BarButtonItemClick
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
//            self.secondRightBarButton.userInteractionEnabled = YES;
        }];
    } else {
        self.maskView.hidden = NO;
        self.littleMoreView.hidden = NO;
//        self.secondRightBarButton.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.littleMoreViewHeightConstraint.constant = 153;
            self.littleMoreView.alpha = 1;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            sender.selected = !sender.selected;
        }];
    }
}

- (void)goOutTheBottomView {
    if (self.bottomViewBottomConstraint.constant == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomViewBottomConstraint.constant = -49;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomViewBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)completeButtonClick:(UIButton *)sender {
    [self goOutTheBottomView];
    self.mailFolderTabelView.isEditing = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MailFolderChildArrayTableViewCellStateChange" object:nil userInfo:nil];
//    self.mailListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerViewRefresh)];
//    self.mailListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerViewRefresh)];
//    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//    self.leftBarButton.hidden = NO;
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton];
//    UIBarButtonItem *secondRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.secondRightBarButton];
//    self.navigationItem.rightBarButtonItems= @[rightBarButtonItem, secondRightBarButtonItem];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    NSMutableArray *mutableArray = [self.mailFolderChildArray mutableCopy];
    for (int i = 0; i < self.mailFolderChildArray.count; i++) {
        MailFolderCell *cellModel = mutableArray[i];
        if (cellModel.isSelect == 100) {
            cellModel.isSelect = 0;
            mutableArray[i] = cellModel;
        }
    }
    self.mailFolderChildArray = [mutableArray copy];
//    if (self.mailFolderChildArray.count > 0 ) {
        self.mailFolderBackView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.mailFolderBackViewTopConstraint.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
//    }
}

#pragma mark - LittleMoreViewButtonClick
- (IBAction)lotUpdateButtonClick:(UIButton *)sender {
    [self callOutTheLittleMoreView:self.rightBarButton];
    [self goOutTheBottomView];
    self.mailFolderTabelView.isEditing = YES;
    //    [self.mailListTableView setEditing:YES];
    //    self.mailListTableView.isManaging = YES;
//    self.mailListTableView.mj_header = nil;
//    self.mailListTableView.mj_footer = nil;
//    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
//    self.leftBarButton.hidden = YES;
//    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = self.completeBarButtonItem;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MailFolderChildArrayTableViewCellStateChange" object:nil userInfo:@{@"state":@"编辑"}];
//    if (self.mailFolderChildArray.count > 0 ) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mailFolderBackViewTopConstraint.constant = -50;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.mailFolderBackView.hidden = YES;
        }];
//    }
}

- (IBAction)searchButtonClick:(UIButton *)sender {
    
}

- (IBAction)createFolderButtonClick:(UIButton *)sender {
    
}


#pragma mark - MailFolderPreviousButtonClick
- (IBAction)mailFolderPreviousButtonClick:(UIButton *)sender {
    if (self.folderLevel == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToRootMailArray" object:nil userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.mailFolderChildArray = self.oldMailFolderChildArrayArray[self.folderLevel - 1];
    [self.oldMailFolderChildArrayArray removeObjectAtIndex:self.folderLevel - 1];
    self.folderLevel -= 1;
    if (self.folderLevel == 0) {
//        self.mailFolderBackView.hidden = YES;
//        self.mailFolderBackViewTopConstraint.constant = -50;
        self.mailFolderLabel.text = @"根邮件列表";
    } else {
        self.mailFolderLabel.text = @"返回上一级";
    }
    [self.mailFolderTabelView reloadData];
}


#pragma mark - GetMailFolderChildArray
- (void)getMailFolderChildArray:(NSArray<MailFolderCell *> *)mailFolderChildArray OldMailFolderChildArrayArray:(NSMutableArray<NSArray<MailFolderCell *> *> *)oldMailFolderChildArrayArray AndFolderLevel:(NSInteger)folderLevel {
    self.mailFolderChildArray = mailFolderChildArray;
    self.folderLevel = folderLevel;
    self.oldMailFolderChildArrayArray = oldMailFolderChildArrayArray;
}

#pragma mark - MailFolderChildArrayTableViewCellButtonClickDelegate
- (void)mailFolderChildArrayTableViewCellButtonClick:(NSInteger)tag {
    NSMutableArray *mutableArray = [self.mailFolderChildArray mutableCopy];
    MailFolderCell *cell = mutableArray[tag];
    if (cell.isSelect == 100) {
        cell.isSelect = 0;
    } else {
        cell.isSelect = 100;
    }
    mutableArray[tag] = cell;
    self.mailFolderChildArray = [mutableArray copy];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mailFolderChildArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"MailFolderChildArrayTableViewCell";
    MailFolderChildArrayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    MailFolderCell *cellModel = self.mailFolderChildArray[indexPath.row];
    cell.mailFolderNameLabel.text = cellModel.name;
    cell.selectButton.tag = indexPath.row;
    cell.buttonDelegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MailFolderCell *cellModel = self.mailFolderChildArray[indexPath.row];
    self.folderLevel += 1;
    self.oldMailFolderChildArrayArray[self.folderLevel - 1] = self.mailFolderChildArray;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MailFolderChildArrayTableViewCellSelect" object:nil userInfo:@{@"cellModel": cellModel, @"folderLevel": @(self.folderLevel), @"oldFolderArrayArray": self.oldMailFolderChildArrayArray}];
    [self.navigationController popViewControllerAnimated:YES];
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
