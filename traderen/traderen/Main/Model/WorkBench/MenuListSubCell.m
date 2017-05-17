//
//  MenuListSubCell.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MenuListSubCell.h"

@implementation MenuListSubCell
+ (NSDictionary*)mj_objectClassInArray {
    return @{
             @"next": [MenuListSecondSubCell class],
             };
}

+ (NSArray*)ignoredProperties {
    return @[@"next"];
}

+ (NSString *)primaryKey {
    return @"menuno";
}
@end
