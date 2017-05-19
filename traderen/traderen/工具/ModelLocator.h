//
//  ModelLocator.h
//  spjk
//
//  Created by PengLin on 14-8-20.
//  Copyright (c) 2014年 PengLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelLocator : NSObject

@property(nonatomic,strong) NSString *userID;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *yglb;
@property(nonatomic,strong) NSString *uuid;
@property(nonatomic,strong) NSString *ygbh; //工号
@property(nonatomic,strong) NSString *ygdh; //移动电话
@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *chatStatue;
@property(nonatomic,strong) NSString *step;
@property(nonatomic,strong) NSString *sex;
@property(nonatomic,strong) NSString *position;
@property(nonatomic,strong) NSString *department;
@property(nonatomic,strong) NSString *headImage;
@property(nonatomic,strong) NSMutableArray *benzu;
@property(nonatomic,strong) NSString *temp;
@property(nonatomic,strong) NSDictionary *patientDic;
@property(nonatomic,strong) NSString *regexp_mobile;
//@property(nonatomic,PX_STRONG) 
+ (ModelLocator*)sharedInstance;

@end
