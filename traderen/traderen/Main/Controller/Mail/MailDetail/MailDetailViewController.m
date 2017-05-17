//
//  MailDetailViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/24.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailDetailViewController.h"
#import "HTTPInterface+Mail.h"
#import "MailDetailModel.h"
#import "NSString+MailLabel.h"
#import "TagLabelView.h"
#import "UIView+Extension.h"
#import "RecipientLabelView.h"
#import <WebKit/WebKit.h>
#import "HTTPInterface+Mail.h"
#import "UserInfoManager.h"
#import "MBProgressHUD+XQ.h"
#import "UserInfoManager.h"
#import "MailDetailCollectionViewCell.h"
#import "MailMoveFolderViewController.h"
#import "MailAttachmentViewController.h"
#import "MailSendViewController.h"
#import "UserDefaultsManager.h"
#import "MailImageAttachmentViewController.h"
#import "MailDocAttachmentViewController.h"

@interface MailDetailViewController ()<WKNavigationDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet TagLabelView *mailLabelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mailLabelViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *fromNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *forthImageView;
@property (weak, nonatomic) IBOutlet UILabel *fromNameLabelInDetail;
@property (weak, nonatomic) IBOutlet UILabel *fromMailAddressLabelInDetail;
@property (weak, nonatomic) IBOutlet RecipientLabelView *mailRecipientView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mailRecipientViewHeightConstraint;
@property (weak, nonatomic) IBOutlet RecipientLabelView *mailCarbonCopyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mailCarbonCopyViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *mailDetailView;
@property (weak, nonatomic) IBOutlet UILabel *mailDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailRemarkLabel;
@property (nonatomic, assign) CGFloat detailViewHeight;
@property (weak, nonatomic) IBOutlet UIView *mailInfoView;
@property (nonatomic, assign) CGFloat mailInfoViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attachmentBackViewConstraint;
@property (nonatomic, strong) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *webBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webBackViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *attachmentView;
@property (nonatomic, strong) NSArray<MailHomeMailListCell *> *mailListArray;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewBottomConstrait;
@property (weak, nonatomic) IBOutlet UIView *activityIndicatorBackView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *distributeButton;
@property (weak, nonatomic) IBOutlet UIButton *replyOrForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
//@property (weak, nonatomic) IBOutlet UIWebView *uiWebView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uiWebViewHeightConstraint;
@property (nonatomic, assign) NSInteger mailId;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *act;
@property (nonatomic, strong) NSString *webLoadString;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreSelectViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyOrForwardViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *moreSelectView;
@property (weak, nonatomic) IBOutlet UIView *replyOrForwardView;
@property (weak, nonatomic) IBOutlet UICollectionView *attachmentCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (nonatomic, strong) NSArray<MailDetailFileModel *> *attachmentArray;
@property (nonatomic, strong) MailDetailModel *mailDetailModel;
@property (nonatomic, strong) UIButton *rightBarButton;
@property (nonatomic, strong) UIButton *secondRightBarButton;
@property (nonatomic, strong) NSString *filePath;
@end

@implementation MailDetailViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addNotificationsOfGetMailDetail];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutTabBar" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    // 自适应屏幕宽度js
//    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//    // 添加自适应屏幕宽度js调用的方法
//    WKUserContentController *wkUserController = [[WKUserContentController alloc] init];
//    [wkUserController addUserScript:wkUserScript];
//    wkWebConfig.userContentController = wkUserController;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.webBackViewHeightConstraint.constant) configuration:wkWebConfig];
    webView.scrollView.bounces = NO;
//    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.webBackView addSubview:webView];
    webView.navigationDelegate = self;
    self.webView = webView;
    self.contentViewHeightConstraint.constant = SCREENH_HEIGHT - 64;
    
    self.webBackView.layer.borderWidth = 0.5;
    self.webBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self setFlowLayout];
    self.attachmentCollectionView.alwaysBounceHorizontal = YES;
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.frame = CGRectMake(0, 0, 25, 25);
    [rightBarButton setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
    [rightBarButton setBackgroundColor:[UIColor clearColor]];
    [rightBarButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    UIButton *secondRightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondRightBarButton.frame = CGRectMake(0, 0, 25, 25);
    [secondRightBarButton setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
    [secondRightBarButton setBackgroundColor:[UIColor clearColor]];
    [secondRightBarButton addTarget:self action:@selector(secondRightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *secondRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:secondRightBarButton];
    
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem, secondRightBarButtonItem];
    self.rightBarButton = rightBarButton;
    self.secondRightBarButton = secondRightBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recieveTheMailListArray:(NSArray<MailHomeMailListCell *> *)mailListArray AndAct:(NSString *)act {
    self.mailListArray = [mailListArray copy];
    self.act = [act copy];
}

//下一封邮件
#pragma RightBarButtonClick
- (void)rightBarButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            if (self.indexPath.row + 1 < self.mailListArray.count) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.indexPath.row + 1 inSection:0];
                
                MailHomeMailListCell *cellModel = self.mailListArray[self.indexPath.row];
                MailDetailModel *mailDetailModel = [MailDetailModel objectForPrimaryKey:@(cellModel.Id)];
                if (mailDetailModel) {
                    self.mailId = cellModel.Id;
                    [self setWholeMailDetailByCellModel:cellModel AndMailId:self.mailId];
                    if (indexPath.row == self.mailListArray.count - 1) {
                        sender.enabled = NO;
                    } else {
                        sender.enabled = YES;
                    }
                    if (indexPath.row != 0) {
                        self.secondRightBarButton.enabled = YES;
                    }
                    self.indexPath = indexPath;
                } else {
                    [MBProgressHUD showError:@"本地数据库中不存在此邮件的详细内容" toView:self.view];
                    return;
                }
            } else {
                return;
            }
            break;
            
        default: {
            if (self.indexPath.row + 1 < self.mailListArray.count) {
                self.indexPath = [NSIndexPath indexPathForRow:self.indexPath.row + 1 inSection:0];
//                if (self.indexPath.row == self.mailListArray.count - 1) {
//                    sender.enabled = NO;
//                } else {
//                    sender.enabled = YES;
//                }
//                if (self.indexPath.row != 0) {
//                    self.secondRightBarButton.enabled = YES;
//                }
                MailHomeMailListCell *cellModel = self.mailListArray[self.indexPath.row];
                NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
                NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
                [HTTPInterface getMailDetailByMailID:cellModel.Id IndexPath:self.indexPath UserAccount:userAccount UserPassword:userPassword];
                [self.activityIndicator startAnimating];
                self.activityIndicatorBackView.hidden = NO;
                [self addNotificationsOfGetMailDetail];
            } else {
                return;
            }
            break;
        }
    }
}

