//
//  MailHomeMailListCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/17.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Realm/Realm.h>

@interface MailHomeMailListCell : RLMObject
@property (nonatomic, assign) NSInteger AccCount;
@property (nonatomic, strong) NSString *Area;
@property (nonatomic, strong) NSString *Bak;
@property (nonatomic, strong) NSString *Box;
@property (nonatomic, strong) NSString *BoxBase;
@property (nonatomic, strong) NSString *CreateTime;
@property (nonatomic, strong) NSString *FromEmail;
@property (nonatomic, strong) NSString *FromName;
@property (nonatomic, strong) NSString *IP;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger MailBoxId;
@property (nonatomic, strong) NSString *MailDate;
@property (nonatomic, strong) NSString *MailLabel;
@property (nonatomic, assign) NSInteger MailSize;
@property (nonatomic, strong) NSString *MailType;
@property (nonatomic, strong) NSString *RE;
@property (nonatomic, strong) NSString *Read;
@property (nonatomic, assign) NSInteger ReadMode;
@property (nonatomic, strong) NSString *RecDate;
@property (nonatomic, strong) NSString *ReplyTo;
@property (nonatomic, strong) NSString *RevUserId;
@property (nonatomic, strong) NSString *RevUserName;
@property (nonatomic, strong) NSString *RootId;
@property (nonatomic, strong) NSString *SendDate;
@property (nonatomic, strong) NSString *Subject;
@property (nonatomic, strong) NSString *TopTime;
@property (nonatomic, strong) NSString *bcc;
@property (nonatomic, strong) NSString *cc;
@property (nonatomic, strong) NSString *itFrom;
@property (nonatomic, strong) NSString *itTo;
@property (nonatomic, strong) NSString *priority;
@property (nonatomic, strong) NSString *redflag;
@property (nonatomic, strong) NSString *star;
@property (nonatomic, assign) NSInteger isSelect;
@end
RLM_ARRAY_TYPE(MailHomeMailListCell);
