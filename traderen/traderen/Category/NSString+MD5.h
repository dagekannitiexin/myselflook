//
//  NSString+MD5.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/10.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
/** 字符串转换为32位大写MD5字符串 */
+ (NSString *)stringTo32BitMD5UpperStringWithString:(NSString *)str;

/** 字符串转换为32位小写MD5字符串 */
+ (NSString *)stringTo32BitMD5LowerStringWithString:(NSString *)str;
@end
