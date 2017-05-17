//
//  MenuListCell.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MenuListCell.h"

@implementation MenuListCell
+ (NSDictionary*)mj_objectClassInArray {
    return @{
             @"next": [MenuListSubCell class],
             };
}

+ (NSArray*)ignoredProperties {
    return @[@"next"];
}

+ (NSString *)primaryKey {
    return @"menuno";
}

- (void)mjSaveToRlm {
    for (MenuListSubCell *cell in self.next) {
        [self.SubList addObject:cell];
    }
}
@end
