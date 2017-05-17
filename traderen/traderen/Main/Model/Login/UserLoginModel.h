//
//  UserLoginModel.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>
#import "UserMailLabelCell.h"

@interface UserLoginModel : RLMObject
@property (nonatomic, strong) NSString *branch;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) RLMArray<UserMailLabelCell *><UserMailLabelCell> *maillabels;
@property (nonatomic, strong) NSArray *maillabel;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, assign) NSInteger type;
- (void)mjSaveToRlm;
@end
