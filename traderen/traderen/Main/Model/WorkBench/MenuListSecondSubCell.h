//
//  MenuListSecondSubCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>

@interface MenuListSecondSubCell : RLMObject
@property (nonatomic, strong) NSString *menuno;
@property (nonatomic, strong) NSString *name;
@end
RLM_ARRAY_TYPE(MenuListSecondSubCell);
