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

@end
