//
//  MailFolderCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/22.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>

@interface MailFolderCell : RLMObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger mailboxId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *parentid;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger isSelect;
@end
RLM_ARRAY_TYPE(MailFolderCell);
