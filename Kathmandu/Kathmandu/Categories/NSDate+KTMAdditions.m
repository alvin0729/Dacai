//
//  NSDate+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSDate+KTMAdditions.h"

// EEEE - weekday
const NSString *dp_DateFormatter_yyyy_MM_dd_HH_mm_ss = @"yyyy-MM-dd HH:mm:ss";
const NSString *dp_DateFormatter_yyyy_MM_dd_HH_mm = @"yyyy-MM-dd HH:mm";
const NSString *dp_DateFormatter_yyyy_MM_dd = @"yyyy-MM-dd";
const NSString *dp_DateFormatter_MM_dd_HH_mm = @"MM-dd HH:mm";
const NSString *dp_DateFormatter_MM_dd = @"MM-dd";
const NSString *dp_DateFormatter_HH_mm = @"HH:mm";

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@implementation NSDate (KTMAdditions)

+ (NSDate *)dp_dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}

+ (NSString *)dp_coverDateString:(NSString *)string fromFormat:(NSString *)srcFormat toFormat:(NSString *)destFormat {
    return [[NSDate dp_dateFromString:string withFormat:srcFormat] dp_stringWithFormat:destFormat];
}

- (NSString *)dp_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (int)dp_nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate * newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents * components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return (int)components.hour;
}

- (int)dp_hour
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return (int)components.hour;
}

- (int)dp_minute
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return (int)components.minute;
}

- (int)dp_seconds
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return (int)components.second;
}

- (int)dp_day
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return (int)components.day;
}

- (int)dp_month
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return (int)components.month;
}

- (int)dp_week
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return (int)components.weekOfMonth;
}

- (int)dp_weekday
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return (int)components.weekday;
}

- (NSString *)dp_weekdayName {
    static NSString *names[] = {@"", @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"};
    return names[self.dp_weekday];
}
- (NSString *)dp_weekdayNameSimple {
    static NSString *names[] = {@"", @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"};
    return names[self.dp_weekday];
}

- (int)dp_nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return (int)components.weekdayOrdinal;
}

- (int)dp_year
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return (int)components.year;
}

+ (NSString *)humanableInfoFromDate: (NSDate *) theDate {
    NSString *info;
    
    NSTimeInterval deltas = - [theDate timeIntervalSinceNow];
    NSNumber *deltaNum = [NSNumber numberWithDouble:deltas];
    int delta = [deltaNum intValue];
    if (delta < 60) {
        // 1分钟之内
        info = @"Just now";
    } else {
        delta = delta / 60;
        if (delta < 60) {
            // n分钟前
            info = [NSString stringWithFormat:@"%d分钟之前", delta];
        } else {
            delta = delta / 60;
            if (delta < 24) {
                // n小时前
                info = [NSString stringWithFormat:@"%d分钟之前",delta];
            } else {
                delta = delta / 24;
                if ((NSInteger)delta == 1) {
                    //昨天
                    info = @"昨天";
                } else if ((NSInteger)delta == 2) {
                    info = @"前天";
                } else {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
                    info = [dateFormatter stringFromDate:theDate];
                    //                    info = [NSString stringWithFormat:@"%d天前", (NSUInteger)delta];
                }
            }
        }
    }
    return info;
}
@end
