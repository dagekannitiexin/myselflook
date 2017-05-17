//
//  MailImageAttachmentViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/5/12.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailImageAttachmentViewController.h"

@interface MailImageAttachmentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;
@property (nonatomic, strong) NSData *imageData;
@end

@implementation MailImageAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.attachmentImageView.image = [UIImage imageWithData:self.imageData];
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

- (void)recieveTheImage:(NSData *)imageData {
    self.imageData = imageData;
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
