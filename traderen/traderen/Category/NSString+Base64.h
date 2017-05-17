//
//  NSString+Base64.h
//  traderen
//
//  Created by 陈伟杰 on 2017/5/2.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)
+ (NSData *)decodeBase64StringTodata:(NSString *)base64String;

+ (NSString *)encodeDataToBase64String:(NSData *)data;
@end
