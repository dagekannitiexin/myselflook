//
//  MailSendViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/5/3.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailSendViewController.h"
#import "UIView+Extension.h"
#import <YYTextView.h>
#import "MBProgressHUD+XQ.h"
#import "HTTPInterface+MailSend.h"
#import "UserInfoManager.h"
#import "MailHomeMailListCell.h"
#import "UserLoginModel.h"
#import "UserDefaultsManager.h"
#import "UserMailBoxList.h"
#import "MailAttachmentInfoModel.h"
#import "UploadAttachmentCollectionViewCell.h"
#import "UIImage+ImageSize.h"

#define TopView_TotalHeight 205
#define TableViewHeight 40
#define CollectionImageViewSize CGSizeMake(60, 60)

@interface MailSendViewController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *recipientTextField;
@property (weak, nonatomic) IBOutlet UITextField *carbonCopyTextField;
@property (weak, nonatomic) IBOutlet UITextField *bindCarbonCopyTextField;
@property (weak, nonatomic) IBOutlet UIButton *userSendMailButton;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (nonatomic, strong) MailDetailModel *mailDetaiModel;
@property (nonatomic, strong) NSArray<MailDetailFileModel *> *attachmentArray;
@property (nonatomic, assign) MailSendType type;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewHeightConstraint;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) MailHomeMailListCell *mailListCellModel;
@property (nonatomic, assign) NSInteger mailBoxId;
@property (nonatomic, strong) NSArray<UserMailBoxListCell *> *mailBoxArray;
@property (nonatomic, strong) UserMailBoxListCell *mailBoxCellModel;
@property (nonatomic, strong) UITableView *mailBoxArrayTableView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UIButton *attachmentButton;
@property (weak, nonatomic) IBOutlet UIView *attachmentBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attachmentBackViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *attachmentCollectionView;
@property (nonatomic, strong) NSMutableArray<MailAttachmentInfoModel *> *uploadAttachmentArray;
@end

@implementation MailSendViewController
#pragma mark - lazyLoad
- (NSMutableArray<MailAttachmentInfoModel *> *)uploadAttachmentArray {
    if (!_uploadAttachmentArray) {
        _uploadAttachmentArray = [NSMutableArray array];
    }
    return _uploadAttachmentArray;
}

- (UITableView *)mailBoxArrayTableView {
    if (!_mailBoxArrayTableView) {
        CGRect tableViewframe;
        if (self.mailBoxArray.count > 4) {
            tableViewframe = CGRectMake(self.userSendMailButton.x, TopView_TotalHeight - 42, self.userSendMailButton.width, TableViewHeight * 4);
        } else {
            tableViewframe = CGRectMake(self.userSendMailButton.x, TopView_TotalHeight - 42, self.userSendMailButton.width, TableViewHeight * self.mailBoxArray.count);
        }
        _mailBoxArrayTableView = [[UITableView alloc] initWithFrame:tableViewframe style:UITableViewStylePlain];
        _mailBoxArrayTableView.hidden = YES;
        _mailBoxArrayTableView.delegate = self;
        _mailBoxArrayTableView.dataSource = self;
        _mailBoxArrayTableView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [_scrollContentView addSubview:_mailBoxArrayTableView];
    }
    return _mailBoxArrayTableView;
}


#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFlowLayout];
    self.userSendMailButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    if (self.mailBoxId != 0) {
        self.mailBoxCellModel = [UserMailBoxListCell objectForPrimaryKey:@(self.mailBoxId)];
        NSString *str = [NSString stringWithFormat:@"%@<%@>",self.mailBoxCellModel.name, self.mailBoxCellModel.email];
        [self.userSendMailButton setTitle:str forState:UIControlStateNormal];
    }
    UserMailBoxList *mailBoxList = [UserMailBoxList objectForPrimaryKey:@(1)];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (UserMailBoxListCell *mailBoxCellModel in mailBoxList.userMailBoxList) {
        [mutableArray addObject:mailBoxCellModel];
    }
    self.mailBoxArray = [mutableArray copy];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonItemClick:)];
    cancelBarButtonItem.tintColor = [UIColor colorWithRed:1/255.0 green:147/255.0 blue:221/255.0 alpha:1.0];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    UIBarButtonItem *mailSendBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(mailSendBarButtonClick:)];
    mailSendBarButtonItem.tintColor = [UIColor colorWithRed:1/255.0 green:147/255.0 blue:221/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = mailSendBarButtonItem;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, TopView_TotalHeight, SCREEN_WIDTH - 30, SCREEN_HEIGHT - TopView_TotalHeight - 64)];
    textView.userInteractionEnabled = YES;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.scrollEnabled = YES;
