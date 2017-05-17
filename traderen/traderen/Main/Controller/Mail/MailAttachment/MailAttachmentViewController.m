//
//  MailAttachmentViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/5/2.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailAttachmentViewController.h"
#import "HTTPInterface+Attachment.h"
#import "UserInfoManager.h"
#import "MBProgressHUD+XQ.h"
#import "NSString+Base64.h"
#import "UserDefaultsManager.h"
#import <WebKit/WebKit.h>
#import "UserLoginModel.h"
#import "MailImageAttachmentViewController.h"
#import "MailDocAttachmentViewController.h"

@interface MailAttachmentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;
@property (weak, nonatomic) IBOutlet UILabel *attachmentNameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *attachmentProgressView;
@property (weak, nonatomic) IBOutlet UILabel *attachmentProgressLabel;
//@property (nonatomic, strong) NSArray<MailDetailFileModel *> *attachmentArray;
@property (nonatomic, strong) MailDetailFileModel *attachmentModel;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) NSInteger attachmentSize;
@property (nonatomic, strong) NSString *attachmentName;
@property (nonatomic, assign) NSInteger attachmentId;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) MailHomeMailListCell *mailHomeMailListCellModel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@end

@implementation MailAttachmentViewController
#pragma mark - LazyLoad
//- (WKWebView *)webView {
//    if (!_webView) {
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
//        _webView.hidden = YES;
//        [self.view addSubview:_webView];
//    }
//    return _webView;
//}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCurrentSlideValue) userInfo:nil repeats:YES];
    self.position = 0;
    self.attachmentNameLabel.text = self.attachmentModel.name;
    self.attachmentSize = self.attachmentModel.size;
    self.attachmentName = self.attachmentModel.name;
    self.attachmentId = self.attachmentModel.id;
    self.attachmentProgressLabel.text = @"mmmmm";
//    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSNumber *userId = [UserDefaultsManager getUserId];
////    NSString *userName = [UserLoginModel objectForPrimaryKey:userId].name;
//    NSString *directoryPath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",userId]];
//    BOOL isExist;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL directoryIsExist = [fileManager fileExistsAtPath:directoryPath isDirectory:&isExist];
//    if (!(isExist && directoryIsExist)) {
//        BOOL isCreateDir = [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
//        if (!isCreateDir) {
//            LRLog(@"创建用户ID文件夹失败");
//        }
//    }
//    NSString *boxDirectoryPath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",self.mailHomeMailListCellModel.MailBoxId]];
//    BOOL isboxIdDirExist;
//    BOOL boxIdDirectoryIsExist = [fileManager fileExistsAtPath:boxDirectoryPath isDirectory:&isboxIdDirExist];
//    if (!(isboxIdDirExist && boxIdDirectoryIsExist)) {
//        BOOL isCreateBoxIdDir = [fileManager createDirectoryAtPath:boxDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
//        if (!isCreateBoxIdDir) {
//            LRLog(@"创建邮箱ID文件夹失败");
//        }
//    }
//    NSString *mailIdDirPath = [boxDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", self.mailHomeMailListCellModel.Id]];
//    BOOL isMailIdDirExist;
//    BOOL mailIdDirectoryIsExist = [fileManager fileExistsAtPath:mailIdDirPath isDirectory:&isMailIdDirExist];
//    if (!(isMailIdDirExist && mailIdDirectoryIsExist)) {
//        BOOL isCreateMailIdDir = [fileManager createDirectoryAtPath:mailIdDirPath withIntermediateDirectories:YES attributes:nil error:nil];
//        if (!isCreateMailIdDir) {
//            LRLog(@"创建邮件ID文件夹失败");
//        }
//    }
//    self.filePath = [mailIdDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.attachmentName]];
//    LRLog(@"%@", self.filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.filePath]) {
        NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];
        if (fileData.length == self.attachmentSize) {
            [MBProgressHUD showSuccess:@"文件已存在直接打开" toView:self.view];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            [self.view addSubview:imageView];
            NSData *data = [NSData dataWithContentsOfFile:self.filePath];
            imageView.image = [UIImage imageWithData:data];
        } else {
            [fileManager removeItemAtPath:self.filePath error:nil];
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [HTTPInterface downloadAttachmentWithUserAccount:userAccount UserPassword:userPassword AttachmentFileId:self.attachmentId AndPosition:self.position];
            [self addNotificationsOfDownloadAttachment];
        }
    } else {
        NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
        NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
        [HTTPInterface downloadAttachmentWithUserAccount:userAccount UserPassword:userPassword AttachmentFileId:self.attachmentId AndPosition:self.position];
        [self addNotificationsOfDownloadAttachment];
    }
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

