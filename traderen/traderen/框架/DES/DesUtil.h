//
//  DesUtil.h
//  yaoeyao
//
//  Created by xiangrui on 14-3-12.
//  Copyright (c) 2014年 xiangrui. All rights reserved.
//

#import <Foundation/Foundation.h>
//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>
@interface DesUtil : NSObject
+ (NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;//加密
+ (NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;//解密
@end
