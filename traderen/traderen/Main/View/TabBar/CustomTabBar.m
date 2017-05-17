//
//  CustomTabBar.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor colorWithRed:50/255.0 green:102/255.0 blue:153/255.0 alpha:1];
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [centerButton setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
        CGRect temp = centerButton.frame;
        temp.size = centerButton.currentImage.size;
        centerButton.frame = temp;
//        centerButton.tintColor = [UIColor colorWithRed:50/255.0 green:102/255.0 blue:153/255.0 alpha:1];
        
        [self addSubview:centerButton];
        [centerButton addTarget:self action:@selector(centerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.button = centerButton;
    }
    return self;
}

//控件的布局方法 每次显示之前会调用
-(void)layoutSubviews{
    [super layoutSubviews];
    CGPoint temp = self.button.center;
    temp.x = self.frame.size.width * 0.5;
    temp.y = self.frame.size.height * 0.5;
    self.button.center = temp;
    
    CGFloat tabBarButtonW = self.frame.size.width * 0.2;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *childView in self.subviews) {
        if ([childView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            CGRect viewFrame = childView.frame;
            viewFrame.size.width = tabBarButtonW;
            viewFrame.origin.x = tabBarButtonIndex * tabBarButtonW;
            childView.frame = viewFrame;
            tabBarButtonIndex ++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
}

- (void)centerButtonClick {
    if ([self.centerButtonDelegate respondsToSelector:@selector(tabBarCenterButtonClick)]) {
        [self.centerButtonDelegate tabBarCenterButtonClick];
    }
}

@end
