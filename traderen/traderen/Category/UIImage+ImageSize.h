//
//  UIImage+ImageSize.h
//  traderen
//
//  Created by 陈伟杰 on 2017/5/12.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageSize)
//高还原截图
+ (UIImage *)saveImageOfView:(UIView *)view;

//图片压缩到指定大小
+ (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize SourceImage:(UIImage *)image;
@end
