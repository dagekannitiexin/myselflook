//
//  UserSmartMailBoxChildList.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/11.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "UserSmartMailBoxChildList.h"

@implementation UserSmartMailBoxChildList
+ (NSDictionary*)mj_objectClassInArray {
    return @{
             @"back": [UserSmartMailBoxChildListCell class],
             };
}

+ (NSArray*)ignoredProperties {
    return @[@"back"];
}

+ (NSString*)primaryKey {
    return @"id";
}

- (void)mjSaveToRlm {
    for (UserSmartMailBoxChildListCell *cell in self.back) {
        [self.userSmartMailBoxChildList addObject:cell];
    }
}
@end
