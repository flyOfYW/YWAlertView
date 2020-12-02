//
//  NSDate+YW.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/9/17.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "NSDate+YW.h"

#define YW_MONTHS_IN_A_SEASON 3 // 1季的月数

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

//MARK: ----------- 日期比较 ---------------------

/// 两个日期比较【YYYY-MM-dd】，比较的结果等于result则不满足，否则满足
/// @param fromDateStr 日期
/// @param toDateStr 被比较的日期
/// @param result 比较条件
+ (BOOL)isMeet:(NSString *)fromDateStr
            to:(NSString *)toDateStr
       compare:(NSComparisonResult)result{
    NSDate *date = [self date:fromDateStr format:YWDateStyleYYYYMMDD];
    NSDate *endDate = [self date:toDateStr format:YWDateStyleYYYYMMDD];
    if ([date compare:endDate] == result) {
        return NO;
    }
    return YES;
}
/// 两个日期比较【YYYY-MM】，比较的结果等于result则不满足，否则满足
/// @param fromDateStr 日期
/// @param toDateStr 被比较的日期
/// @param result 比较条件
+ (BOOL)isMeetOnYYYYMM:(NSString *)fromDateStr
                    to:(NSString *)toDateStr
               compare:(NSComparisonResult)result{
    NSDate *date = [self date:fromDateStr format:YWDateStyleYYYYMM];
    NSDate *endDate = [self date:toDateStr format:YWDateStyleYYYYMM];
    if ([date compare:endDate] == result) {
        return NO;
    }
    return YES;
}

//MARK: ----------- 将日期格式字符串转NSDate日期相关 ---------------------
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


//MARK: ----------- 将时间戳转日期格式字符串相关 ---------------------
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


/**
 获取昨天的日期
 
 @return 日期
 */
+ (NSString *)getDateOfYesterday{
    
    return [self getTheDateBeforeSomeday:nil day:1];
}
/**
 获取当期的日期

 @return 日期
 */
+ (NSString *)getDateOfNow{
    
    [[self currentDateFormatter] setDateFormat:@"yyyy-MM-dd"];
    
    return [[self currentDateFormatter] stringFromDate:[NSDate date]];
}
/**
 获取明天的日期

 @return 日期
 */
+ (NSString *)getDateOfTomorrow{
    
    return [self getTheDateAfterSomeday:nil day:1];
}
/**
 获取本月最后一天的日期

 @return 日期
 */
+ (NSString *)getDateOfThisMonth{
    
    return [self dateYYYYMMDDByTimeStamp:[self getEndTimeOfThisMonth]];
}

/**
 获取某天的几天前的日期

 @param someDate 某天(someData为nil时，默认今天)
 @param day 天数
 @return 日期
 */
+ (NSString *)getTheDateBeforeSomeday:(NSDate *)someDate
                                  day:(NSInteger)day{
    
    NSTimeInterval  oneDay = [self getDayTimeInterval:day] ;  //1天的长度
    
    [[self currentDateFormatter] setDateFormat:@"yyyy-MM-dd"];
    
    if (someDate) {
        
    return [[self currentDateFormatter] stringFromDate:[someDate initWithTimeIntervalSinceNow:-oneDay]];
        
    }
    
    return [[self currentDateFormatter] stringFromDate:[[NSDate date] initWithTimeIntervalSinceNow:-oneDay]];
}

/**
 获取某天的几天后的日期

 @param someDate 某天(someData为nil时，默认今天)
 @param day 天数
 @return 日期
 */
+ (NSString *)getTheDateAfterSomeday:(NSDate *)someDate
                                 day:(NSInteger)day{
    
    NSTimeInterval  oneDay = [self getDayTimeInterval:day] ;  //1天的长度
    
    [[self currentDateFormatter] setDateFormat:@"yyyy-MM-dd"];
    
    if (someDate) {
        
        return [[self currentDateFormatter] stringFromDate:[someDate initWithTimeIntervalSinceNow:oneDay]];
        
    }
    
    return [[self currentDateFormatter] stringFromDate:[[NSDate date] initWithTimeIntervalSinceNow:oneDay]];
}
/**
 获取本季度的第一天日期

 @return 日期
 */
+ (NSString *)getTheDateOfTheFirstDayOfTheQuarter{
    
    return [self dateYYYYMMDDByTimeStamp:[self getStartTimeOfThisSeason]];
}
/**
 获取本季度的最后一天日期
 
 @return 日期
 */
+ (NSString *)getTheDateOfTheLastDayOfTheQuarter{
    
    return [self dateYYYYMMDDByTimeStamp:[self getEndTimeOfThisSeason]];
}
//MARK: ----------- 时间戳操作相关 ---------------------
/**
 获取昨天的起始秒（单位：秒(s)）
 
 @return 昨天的起始秒
 */
+ (NSTimeInterval)getStartTimeOfYesterday{
    
    NSDateComponents* components = [self getComponentsOfDay:nil];
    
    [components setHour:-24];
    
    NSDate *nowDate = [[self currentCalendar] dateFromComponents:components];
    
    return [nowDate timeIntervalSince1970];
}
/**
 获取昨天的结束秒（单位：秒(s)）
 
 @return 昨天的结束秒
 */
