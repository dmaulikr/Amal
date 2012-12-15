//
//  AmalDataController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/17/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "AmalDataController.h"
#import "Amal.h"
#import "Score.h"
#import "Done.h"
#import "Utility.h"

@interface AmalDataController ()
-(NSDate *)formatDate:(NSDate *)date;
-(NSString *)dateToString:(NSDate *)date;
-(NSDate *)stringToDate:(NSString *)string;
-(NSDate *)getDayByOffset:(NSDate *)date offset:(int)offset;
@end

@implementation AmalDataController

@synthesize masterAmalList = _masterAmalList;
@synthesize dictAmalViewControllersList = _dictAmalViewControllersList;
@synthesize currentVisibleDate = _currentVisibleDate;
@synthesize isAmalSubViewControllerListDirty = _isAmalSubViewControllerListDirty;
@synthesize isAmalComingFromPopUpReminder = _isAmalComingFromPopUpReminder;
@synthesize reminderEnable = _reminderEnable;
@synthesize reminderTime = _reminderTime;
@synthesize launchedFirstTime = _launchedFirstTime;

#pragma mark - INITIALIZATION

// INITIALIZATION
//------------------------------------------------------------
-(id)init 
{
    if (self = [super init])
    {
        //[self initializeDefaultAmalList];
        [self initAmalDataController];
        return self;
    }
    return nil;
}

//------------------------------------------------------------
-(void)initializeDefaultAmalList
{
    Utility *util = [[Utility alloc] init];
    
    NSMutableArray *amalList = [[NSMutableArray alloc] init];
    self.masterAmalList = amalList;
    
    NSMutableDictionary *dictList = [[NSMutableDictionary alloc] init];
    self.dictAmalViewControllersList = dictList;
    
    NSDate *date = [util getDateReset:[NSDate date]];
    self.currentVisibleDate = date;
    //NSLog(@"Initializing currentvisibledate: %@", [self dateToString:self.currentVisibleDate]);

    // Image
    UIImage *quran = [UIImage imageNamed:@"amalquran.png"];
	UIImage *mathurat = [UIImage imageNamed:@"amalmathurat.png"];
	//UIImage *dhuha = [UIImage imageNamed:@"amaldhuha.png"];
    
    // Date, Done, Score
    NSDate *dateToday = [util getDateReset:[NSDate date]];
    NSDate *dateToday2 = [util getDateReset:[NSDate date]];
    //NSDate *dateToday3 = [[NSDate alloc] init];

    Done *done = [[Done alloc] initWithDate:dateToday did:FALSE];
    Done *done2 = [[Done alloc] initWithDate:dateToday did:FALSE];
    //Done *done3 = [[Done alloc] initWithDate:dateToday did:FALSE];

    NSMutableArray* dones = [[NSMutableArray alloc] init];
    NSMutableArray* dones2 = [[NSMutableArray alloc] init];
    //NSMutableArray* dones3 = [[NSMutableArray alloc] init];

    NSNumber *currentIndex = [NSNumber numberWithInt:[dones count]];
    [dones addObject:done];
    NSNumber *currentIndex2 = [NSNumber numberWithInt:[dones2 count]];
    [dones2 addObject:done2];
    //NSNumber *currentIndex3 = [NSNumber numberWithInt:[dones3 count]];
    //[dones3 addObject:done3];
    
    NSMutableDictionary* dictDones = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* dictDones2 = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary* dictDones3 = [[NSMutableDictionary alloc] init];

    [dictDones setObject:currentIndex forKey:[self dateToString:dateToday]];
    [dictDones2 setObject:currentIndex2 forKey:[self dateToString:dateToday2]];
    //[dictDones3 setObject:currentIndex3 forKey:[self dateToString:dateToday3]];

    Score *scores = [[Score alloc] initWithMark:0 dones:dones];
    Score *scores2 = [[Score alloc] initWithMark:0 dones:dones2];
    //Score *scores3 = [[Score alloc] initWithMark:0 dones:dones3];
    
    [self addAmalWithName:@"Baca Quran" scale:@"10 muka" frequency:@"Daily" scores:scores imageUrl:@"amalquran.png"];
    [self addAmalWithName:@"Baca Mathurat" scale:@"" frequency:@"Twice a day" scores:scores2 imageUrl:@"amalmathurat.png"];
    //[self addAmalWithName:@"Solat Dhuha" scale:@"" frequency:@"Daily" score:0 scores:scores3 image:dhuha];
}

