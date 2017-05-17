//
//  UserInfoManager.h
//  traderen
//
//  Created by 陈伟杰 on 2017/4/12.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface UserInfoManager : NSObject
@property (nonatomic, strong) NSString *userAccount;
@property (nonatomic, strong) NSString *userMD5Password;
@property (nonatomic, strong) NSString *userServerAddress;
singleton_interface(UserInfoManager)
@end
