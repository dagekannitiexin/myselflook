//
//  LoginViewController.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/5.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "LoginViewController.h"
#import "HTTPInterface.h"
#import "MBProgressHUD+XQ.h"
#import "UserDefaultsManager.h"
#import "NSString+MD5.h"
#import "KGModal.h"
#import "UserInfoManager.h"
#import "HTTPInterface+MailBox.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *rememberPasswordButton;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifications
- (void)getUserInfoSuccess:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSNumber *userId = sender.userInfo[@"userId"];
    [UserDefaultsManager setUserId:userId];
    [UserInfoManager sharedUserInfoManager].userAccount = self.accountTextField.text;
    [UserDefaultsManager setUserAccount:self.accountTextField.text];
    NSString *MD5Password = [NSString stringTo32BitMD5UpperStringWithString:self.passwordTextField.text];
    [UserInfoManager sharedUserInfoManager].userMD5Password = MD5Password;
    NSNumber *info = sender.userInfo[@"rememberPassword"];
    BOOL rememberPassword = [info boolValue];
    if (rememberPassword) {
        [UserDefaultsManager setUserPassword:MD5Password];
    }
    [UserInfoManager sharedUserInfoManager].userServerAddress = [UserDefaultsManager getUserServerAddress];
//    [HTTPInterface getUserMailBoxListWithUserAccount:self.accountTextField.text AndMD5Password:MD5Password];
//    [HTTPInterface getUserMailBoxChildListByParentID:@"zn" AndUserAccount:self.accountTextField.text AndMD5Password:MD5Password];
    [self removeNotifications];
    [self transitionToTabBarViewController];
}

- (void)getUserInfoFailed:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *back = sender.userInfo[@"back"];
    if (back && ![back isEqualToString:@""]) {
        [MBProgressHUD showError:back toView:self.view];
    }
    [self removeNotifications];
}

- (void)getUserInfoError:(NSNotification *)sender {
    [self.hud hideAnimated:NO];
    NSString *errorInfo = sender.userInfo[@"NSLocalizedDescription"];
    if (errorInfo && ![errorInfo isEqualToString:@""]) {
        [MBProgressHUD showError:errorInfo toView:self.view];
    }
    [self removeNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccess:) name:GetUserInfoSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoFailed:) name:GetUserInfoFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoError:) name:GetUserInfoError object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Transistion
- (void)transitionToTabBarViewController {
//    UINavigationController *rootNAVI = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootNAVI"];
    UITabBarController *tabVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TabBarVC"];
    [UIView transitionFromView:self.view
                        toView:tabVC.view
                      duration:0.9
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished)
     {
         [self.navigationController setViewControllers:@[tabVC]];
     }];
}

#pragma mark - ButtonClick

- (IBAction)loginButtonClick:(UIButton *)sender {
    if (!self.accountTextField.text || self.accountTextField.text.length == 0 || [self.accountTextField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"未填写用户账号" toView:self.view];
        return;
    }
    if (!self.passwordTextField.text || self.passwordTextField.text.length == 0 || [self.passwordTextField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"未填写用户密码" toView:self.view];
        return;
    }
    
    NSString *userServerAddress = [UserDefaultsManager getUserServerAddress];
    if (!userServerAddress || userServerAddress.length == 0 || [userServerAddress isEqualToString:@""]) {
        [MBProgressHUD showError:@"未填写服务器地址" toView:self.view];
        return;
    }
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            [MBProgressHUD showError:@"网络状态未知" toView:nil];
            return;
        case AFNetworkReachabilityStatusNotReachable:
            [MBProgressHUD showError:@"无网络" toView:nil];
            return;
            
        default:
            break;
    }
    
    if (self.accountTextField.text != nil && self.passwordTextField.text != nil && ![self.accountTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        
        self.hud = [MBProgressHUD showIndicatorWithText:@"登录中" ToView:self.view];
        [self addNotifications];
        
        NSString *MD5UpperString = [NSString stringTo32BitMD5UpperStringWithString:self.passwordTextField.text];
        LRLog(@"%@",MD5UpperString);
        
        [HTTPInterface getUserInfoWithUserAccount:self.accountTextField.text MD5Password:MD5UpperString RememberPassWord:self.rememberPasswordButton.selected];
    }
}

- (IBAction)settingButtonClick:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置" message:@"设置服务器地址\n例:120.26.137.208:9898" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请正确填写服务器地址";
    }];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textField = alert.textFields.firstObject;
        if (textField.text && textField.text.length > 0 && ![textField.text isEqualToString:@""]) {
            [UserDefaultsManager setUserServerAddress:textField.text];
        }
    }];
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionNO];
    [alert addAction:actionYes];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)rememberButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - keyBoard
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
        [self loginButtonClick:nil];
    }
    return YES;
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
