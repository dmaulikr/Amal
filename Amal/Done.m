//
//  Done.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/27/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "Done.h"

#import "Utility.h"

@interface Done ()
-(NSDate *)formatDate:(NSDate *)date;
@end

@implementation Done

@synthesize did = _did;
@synthesize date = _date;

-(id)initWithDate:(NSDate *)date did:(BOOL)did
{
    Utility *util = [[Utility alloc] init];
    date = [util getDateReset:date];
    self = [super init];
    if (self) {
        _did = did;
        _date = date;
        return self;
    }
    return nil;
}

-(NSDate *)formatDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    NSDate *dateFromString = [formatter dateFromString:stringFromDate];
    
    return dateFromString;
}

@end
