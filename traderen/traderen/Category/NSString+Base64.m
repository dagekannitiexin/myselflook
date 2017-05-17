//
//  NSString+Base64.m
//  traderen
//
//  Created by 陈伟杰 on 2017/5/2.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)
+ (NSString *)encodeDataToBase64String:(NSData *)data {
    NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64String;
}

+(NSData *)decodeBase64StringTodata:(NSString *)base64String {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    return data;
}
@end
