//
//  RESTError.h
//  LXLPay
//
//  Created by PengLin on 13-12-2.
//  Copyright (c) 2013年 PengLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kRequestErrorDomain @"HTTP_ERROR"
#define kBusinessErrorDomain @"BIZ_ERROR" // rename this appropriately

@interface RESTError : NSError

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *errorCode;

- (NSString*) localizedOption;
-(id) initWithDictionary:(NSMutableDictionary*) jsonObject;
@end
