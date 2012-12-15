//
//  Amal.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/16/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Score;

@interface Amal : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *frequency;
@property (nonatomic, copy) Score *scores;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, weak) NSDate* dateCreated;

// this will init an amal with dateCreated set as today set to midnite before
-(id)initWithName:(NSString *)title scale:(NSString *)scale frequency:(NSString *)frequency scores:(Score *)scores imageUrl:(NSString *)imageUrl;
-(void)tickAsDoneWithDate:(NSDate *)date;

@end