- (void)getAttachmentCellModel:(MailDetailFileModel *)mailDetailFileModel andMailHomeMailListCell:(MailHomeMailListCell *)mailListCell AndFilePath:(NSString *)filePath {
    self.attachmentModel = mailDetailFileModel;
    self.mailHomeMailListCellModel = mailListCell;
    self.filePath = filePath;
}

#pragma mark - NSNotifications Of DownloadAttachment
- (void)downloadAttachmentSuccess:(NSNotification *)sender {
    NSString *base64DataString = sender.userInfo[@"data"];
    NSData *base64Data = [base64DataString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [[NSData alloc] initWithBase64EncodedData:base64Data options:NSDataBase64DecodingIgnoreUnknownCharacters];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSUInteger subSize = data.length;
    self.position += subSize;
    if (![fileManager fileExistsAtPath:self.filePath]) {
        BOOL isSuccess = [fileManager createFileAtPath:self.filePath contents:data attributes:nil];
        if (!isSuccess) {
            [MBProgressHUD showError:@"文件写入失败" toView:self.view];
            [fileManager removeItemAtPath:self.filePath error:nil];
            [self removeNotificationsOfDownloadAttachment];
            return;
        } else {
            NSInteger percent = self.position/self.attachmentSize * 100 * 1.0;
            self.attachmentProgressLabel.text = [NSString stringWithFormat:@"%.1ld%%", percent];
            [self.attachmentProgressView setProgress:self.position/self.attachmentSize*1.0 animated:YES];
            LRLog(@"text = %@, progress = %f", self.attachmentProgressLabel.text, self.attachmentProgressView.progress);
            if (self.position < self.attachmentSize) {
                NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
                NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
                [HTTPInterface downloadAttachmentWithUserAccount:userAccount UserPassword:userPassword AttachmentFileId:self.attachmentId AndPosition:self.position];
            } else {
//                [MBProgressHUD showSuccess:@"下载完成，可以打开" toView:self.view];
//                NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];
//                NSString *lastString = [self.attachmentModel.name componentsSeparatedByString:@"."].lastObject;
//                NSString *lowerString = [lastString lowercaseString];
//                if ([lowerString isEqualToString:@"png"] || [lowerString isEqualToString:@"jpg"] || [lowerString isEqualToString:@"jpeg"] || [lowerString isEqualToString:@"gif"]) {
//                    MailImageAttachmentViewController *imageAttachmentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailImageAttachmentViewController"];
//                    [imageAttachmentVC recieveTheImage:fileData];
//                    [self.navigationController pushViewController:imageAttachmentVC animated:YES];
//                    //pdf、doc、docx、xls、xlsx、ppt、pptx、txt
//                } else if ([lowerString isEqualToString:@"pdf"] || [lowerString isEqualToString:@"doc"] || [lowerString isEqualToString:@"docx"] || [lowerString isEqualToString:@"xls"] || [lowerString isEqualToString:@"xlsx"] || [lowerString isEqualToString:@"ppt"] || [lowerString isEqualToString:@"pptx"] || [lowerString isEqualToString:@"txt"]) {
//                    MailDocAttachmentViewController *docAttachmentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailDocAttachmentViewController"];
//                    [docAttachmentVC recieveFilePath:self.filePath];
//                    [self.navigationController pushViewController:docAttachmentVC animated:YES];
//                } else {
//                    NSString *msg = [NSString stringWithFormat:@"此文件已下载\n但无法打开查看%@格式的文件",lowerString];
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
//                    [alert addAction:action];
//                    [self presentViewController:alert animated:YES completion:nil];
//                }
                [self checkFile];
                [self removeNotificationsOfDownloadAttachment];
                self.checkButton.hidden = NO;
            }
        }
    } else {
        NSInteger percent = self.position/self.attachmentSize * 100 * 1.0;
        self.attachmentProgressLabel.text = [NSString stringWithFormat:@"%.1ld%%", percent];
        [self.attachmentProgressView setProgress:self.position/self.attachmentSize*1.0 animated:YES];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        [fileHandle closeFile];
        LRLog(@"text = %@, progress = %f", self.attachmentProgressLabel.text, self.attachmentProgressView.progress);
        if (self.position < self.attachmentSize) {
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [HTTPInterface downloadAttachmentWithUserAccount:userAccount UserPassword:userPassword AttachmentFileId:self.attachmentId AndPosition:self.position];
        } else {
//            [MBProgressHUD showSuccess:@"下载完成，可以打开" toView:self.view];
            [self checkFile];
//            NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];
//            NSString *lastString = [self.attachmentModel.name componentsSeparatedByString:@"."].lastObject;
//            NSString *lowerString = [lastString lowercaseString];
//            if ([lowerString isEqualToString:@"png"] || [lowerString isEqualToString:@"jpg"] || [lowerString isEqualToString:@"jpeg"] || [lowerString isEqualToString:@"gif"]) {
//                MailImageAttachmentViewController *imageAttachmentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailImageAttachmentViewController"];
//                [imageAttachmentVC recieveTheImage:fileData];
//                [self.navigationController pushViewController:imageAttachmentVC animated:YES];
//                //pdf、doc、docx、xls、xlsx、ppt、pptx、txt
//            } else if ([lowerString isEqualToString:@"pdf"] || [lowerString isEqualToString:@"doc"] || [lowerString isEqualToString:@"docx"] || [lowerString isEqualToString:@"xls"] || [lowerString isEqualToString:@"xlsx"] || [lowerString isEqualToString:@"ppt"] || [lowerString isEqualToString:@"pptx"] || [lowerString isEqualToString:@"txt"]) {
//                MailDocAttachmentViewController *docAttachmentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailDocAttachmentViewController"];
//                [docAttachmentVC recieveFilePath:self.filePath];
//                [self.navigationController pushViewController:docAttachmentVC animated:YES];
//            } else {
//                NSString *msg = [NSString stringWithFormat:@"此文件已下载\n但无法打开查看%@格式的文件",lowerString];
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
//                [alert addAction:action];
//                [self presentViewController:alert animated:YES completion:nil];
//            }
            [self removeNotificationsOfDownloadAttachment];
            self.checkButton.hidden = NO;
        }
    }
}

- (void)checkFile {
    NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];
    NSString *lastString = [self.attachmentModel.name componentsSeparatedByString:@"."].lastObject;
    NSString *lowerString = [lastString lowercaseString];
    if ([lowerString isEqualToString:@"png"] || [lowerString isEqualToString:@"jpg"] || [lowerString isEqualToString:@"jpeg"] || [lowerString isEqualToString:@"gif"]) {
        MailImageAttachmentViewController *imageAttachmentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailImageAttachmentViewController"];
        [imageAttachmentVC recieveTheImage:fileData];
        [self.navigationController pushViewController:imageAttachmentVC animated:YES];
        //pdf、doc、docx、xls、xlsx、ppt、pptx、txt
    } else if ([lowerString isEqualToString:@"pdf"] || [lowerString isEqualToString:@"doc"] || [lowerString isEqualToString:@"docx"] || [lowerString isEqualToString:@"xls"] || [lowerString isEqualToString:@"xlsx"] || [lowerString isEqualToString:@"ppt"] || [lowerString isEqualToString:@"pptx"] || [lowerString isEqualToString:@"txt"]) {
        MailDocAttachmentViewController *docAttachmentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailDocAttachmentViewController"];
        [docAttachmentVC recieveFilePath:self.filePath];
        [self.navigationController pushViewController:docAttachmentVC animated:YES];
    } else {
        NSString *msg = [NSString stringWithFormat:@"此文件已下载\n但无法打开查看%@格式的文件",lowerString];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//-(void)loadDocument:(NSString *)documentPath inView:(WKWebView *)webView {
//    NSURL *url = [NSURL fileURLWithPath:documentPath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//}

- (void)downloadAttachmentFailed:(NSNotification *)sender {
    NSString *back = sender.userInfo[@"back"];
    LRLog(@"%@",back);
    [MBProgressHUD showError:back toView:self.view];
    [self removeNotificationsOfDownloadAttachment];
}

- (void)downloadAttachmentError:(NSNotification *)sender {
    NSString *back = sender.userInfo[@"userInfo"];
    [MBProgressHUD showError:back toView:self.view];
    [self removeNotificationsOfDownloadAttachment];
}

- (void)addNotificationsOfDownloadAttachment {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAttachmentSuccess:) name:DownloadAttachmentSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAttachmentFailed:) name:DownloadAttachmentFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAttachmentError:) name:DownloadAttachmentError object:nil];
}

- (void)removeNotificationsOfDownloadAttachment {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DownloadAttachmentSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DownloadAttachmentFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DownloadAttachmentError object:nil];
}

#pragma mark - CheckButtonClick
- (IBAction)checkButtonClick:(UIButton *)sender {
    [self checkFile];
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
