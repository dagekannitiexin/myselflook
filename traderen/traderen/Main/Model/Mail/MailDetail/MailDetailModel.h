//
//  MailDetailModel.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/24.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>
#import "MailDetailFileModel.h"

@interface MailDetailModel : RLMObject
@property (nonatomic, strong) NSString *bcc;
@property (nonatomic, strong) NSString *cc;
@property (nonatomic, strong) NSArray *file;
@property (nonatomic, strong) NSString *htmlbody;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *mailtype;
@property (nonatomic, strong) NSString *replyto;
@property (nonatomic, strong) NSString *textBody;
@property (nonatomic, strong) RLMArray<MailDetailFileModel *><MailDetailFileModel> *fileModels;

- (void)mjSaveToRlm;
@end
