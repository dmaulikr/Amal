//
//  Amal.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/16/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "Amal.h"

#import "Utility.h"

@implementation Amal

@synthesize title = _title;
@synthesize scale = _scale;
@synthesize frequency = _frequency;
@synthesize scores = _scores;
@synthesize imageUrl = _imageUrl;
@synthesize dateCreated = _dateCreated;

-(id)initWithName:(NSString *)title scale:(NSString *)scale frequency:(NSString *)frequency scores:(Score *)scores imageUrl:(NSString *)imageUrl
{
    Utility *util = [[Utility alloc] init];
    
    self = [super init];
    if (self) {
        _title = title;
        _scale = scale;
        _frequency = frequency;
        _scores = scores;
        _imageUrl = imageUrl;
        _dateCreated = [util getDateReset:[NSDate date]];
        return self;
    }
    return nil;
}

-(void)tickAsDoneWithDate:(NSDate *)date
{
    //[self.scores tickAsDoneWithDate:date];
}

@end
