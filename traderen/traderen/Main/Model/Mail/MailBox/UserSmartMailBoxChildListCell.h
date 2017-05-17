//
//  UserSmartMailBoxChildListCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/12.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserSmartMailBoxChildListCell : RLMObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@end
RLM_ARRAY_TYPE(UserSmartMailBoxChildListCell);