+ (NSTimeInterval)getEndTimeOfYesterday{
    // 减一秒
    return [self getStartTimeOfToday] - 1;
}
/**
 获取当前的时间戳

 @return 当前的时间戳
 */
+ (NSTimeInterval)getNowTimeInterval{
    return [[NSDate date] timeIntervalSince1970];
}
/**
 获取今天的起始秒（单位：秒(s)）

 @return 今天的起始秒
 */
+ (NSTimeInterval)getStartTimeOfToday{
    
    NSDateComponents* components = [self getComponentsOfDay:nil];
    
    NSDate *nowDate = [[self currentCalendar] dateFromComponents:components];
    
    return [nowDate timeIntervalSince1970];
}
/**
  获取今天的结束秒（单位：秒(s)）

 @return 今天的结束秒
 */
+ (NSTimeInterval)getEndTimeOfToday{
    
    NSDateComponents* components = [self getComponentsOfDay:nil];
    
    //在今天的日期位置上，hours + 24，即是明天的起始日期，
    [components setHour:+24];
    
    NSDate *nowDate = [[self currentCalendar] dateFromComponents:components];
    
    //    在减去1s，就是今日的最后的秒数
    return [nowDate timeIntervalSince1970] - 1;
}
/**
 获取该天的起始秒（单位：秒(s)）
 
 @param theDate 该天的日期
 @return 该天的起始秒
 */
+ (NSTimeInterval)getStartTimeOfThisDay:(NSDate *)theDate{
    
    NSDateComponents* components = [self getComponentsOfDay:theDate];
    
    NSDate* date = [[self currentCalendar] dateFromComponents:components];
    
    return [date timeIntervalSince1970];
}
/**
 获取该天的结束秒（单位：秒(s)）
 
 @param theDate 该天的日期
 @return 该天的结束秒
 */
+ (NSTimeInterval)getEndTimeOfThisDay:(NSDate *)theDate{
    
    NSDateComponents* components = [self getComponentsOfDay:theDate];
    
    [components setHour: +24];
    
    NSDate* date = [[self currentCalendar] dateFromComponents:components];
    
    return [date timeIntervalSince1970]- 1;
}
/**
 获取上个月的起始秒（单位：秒）
 
 @return 上个月的起始秒
 */
+ (NSTimeInterval)getStartTimeOfLastMonth{
    
    NSDateComponents * components = [self getComponentsOfMonth];
    
    [components setMonth: [components month] - 1];
    
    NSDate *date = [[self currentCalendar] dateFromComponents:components];
    
    return [date timeIntervalSince1970];
}
/**
 获取上个月的结束秒（单位：秒）
 
 @return 上个月的结束秒
 */
+ (NSTimeInterval)getEndTimeOfLastMonth{
    
    //设置当前月的第一天的起始日期（精确到秒）
    NSDateComponents * components = [self getComponentsOfMonth];
    
    NSDate* date = [[self currentCalendar] dateFromComponents:components];
    
//    [date timeIntervalSince1970] 其实是本月的起始秒
    return [date timeIntervalSince1970]  - 1;
}
/**
 获取该月的起始秒 （单位：秒）
 
 @param date 日期（支持yyyy-MM yyyy-MM-dd等格式）
 @return 该月的起始秒
 */
+ (NSTimeInterval)getStartTimeOfTheMonth:(NSDate *)date{
    
    NSDateComponents   *components = [self getComponentOfMonth: date];
    
    NSDate  *newDate = [[self currentCalendar] dateFromComponents:components];
    
    return [newDate timeIntervalSince1970];
}

/**
 该月的结束秒 （单位：秒）
 
 @param date 日期（支持yyyy-MM yyyy-MM-dd等格式）
 @return 该月的结束秒
 */
+ (NSTimeInterval)getEndTimeOfTheMonth:(NSDate*)date{
    
    // 该月的起始秒
    NSDateComponents* components = [self getComponentOfMonth:date];
    
    // 加1月
    [components setMonth: [components month] + 1];
    
    NSDate *newDate = [[self currentCalendar] dateFromComponents:components];
    
    return [newDate timeIntervalSince1970] - 1;
}
/**
 获取本月的起始秒（单位：秒）
 
 @return 本月的起始秒
 */
+ (NSTimeInterval)getStartTimeOfThisMonth{
    
   return [self getStartTimeOfTheMonth:[NSDate date]];
}
/**
 获取本月的结束秒（单位：秒）
 
 @return 本月的结束秒
 */
+ (NSTimeInterval)getEndTimeOfThisMonth{
    
    return [self getEndTimeOfTheMonth:[NSDate date]];
}

/**
 获取本季度的开始秒 （单位：秒）
 
 * @return: 本季的开始秒
 */
+ (NSTimeInterval)getStartTimeOfThisSeason{
    
    NSDateComponents *components = [self getComponentsOfThisSeason];
    
    NSDate *date = [[self currentCalendar] dateFromComponents:components];
    
    return [date timeIntervalSince1970];
}

