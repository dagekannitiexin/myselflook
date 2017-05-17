//
//  MailHomeMailList.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/17.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>
#import "MailHomeMailListCell.h"

@interface MailHomeMailList : RLMObject
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) RLMArray<MailHomeMailListCell *><MailHomeMailListCell> *mailList;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) NSInteger unread;

- (void)mjSaveToRlm;
@end
