//
//  ModelLocator.m
//  spjk
//
//  Created by PengLin on 14-8-20.
//  Copyright (c) 2014年 PengLin. All rights reserved.
//

#import "ModelLocator.h"

@implementation ModelLocator

static ModelLocator *sharedInstance = nil;




+ (ModelLocator*)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
    if (self = [super init]) {
        self.regexp_mobile =  @"^(0|86|17951)?(13[0-9]|15[012356789]|17[05678]|18[0-9]|14[579])[0-9]{8}$";
    }
    return self;
}

- (void)setUserName:(NSString *)userName{
    if(userName ==nil){
        _userName = @"";
    }else{
        _userName = userName;
    }
}

- (void)setPosition:(NSString *)position{
    if(position ==nil){
        _position = @"";
    }else{
        _position = position ;
    }
}

- (void)setDepartment:(NSString *)department{
    if(department ==nil){
        _department = @"";
    }else{
        _department = department;
    }
}

- (NSString *)getFiledPath{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"mzyyData.plist"];
    return plistPath;
}

- (NSArray *)getTheArrayInFileWithKey:(NSString *)keyName{
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:[self getFiledPath]];
    
    return [dictionary valueForKey:keyName];
}

- (void)saveTheInfoToFieldWithData:(NSArray *)dataArray  key:(NSString *)keyName{
    NSString *error;
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:[self getFiledPath]];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]initWithDictionary:dictionary];

    [infoDic setObject:dataArray forKey:keyName];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [infoDic allValues] forKeys:[infoDic allKeys]];
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    
    if(plistData) {
        [plistData writeToFile:[self getFiledPath] atomically:YES];
    }
}

@end
