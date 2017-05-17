//
//  CustomTabBar.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarCenterButtonClickDelegate <NSObject>

@required
- (void)tabBarCenterButtonClick;

@end

@interface CustomTabBar : UITabBar

@property (nonatomic, weak) id<TabBarCenterButtonClickDelegate> centerButtonDelegate;
@property (nonatomic, strong) UIButton *button;

@end
