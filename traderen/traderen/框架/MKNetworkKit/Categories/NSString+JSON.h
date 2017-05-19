//
//  NSString+JSON.h
//  纸飞机
//
//  Created by wbq on 15/12/22.
//  Copyright © 2015年 wbq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithString:(NSString *) string;
+(NSString *) jsonStringWithObject:(id) object;
+(NSString *)base64Encode:(NSString *)str;
+(NSString *)base64Decode:(NSString *)str;
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;
@end
