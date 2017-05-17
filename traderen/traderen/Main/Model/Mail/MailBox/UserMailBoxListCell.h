//
//  UserMailBoxListCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/11.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserMailBoxListCell : RLMObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@end
RLM_ARRAY_TYPE(UserMailBoxListCell);
