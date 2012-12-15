//
//  Utility.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 2/13/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "Utility.h"

@implementation Utility

//------------------------------------------------------------
-(NSDate *)getDateReset:(NSDate *)date
{
    NSDate *dateOffset = date;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    dateOffset = [cal dateByAddingComponents:components toDate:dateOffset options:0];
    
    return dateOffset;
}

//------------------------------------------------------------
-(NSDate *)getDayByOffset:(NSDate *)date offset:(int)offset
{
    NSDate *dateOffset = date;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:24*offset];
    [components setMinute:0];
    [components setSecond:0];
    dateOffset = [cal dateByAddingComponents:components toDate:dateOffset options:0];
    
    return dateOffset;
}

//------------------------------------------------------------
-(NSInteger)getDayTimeIntervalBetweenDates:(NSDate *)dateFrom dateTo:(NSDate *)dateTo
{
    dateFrom = [self getDateReset:dateFrom];
    dateTo = [self getDateReset:dateTo];
    
    NSTimeInterval timeIntervalSinceDateFrom;
    
    timeIntervalSinceDateFrom = ([dateTo timeIntervalSinceDate:dateFrom] / 86400);
    
    return (NSInteger)timeIntervalSinceDateFrom;
}

@end
