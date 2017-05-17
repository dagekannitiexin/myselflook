//
//  NSString+MailLabel.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/17.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "NSString+MailLabel.h"

@implementation NSString (MailLabel)
+ (NSArray<NSString *> *)mailLabelStrToLabelStrArray:(NSString *)mailLabel {
    NSArray<NSString *> *strArray = [mailLabel componentsSeparatedByString:@","];
    NSMutableArray *mutableStrArray = [NSMutableArray array];
    for (NSString *str in strArray) {
        if (str && ![str isEqualToString:@""] && str.length > 0) {
            NSArray<NSString *> *anotherStrArray = [str componentsSeparatedByString:@"|"];
            [mutableStrArray addObject:anotherStrArray[0]];
        }
    }
    return [mutableStrArray copy];
}
@end