//上一封邮件
- (void)secondRightBarButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            if (self.indexPath.row - 1 >= 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.indexPath.row - 1 inSection:0];
                
                MailHomeMailListCell *cellModel = self.mailListArray[self.indexPath.row];
                MailDetailModel *mailDetailModel = [MailDetailModel objectForPrimaryKey:@(cellModel.Id)];
                if (mailDetailModel) {
                    self.mailId = cellModel.Id;
                    [self setWholeMailDetailByCellModel:cellModel AndMailId:self.mailId];
                    if (indexPath.row == 0) {
                        sender.enabled = NO;
                    } else {
                        sender.enabled = YES;
                    }
                    if (indexPath.row != self.mailListArray.count - 1) {
                        self.rightBarButton.enabled = YES;
                    }
                } else {
                    [MBProgressHUD showError:@"本地数据库中不存在此邮件的详细内容" toView:self.view];
                    return;
                }
            } else {
                return;
            }
            break;
            
        default: {
            if (self.indexPath.row - 1 >= 0) {
                self.indexPath = [NSIndexPath indexPathForRow:self.indexPath.row - 1 inSection:0];
//                if (self.indexPath.row == 0) {
//                    sender.enabled = NO;
//                } else {
//                    sender.enabled = YES;
//                }
//                
                MailHomeMailListCell *cellModel = self.mailListArray[self.indexPath.row];
                NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
                NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
                [HTTPInterface getMailDetailByMailID:cellModel.Id IndexPath:self.indexPath UserAccount:userAccount UserPassword:userPassword];
                [self.activityIndicator startAnimating];
                self.activityIndicatorBackView.hidden = NO;
                [self addNotificationsOfGetMailDetail];
            } else {
                return;
            }
            break;
        }
    }
}

#pragma mark - DetailButtonClick
- (IBAction)detailButtonClick:(UIButton *)sender {
    if (sender.selected) {
        self.fromNameLabel.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.detailViewBottomConstrait.constant = - self.detailViewHeight;
            self.mailDetailView.alpha = 0;
            self.fromNameLabel.alpha = 1;
            [self.contentView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.mailDetailView.hidden = YES;
            sender.selected = !sender.selected;
            self.contentViewHeightConstraint.constant = self.webBackView.y + self.webBackViewHeightConstraint.constant;
        }];
    } else {
        self.mailDetailView.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.detailViewBottomConstrait.constant = 0;
            self.mailDetailView.alpha = 1;
            self.fromNameLabel.alpha = 0;
            [self.contentView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.fromNameLabel.hidden = YES;
            sender.selected = !sender.selected;
            self.contentViewHeightConstraint.constant = self.webBackView.y + self.webBackViewHeightConstraint.constant;
        }];
    }
}

#pragma mark - Notifications Of GetMailDetail
- (void)addNotificationsOfGetMailDetail {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMailDetailSuccess:) name:GetMailDetailSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMailDetailFailed:) name:GetMailDetailFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMailDetailError:) name:GetMailDetailError object:nil];
}

- (void)removeNotificationsOfGetMailDetail {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetMailDetailSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetMailDetailFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetMailDetailError object:nil];
}

- (void)getMailDetailSuccess:(NSNotification *)sender {
    [self.activityIndicator stopAnimating];
    self.activityIndicatorBackView.hidden = YES;
    NSNumber *mailId = sender.userInfo[@"mailID"];
    self.mailId = [mailId integerValue];
    NSIndexPath *indexPath = sender.userInfo[@"indexPath"];
    self.indexPath = indexPath;
    if (indexPath.row == 0) {
        self.secondRightBarButton.enabled = NO;
    } else {
        self.secondRightBarButton.enabled = YES;
    }
    if (indexPath.row == self.mailListArray.count - 1) {
        self.rightBarButton.enabled = NO;
    } else {
        self.rightBarButton.enabled = YES;
    }
    MailHomeMailListCell *cellModel = self.mailListArray[indexPath.row];
    
    [self setWholeMailDetailByCellModel:cellModel AndMailId:self.mailId];
    [self removeNotificationsOfGetMailDetail];
}

