//
//  SLSearchViewController.m
//  traderen
//
//  Created by 林林尤达 on 2017/5/18.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "SLSearchViewController.h"

@interface SLSearchViewController ()
//搜索控制器
@property (nonatomic,strong) UISearchBar *search;
//存放搜索数组

@end

@implementation SLSearchViewController

#pragma mark init 

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH-60, 40)];
    _search.barStyle = UIBarStyleDefault;
    _search.prompt = @"搜索";
    _search.showsCancelButton = NO;
    [self.view addSubview:_search];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 40, 40, 20)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(canClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)canClick
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - searchBarDelegate


@end
