//
//  JSONModel.h
//  LXLPay
//
//  Created by PengLin on 13-12-2.
//  Copyright (c) 2013年 PengLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONModel : NSObject <NSCoding, NSCopying, NSMutableCopying> {

}

-(id) initWithDictionary:(NSMutableDictionary*) jsonObject;

@end
