//
//  UserSmartMailBoxChildList.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/11.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>
#import "UserSmartMailBoxChildListCell.h"

@interface UserSmartMailBoxChildList : RLMObject
@property (nonatomic, strong) NSArray *back;
@property (nonatomic, strong) RLMArray<UserSmartMailBoxChildListCell *><UserSmartMailBoxChildListCell> *userSmartMailBoxChildList;
@property (nonatomic, assign) NSInteger id;

- (void)mjSaveToRlm;
@end