//------------------------------------------------------------
-(void)initAmalDataController
{
    Utility *util = [[Utility alloc] init];
    
    NSMutableArray *amalList = [[NSMutableArray alloc] init];
    self.masterAmalList = amalList;
    
    NSMutableDictionary *dictList = [[NSMutableDictionary alloc] init];
    self.dictAmalViewControllersList = dictList;
    
    //NSLog(@"date today: %@", [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    NSDate *date = [util getDateReset:[NSDate date]];
    
    self.currentVisibleDate = date;
    //NSLog(@"date after: %@", [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    //NSLog(@"self.currentVisibleDate: %@", [NSDateFormatter localizedStringFromDate:self.currentVisibleDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    //NSLog(@"self.currentVisibleDate: %@", self.currentVisibleDate);
}

#pragma mark - LOADING

// LOADING
//------------------------------------------------------------
-(void)initAmalListFromRawList:(NSMutableArray *)rawAmalList
{
    // LOOP TO CREATE AMAL
    // for each amal, create the amal and its content
    Amal *amal;
    for (int i = 0; i < [rawAmalList count]; i++) 
    {
        // create amal
        amal = [self createAmalFromRawAmal:[rawAmalList objectAtIndex:i]];
        [self.masterAmalList addObject:amal];
    }    
}

//------------------------------------------------------------
-(Amal *)createAmalFromRawAmal:(NSMutableDictionary *)rawAmal
{
    NSString *amalTitle = [rawAmal objectForKey:@"AmalTitle"];
    NSString *amalScale = [rawAmal objectForKey:@"AmalScale"];
    NSString *amalFrequency = [rawAmal objectForKey:@"AmalFrequency"];
    NSString *amalImageUrl = [rawAmal objectForKey:@"AmalImageUrl"];
        
    Score* amalScore = [self createScoreFromRawScore:[rawAmal objectForKey:@"AmalScore"]];
    
    Amal *amal;
    amal = [[Amal alloc] initWithName:amalTitle scale:amalScale frequency:amalFrequency scores:amalScore imageUrl:amalImageUrl];
    
    return amal;
}

//------------------------------------------------------------
-(Score *)createScoreFromRawScore:(NSMutableDictionary *)rawScore
{
    NSNumber *scoreMark = [rawScore objectForKey:@"ScoreMark"];
    NSMutableArray *scoreDoneList = [self createDoneListFromRawList:[rawScore objectForKey:@"ScoreDoneList"]];
    
    Score* score = [[Score alloc] initWithMark:[scoreMark integerValue] dones:scoreDoneList];
    
    return score;
}

