//
//  MailAttachmentInfoModel.h
//  traderen
//
//  Created by 陈伟杰 on 2017/5/12.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailAttachmentInfoModel : NSObject
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sizeString;
@property (nonatomic, strong) NSData *smallImageData;
@property (nonatomic, strong) NSData *imageData;
@end
