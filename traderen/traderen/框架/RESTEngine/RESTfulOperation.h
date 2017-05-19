//
//  RESTfulOperation.h
//  LXLPay
//
//  Created by PengLin on 13-12-2.
//  Copyright (c) 2013年 PengLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkOperation.h"
#import "RESTError.h"

@interface RESTfulOperation : MKNetworkOperation

@property (nonatomic, strong) RESTError *restError;
@end