//------------------------------------------------------------
-(NSMutableArray *)createDoneListFromRawList:(NSMutableArray *)rawDoneList
{
    Done* done;
    NSMutableArray *doneList = [[NSMutableArray alloc] init];
    
    // Load existing dones
    for (int i = 0; i < [rawDoneList count]; i++) 
    {
        done = [self createDoneFromRawDone:[rawDoneList objectAtIndex:i]];
        [doneList addObject:done];
    }
    
    //NSLog(@"doneList count: %d", [doneList count]);
    // Check the time interval between the date of last dones' created and today,
    Utility *util = [[Utility alloc] init];
    
    Done *lastDone = [doneList objectAtIndex:[doneList count]-1];
    NSDate *dateLastDone = [util getDateReset:lastDone.date];
    NSDate *dateToday = [util getDateReset:[NSDate date]];
    
    //NSLog(@"createDoneListFromRawList dateLastDone: %@", [NSDateFormatter localizedStringFromDate:dateLastDone dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    //NSLog(@"createDoneListFromRawList dateToday: %@", [NSDateFormatter localizedStringFromDate:dateToday dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    
    NSInteger numberOfDonesToCreate = [util getDayTimeIntervalBetweenDates:dateLastDone dateTo:dateToday];
    //NSLog(@"numberOfDonesToCreate: %d", numberOfDonesToCreate);
    
    // add the default dones until today
    NSDate *dateForDone;
    for (int i = 0; i < numberOfDonesToCreate; i++) 
    {
        dateForDone = [util getDayByOffset:lastDone.date offset:i+1];
        //NSLog(@"createDoneListFromRawList dateForDone: %@", [NSDateFormatter localizedStringFromDate:dateForDone dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
        
        done = [[Done alloc] initWithDate:dateForDone did:FALSE];
        [doneList addObject:done];
    }
    //NSLog(@"doneList count: %d", [doneList count]);

    return doneList;
}

//------------------------------------------------------------
-(Done *)createDoneFromRawDone:(NSMutableDictionary *)rawDone
{
    Utility *util = [[Utility alloc] init];
    
    BOOL did = [[rawDone objectForKey:@"DoneDid"] boolValue];
    NSDate *date = [util getDateReset:[NSDate date]];
    date = [rawDone objectForKey:@"DoneDate"];
    
    Done* done = [[Done alloc] initWithDate:date did:did];
    
    return done;
}

#pragma mark - SAVING

// SAVING
//------------------------------------------------------------
-(NSMutableArray *)wrapAmalList:(NSMutableArray *)amalList
{
    // LOOP TO WRAP AMAL
    // for each amal, wrap the amal and its content
    NSMutableArray *wrappedAmalList = [[NSMutableArray alloc] init];
    NSMutableDictionary *wrappedAmal;
    
    for (int i = 0; i < [amalList count]; i++) 
    {
        // wrap amal
        wrappedAmal = [self wrapAmal:[amalList objectAtIndex:i]];
        [wrappedAmalList addObject:wrappedAmal];
    }
    
    return wrappedAmalList;
}

//------------------------------------------------------------
-(NSMutableDictionary *)wrapAmal:(Amal *)amal
{
    NSMutableDictionary *wrappedAmal = [[NSMutableDictionary alloc] init];
    
    [wrappedAmal setObject:amal.title forKey:@"AmalTitle"];
    [wrappedAmal setObject:amal.scale forKey:@"AmalScale"];
    [wrappedAmal setObject:amal.frequency forKey:@"AmalFrequency"];
    [wrappedAmal setObject:amal.imageUrl forKey:@"AmalImageUrl"];
    
    NSMutableDictionary* wrappedScore = [self wrapScore:amal.scores];
    [wrappedAmal setObject:wrappedScore forKey:@"AmalScore"];
    
    return wrappedAmal;
}

//------------------------------------------------------------
-(NSMutableDictionary *)wrapScore:(Score *)score
{
    NSMutableDictionary *wrappedScore = [[NSMutableDictionary alloc] init];
    
    NSNumber *scoreMark = [NSNumber numberWithInteger:score.mark];
    [wrappedScore setObject:scoreMark forKey:@"ScoreMark"];
    
    NSMutableArray *wrappedDoneList = [self wrapDoneList:score.dones];
    [wrappedScore setObject:wrappedDoneList forKey:@"ScoreDoneList"];
        
    return wrappedScore;
}