/**
 获取本季度的结束秒 （单位：秒）
 
 * @return: 本季的结束秒
 */
+ (NSTimeInterval) getEndTimeOfThisSeason{
    
    NSDateComponents *components = [self getComponentsOfThisSeason];
    
    [components setMonth: [components month] + 3];
    
    NSDate *date = [[self currentCalendar] dateFromComponents:components];
    
    return [date timeIntervalSince1970] - 1;
}
/**
 获取本年的起始秒
 
 @return 本年的起始秒
 */
+ (NSTimeInterval)getStartTimeOfThisYear{
    
    NSDateComponents *components = [self getComponentsOfYear];
    
    NSDate *date = [[self currentCalendar] dateFromComponents:components];
    
    return [date timeIntervalSince1970];
}


/**
 获取本年的结束秒
 
 @return 本年的结束秒
 */
+ (NSTimeInterval)getEndTimeOfThisYear{
    
    NSDateComponents *components = [self getComponentsOfYear];
    
    [components setYear: [components year] + 1];
    
    NSDate *date = [[self currentCalendar] dateFromComponents:components];
    
    return [date timeIntervalSince1970] - 1;
}


/**
 获取上年的起始秒
 
 @return 上年的起始秒
 */
+ (NSTimeInterval) getStartTimeOfLastYear{
    
    NSDateComponents *components = [self getComponentsOfYear];
    
    [components setYear: [components year] - 1];
    
    NSDate *date = [[self currentCalendar] dateFromComponents:components];
    
    return [date timeIntervalSince1970];
}
/**
 获取上年的结束秒
 
 @return 上年的结束秒
 */
+ (NSTimeInterval) getEndTimeOfLastYear{
    
    return [self getStartTimeOfThisYear] - 1;
}
//MARK: -----------   私有方法 -----------------
/**
 获取当年的第一天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 
 @return 当年的第一天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 */
+ (NSDateComponents*)getComponentsOfYear{
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    [components setYear: [[self getComponentsOfDay:nil] year]];
    
    [components setMonth: 1];
    
    return components;
}
/**
 获取当季第一天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 
 @return 当季第一天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 */
+ (NSDateComponents*) getComponentsOfThisSeason{
    
    NSDateComponents* components = [self getComponentsOfDay: [NSDate date]];
    
    NSInteger thisMonth = [components month];
    
    NSInteger thisSeasonStartMonth;
    
    if(thisMonth % YW_MONTHS_IN_A_SEASON == 0){
        thisSeasonStartMonth = thisMonth - 2;
    }else{
        thisSeasonStartMonth = thisMonth - (thisMonth % YW_MONTHS_IN_A_SEASON - 1);
    }
    
    [components setMonth: thisSeasonStartMonth];
    
    NSDateComponents* thisSeasonStartMonthComponents = [[NSDateComponents alloc] init];
    
    [thisSeasonStartMonthComponents setYear: [components year]];
    
    [thisSeasonStartMonthComponents setMonth: [components month]];
    
    return thisSeasonStartMonthComponents;
}
/**
 获取该月的“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 
 @param date 日期
 @return NSDateComponents对象
 */
+ (NSDateComponents *)getComponentOfMonth:(NSDate *)date{
    
    NSDateComponents* components = [self getComponentsOfDay:date];
    
    [components setDay:1];
    
    return components;
}
/**
 获取当月的“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 
 @return NSDateComponents对象
 */
+ (NSDateComponents *)getComponentsOfMonth{
    
    NSDateComponents* components = [self getComponentsOfDay: [NSDate date]];
    
    NSDateComponents* firstDayCurrentMonth = [[NSDateComponents alloc] init];
    
    [firstDayCurrentMonth setYear: [components year]];
    [firstDayCurrentMonth setMonth: [components month]];
    [firstDayCurrentMonth setDay:1];//不存在0号
    [firstDayCurrentMonth setHour: 0];
    [firstDayCurrentMonth setMinute: 0];
    [firstDayCurrentMonth setSecond: 0];
    
    return firstDayCurrentMonth;
}
/**
 获取指定日期的“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 
 @param appointDate 指定的日期，当为空的时候，默认当前日期
 @return NSDateComponents对象
 */
+ (NSDateComponents *)getComponentsOfDay:(NSDate *)appointDate{
    
    if (appointDate == NULL || appointDate == nil){
        appointDate = [NSDate date];
    }
    NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:appointDate];
    
    // 0时0分0秒
    [components setHour: 0];
    [components setMinute: 0];
    [components setSecond: 0];
    
    return components;
}
/**
 获取对应的秒数

 @param day 范围（单位：天）
 @return 秒数
 */
+ (NSTimeInterval)getDayTimeInterval:(NSInteger)day{
    
    return  24 * 60 * 60 * day;  //1天的长度
}
//MARK: --------------------------- getter ---------------------
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
- (NSInteger)days{
   NSRange range = [[NSDate currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}
@end
