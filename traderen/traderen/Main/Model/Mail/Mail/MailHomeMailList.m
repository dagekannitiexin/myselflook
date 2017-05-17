//
//  MailHomeMailList.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/17.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailHomeMailList.h"

@implementation MailHomeMailList
+ (NSDictionary*)mj_objectClassInArray {
    return @{
             @"list": [MailHomeMailListCell class],
             };
}

+ (NSArray*)ignoredProperties {
    return @[@"list"];
}

+ (NSString*)primaryKey {
    return @"index";
}

- (void)mjSaveToRlm {
    for (MailHomeMailListCell *cell in self.list) {
        [self.mailList addObject:cell];
    }
}
@end
