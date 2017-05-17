//
//  MailDetailFileModel.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/24.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>

@interface MailDetailFileModel : RLMObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger size;
@end
RLM_ARRAY_TYPE(MailDetailFileModel);
