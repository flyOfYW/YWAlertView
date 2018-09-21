//
//  NSDate+YW.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/9/17.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "NSDate+YW.h"

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);


@implementation NSDate (YW)

+ (NSCalendar *)currentCalendar{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}
+ (NSDateFormatter *)currentDateFormatter{
    static NSDateFormatter *sharedDateFormatter = nil;
    if (!sharedDateFormatter) {
        sharedDateFormatter = [[NSDateFormatter alloc] init];
    }
    return sharedDateFormatter;
}

+ (NSDate *)date:(NSString *)dateString format:(YWDateStyle)dateStyle{
    switch (dateStyle) {
        case YWDateStyleYYYYMMDDHHMMSS:
           return  [self date:dateString formatString:@"yyyy-MM-dd HH:mm:ss"];
            break;
        case YWDateStyleYYYYMMDDHHMM:
            return  [self date:dateString formatString:@"yyyy-MM-dd HH:mm"];
            break;
        case YWDateStyleYYYYMMDD:
            return  [self date:dateString formatString:@"yyyy-MM-dd"];
            break;
        case YWDateStyleYYYYMM:
            return  [self date:dateString formatString:@"yyyy-MM"];
            break;
        case YWDateStyleHHMMSS:
            return  [self date:dateString formatString:@"HH:mm:ss"];
            break;
        case YWDateStyleHHMM:
            return  [self date:dateString formatString:@"HH:mm:"];
            break;
        default:
            break;
    }
    return [NSDate date];
}
+ (NSDate *)date:(NSString *)dateString formatString:(NSString *)format{
    NSDateFormatter *dateFormatter = [self currentDateFormatter];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
}
+ (NSString *)dateByTimeStamp:(long long)timeStamp format:(YWDateStyle)dateStyle{
    switch (dateStyle) {
        case YWDateStyleYYYYMMDDHHMMSS:
            return  [self dateYYYYMMDDHHMMSSByTimeStamp:timeStamp];
            break;
        case YWDateStyleYYYYMMDDHHMM:
            return  [self dateYYYYMMDDHHMMByTimeStamp:timeStamp];
            break;
        case YWDateStyleYYYYMMDD:
            return  [self dateYYYYMMDDByTimeStamp:timeStamp];
            break;
        case YWDateStyleYYYYMM:
            return  [self dateYYYYMMByTimeStamp:timeStamp];
            break;
        case YWDateStyleHHMMSS:
            return  [self dateHHMMSSByTimeStamp:timeStamp];
            break;
        case YWDateStyleHHMM:
            return  [self dateHHMMByTimeStamp:timeStamp];
            break;
        default:
            break;
    }
    return @"";
}
+ (NSString *)dateYYYYMMDDHHMMSSByTimeStamp:(long long)timeStamp{
    
    time_t timeInterval = [NSDate dateWithTimeIntervalSince1970:timeStamp].timeIntervalSince1970;
    
    struct tm *cTime = localtime(&timeInterval);
    
    return [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d:%02d", cTime->tm_year + 1900, cTime->tm_mon + 1, cTime->tm_mday,cTime->tm_hour,cTime->tm_min,cTime->tm_sec];
}
+ (NSString *)dateYYYYMMDDHHMMByTimeStamp:(long long)timeStamp{
    
    time_t timeInterval = [NSDate dateWithTimeIntervalSince1970:timeStamp].timeIntervalSince1970;
    
    struct tm *cTime = localtime(&timeInterval);
    
    return [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", cTime->tm_year + 1900, cTime->tm_mon + 1, cTime->tm_mday,cTime->tm_hour,cTime->tm_min];
}
+ (NSString *)dateYYYYMMDDByTimeStamp:(long long)timeStamp{
    
    time_t timeInterval = [NSDate dateWithTimeIntervalSince1970:timeStamp].timeIntervalSince1970;
    
    struct tm *cTime = localtime(&timeInterval);
    
    return [NSString stringWithFormat:@"%d-%02d-%02d", cTime->tm_year + 1900, cTime->tm_mon + 1, cTime->tm_mday];
}
+ (NSString *)dateYYYYMMByTimeStamp:(long long)timeStamp{
    
    time_t timeInterval = [NSDate dateWithTimeIntervalSince1970:timeStamp].timeIntervalSince1970;
    
    struct tm *cTime = localtime(&timeInterval);
    
    return [NSString stringWithFormat:@"%d-%02d", cTime->tm_year + 1900, cTime->tm_mon + 1];
}
+ (NSString *)dateHHMMSSByTimeStamp:(long long)timeStamp{
    
    time_t timeInterval = [NSDate dateWithTimeIntervalSince1970:timeStamp].timeIntervalSince1970;
    
    struct tm *cTime = localtime(&timeInterval);
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",cTime->tm_hour,cTime->tm_min,cTime->tm_sec];
}
+ (NSString *)dateHHMMByTimeStamp:(long long)timeStamp{
    
    time_t timeInterval = [NSDate dateWithTimeIntervalSince1970:timeStamp].timeIntervalSince1970;
    
    struct tm *cTime = localtime(&timeInterval);
    
    return [NSString stringWithFormat:@"%02d:%02d",cTime->tm_hour,cTime->tm_min];
}

- (NSInteger)year{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}
- (NSInteger)month{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}
- (NSInteger)day{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}
- (NSInteger)hour{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}
- (NSInteger)minute{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}
- (NSInteger)seconds{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}
@end