- (void)setWholeMailDetailByCellModel:(MailHomeMailListCell *)cellModel AndMailId:(NSInteger)mailId {
    NSString *subject = cellModel.Subject;
    
    if (subject && ![subject isEqualToString:@""] && subject.length > 0) {
        self.subjectLabel.text = cellModel.Subject;
    } else {
        self.subjectLabel.text = @"未填写";
    }
    self.subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    NSString *mailLabel = cellModel.MailLabel;
    if (mailLabel && ![mailLabel isEqualToString:@""] && mailLabel.length > 0) {
        self.mailLabelView.hidden = NO;
        NSArray<NSString *> *strArray = [NSString mailLabelStrToLabelStrArray:mailLabel];
        [self.mailLabelView bindTags:strArray];
        self.mailLabelViewHeightConstraint.constant = self.mailLabelView.height;
    }
    self.fromNameLabel.text = cellModel.FromName;
    if (self.fromNameLabel.hidden == YES) {
        self.fromNameLabel.hidden = NO;
        self.fromNameLabel.alpha = 1.0;
    }
    [self ToShowTheImageByfourImageView:@[self.firstImageView, self.secondImageView, self.thirdImageView, self.forthImageView] WithCellModel:cellModel];
    
    if (self.detailButton.selected) {
        self.detailButton.selected = NO;
    }
    
    if (self.mailDetailView.hidden == NO) {
        self.mailDetailView.hidden = YES;
        self.mailDetailView.alpha = 0;
    }
    
    self.fromNameLabelInDetail.text = cellModel.FromName;
    self.fromMailAddressLabelInDetail.text = cellModel.FromEmail;
    
    if (cellModel.itTo && ![cellModel.itTo isEqualToString:@""] && cellModel.itTo.length > 0) {
        NSArray<NSString *> *strArray = [cellModel.itTo componentsSeparatedByString:@","];
        [self.mailRecipientView bindRecipients:strArray];
        self.mailRecipientViewHeightConstraint.constant = self.mailRecipientView.height;
    }
    
    if (cellModel.cc && ![cellModel.cc isEqualToString:@""] && cellModel.cc.length > 0) {
        NSArray<NSString *> *strArray = [cellModel.cc componentsSeparatedByString:@","];
        [self.mailCarbonCopyView bindRecipients:strArray];
        self.mailCarbonCopyViewHeightConstraint.constant = self.mailCarbonCopyView.height;
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy/M/dd HH:mm:ss";
    NSDate *date = [format dateFromString:cellModel.MailDate];
    format.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    NSString *dateString = [format stringFromDate:date];
    self.mailDateLabel.text = dateString;
    
    self.areaLabel.text = cellModel.Area;
    self.mailRemarkLabel.text = @"未填写";
    [self.mailDetailView layoutIfNeeded];
    self.detailViewHeight = self.mailRemarkLabel.y + self.mailRemarkLabel.height + 8;
    self.mailInfoViewHeight = self.mailInfoView.height;
    self.detailViewBottomConstrait.constant = - self.detailViewHeight;
    self.mailDetailView.alpha = 0;
    self.mailDetailView.hidden = YES;
    
    MailDetailModel *detailModel = [MailDetailModel objectForPrimaryKey:@(mailId)];
    if (detailModel) {
        self.mailDetailModel = detailModel;
    }
    if (detailModel && detailModel.fileModels.count > 0) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (MailDetailFileModel *fileModel in detailModel.fileModels) {
            [mutableArray addObject:fileModel];
        }
        self.attachmentArray = [mutableArray copy];
        [self.attachmentCollectionView reloadData];
    } else {
        self.attachmentBackViewConstraint.constant = 0;
        self.attachmentView.hidden = YES;
    }
    
    //先清除缓存，再加载webView
    if ([[[UIDevice currentDevice] systemVersion] intValue] > 8) {
        NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];  // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (detailModel.htmlbody && ![detailModel.htmlbody isEqualToString:@""] && detailModel.htmlbody.length > 0) {
            NSString *copyString = [detailModel.htmlbody copy];
            NSString *htmlString = [copyString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\\"];
            NSString *newHtmlString = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", htmlString];
            [self.webView loadHTMLString:newHtmlString baseURL:nil];
        } else {
            NSString *textString = [detailModel.textBody stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\\"];
            NSString *newTextString = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", textString];
            [self.webView loadHTMLString:newTextString baseURL:nil];
        }
    });
}

