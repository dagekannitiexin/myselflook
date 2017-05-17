//
//  MBProgressHUD+MBProgressHUD.h
//  XiaoQiao
//
//  Created by tong on 2016/12/19.
//  Copyright © 2016年 NingboXiaojiang. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (XQ)
+ (MBProgressHUD *_Nonnull)showIndicatorWithText:(NSString *_Nonnull)text ToView:(UIView *_Nullable)view;

+ (void)showSuccess:(NSString * _Nonnull)success toView:(UIView * _Nullable)view;
+ (void)showError:(NSString * _Nonnull)error toView:(UIView * _Nullable)view;

+ (MBProgressHUD * _Nonnull)showMessage:(NSString * _Nonnull)message toView:(UIView * _Nullable)view;


+ (void)showSuccess:(NSString * _Nonnull)success;
+ (void)showError:(NSString * _Nonnull)error;

+ (MBProgressHUD * _Nonnull)showMessage:(NSString * _Nonnull)message;

+ (void)hideHUDForView:(UIView * _Nullable)view;
+ (void)hideHUD;
@end
