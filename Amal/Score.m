//
//  Score.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/27/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "Score.h"

#import "Amal.h"
#import "Done.h"
#import "Utility.h"

@implementation Score

@synthesize mark = _mark;
@synthesize dones = _dones;

//------------------------------------------------------------
-(id)initWithMark:(NSInteger)mark dones:(NSMutableArray *)dones
{
    self = [super init];
    if (self) {
        _mark = mark;
        _dones = dones;
        return self;
    }
    return nil;
}

//------------------------------------------------------------
-(void)addDoneWithDate:(NSDate *)inputDate did:(BOOL)inputDid
{
    Done *done;
    done = [[Done alloc] initWithDate:inputDate did:inputDid];
    [self.dones addObject:done];
    
    // DictDones is not used anymore
}

//------------------------------------------------------------
-(BOOL)tickAmalWithDate:(NSDate *)date did:(BOOL)did
{
    Done* done;
    if([self isDoneExistAtDate:date])
    {
        done = [self getDoneAtDate:date];
        done.did = did;
        return TRUE;
    }
    else
        return FALSE;
}

//------------------------------------------------------------
-(BOOL)isDoneExistAtDate:(NSDate *)date
{
    //NSLog(@"isDoneExistAtDate date: %@", [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    
    if ([self.dones count] == 0)
        return FALSE;
        
    Utility *util = [[Utility alloc] init];
    
    Done *firstDone = [self.dones objectAtIndex:0];
    NSDate *dateCreated = [util getDateReset:firstDone.date];
    NSDate *dateToday = [util getDateReset:[NSDate date]];
    
    //NSLog(@"isDoneExistAtDate dateCreated: %@", [NSDateFormatter localizedStringFromDate:dateCreated dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    //NSLog(@"isDoneExistAtDate dateToday: %@", [NSDateFormatter localizedStringFromDate:dateToday dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    
    NSTimeInterval timeIntervalSinceDateCreated, timeIntervalSinceDateToday;
    
    timeIntervalSinceDateCreated = ([date timeIntervalSinceDate:dateCreated] / 86400);
    timeIntervalSinceDateToday = ([date timeIntervalSinceDate:dateToday] / 86400);
    
    //NSLog(@"timeIntervalSinceDateCreated: %f", timeIntervalSinceDateCreated);
    //NSLog(@"timeIntervalSinceDateToday: %f", timeIntervalSinceDateToday);
    //NSLog(@"(NSInteger)timeIntervalSinceDateCreated: %f", round(timeIntervalSinceDateCreated));
    //NSLog(@"(NSInteger)timeIntervalSinceDateToday: %f", round(timeIntervalSinceDateToday));
    
    // If date is after date of amal created, and equal or less than today, then ok.
    if (round(timeIntervalSinceDateCreated) >= 0 && round(timeIntervalSinceDateToday) <= 0) 
        return TRUE;
    else 
        return FALSE;
}

//------------------------------------------------------------
-(Done *)getDoneAtDate:(NSDate *)date
{
    if (![self isDoneExistAtDate:date])
        return nil;
        
    Utility *util = [[Utility alloc] init];
    Done *firstDone = [self.dones objectAtIndex:0];
    NSDate *dateCreated = [util getDateReset:firstDone.date];
    
    //NSLog(@"date: %@", date);
    //NSLog(@"dateCreated: %@", dateCreated);
    
    date = [util getDateReset:date];
    
    //NSLog(@"date: %@", date);
    //NSLog(@"dateCreated: %@", dateCreated);
    
    NSTimeInterval timeIntervalSinceDateCreated;
    
    timeIntervalSinceDateCreated = ([date timeIntervalSinceDate:dateCreated] / 86400);
    //NSLog(@"timeIntervalSinceDateCreated: %d", (NSInteger)timeIntervalSinceDateCreated);
    //NSLog(@"self.dones count: %d", [self.dones count]);

    //NSLog(@"timeIntervalSinceDateCreated: %d", (NSInteger)timeIntervalSinceDateCreated);
        
    return [self.dones objectAtIndex:(NSInteger)timeIntervalSinceDateCreated];
}

//------------------------------------------------------------
-(void)calculateOverallTotalMark
{
    NSInteger numberOfDones = [self.dones count];
    NSPredicate *findTrueDones = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bind) {
        Done *done = (Done *)obj;
        return (done.did == TRUE);
    }];
    
    NSArray *trueDones = [self.dones filteredArrayUsingPredicate:findTrueDones];
    NSInteger numberOfTrueDones = [trueDones count];
    
    CGFloat floatNumberOfTrueDones = (CGFloat)numberOfTrueDones;
    CGFloat floatNumberOfDones = (CGFloat)numberOfDones;
    self.mark = floatNumberOfTrueDones / floatNumberOfDones * 100;
}

//------------------------------------------------------------
-(void)calculateCurrentMonthTotalMark
{
    Utility *util = [[Utility alloc] init];
    NSDate *dateToday = [util getDateReset:[NSDate date]];
    
    NSPredicate *findDonesInCurrentMonth = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bind) {
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
        Done *done = (Done *)obj;
        NSDate *dateCompared = done.date;
        NSDateComponents *comparedMonthYearComponents =
        [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:dateCompared];
        
        NSDateComponents *currentMonthYearComponents =
        [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:dateToday];
        
        BOOL isCurrentMonth = ([comparedMonthYearComponents month] == [currentMonthYearComponents month]);
        BOOL isCurrentYear = ([comparedMonthYearComponents year] == [currentMonthYearComponents year]);
        return (isCurrentMonth && isCurrentYear);
    }];
    
    NSArray *donesInCurrentMonth = [self.dones filteredArrayUsingPredicate:findDonesInCurrentMonth];
    NSInteger numberOfDonesInCurrentMonth = [donesInCurrentMonth count];
    
    NSPredicate *findTrueDones = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bind) {
        Done *done = (Done *)obj;
        return (done.did == TRUE);
    }];
    
    NSArray *trueDonesInCurrentMonth = [donesInCurrentMonth filteredArrayUsingPredicate:findTrueDones];
    NSInteger numberOfTrueDonesInCurrentMonth = [trueDonesInCurrentMonth count];

    ////NSLog(@"Number of dones in current month: %d", numberOfDonesInCurrentMonth);    
    ////NSLog(@"Number of      dones: %d", [self.dones count]);
    ////NSLog(@"Number of true dones: %d", [trueDonesInCurrentMonth count]);
    
    CGFloat floatNumberOfTrueDonesInCurrentMonth = (CGFloat)numberOfTrueDonesInCurrentMonth;
    CGFloat floatNumberOfDonesInCurrentMonth = (CGFloat)numberOfDonesInCurrentMonth;
    self.mark = floatNumberOfTrueDonesInCurrentMonth / floatNumberOfDonesInCurrentMonth * 100;
}

// UTILITY
//------------------------------------------------------------
-(NSDate *)formatDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    NSDate *dateFromString = [formatter dateFromString:stringFromDate];
    
    return dateFromString;
}

//------------------------------------------------------------
-(NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    return stringFromDate;
}

//------------------------------------------------------------
-(NSDate *)stringToDate:(NSString *)string;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [formatter dateFromString:string];
    
    return dateFromString;
}

@end
