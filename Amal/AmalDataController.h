//
//  AmalDataController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/17/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Amal;
@class Score;
@class Done;

@interface AmalDataController : NSObject

@property (nonatomic, retain) NSMutableArray *masterAmalList;

// temp
@property (nonatomic, retain) NSMutableDictionary *dictAmalViewControllersList;
@property (nonatomic, retain) NSDate *currentVisibleDate;
@property (nonatomic, assign) BOOL isAmalSubViewControllerListDirty;
@property (nonatomic, assign) BOOL isAmalComingFromPopUpReminder;

// Settings
@property (nonatomic, assign) BOOL reminderEnable;
@property (nonatomic, retain) NSDate *reminderTime;
@property (nonatomic, assign) BOOL launchedFirstTime;

// return no of amal
-(unsigned)countOfList;

// return amal at index specified
-(Amal *)objectInListAtIndex:(unsigned)theIndex;

-(NSMutableArray *)getAmalListAtDate:(NSDate *)date;

-(NSInteger)getNumberOfAmalAtDate:(NSDate *)date;

-(NSInteger)calculateAllScores;

-(NSMutableArray *)getAmalViewControllerListAtDate:(NSDate *)date;

-(void)removeAmalAtDictSubViewControllerList:(NSInteger)index;

-(NSMutableArray *)viewControllersInListAtIndex:(unsigned)theIndex; // unfinish

// add amal into list, with specified arguments.
-(void)addAmalWithName:(NSString *)inputAmalName scale:(NSString *)inputScale frequency:(NSString *)inputFrequency scores:(Score *)inputScores imageUrl:(NSString *)inputImageUrl;

// remove amal at index
-(void)removeAmalAtIndex:(NSInteger)index;

// INITIALIZATION
-(void)initializeDefaultAmalList;
-(void)initAmalDataController;

// LOADING
-(void)initAmalListFromRawList:(NSMutableArray *)rawAmalList;
-(Amal *)createAmalFromRawAmal:(NSDictionary *)rawAmal;
-(Score *)createScoreFromRawScore:(NSDictionary *)rawScore;
-(NSMutableArray *)createDoneListFromRawList:(NSMutableArray *)rawDoneList;
-(Done *)createDoneFromRawDone:(NSDictionary *)rawDone;

// SAVING
-(NSMutableArray *)wrapAmalList:(NSMutableArray *)amalList;
-(NSMutableDictionary *)wrapAmal:(Amal *)amal;
-(NSMutableDictionary *)wrapScore:(Score *)score;
-(NSMutableArray *)wrapDoneList:(NSMutableArray *)doneList;
-(NSMutableDictionary *)wrapDone:(Done *)done;

// LOADING & SAVING into plist
-(void)loadDataController;
-(void)saveDataController;
-(void)loadSettings;
-(void)saveSettings;
@end
