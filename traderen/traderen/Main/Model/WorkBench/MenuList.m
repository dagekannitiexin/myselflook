//
//  MenuList.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MenuList.h"

@implementation MenuList
+ (NSDictionary*)mj_objectClassInArray {
    return @{
             @"back": [MenuListCell class],
             };
}

+ (NSArray*)ignoredProperties {
    return @[@"back"];
}

- (void)mjSaveToRlm {
    for (MenuListCell *cell in self.back) {
        for (MenuListSubCell *subCell in cell.next) {
            for (MenuListSecondSubCell *secondSubCell in subCell.next) {
                [subCell.secondSubList addObject:secondSubCell];
            }
            [cell.SubList addObject:subCell];
        }
        [self.menuList addObject:cell];
    }
}

+ (NSString*)primaryKey {
    return @"id";
}
@end
