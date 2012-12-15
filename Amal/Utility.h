//
//  Utility.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 2/13/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
-(NSDate *)getDateReset:(NSDate *)date;
-(NSDate *)getDayByOffset:(NSDate *)date offset:(int)offset;
-(NSInteger)getDayTimeIntervalBetweenDates:(NSDate *)dateFrom dateTo:(NSDate *)dateTo;
@end
