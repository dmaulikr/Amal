//
//  Score.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/27/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Done;
@class Amal;

@interface Score : NSObject

@property (nonatomic, assign) NSInteger mark;
@property (nonatomic, copy) NSMutableArray *dones; // Done.h
// DictDones is not used anymore - replace by amal.dateCreated

-(id)initWithMark:(NSInteger)mark dones:(NSMutableArray *)dones;
// Every time we call addDoneWithDate, it will create:
// 1. a Done object for this amal, inserted into an NSMutableArray
// [===========] [===========] 
// [=  YES/NO =] [=  YES/NO =]
// [=  Date   =] [=  Date   =]
// [===========] [===========]
//     index         index
//
// 2. No more DictDones
//
// One way of getting number of done in a specific month (super slow):
// 1. extract all key string
// 2. format it in yyyy-MM
// 3. compare with the specific month
// 4. if true, increase count.
//
// Faster way:
// - use NSPredicate
-(void)addDoneWithDate:(NSDate *)date did:(BOOL)did;

// modify amal at specified date
-(BOOL)tickAmalWithDate:(NSDate *)date did:(BOOL)did;

-(BOOL)isDoneExistAtDate:(NSDate *)date;

// if it doesnt exist, return nil
-(Done *)getDoneAtDate:(NSDate *)date;

// Get Overall total mark
//
// Formula:
// Total Mark = No of True Dones / No of all Dones x 100 
-(void)calculateOverallTotalMark;

// Get Current Month total mark
//
// Formula:
// Total Mark = No of True Dones in Current Month / no of current month Dones x 100
-(void)calculateCurrentMonthTotalMark;

// UTILITY
// format date to yyy-MM-dd
-(NSDate *)formatDate:(NSDate *)date;

// convert date to string with desired format
-(NSString *)dateToString:(NSDate *)date;

// convert string to date with desired format
-(NSDate *)stringToDate:(NSString *)string;

@end
