//
//  NSDate+YW.h
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/9/17.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const YW_DEFAULT_FORMAT = @"yyyy-MM-dd";
static NSString* const YW_YYYYMM = @"yyyy-MM";
static NSString* const YW_YYYYMMDDHHMM = @"yyyy-MM-dd HH:mm";
static NSString* const YW_YYYYMMDDHHMMSS = @"yyyy-MM-dd HH:mm:ss";
static NSString* const YW_HHMMSS = @"HH:mm:ss";
static NSString* const YW_HHMM = @"HH:mm";

typedef enum : NSUInteger {
    YWDateStyleYYYYMMDD,//yyyy-MM-dd
    YWDateStyleYYYYMM,//yyyy-MM
    YWDateStyleYYYYMMDDHHMM,//yyyy-MM-dd HH:mm
    YWDateStyleYYYYMMDDHHMMSS,//yyyy-MM-dd HH:mm:ss
    YWDateStyleHHMMSS,//HH:mm:ss
    YWDateStyleHHMM,//HH:mm
} YWDateStyle;


@interface NSDate (YW)
//获取该NSDate的年份
@property (readonly) NSInteger year;
//获取该NSDate的月份
@property (readonly) NSInteger month;
//获取该NSDate的号数
@property (readonly) NSInteger day;
//获取该NSDate的小时
@property (readonly) NSInteger hour;
//获取该NSDate的分钟
@property (readonly) NSInteger minute;
//获取该NSDate的秒数
@property (readonly) NSInteger seconds;
//获取该NSDate的这个日期对应的月份共有多少天
@property (readonly) NSInteger days;

/**
 获取NSCalendar对象

 @return NSCalendar
 */
+ (NSCalendar *) currentCalendar;
/**
 获取NSDateFormatter对象

 @return NSDateFormatter
 */
+ (NSDateFormatter *)currentDateFormatter;
/**
 将时间字符串格式成NSDate对象

 @param dateString 时间字符串
 @param dateStyle 格式模式
 @return NSDate
 */
+ (NSDate *)date:(NSString *)dateString format:(YWDateStyle)dateStyle;

/// 两个日期比较【YYYY-MM-dd】，比较的结果等于result则不满足，否则满足
/// @param fromDateStr 日期
/// @param toDateStr 被比较的日期
/// @param result 比较条件
+ (BOOL)isMeet:(NSString *)fromDateStr
            to:(NSString *)toDateStr
       compare:(NSComparisonResult)result;

/// 两个日期比较【YYYY-MM】，比较的结果等于result则不满足，否则满足
/// @param fromDateStr 日期
/// @param toDateStr 被比较的日期
/// @param result 比较条件
+ (BOOL)isMeetOnYYYYMM:(NSString *)fromDateStr
                    to:(NSString *)toDateStr
               compare:(NSComparisonResult)result;
/**
 将时间戳转时间格式的日期字符串

 @param timeStamp 时间戳
 @param dateStyle 需要转化的格式
 @return 日期字符串
 */
+ (NSString *)dateByTimeStamp:(long long)timeStamp format:(YWDateStyle)dateStyle;

/**
 将时间戳转时间格式的日期字符串(yyyy-MMM-dd HH:mm:ss)[不使用通过NSDateFormatter对象进行转换，而是通过C语言转换，效率更高]
 
 @param timeStamp 时间戳
 @return 日期字符串(yyyy-MMM-dd HH:mm:ss)
 */
+ (NSString *)dateYYYYMMDDHHMMSSByTimeStamp:(long long)timeStamp;
/**
 将时间戳转时间格式的日期字符串(yyyy-MMM-dd HH:mm)[不使用通过NSDateFormatter对象进行转换，而是通过C语言转换，效率更高]
 
 @param timeStamp 时间戳
 @return 日期字符串(yyyy-MMM-dd HH:mm)
 */
+ (NSString *)dateYYYYMMDDHHMMByTimeStamp:(long long)timeStamp;
/**
 将时间戳转时间格式的日期字符串(yyyy-MMM-dd)[不使用通过NSDateFormatter对象进行转换，而是通过C语言转换，效率更高]
 
 @param timeStamp 时间戳
 @return 日期字符串(yyyy-MMM-dd)
 */
+ (NSString *)dateYYYYMMDDByTimeStamp:(long long)timeStamp;
/**
 将时间戳转时间格式的日期字符串(yyyy-MMM)[不使用通过NSDateFormatter对象进行转换，而是通过C语言转换，效率更高]

 @param timeStamp 时间戳
 @return 日期字符串(yyyy-MMM)
 */
+ (NSString *)dateYYYYMMByTimeStamp:(long long)timeStamp;
/**
 将时间戳转时间格式的日期字符串(HH:mm:ss)[不使用通过NSDateFormatter对象进行转换，而是通过C语言转换，效率更高]

 @param timeStamp 时间戳
 @return 日期字符串(HH:mm:ss)
 */