//------------------------------------------------------------
-(NSMutableArray *)wrapDoneList:(NSMutableArray *)doneList
{
    NSMutableDictionary *wrappedDone = [[NSMutableDictionary alloc] init];
    NSMutableArray *wrappedDoneList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [doneList count]; i++) 
    {
        wrappedDone = [self wrapDone:[doneList objectAtIndex:i]];
        [wrappedDoneList addObject:wrappedDone];
    }
    
    return wrappedDoneList;
}

//------------------------------------------------------------
-(NSMutableDictionary *)wrapDone:(Done *)done
{
    NSMutableDictionary *wrappedDone = [[NSMutableDictionary alloc] init];
    
    NSNumber *wrappedDid = [NSNumber numberWithBool:done.did];
    [wrappedDone setObject:wrappedDid forKey:@"DoneDid"];
    [wrappedDone setObject:done.date forKey:@"DoneDate"];
        
    return wrappedDone;
}

#pragma mark - OPERATIONS

// OPERATIONS
//------------------------------------------------------------
-(void)setMasterAmalList:(NSMutableArray *)newList
{
    if (_masterAmalList != newList)
    {
        _masterAmalList = [newList mutableCopy];
    }
}

//------------------------------------------------------------
-(unsigned)countOfList
{
    return [self.masterAmalList count];
}

//------------------------------------------------------------
-(Amal *)objectInListAtIndex:(unsigned)theIndex
{
    return [self.masterAmalList objectAtIndex:theIndex];
}

//------------------------------------------------------------
-(NSMutableArray *)viewControllersInListAtIndex:(unsigned)theIndex
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    return array;
}

//------------------------------------------------------------
-(void)removeAmalAtIndex:(NSInteger)index
{
    [self.masterAmalList removeObjectAtIndex:index];
}

//------------------------------------------------------------
-(NSMutableArray *)getAmalViewControllerListAtDate:(NSDate *)date
{
    //NSLog(@"getAmalViewControllerListAtDate date: %@", [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    
    NSString *dateString = [self dateToString:date];
    
    NSMutableArray *amalViewControllersAtDate = [self.dictAmalViewControllersList objectForKey:dateString];
    
    return amalViewControllersAtDate;
}

//------------------------------------------------------------
-(void)removeAmalAtDictSubViewControllerList:(NSInteger)index
{
    NSMutableArray *amalDones = [self objectInListAtIndex:index].scores.dones;
    NSInteger numberOfAmalDones = [amalDones count];
    
    Done *done;
    NSDate *date;
    
    NSMutableArray *subViewControllerList;
    
    for (int i = 0; i < numberOfAmalDones; i++) 
    {
        done = [amalDones objectAtIndex:i];
        date = done.date;
        subViewControllerList = [self getAmalViewControllerListAtDate:date];
        
        // this should not crash, because this function is only called when everything is updated/not dirty
        [subViewControllerList removeObjectAtIndex:index];
        
        if ([subViewControllerList count] == 0)
        {
            NSString *dateString = [self dateToString:date];
            [self.dictAmalViewControllersList removeObjectForKey:dateString];
        }
    }
}

//------------------------------------------------------------
-(void)addAmalWithName:(NSString *)inputAmalName scale:(NSString *)inputScale frequency:(NSString *)inputFrequency scores:(Score *)inputScores imageUrl:(NSString *)inputImageUrl
{
    Amal *amal;
    amal = [[Amal alloc] initWithName:inputAmalName scale:inputScale frequency:inputFrequency scores:inputScores imageUrl:inputImageUrl];
    [self.masterAmalList addObject:amal];
}

//------------------------------------------------------------
-(NSMutableArray *)getAmalListAtDate:(NSDate *)date
{
    //NSLog(@"Date when getAmalListAtDate: %@", [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    NSMutableArray *amalListAtDate = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self countOfList]; i++)
    {
        Amal *thisAmal = [self objectInListAtIndex:i];
        BOOL isAmalExistAtDate = [thisAmal.scores isDoneExistAtDate:date];
        if (isAmalExistAtDate) 
        {
            [amalListAtDate addObject:thisAmal];
        }
    }
    
    return amalListAtDate;
}

