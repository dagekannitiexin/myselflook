//
//  MenuListCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>
#import "MenuListSubCell.h"

@interface MenuListCell : RLMObject
@property (nonatomic, strong) NSString *menuno;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) RLMArray<MenuListSubCell *><MenuListSubCell> *SubList;
@property (nonatomic, strong) NSArray *next;

- (void)mjSaveToRlm;
@end
RLM_ARRAY_TYPE(MenuListCell);