+ (NSString *)dateHHMMSSByTimeStamp:(long long)timeStamp;
/**
 将时间戳转时间格式的日期字符串(HH:mm)[不使用通过NSDateFormatter对象进行转换，而是通过C语言转换，效率更高]

 @param timeStamp 时间戳
 @return 日期字符串(HH:mm)
 */
+ (NSString *)dateHHMMByTimeStamp:(long long)timeStamp;

/**
 获取昨天的日期
 
 @return 日期
 */
+ (NSString *)getDateOfYesterday;
/**
 获取当期的日期
 
 @return 日期
 */
+ (NSString *)getDateOfNow;
/**
 获取明天的日期
 
 @return 日期
 */
+ (NSString *)getDateOfTomorrow;
/**
 获取本月最后一天的日期
 
 @return 日期
 */
+ (NSString *)getDateOfThisMonth;
/**
 获取某天的几天前的日期
 
 @param someDate 某天(someData为nil时，默认今天)
 @param day 天数
 @return 日期
 */
+ (NSString *)getTheDateBeforeSomeday:(NSDate *)someDate
                                  day:(NSInteger)day;
/**
 获取某天的几天后的日期
 
 @param someDate 某天(someData为nil时，默认今天)
 @param day 天数
 @return 日期
 */
+ (NSString *)getTheDateAfterSomeday:(NSDate *)someDate
                                 day:(NSInteger)day;
/**
 获取本季度的第一天日期
 
 @return 日期
 */
+ (NSString *)getTheDateOfTheFirstDayOfTheQuarter;
/**
 获取本季度的最后一天日期
 
 @return 日期
 */
+ (NSString *)getTheDateOfTheLastDayOfTheQuarter;

/**
 获取昨天的起始秒（单位：秒(s)）
 
 @return 昨天的起始秒
 */
+ (NSTimeInterval)getStartTimeOfYesterday;
/**
 获取昨天的结束秒（单位：秒(s)）
 
 @return 昨天的结束秒
 */
+ (NSTimeInterval)getEndTimeOfYesterday;
/**
 获取当前的时间戳
 
 @return 当前的时间戳
 */
+ (NSTimeInterval)getNowTimeInterval;
/**
 获取今天的起始秒（单位：秒(s)）
 
 @return 今天的起始秒
 */
+ (NSTimeInterval)getStartTimeOfToday;
/**
 获取今天的结束秒（单位：秒(s)）
 
 @return 今天的结束秒
 */
+ (NSTimeInterval)getEndTimeOfToday;
/**
 获取该天的起始秒（单位：秒(s)）
 
 @param theDate 该天的日期
 @return 该天的起始秒
 */
+ (NSTimeInterval)getStartTimeOfThisDay:(NSDate *)theDate;
/**
 获取该天的结束秒（单位：秒(s)）
 
 @param theDate 该天的日期
 @return 该天的结束秒
 */
+ (NSTimeInterval)getEndTimeOfThisDay:(NSDate *)theDate;
/**
 获取上个月的起始秒（单位：秒）
 
 @return 上个月的起始秒
 */
+ (NSTimeInterval)getStartTimeOfLastMonth;
/**
 获取上个月的结束秒（单位：秒）
 
 @return 上个月的结束秒
 */
+ (NSTimeInterval)getEndTimeOfLastMonth;
/**
 获取该月的起始秒 （单位：秒）
 
 @param date 日期（支持yyyy-MM yyyy-MM-dd等格式）
 @return 该月的起始秒
 */
+ (NSTimeInterval)getStartTimeOfTheMonth:(NSDate *)date;
/**
 该月的结束秒 （单位：秒）
 
 @param date 日期（支持yyyy-MM yyyy-MM-dd等格式）
 @return 该月的结束秒
 */
+ (NSTimeInterval)getEndTimeOfTheMonth:(NSDate*)date;
/**
 获取本月的起始秒（单位：秒）
 
 @return 本月的起始秒
 */
+ (NSTimeInterval)getStartTimeOfThisMonth;
/**
 获取本月的起始秒（单位：秒）
 
 @return 本月的起始秒
 */
+ (NSTimeInterval)getEndTimeOfThisMonth;
/**
 获取本季度的开始秒 （单位：秒）
 
 * @return: 本季的开始秒
 */
+ (NSTimeInterval)getStartTimeOfThisSeason;

/**
 获取本季度的结束秒 （单位：秒）
 
 * @return: 本季的结束秒
 */
+ (NSTimeInterval) getEndTimeOfThisSeason;
/**
 获取本年的起始秒
 
 @return 本年的起始秒
 */
+ (NSTimeInterval)getStartTimeOfThisYear;
/**
 获取本年的结束秒
 
 @return 本年的结束秒
 */
+ (NSTimeInterval)getEndTimeOfThisYear;
/**
 获取上年的起始秒
 
 @return 上年的起始秒
 */
+ (NSTimeInterval) getStartTimeOfLastYear;
/**
 获取上年的结束秒
 
 @return 上年的结束秒
 */
+ (NSTimeInterval) getEndTimeOfLastYear;
@end
