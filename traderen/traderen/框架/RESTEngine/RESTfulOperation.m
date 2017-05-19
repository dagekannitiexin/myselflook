//
//  RESTfulOperation.m
//  LXLPay
//
//  Created by PengLin on 13-12-2.
//  Copyright (c) 2013年 PengLin. All rights reserved.
//

#import "RESTfulOperation.h"

@implementation RESTfulOperation

- (void)operationSucceeded
{  
  // even when request completes without a HTTP Status code, it might be a benign error
  
  NSMutableDictionary *errorDict = [[self responseJSON] objectForKey:@"error"];
  
  if(errorDict)
  {
    self.restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
                                                code:[[errorDict objectForKey:@"code"] intValue]
                                            userInfo:errorDict];
    [super operationFailedWithError:self.restError];
  }
	else 
	{		
		[super operationSucceeded];
	}	
}

-(void) operationFailedWithError:(NSError *)theError
{
  NSMutableDictionary *errorDict = [[self responseJSON] objectForKey:@"error"];

  if(errorDict == nil)
  {
    self.restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain 
                                              code:[theError code]
                                          userInfo:[theError userInfo]];
  }
  else
  {
    self.restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain 
                                                code:[[errorDict objectForKey:@"code"] intValue]
                                            userInfo:errorDict];    
  }
    
  [super operationFailedWithError:theError];
}

@end