- (void)ToShowTheImageByfourImageView:(NSArray<UIImageView *> *)imageViewArray WithCellModel:(MailHomeMailListCell *)cellModel {
    
    for (UIImageView *imageView in imageViewArray) {
        imageView.hidden = NO;
    }
    
    BOOL accCount = cellModel.AccCount > 0;
    BOOL redFlag = cellModel.redflag && ![cellModel.redflag isEqualToString:@""] && cellModel.redflag.length > 0;
    BOOL star = cellModel.star && ![cellModel.star isEqualToString:@" "] && ![cellModel.star  isEqualToString:@""] && cellModel.star.length > 0;
    BOOL topTime = cellModel.TopTime && ![cellModel.TopTime isEqualToString:@""] && cellModel.TopTime.length > 0;
    UIImage *accCountImage = [UIImage imageNamed:@"附件"];
    UIImage *redFlagImage = [UIImage imageNamed:@"红旗邮件"];
    UIImage *starImage = [UIImage imageNamed:@"星标邮件"];
    UIImage *topTimeImage = [UIImage imageNamed:@"置顶邮件"];
    for (int i = 0; i < imageViewArray.count; i++) {
        UIImageView *imageView = imageViewArray[i];
        if (accCount && redFlag && star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = redFlagImage;
                    break;
                case 2:
                    imageView.image = starImage;
                    break;
                default:
                    imageView.image = topTimeImage;
                    break;
            }
        } else if (accCount && redFlag && star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = redFlagImage;
                    break;
                case 2:
                    imageView.image = starImage;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && redFlag && !star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = redFlagImage;
                    break;
                case 2:
                    imageView.image = topTimeImage;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && !redFlag && star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = starImage;
                    break;
                case 2:
                    imageView.image = topTimeImage;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && redFlag && star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = redFlagImage;
                    break;
                case 1:
                    imageView.image = starImage;
                    break;
                case 2:
                    imageView.image = topTimeImage;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && redFlag && !star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = redFlagImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && !redFlag && !star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = topTimeImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && !redFlag && star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = starImage;
                    break;
                case 1:
                    imageView.image = topTimeImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && redFlag && star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = redFlagImage;
                    break;
                case 1:
                    imageView.image = starImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && redFlag && !star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = redFlagImage;
                    break;
                case 1:
                    imageView.image = topTimeImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && !redFlag && star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.image = starImage;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (accCount && !redFlag && !star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = accCountImage;
                    break;
                case 1:
                    imageView.hidden = YES;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && redFlag && !star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = redFlagImage;
                    break;
                case 1:
                    imageView.hidden = YES;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && !redFlag && star && !topTime) {
            switch (i) {
                case 0:
                    imageView.image = starImage;
                    break;
                case 1:
                    imageView.hidden = YES;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else if (!accCount && !redFlag && !star && topTime) {
            switch (i) {
                case 0:
                    imageView.image = topTimeImage;
                    break;
                case 1:
                    imageView.hidden = YES;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        } else {
            switch (i) {
                case 0:
                    imageView.hidden = YES;
                    break;
                case 1:
                    imageView.hidden = YES;
                    break;
                case 2:
                    imageView.hidden = YES;
                    break;
                default:
                    imageView.hidden = YES;
                    break;
            }
        }
    }
}

- (void)getMailDetailFailed:(NSNotification *)sender {
    NSString *back = sender.userInfo[@"back"];
    [self.activityIndicator stopAnimating];
    [MBProgressHUD showError:back toView:self.view];
    [self removeNotificationsOfGetMailDetail];
}

- (void)getMailDetailError:(NSNotification *)sender {
    NSString *str = sender.userInfo[@"userInfo"];
    [self.activityIndicator stopAnimating];
    [MBProgressHUD showError:str toView:self.view];
    [self removeNotificationsOfGetMailDetail];
}

#pragma mark - Button Of BottomView Click
- (IBAction)starButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default: {
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [self changCellStateWithTypeString:@"Star" IndexPath:self.indexPath UserAccount:userAccount UserPassword:userPassword];
            break;
        }
    }
}

- (IBAction)deleteButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default: {
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [self changCellStateWithTypeString:@"Delete" IndexPath:self.indexPath UserAccount:userAccount UserPassword:userPassword];
            break;
        }
    }
}

- (IBAction)distributeButtonClick:(UIButton *)sender {
    
}

- (IBAction)replyOrForwardButtonClick:(UIButton *)sender {
    self.maskView.hidden = NO;
    sender.enabled = NO;
    self.replyOrForwardView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.replyOrForwardViewBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)moreButtonClick:(UIButton *)sender {
    self.maskView.hidden = NO;
    sender.enabled = NO;
    self.moreSelectView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.moreSelectViewBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeBottomButtonEnable {
    self.starButton.enabled = !self.starButton.enabled;
    self.deleteButton.enabled = !self.deleteButton.enabled;
    self.distributeButton.enabled = !self.distributeButton.enabled;
    self.replyOrForwardButton.enabled = !self.replyOrForwardButton.enabled;
    self.moreButton.enabled = !self.moreButton.enabled;
}

#pragma mark - Notification Of MailStateChange
- (void)mailStateChangeSuccess:(NSNotification *)sender {
    NSString *str = sender.userInfo[@"back"];
    NSString *isTrue = sender.userInfo[@"isTrue"];
    LRLog(@"%@",isTrue);
    LRLog(@"%@",str);
    NSString *typeStr = sender.userInfo[@"typeString"];
    LRLog(@"%@",typeStr);
    NSArray<UIImageView *> *imageViewArray = @[self.firstImageView, self.secondImageView, self.thirdImageView, self.forthImageView];
    NSArray<NSIndexPath *> *indexPathArray = sender.userInfo[@"indexPathArray"];
    NSMutableArray *mutableCellModelArray = [self.mailListArray mutableCopy];
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
            [self ToShowTheImageByfourImageView:imageViewArray WithCellModel:cellModel];
        }
        [MBProgressHUD showSuccess:str toView:self.view];
        self.mailListArray = [mutableCellModelArray copy];
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
            self.mailListArray = [mutableCellModelArray copy];
            [self ToShowTheImageByfourImageView:imageViewArray WithCellModel:cellModel];
        }
        [MBProgressHUD showSuccess:str toView:self.view];
        
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
            [self ToShowTheImageByfourImageView:imageViewArray WithCellModel:cellModel];
        }
        [MBProgressHUD showSuccess:str toView:self.view];
        self.mailListArray = [mutableCellModelArray copy];
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
            [self ToShowTheImageByfourImageView:imageViewArray WithCellModel:cellModel];
            LRLog(@"%@",cellModel);
        }
        [MBProgressHUD showSuccess:str toView:self.view];
        self.mailListArray = [mutableCellModelArray copy];
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
        self.mailListArray = [mutableCellModelArray copy];
        [self.navigationController popViewControllerAnimated:YES];
