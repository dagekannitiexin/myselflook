//
//  MailFolderCell.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/22.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailFolderCell.h"

@implementation MailFolderCell
+ (NSString*)primaryKey {
    return @"id";
}

+ (NSArray*)ignoredProperties {
    return @[@"isSelect"];
}
@end
