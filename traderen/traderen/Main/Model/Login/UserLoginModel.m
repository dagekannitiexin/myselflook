//
//  UserLoginModel.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "UserLoginModel.h"

@implementation UserLoginModel
+ (NSDictionary*)mj_objectClassInArray {
    return @{
             @"maillabel": [UserMailLabelCell class],
             };
}

+ (NSArray*)ignoredProperties {
    return @[@"maillabel"];
}

+ (NSString*)primaryKey {
    return @"id";
}

- (void)mjSaveToRlm {
    for (UserMailLabelCell *cell in self.maillabel) {
        [self.maillabels addObject:cell];
    }
}
@end
