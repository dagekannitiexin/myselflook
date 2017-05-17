//
//  MenuList.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/6.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>
#import "MenuListCell.h"

@interface MenuList : RLMObject
@property (nonatomic, strong) RLMArray<MenuListCell *><MenuListCell> *menuList;
@property (nonatomic, strong) NSArray *back;
@property (nonatomic, assign) NSInteger id;
- (void)mjSaveToRlm;
@end
RLM_ARRAY_TYPE(MenuList);
