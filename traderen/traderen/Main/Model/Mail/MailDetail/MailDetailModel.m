//
//  MailDetailModel.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/24.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "MailDetailModel.h"

@implementation MailDetailModel
+ (NSString*)primaryKey {
    return @"id";
}

+ (NSArray*)ignoredProperties {
    return @[@"file"];
}

+ (NSDictionary*)mj_objectClassInArray {
    return @{
             @"file": [MailDetailFileModel class],
             };
}

- (void)mjSaveToRlm {
    for (MailDetailFileModel *cell in self.file) {
        [self.fileModels addObject:cell];
    }
}
@end