//    textView.alwaysBounceHorizontal = YES;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:16];
//    textView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    NSString *normalStr = nil;
    NSMutableAttributedString *contentText = nil;
    if (self.type == MailSendTypeNew) {
        normalStr = @"发自我的iPhone";
        contentText = [[NSMutableAttributedString alloc] initWithString:normalStr];
    } else {
        normalStr = @" \n\n\n----------原始邮件----------\n<br>";
        NSString *str = nil;
        if (self.mailDetaiModel.htmlbody) {
            str = [self.mailDetaiModel.htmlbody stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\\"];
        } else {
            str = [self.mailDetaiModel.textBody stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\\"];
        }
//        NSString *newString = [htmlStr stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=\"%f\"",kScreenWidth - 10]];
//        str = [str stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=\"%f\"",SCREEN_WIDTH - 10]];
        NSString *newStr = [normalStr stringByAppendingString:str];
        contentText = [[NSMutableAttributedString alloc] initWithData:[newStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    }
    
    textView.attributedText = contentText;
    textView.returnKeyType = UIReturnKeyDone;
    [self.scrollContentView addSubview:textView];
    self.textView = textView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat textContentHeight = self.textView.contentSize.height;
//    CGFloat bottomInset =  self.textView.contentInset.bottom;
//    CGFloat topInset = self.textView.contentInset.top;
    if (textContentHeight > self.textView.height) {
        self.scrollContentViewHeightConstraint.constant = TopView_TotalHeight + textContentHeight;
    }
    self.textView.height = textContentHeight + 10;
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.maskView removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma ButtonsAboutAttachment
- (IBAction)attachmentButtonClick:(UIButton *)sender {
    //取消键盘响应
    [self.view endEditing:YES];
    
    if (!sender.selected) {
        self.attachmentBackView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.attachmentBackViewBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            sender.selected = !sender.selected;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.attachmentBackViewBottomConstraint.constant = -170;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            sender.selected = !sender.selected;
            self.attachmentBackView.hidden = YES;
        }];
    }
    
}

- (IBAction)cameraButtonClick:(UIButton *)sender {
    [self getPhotoFromCemera];
}

- (IBAction)albumButtonClick:(UIButton *)sender {
    [self getPhotoFromAlbum];
}

- (void)getPhotoFromAlbum {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
//        picker.allowsEditing = YES;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)getPhotoFromCemera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
//        picker.allowsEditing = YES;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        picker.showsCameraControls = YES;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    NSData *imageData = UIImagePNGRepresentation(image);
    MailAttachmentInfoModel *model = [[MailAttachmentInfoModel alloc] init];
    model.imageData = imageData;
    model.size = imageData.length;
    NSDate *date = [NSDate date];
    NSDateFormatter *dateForMatter = [[NSDateFormatter alloc] init];
    dateForMatter.dateFormat = @"yyyyMMdd";
    NSString *dateString = [dateForMatter stringFromDate:date];
    model.name = [NSString stringWithFormat:@"%@_%zd.png",dateString,self.uploadAttachmentArray.count];
    NSString *sizeString = [self dataSizeToString:imageData.length];
    model.sizeString = sizeString;
    UIImage *smallImage = [UIImage imageByScalingAndCroppingForSize:CollectionImageViewSize SourceImage:image];
    NSData *smallImageData = UIImagePNGRepresentation(smallImage);
    model.smallImageData = smallImageData;
    [self.uploadAttachmentArray addObject:model];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.attachmentCollectionView reloadData];
    }];
}

- (NSString *)dataSizeToString:(NSUInteger)size {
    NSString *sizeString;
    double aSize = size / 1024.0;
    if (aSize > 1024) {
        double bSize = size / 1024.0 / 1024.0;
        if (bSize > 1024) {
            double cSize = size / 1024.0 / 1024.0 / 1024.0;
            sizeString = [NSString stringWithFormat:@"%.2fG",cSize];
        } else {
            sizeString = [NSString stringWithFormat:@"%.2fM",bSize];
        }
    } else {
        sizeString = [NSString stringWithFormat:@"%.2fKB",aSize];
    }
    return sizeString;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*) thumbnaiWithImage:(UIImage*)image size:(CGSize) size {
    UIImage *newImage = nil;
    if (image != nil) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 3) {
//        self.maskView.hidden = !self.maskView.hidden;
        self.mailBoxArrayTableView.hidden = !self.mailBoxArrayTableView.hidden;
    }
}

#pragma mark - UserSendMailButtonClick
- (IBAction)userSendMailButtonClick:(UIButton *)sender {
    self.mailBoxArrayTableView.hidden = !self.mailBoxArrayTableView.hidden;
}

