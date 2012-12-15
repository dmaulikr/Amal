//
//  Done.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/27/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Done : NSObject

@property (nonatomic, assign) BOOL did;
@property (nonatomic, copy) NSDate *date;

-(id)initWithDate:(NSDate *)date did:(BOOL)did;

@end
