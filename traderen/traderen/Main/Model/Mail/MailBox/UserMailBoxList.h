//
//  UserMailBoxList.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/11.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>
#import "UserMailBoxListCell.h"
@interface UserMailBoxList : RLMObject
@property (nonatomic, strong) RLMArray<UserMailBoxListCell *><UserMailBoxListCell> *userMailBoxList;
@property (nonatomic, strong) NSArray *back;
@property (nonatomic, assign) NSInteger id;
- (void)mjSaveToRlm;
@end