#pragma mark - ReciveTheMailDetailModelAndAttachmentArray
- (void)recieveTheMailDetailModel:(MailDetailModel *)mailDetailModel AndAttachmentArray:(NSArray<MailDetailFileModel *> *)attachmentArray AndType:(MailSendType)type AndMailBoxId:(NSInteger)mailBoxId{
    self.mailDetaiModel = mailDetailModel;
    self.attachmentArray = attachmentArray;
    self.type = type;
    self.mailBoxId = mailBoxId;
}

#pragma mark - NavigationBarButtonItemClick
- (void)cancelBarButtonItemClick:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailSendBarButtonClick:(UIBarButtonItem *)sender {
    if (!self.recipientTextField.text || [self.recipientTextField.text isEqualToString:@""] || self.recipientTextField.text.length < 1) {
        [MBProgressHUD showError:@"收件人不能为空" toView:self.view];
        return;
    }
    if (!self.subjectTextField.text || [self.subjectTextField.text isEqualToString:@""] || self.subjectTextField.text.length < 1) {
        [MBProgressHUD showError:@"主题不能为空" toView:self.view];
        return;
    }
    NSNumber *userId = [UserDefaultsManager getUserId];
    UserLoginModel *userModel = [UserLoginModel objectForPrimaryKey:userId];
    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
    NSDate *date = [NSDate date];
    NSDateFormatter *dateForMatter = [[NSDateFormatter alloc] init];
    NSString *dateString = [dateForMatter stringFromDate:date];
//    UserMailBoxListCell *userMailBoxCellModel = [UserMailBoxListCell objectForPrimaryKey:@(self.mailBoxId)];
//    NSString *itFrom = [NSString stringWithFormat:@"%@<%@>", userModel.name, userMailBoxCellModel.email];
    NSString *itFrom = self.userSendMailButton.titleLabel.text;
    NSData *htmlData = [self.textView.attributedText dataFromRange:NSMakeRange(0, self.textView.attributedText.length) documentAttributes:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} error:nil];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\\" withString:@"&quot;"];
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
//    @{
//      @"UserId": userAccount,
//      @"Password": userPassword,
//      @"Ran": RAN,
//      @"Sign": SIGN,
//      @"check": @(check),
//      @"mailid": @(mailId),
//      @"MailBoxId":@(mailBoxId),
//      @"FromName":fromName,
//      @"Subject":subject,
//      @"SendDate":sendDate,
//      @"MailType":mailType,
//      @"itFrom":itFrom,
//      @"itTo":itTo,
//      @"cc":cc,
//      @"Bcc":bcc,
//      @"MailLabel":mailLabel,
//      @"HtmlBody":htmlBody,
//      @"BoxBase":boxBase,
//      @"Box":box,
//      @"MailDate":mailDate
//      };

    mutableParameters[@"UserId"] = userAccount;
    mutableParameters[@"Password"] = userPassword;
    mutableParameters[@"check"] = @(1);
    mutableParameters[@"mailid"] = @(0);
    mutableParameters[@"MailBoxId"] = @(self.mailBoxId);
    mutableParameters[@"FromName"] = userModel.name;
    mutableParameters[@"Subject"] = self.subjectTextField.text;
    mutableParameters[@"SendDate"] = dateString;
    mutableParameters[@"MailType"] = @"text/html";
    mutableParameters[@"itFrom"] = itFrom;
    mutableParameters[@"itTo"] = self.recipientTextField.text;
    if (self.carbonCopyTextField.text && ![self.carbonCopyTextField.text isEqualToString:@""] && self.carbonCopyTextField.text.length > 0) {
        mutableParameters[@"cc"] = self.carbonCopyTextField.text;
    }
    if (self.bindCarbonCopyTextField.text && ![self.bindCarbonCopyTextField.text isEqualToString:@""] && self.bindCarbonCopyTextField.text.length > 0) {
        mutableParameters[@"Bcc"] = self.bindCarbonCopyTextField.text;
    }
    mutableParameters[@"HtmlBody"] = htmlString;
    mutableParameters[@"BoxBase"] = @"YFS";
    mutableParameters[@"Box"] = @"CGX";
    mutableParameters[@"MailDate"] = dateString;
    
    [HTTPInterface createMailOnServerBeforeSendingWithParameters:mutableParameters];
    [self addNotificationsOfCreateMailBeforeSend];
    self.hud = [MBProgressHUD showIndicatorWithText:@"发送中" ToView:self.view];
}

#pragma mark - Notifications Of CreateMailBeforeSend
- (void)addNotificationsOfCreateMailBeforeSend {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createMailBeforeSendSuccess:) name:CreateMailBeforeSendSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createMailBeforeSendFailed:) name:CreateMailBeforeSendFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createMailBeforeSendError:) name:CreateMailBeforeSendError object:nil];
}

