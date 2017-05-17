//
//  MenuListSubCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>
#import "MenuListSecondSubCell.h"

@interface MenuListSubCell : RLMObject
@property (nonatomic, strong) NSString *menuno;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) RLMArray<MenuListSecondSubCell *><MenuListSecondSubCell> *secondSubList;
@property (nonatomic, strong) NSArray *next;
@end
RLM_ARRAY_TYPE(MenuListSubCell);