//        if (self.indexPath.row > self.mailListArray.count - 1) {
//            self.indexPath = [NSIndexPath indexPathForRow:self.mailListArray.count - 1 inSection:0];
//        }
//        MailHomeMailListCell *cellModel = self.mailListArray[self.indexPath.row];
//        NSInteger mailId = cellModel.Id;
//        self.mailId = mailId;
//        NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
//        NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
//        [HTTPInterface getMailDetailByMailID:mailId IndexPath:self.indexPath UserAccount:userAccount UserPassword:userPassword];
    }
    [self removeNotificationsOfMailStateChange];
}


- (void)mailStateChangeFailed:(NSNotification *)sender {
    NSString *str = sender.userInfo[@"back"];
    [MBProgressHUD showError:str toView:self.view];
    [self removeNotificationsOfMailStateChange];
}

- (void)mailStateChangeError:(NSNotification *)sender {
    NSString *str = sender.userInfo[@"userInfo"];
    [MBProgressHUD showError:str toView:self.view];
    [self removeNotificationsOfMailStateChange];
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

#pragma mark - Methods Of Top, Star, RedFlag, Delete, Read
- (void)changCellStateWithTypeString:(NSString *)typeString IndexPath:(NSIndexPath *)indexPath UserAccount:(NSString *)userAccount UserPassword:(NSString *)userPassword {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:nil];
            break;
            
        default: {
            NSString *IdStr = [NSString stringWithFormat:@"%ld",self.mailId];
            MailHomeMailListCell *cellModel = self.mailListArray[indexPath.row];
            NSString * isTrue = @"true";
            NSArray<NSIndexPath *> *indexPathArray = @[indexPath];
            if ([typeString isEqualToString:@"Top"]) {
                NSString *topTime = cellModel.TopTime;
                if (topTime && ![topTime isEqualToString:@""] && topTime.length > 0) {
                    isTrue = @"false";
                }
                [self addNotificationsOfMailStateChange];
                [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:IdStr AndTrue:isTrue AndTypeString:typeString IndexPathArray:indexPathArray];
            } else if ([typeString isEqualToString:@"Star"]) {
                NSString *star = cellModel.star;
                if ([star isEqualToString:@"1"]) {
                    isTrue = @"false";
                }
                [self addNotificationsOfMailStateChange];
                [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:IdStr AndTrue:isTrue AndTypeString:typeString IndexPathArray:indexPathArray];
            } else if ([typeString isEqualToString:@"Redflag"]) {
                NSString *redFlag = cellModel.redflag;
                if ([redFlag isEqualToString:@"1"]) {
                    isTrue = @"false";
                }
                [self addNotificationsOfMailStateChange];
                [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:IdStr AndTrue:isTrue AndTypeString:typeString IndexPathArray:indexPathArray];
            } else if ([typeString isEqualToString:@"Read"]) {
                NSString *read = cellModel.Read;
                if ([read isEqualToString:@"是"]) {
                    isTrue = @"false";
                }
                [self addNotificationsOfMailStateChange];
                [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:IdStr AndTrue:isTrue AndTypeString:typeString IndexPathArray:indexPathArray];
            } else if ([typeString isEqualToString:@"Delete"]) {
                NSString *mailIdStr = [NSString stringWithFormat:@"%ld", cellModel.Id];
                if ([self.act isEqualToString:NSLocalizedString(@"垃圾箱", nil)]) {
                    //写移动到已删除邮件的方法
                    [self addNotificationsOfMailMove];
                    [HTTPInterface moveMailToBoxID:cellModel.MailBoxId FromMailID:mailIdStr RootID:0 OrBoxStr:NSLocalizedString(@"已删除邮件", nil) WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:indexPathArray];
                } else if ([self.act isEqualToString:NSLocalizedString(@"已删除邮件", nil)]) {
                    //写删除邮件方法
                    [self addNotificationsOfMailStateChange];
                    [HTTPInterface changedMailStateWithUserAcount:userAccount UserPassword:userPassword ByMailIDString:mailIdStr AndTrue:@"true" AndTypeString:@"Delete" IndexPathArray:indexPathArray];
                } else {
                    //写移动到垃圾箱的方法
                    [self addNotificationsOfMailMove];
                    [HTTPInterface moveMailToBoxID:cellModel.MailBoxId FromMailID:mailIdStr RootID:0 OrBoxStr:NSLocalizedString(@"垃圾箱", nil) WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:indexPathArray];
                }
            }
            break;
        }
    }
}

#pragma mark - Reply Or Forward View
- (IBAction)replyOrForwardViewCancelButtonClick:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.replyOrForwardViewBottomConstraint.constant = -168;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.maskView.hidden = YES;
        self.replyOrForwardButton.enabled = YES;
        self.replyOrForwardView.hidden = YES;
    }];
}

