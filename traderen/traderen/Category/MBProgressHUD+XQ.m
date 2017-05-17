//
//  MBProgressHUD+MBProgressHUD.m
//  XiaoQiao
//
//  Created by tong on 2016/12/19.
//  Copyright © 2016年 NingboXiaojiang. All rights reserved.
//

#import "MBProgressHUD+XQ.h"

@implementation MBProgressHUD (XQ)

#pragma mark 显示信息
+ (void)show:(NSString * _Nonnull)text icon:(NSString * _Nonnull)icon view:(UIView * _Nullable)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.0];
}
#pragma mark - 显示菊花
+ (MBProgressHUD *)showIndicatorWithText:(NSString *)text ToView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

#pragma mark 显示错误信息
+ (void)showError:(NSString * _Nonnull)error toView:(UIView * _Nullable)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString * _Nonnull)success toView:(UIView * _Nullable)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString * _Nonnull)message toView:(UIView * _Nullable)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];// : [UIColor clearColor];
    return hud;
}

+ (void)showSuccess:(NSString * _Nonnull)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString * _Nonnull)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD * _Nonnull)showMessage:(NSString * _Nonnull)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView * _Nullable)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}



@end
