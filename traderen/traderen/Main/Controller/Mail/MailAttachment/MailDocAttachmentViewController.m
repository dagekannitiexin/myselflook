//
//  MailDocAttachmentViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/5/12.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailDocAttachmentViewController.h"
#import <WebKit/WebKit.h>

@interface MailDocAttachmentViewController ()
@property (nonatomic, strong) NSString *filePath;
@end

@implementation MailDocAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *wkwebview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:wkwebview];
    NSURL *fileURL = [NSURL fileURLWithPath:self.filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [wkwebview loadRequest:request];
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

- (void)recieveFilePath:(NSString *)filePath {
    self.filePath = filePath;
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