- (void)removeNotificationsOfCreateMailBeforeSend {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CreateMailBeforeSendSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CreateMailBeforeSendFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CreateMailBeforeSendError object:nil];
}

- (void)createMailBeforeSendSuccess:(NSNotification *)sender {
    [self removeNotificationsOfCreateMailBeforeSend];
    NSNumber *beCreateMailId = sender.userInfo[@"beCreateMailId"];
    NSInteger beCreateId = [beCreateMailId integerValue];
    NSString *userAccount = [UserInfoManager sharedUserInfoManager].userAccount;
    NSString *userPassword = [UserInfoManager sharedUserInfoManager].userMD5Password;
    [HTTPInterface sendMailWithUserAccount:userAccount UserPassword:userPassword mailId:beCreateId];
    [self addNotificationsOfSendMail];
}

- (void)createMailBeforeSendFailed:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *back = sender.userInfo[@"back"];
    LRLog(@"%@",back);
    [MBProgressHUD showError:back toView:self.view];
    [self removeNotificationsOfCreateMailBeforeSend];
}

- (void)createMailBeforeSendError:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *back = sender.userInfo[@"userInfo"];
    LRLog(@"%@",back);
    [MBProgressHUD showError:back toView:self.view];
    [self removeNotificationsOfCreateMailBeforeSend];
}

#pragma mark - Notifications Of SendMail
- (void)addNotificationsOfSendMail {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMailSuccess:) name:SendMailSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMailFailed:) name:SendMailFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMailError:) name:SendMailError object:nil];
}

- (void)removeNotificaionsOfSendMail {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SendMailSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SendMailFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SendMailError object:nil];
}

- (void)sendMailSuccess:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSDictionary *back = sender.userInfo[@"back"];
    LRLog(@"%@",back);
    [self removeNotificaionsOfSendMail];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendMailFailed:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *back = sender.userInfo[@"back"];
    LRLog(@"%@",back);
    [MBProgressHUD showError:back toView:self.view];
    [self removeNotificaionsOfSendMail];
}

- (void)sendMailError:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *back = sender.userInfo[@"userInfo"];
    LRLog(@"%@",back);
    [MBProgressHUD showError:back toView:self.view];
    [self removeNotificaionsOfSendMail];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mailBoxArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"MailSendTabelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UserMailBoxListCell *cellModel = self.mailBoxArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@<%@>", cellModel.name, cellModel.email];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    self.userSendMailButton.titleLabel.text = ;
    [self.userSendMailButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
//    self.maskView.hidden = !self.maskView.hidden;
    self.mailBoxArrayTableView.hidden = !self.mailBoxArrayTableView.hidden;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.uploadAttachmentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"UploadAttachmentCollectionViewCell";
    UploadAttachmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    MailAttachmentInfoModel * cellModel = self.uploadAttachmentArray[indexPath.row];
    cell.AttachmentSmallImageView.image = [UIImage imageWithData:cellModel.smallImageData];
    cell.attachmentNameLabel.text = cellModel.name;
    cell.attachmentSizeLabel.text = cellModel.sizeString;
    
    return cell;
}

//- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return CGSizeMake(100, collectionView.bounds.size.height);
//}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MailAttachmentInfoModel *model = self.uploadAttachmentArray[indexPath.row];
    NSString *msg = [NSString stringWithFormat:@"%@(%@)",model.name,model.sizeString];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"附件操作" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.uploadAttachmentArray removeObjectAtIndex:indexPath.row];
        [self.attachmentCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    }];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionToChangeAttachmentNameWithUploadAttachmentModel:model andIndexPath:indexPath];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:actionOne];
    [alert addAction:actionTwo];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)actionToChangeAttachmentNameWithUploadAttachmentModel:(MailAttachmentInfoModel *)model andIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重命名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *name = [model.name componentsSeparatedByString:@"."].firstObject;
        textField.text = name;
    }];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textField = alert.textFields.firstObject;
        if (textField.text && textField.text.length > 0 && ![textField.text isEqualToString:@""]) {
            NSString *lastString = [model.name componentsSeparatedByString:@"."].lastObject;
            NSString *nameString = [NSString stringWithFormat:@"%@.%@",textField.text,lastString];
            model.name = nameString;
            [self.attachmentCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }];
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionNO];
    [alert addAction:actionYes];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - SetLayout
- (void)setFlowLayout {
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 10;
    //    flowLayout.estimatedItemSize = CGSizeMake(160, 16);
    //    flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
    flowLayout.itemSize = CGSizeMake(100, 120);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.attachmentCollectionView.collectionViewLayout = flowLayout;
    self.attachmentCollectionView.alwaysBounceHorizontal = YES;
//    self.attachmentCollectionView.scrollsToTop = NO;
    
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