- (IBAction)replyButtonClick:(UIButton *)sender {
    MailSendViewController *mailSendVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailSendVC"];
    MailHomeMailListCell *cellModel = self.mailListArray[self.indexPath.row];
    [mailSendVC recieveTheMailDetailModel:self.mailDetailModel AndAttachmentArray:self.attachmentArray AndType:MailSendTypeReply AndMailBoxId:cellModel.MailBoxId];
    UINavigationController *mailSendNavi = [[UINavigationController alloc] initWithRootViewController:mailSendVC];
    [self presentViewController:mailSendNavi animated:YES completion:nil];
    [self replyOrForwardViewCancelButtonClick:nil];
}

- (IBAction)forwardButtonClick:(UIButton *)sender {
    MailSendViewController *mailSendVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailSendVC"];
    MailHomeMailListCell *cellModel = self.mailListArray[self.indexPath.row];
    [mailSendVC recieveTheMailDetailModel:self.mailDetailModel AndAttachmentArray:self.attachmentArray AndType:MailSendTypeForward AndMailBoxId:cellModel.MailBoxId];
    UINavigationController *mailSendNavi = [[UINavigationController alloc] initWithRootViewController:mailSendVC];
    [self presentViewController:mailSendNavi animated:YES completion:nil];
    [self replyOrForwardViewCancelButtonClick:nil];
}

#pragma mark - AddMoreViewOnWindow
- (void)addMoreViewOnWindow {
//    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
//    maskView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.25];
//    
//    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClick:)];
//    [maskView addGestureRecognizer:tap];
//    CGFloat cancelButtonHeight = 60;
//    CGFloat viewBetweenView = 10;
//    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [cancelButton setFrame:CGRectMake(viewBetweenView, SCREENH_HEIGHT - cancelButtonHeight - viewBetweenView, SCREEN_WIDTH - viewBetweenView * 2, cancelButtonHeight)];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelButton setBackgroundColor:[UIColor whiteColor]];
//    [cancelButton setTitleColor:[UIColor colorWithRed:120/255.0 green:137/255.0 blue:146/255.0 alpha:1.0] forState:UIControlStateNormal];
//    cancelButton.layer.borderWidth = 1.5;
//    cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    cancelButton.layer.cornerRadius = 8.0;
//    cancelButton.titleLabel.font = [UIFont systemFontOfSize:25.0];
//    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [maskView addSubview:cancelButton];
//    
//    CGFloat selectViewHeight = 182;
//    CGFloat subViewHeight = 60;
//    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(viewBetweenView, SCREENH_HEIGHT - cancelButtonHeight - viewBetweenView * 2 - selectViewHeight, SCREEN_WIDTH - viewBetweenView * 2, selectViewHeight)];
//    selectView.backgroundColor = [UIColor clearColor];
//    selectView.layer.borderWidth = 1.5;
//    selectView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    selectView.layer.cornerRadius = 8.0;
//    UIView *subviewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selectView.width, subViewHeight)];
//    subviewOne.backgroundColor = [UIColor whiteColor];
    
}
- (IBAction)tapGestureOnMaskView:(UITapGestureRecognizer *)sender {
    if (!self.moreButton.enabled) {
        [self cancelButtonClick:nil];
    }
    if (!self.replyOrForwardButton.enabled) {
        [self replyOrForwardViewCancelButtonClick:nil];
    }
}

- (IBAction)cancelButtonClick:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.moreSelectViewBottomConstraint.constant = -251;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.maskView.hidden = YES;
        self.moreButton.enabled = YES;
        self.moreSelectView.hidden = YES;
    }];
}

- (IBAction)addCustomerButtonClick:(UIButton *)sender {
    
}

- (IBAction)attentionToProductButtonClick:(UIButton *)sender {
    
}

- (IBAction)setTopButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default: {
            [self addNotificationsOfMailStateChange];
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [self changCellStateWithTypeString:@"Top" IndexPath:self.indexPath UserAccount:userAccount UserPassword:userPassword];
            break;
        }
    }
    [self cancelButtonClick:nil];
}

- (IBAction)setTagButtonClick:(UIButton *)sender {
    
}

- (IBAction)mailMoveButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default: {
//            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
//            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
//            [self addNotificationsOfMailMove];
//            [HTTPInterface moveMailToBoxID:cellModel.MailBoxId FromMailID:mailIdStr RootID:0 OrBoxStr:NSLocalizedString(@"已删除邮件", nil) WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:indexPathArray];
//            self.mutableCellModelArray = @[self.mailHomeMailArray[indexPath.row]];
//            self.mutableIndexPathArray = @[indexPath];
//            [self addno];
            MailMoveFolderViewController *mailMoveFolderVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailMoveFolderViewController"];
            [self.navigationController pushViewController:mailMoveFolderVC animated:YES];
            break;
        }
    }
    [self cancelButtonClick:nil];
}

- (IBAction)mailForwardButtonClick:(UIButton *)sender {
    
}

- (IBAction)setRedflagButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default: {
            [self addNotificationsOfMailStateChange];
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [self changCellStateWithTypeString:@"Redflag" IndexPath:self.indexPath UserAccount:userAccount UserPassword:userPassword];
            break;
        }
    }
    [self cancelButtonClick:nil];
}

