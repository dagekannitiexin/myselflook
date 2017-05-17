//
//  UserMailBoxList.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/11.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "UserMailBoxList.h"

@implementation UserMailBoxList
+ (NSDictionary*)mj_objectClassInArray {
    return @{
             @"back": [UserMailBoxListCell class],
             };
}

+ (NSArray*)ignoredProperties {
    return @[@"back"];
}

+ (NSString*)primaryKey {
    return @"id";
}

- (void)mjSaveToRlm {
    for (UserMailBoxListCell *cell in self.back) {
        [self.userMailBoxList addObject:cell];
    }
}
@end