//------------------------------------------------------------
-(NSInteger)getNumberOfAmalAtDate:(NSDate *)date
{
    NSInteger numberOfAmalAtDate = [[self getAmalListAtDate:date] count];
    //NSLog(@"numberOfAmalAtDate: %d", numberOfAmalAtDate);
    return numberOfAmalAtDate;
}

//------------------------------------------------------------
-(NSInteger)calculateAllScores
{
    if ([self countOfList] == 0)
        return -1;
    
    Amal *amal;
    NSInteger overallMark = 0;
    
    for (int i = 0; i < [self countOfList]; i++) 
    {
        amal = [self objectInListAtIndex:i];
        
        //[amal.scores calculateCurrentMonthTotalMark];
        [amal.scores calculateOverallTotalMark];
        overallMark = overallMark + amal.scores.mark;
    }
    
    overallMark = overallMark / [self countOfList];
    
    return overallMark;
}

#pragma mark - LOADING & SAVING

// LOADING & SAVING into plist
//------------------------------------------------------------
-(void)loadDataController
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    //NSLog(@"documentsPath: %@", documentsPath);
    // get the path to our plist
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"AmalData.plist"];
    //NSLog(@"plistPath: %@", plistPath);
    
    // check to see if data plist exist in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
    {
        // if not in documents, get it from the bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"AmalData" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML 
                                                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                                                    format:&format 
                                                                          errorDescription:&errorDesc];
    if (!temp)
    {
        //NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    // assign values
    NSMutableArray *rawAmalList = [NSMutableArray arrayWithArray:[temp objectForKey:@"AmalList"]];
    // display values
    //NSLog(@"AmalList count: %d", [rawAmalList count]);
    ////NSLog(@"Title of 1st AmalList: %@", [rawAmalList objectAc tIndex:0].title);

    
    if ([rawAmalList count] == 0) 
    {
        //NSLog(@"Loaded data is empty");
        return;
    }
    
    [self initAmalListFromRawList:rawAmalList];
}

//------------------------------------------------------------
-(void)saveDataController
{
    // get paths from root directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our plist
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"AmalData.plist"];
    
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithObject:[self wrapAmalList:self.masterAmalList] forKey:@"AmalList"];
    
    NSString *error = nil;
    // create NSData(plistData) from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check if plist data exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        //NSLog(@"Error in saveData: %@", error);
    }
}

//------------------------------------------------------------
-(void)loadSettings
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    //NSLog(@"documentsPath: %@", documentsPath);
    // get the path to our plist
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Settings.plist"];
    //NSLog(@"plistPath: %@", plistPath);
    
    // check to see if data plist exist in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
    {
        // if not in documents, get it from the bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML 
                                                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                                                    format:&format 
                                                                          errorDescription:&errorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    // assign values
    self.reminderEnable = [[temp objectForKey:@"ReminderEnable"] boolValue];
    self.reminderTime = [temp objectForKey:@"ReminderTime"];
    self.launchedFirstTime = [[temp objectForKey:@"LaunchedFirstTime"] boolValue];
}

//------------------------------------------------------------
-(void)saveSettings
{
    // get paths from root directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our plist
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Settings.plist"];
    
    NSNumber *reminderEnable = [NSNumber numberWithBool:self.reminderEnable];    
    NSNumber *launchedFirstTime = [NSNumber numberWithBool:self.launchedFirstTime];    
    
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      reminderEnable, @"ReminderEnable",
                                      self.reminderTime, @"ReminderTime",
                                      launchedFirstTime, @"LaunchedFirstTime",
                                      nil];
    
    NSString *error = nil;
    // create NSData(plistData) from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check if plist data exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
    }
}

#pragma mark - UTILITY

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
-(NSDate *)stringToDate:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [formatter dateFromString:string];
    
    return dateFromString;
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

@end