- (IBAction)needTodealWithButtonClick:(UIButton *)sender {
    
}

- (IBAction)deleteCompletelyButtonClick:(UIButton *)sender {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:self.view];
            break;
            
        default: {
            [self addNotificationsOfMailStateChange];
            NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
            NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
            [self changCellStateWithTypeString:@"Delete" IndexPath:self.indexPath UserAccount:userAccount UserPassword:userPassword];
            break;
        }
    }
    [self cancelButtonClick:nil];
}

- (IBAction)remarkButtonClick:(UIButton *)sender {
    
}

//- (void)add {
//    _window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    _window.windowLevel = UIWindowLevelAlert+1;
//    _window.backgroundColor = [UIColor clearColor];
//    _imgv=[[YFGIFImageView alloc]initWithFrame:self.view.bounds];
//    _imgv.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.522];
//    [YFGIFImageView viewAnimation:_imgv];
//    _imgv.userInteractionEnabled = YES;
//    [_window addSubview:_imgv];
//    [_window makeKeyAndVisible]
//}
//// 隐藏 关闭 window
//- (void)close {
//    [_window resignKeyWindow];
//    _window = nil;
//}

#pragma mark - NSNotifications Of MoveMailToAnotherFolder
- (void)addNotificationOfMoveMailToAnotherFolder {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comfirmToMoveMailToAnotherFolder:) name:@"MoveMailToAnotherFolder" object:nil];
}

- (void)removeNotificationOfMoveMailToAnotherFolder {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MoveMailToAnotherFolder" object:nil];
}

- (void)comfirmToMoveMailToAnotherFolder:(NSNotification *)sender {
//    MailFolderCell *folderCellModel = sender.userInfo[@"folderCellModel"];
//    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
//    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
//    NSString *mutableStr = @"";
//    for (int i = 0; i < self.mutableCellModelArray.count; i++) {
//        MailHomeMailListCell *cellModel = self.mutableCellModelArray[i];
//        if (i == 0) {
//            mutableStr = [mutableStr stringByAppendingFormat:@"%ld", cellModel.Id];
//        } else {
//            mutableStr = [mutableStr stringByAppendingFormat:@",%ld", cellModel.Id];
//        }
//    }
//    [HTTPInterface moveMailToBoxID:folderCellModel.mailboxId FromMailID:mutableStr RootID:folderCellModel.id OrBoxStr:nil WithUserAccount:userAccount UserPassword:userPassword IndexPathArray:self.mutableIndexPathArray];
}

#pragma mark - Notifications Of MailMove
- (void)mailMoveSuccess:(NSNotification *)sender {
    NSString *back = sender.userInfo[@"back"];
    NSArray<NSIndexPath *> *indexPathArray = sender.userInfo[@"indexPath"];
    NSMutableArray *mutableArray = [self.mailListArray mutableCopy];
    for (NSIndexPath *indexPath in indexPathArray) {
        MailHomeMailListCell *cellModel = self.mailListArray[indexPath.row];
        //        [[RLMRealm defaultRealm] transactionWithBlock:^{
        //            [[RLMRealm defaultRealm] deleteObject:cellModel];
        //        }];//移动邮件只删除界面，数据库内不删除
        [mutableArray removeObject:cellModel];
    }
    self.mailListArray = [mutableArray copy];
    [MBProgressHUD showSuccess:back toView:self.view];
//    if (self.indexPath.row > self.mailListArray.count - 1) {
//        self.indexPath = [NSIndexPath indexPathForRow:self.mailListArray.count - 1 inSection:0];
//    }
//    MailHomeMailListCell *cellModel = self.mailListArray[self.indexPath.row];
//    NSInteger mailId = cellModel.Id;
//    self.mailId = mailId;
//    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
//    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
//    [HTTPInterface getMailDetailByMailID:mailId IndexPath:self.indexPath UserAccount:userAccount UserPassword:userPassword];
    [self.navigationController popViewControllerAnimated:YES];
    [self removeNotificationsOfMailMove];
}

- (void)mailMoveFailed:(NSNotification *)sender {
    NSString *back = sender.userInfo[@"back"];
    LRLog(@"%@",back);
    [MBProgressHUD showError:back toView:self.view];
    [self removeNotificationsOfMailMove];
}

