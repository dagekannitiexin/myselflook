//
//  NSString+CreateTime.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/17.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "NSString+CreateTime.h"

@implementation NSString (CreateTime)
+ (NSString *)createDateStringToCreateTimeFromNow:(NSString *)dateString {
    //    Mon May 09 15:21:58 +0800 2016
    //获取微博发送时间
    //把获得的字符串时间 转成 时间戳
    //EEE（星期）  MMM（月份）dd（天） HH小时 mm分钟 ss秒 Z时区 yyyy年
//    NSRange range = [dateString rangeOfString:@"."];
//    NSString *str = [dateString substringWithRange:NSMakeRange(0, 19)];
//    NSString *newStr = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    format.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    format.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    //设置地区
    format.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *Date = [format dateFromString:dateString];
    
    //获取当前时间
    NSDate *nowDate = [NSDate new];
    
    long nowTime = [nowDate timeIntervalSince1970];
    long weiboTime = [Date timeIntervalSince1970];
    long time = nowTime-weiboTime;
    if (time<60) {//一分钟内 显示刚刚
        return @"刚刚";
    } else if (time > 60 && time <= 3600){
        return [NSString stringWithFormat:@"%d分钟前",(int)time/60];
    } else if (time > 3600 && time < 3600*24){
        return [NSString stringWithFormat:@"%d小时前",(int)time/3600];
    } else if (time >= 3600*24 && time < 3600*24*7) {
        return [NSString stringWithFormat:@"%d天前", (int)time/3600/24];
    } else {//直接显示日期
        format.dateFormat = @"yyyy年MM月dd日";
        format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        return  [format stringFromDate:Date];
    }
}


@end
