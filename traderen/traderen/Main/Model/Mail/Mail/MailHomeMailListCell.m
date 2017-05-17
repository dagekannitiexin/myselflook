//
//  MailHomeMailListCell.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/17.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailHomeMailListCell.h"

@implementation MailHomeMailListCell
+ (NSString*)primaryKey {
    return @"Id";
}

+ (NSArray*)ignoredProperties {
    return @[@"isSelect"];
}
@end