- (void)mailMoveError:(NSNotification *)sender {
    NSString *back = sender.userInfo[@"userInfo"];
    [MBProgressHUD showError:back toView:self.view];
    [self removeNotificationsOfMailMove];
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

//#pragma mark - UIWebViewDelegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
////    NSString *heightString = @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))";
////    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:heightString] floatValue];
//    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
//    if (height < SCREENH_HEIGHT - self.mailInfoView.height - self.attachmentBackViewConstraint.constant - 49 - 64 + 1) {
//        height = SCREENH_HEIGHT - self.mailInfoView.height - self.attachmentBackViewConstraint.constant - 49 - 64 + 1;
//    }
//    self.uiWebViewHeightConstraint.constant = height;
//    self.webBackViewHeightConstraint.constant = height;
//    self.contentViewHeightConstraint.constant = self.webBackView.y + self.webBackViewHeightConstraint.constant;
//    NSString *bodyWidth= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth"];
//    CGFloat pageWidth = [bodyWidth floatValue];
//    CGFloat initialScale = webView.frame.size.width/pageWidth;
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \" initial-scale=%f, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes\"",initialScale];// webView.frame.size.width,width=%f,
//    [webView stringByEvaluatingJavaScriptFromString:meta];
////    [self.activityIndicator stopAnimating];
////    self.activityIndicatorBackView.hidden = YES;
////    [self changeBottomButtonEnable];
//}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSString *heightString = @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))";
    [webView evaluateJavaScript:heightString completionHandler:^(id _Nullable result,NSError *_Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat documentHeight = [result doubleValue];
        if (documentHeight < SCREENH_HEIGHT - self.mailInfoView.height - self.attachmentBackViewConstraint.constant - 49 - 64) {
            documentHeight = SCREENH_HEIGHT - self.mailInfoView.height - self.attachmentBackViewConstraint.constant - 49 - 64;
        }
//        CGRect frame = self.webView.frame;
//        frame.size.height = documentHeight;
//        webView.frame = frame;
        webView.height = documentHeight;

        self.webBackViewHeightConstraint.constant = webView.height;
        self.contentViewHeightConstraint.constant = self.webBackView.y + self.webBackViewHeightConstraint.constant;
//        [self.activityIndicator stopAnimating];
//        self.activityIndicatorBackView.hidden = YES;
//        [self changeBottomButtonEnable];
    }];
    
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView evaluateJavaScript:js completionHandler:nil];
    [webView evaluateJavaScript:@"ResizeImages();" completionHandler:nil];
    
    if (![self.mailDetailModel.htmlbody containsString:@"device-width"]) {
        [webView evaluateJavaScript:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);" completionHandler:nil];
    }
//    [webView stringByEvaluatingJavaScriptFromString:js];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSNumber *userId = [UserDefaultsManager getUserId];
    //    NSString *userName = [UserLoginModel objectForPrimaryKey:userId].name;
    NSString *directoryPath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",userId]];
    BOOL isExist;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL directoryIsExist = [fileManager fileExistsAtPath:directoryPath isDirectory:&isExist];
    if (!(isExist && directoryIsExist)) {
        BOOL isCreateDir = [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir) {
            LRLog(@"创建用户ID文件夹失败");
        }
    }
    MailHomeMailListCell *mailHomeMailListCell = self.mailListArray[self.indexPath.row];
    NSString *boxDirectoryPath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",mailHomeMailListCell.MailBoxId]];
    BOOL isboxIdDirExist;
    BOOL boxIdDirectoryIsExist = [fileManager fileExistsAtPath:boxDirectoryPath isDirectory:&isboxIdDirExist];
    if (!(isboxIdDirExist && boxIdDirectoryIsExist)) {
        BOOL isCreateBoxIdDir = [fileManager createDirectoryAtPath:boxDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateBoxIdDir) {
            LRLog(@"创建邮箱ID文件夹失败");
        }
    }
    NSString *mailIdDirPath = [boxDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", mailHomeMailListCell.Id]];
    BOOL isMailIdDirExist;
    BOOL mailIdDirectoryIsExist = [fileManager fileExistsAtPath:mailIdDirPath isDirectory:&isMailIdDirExist];
    if (!(isMailIdDirExist && mailIdDirectoryIsExist)) {
        BOOL isCreateMailIdDir = [fileManager createDirectoryAtPath:mailIdDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateMailIdDir) {
            LRLog(@"创建邮件ID文件夹失败");
        }
    }
    MailDetailFileModel *mailDetailFileModel = self.attachmentArray[indexPath.row];
    self.filePath = [mailIdDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", mailDetailFileModel.name]];
    LRLog(@"%@", self.filePath);
    static NSString * const storyBoardIdentifier = @"MailAttachmentViewController";
    if ([fileManager fileExistsAtPath:self.filePath]) {
        NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];
        if (fileData.length == mailDetailFileModel.size) {
            NSString *lastString = [mailDetailFileModel.name componentsSeparatedByString:@"."].lastObject;
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
        } else {
            [fileManager removeItemAtPath:self.filePath error:nil];
            MailAttachmentViewController *mailAttachmentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyBoardIdentifier];
            [mailAttachmentVC getAttachmentCellModel:mailDetailFileModel andMailHomeMailListCell:mailHomeMailListCell AndFilePath:self.filePath];
            [self.navigationController pushViewController:mailAttachmentVC animated:YES];
        }
    } else {
            MailAttachmentViewController *mailAttachmentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyBoardIdentifier];
            [mailAttachmentVC getAttachmentCellModel:mailDetailFileModel andMailHomeMailListCell:mailHomeMailListCell AndFilePath:self.filePath];
            [self.navigationController pushViewController:mailAttachmentVC animated:YES];
    }
    
//    MailDetailFileModel *mailDetailFileModel = self.attachmentArray[indexPath.row];
    
//    MailHomeMailListCell *mailHomeMailListCell = self.mailListArray[self.indexPath.row];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.attachmentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"attachmentCell";
    MailDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    MailDetailFileModel *cellModel = self.attachmentArray[indexPath.row];
    cell.attachmentNameLabel.text = cellModel.name;
    
    return cell;
}

#pragma mark - SetFlowLayout
- (void)setFlowLayout {
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 10;
//    flowLayout.estimatedItemSize = CGSizeMake(160, 16);
//    flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
    flowLayout.itemSize = CGSizeMake(60, 80);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.attachmentCollectionView.collectionViewLayout = flowLayout;
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
