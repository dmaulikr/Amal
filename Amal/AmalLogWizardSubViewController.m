//
//  AmalLogWizardSubViewController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 2/1/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "AmalLogWizardSubViewController.h"
#import "AmalDataController.h"
#import "Amal.h"
#import "Score.h"
#import "Done.h"
#import "ConversationLibrary.h"
#import "Utility.h"

#import <stdlib.h>

@interface AmalLogWizardSubViewController ()
-(void)printLogAmal:(Amal *)amal;
@end

@implementation AmalLogWizardSubViewController
@synthesize buttonDateNext = _buttonDateNext;
@synthesize buttonDatePrevious = _buttonDatePrevious;

@synthesize dataController = _dataController;

@synthesize amal = _amal;
@synthesize amalTitleLabel = _amalTitleLabel;
@synthesize amalDetailLabel = _amalDetailLabel;
@synthesize amalDateLabel = _amalDateLabel;
@synthesize randomYesLabel = _randomYesLabel;
@synthesize randomNoLabel = _randomNoLabel;
@synthesize conversationLibrary = _conversationLibrary;
@synthesize amalLogYesIndicator = _amalLogYesIndicator;
@synthesize amalLogNoIndicator = _amalLogNoIndicator;
@synthesize amalNumber = _amalNumber;

@synthesize delegate = _delegate;

//------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//------------------------------------------------------------
-(void)initConversationLibrary
{
    ConversationLibrary *library = [[ConversationLibrary alloc] init];
    self.conversationLibrary = library;
}

//------------------------------------------------------------
-(void)configureView
{
    Amal *theAmal = self.amal;
    
    if(theAmal)
    {
        //NSLog(@"AmalLWSubViewC amal title: %@", theAmal.title);
        //NSLog(@"AmalLWSubViewC currentvisibledate: %@", [NSDateFormatter localizedStringFromDate:self.dataController.currentVisibleDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
        // show previous and next date button only if amal exist on the prev/next date
        NSDate *nextDate = [self getDayByOffset:self.dataController.currentVisibleDate offset:+1];
        //NSLog(@"AmalLWSubViewC nextDate: %@", [NSDateFormatter localizedStringFromDate:nextDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
        //NSLog(@"AmalLWSubViewC getNumberOfAmalAtDate: %d", [self.dataController getNumberOfAmalAtDate:nextDate]);
        BOOL isAmalExistAtNextDate = ([self.dataController getNumberOfAmalAtDate:nextDate] > 0); 
        //NSLog(@"AmalLWSubViewC isAmalExistAtNextDate: %@", isAmalExistAtNextDate?@"TRUE":@"FALSE");
        self.buttonDateNext.hidden = !isAmalExistAtNextDate;
        
        NSDate *previousDate = [self getDayByOffset:self.dataController.currentVisibleDate offset:-1];
        BOOL isAmalExistAtPreviousDate = ([self.dataController getNumberOfAmalAtDate:previousDate] > 0); 
        self.buttonDatePrevious.hidden = !isAmalExistAtPreviousDate;
        
        // configure title, detail
        self.amalTitleLabel.text = theAmal.title;
        self.amalDetailLabel.text = [self concatenateScaleFrequency:theAmal.scale frequency:theAmal.frequency];
        
        // get the current date
        NSDate *date = self.dataController.currentVisibleDate;
        
        // format it
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateStyle:kCFDateFormatterMediumStyle];
        
        // convert it to a string
        NSString *dateString = [dateFormat stringFromDate:date];
        
        // if date is today, just put in "Today"
        Utility *util = [[Utility alloc] init];
        NSDate *dateToday = [util getDateReset:[NSDate date]];
        
        if((NSInteger)[date timeIntervalSinceDate:dateToday] == 0)
        {
            dateString = [NSString stringWithFormat:@"Today, %@", dateString]; 
        }
        
        self.amalDateLabel.text = dateString;
        
        BOOL isAmalDoneTrue = [self.amal.scores getDoneAtDate:self.dataController.currentVisibleDate].did;
        
        [self doToggleAmalLogYes:isAmalDoneTrue];
        [self doToggleAmalLogNo:!isAmalDoneTrue];
    }
    
    // Populate the text in random button
    NSNumber *randomNumber = [NSNumber numberWithInt:arc4random() % self.conversationLibrary.conversationYes.count];
    
    NSString *randomYes = [self.conversationLibrary.conversationYes objectForKey:randomNumber];
    self.randomYesLabel.text = randomYes;
    
    NSString *randomNo = [self.conversationLibrary.conversationNo objectForKey:randomNumber];
    self.randomNoLabel.text = randomNo;
}

//------------------------------------------------------------
-(void)setAmal:(Amal *)amal
{
    if(_amal != amal)
    {
        _amal = amal;
    }
    
    [self initConversationLibrary];
    [self configureView];
}

//------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.amalNumberLabel.text = [NSString stringWithFormat:@"%d",  arc4random_uniform(10)];
}

//------------------------------------------------------------
- (void)viewDidUnload
{
    [self setAmalTitleLabel:nil];
    [self setAmalDetailLabel:nil];
    [self setRandomYesLabel:nil];
    [self setRandomNoLabel:nil];
    [self setAmalDateLabel:nil];
    [self setAmalLogYesIndicator:nil];
    [self setAmalLogNoIndicator:nil];
    [self setButtonDateNext:nil];
    [self setButtonDatePrevious:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
//------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//------------------------------------------------------------
- (IBAction)nextPageYes:(id)sender 
{
    [self doToggleAmalLogYes:YES];
    [self.amal.scores tickAmalWithDate:self.dataController.currentVisibleDate did:TRUE];

    [[self delegate] amalLogWizardSubViewControllerNextPageYes:self];
}

//------------------------------------------------------------
- (IBAction)nextPageNo:(id)sender 
{
    [self doToggleAmalLogNo:YES];
    [self.amal.scores tickAmalWithDate:self.dataController.currentVisibleDate did:FALSE];
        
    [[self delegate] amalLogWizardSubViewControllerNextPageNo:self];
}

//------------------------------------------------------------
- (IBAction)buttonDateNext:(id)sender 
{
    [[self delegate] amalLogWizardSubViewControllerButtonDateNext:self currentDate:self.dataController.currentVisibleDate];
    
    [self initConversationLibrary];
    [self configureView];
}

//------------------------------------------------------------
- (IBAction)buttonDatePrevious:(id)sender 
{
    [[self delegate] amalLogWizardSubViewControllerButtonDatePrevious:self currentDate:self.dataController.currentVisibleDate];
    
    [self initConversationLibrary];
    [self configureView];
}

//------------------------------------------------------------
-(void)doToggleAmalLogYes:(BOOL)boolean
{
    Score* scoreSystem = self.amal.scores;
    NSDate *currentVisibleDate = self.dataController.currentVisibleDate;
    
    if(boolean)
    {
        [scoreSystem tickAmalWithDate:currentVisibleDate did:TRUE];
        self.amalLogYesIndicator.backgroundColor = [[UIColor alloc] initWithRed:0.6 green:0.8 blue:0.5 alpha:1.0];
        self.amalLogNoIndicator.backgroundColor = [[UIColor alloc] initWithRed:0.67 green:0.67 blue:0.67 alpha:1.0];
    }
    else
        self.amalLogYesIndicator.backgroundColor = [[UIColor alloc] initWithRed:0.67 green:0.67 blue:0.67 alpha:1.0];
}

//------------------------------------------------------------
-(void)doToggleAmalLogNo:(BOOL)boolean
{
    Score* scoreSystem = self.amal.scores;
    NSDate *currentVisibleDate = self.dataController.currentVisibleDate;
    
    if(boolean)
    {
        [scoreSystem tickAmalWithDate:currentVisibleDate did:FALSE];
        self.amalLogNoIndicator.backgroundColor = [[UIColor alloc] initWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
        self.amalLogYesIndicator.backgroundColor = [[UIColor alloc] initWithRed:0.67 green:0.67 blue:0.67 alpha:1.0];
    }
    else
        self.amalLogNoIndicator.backgroundColor = [[UIColor alloc] initWithRed:0.67 green:0.67 blue:0.67 alpha:1.0];
}

#pragma mark - UTILITY

// UTILITY
//------------------------------------------------------------
-(NSString *)concatenateScaleFrequency:(NSString *)scale frequency:(NSString *)frequency
{
    // If scale is nonexistent, remove single space
    if ([scale length] != 0)
        return [NSString stringWithFormat:@"%@ %@", scale, frequency];
    else
        return frequency;
}

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

//------------------------------------------------------------
-(void)printLogAmal:(Amal *)amal
{
    NSLog(@"Amal Title: %@", amal.title);
    Done *thisDone = [amal.scores.dones objectAtIndex:0];
    NSString * boolString = thisDone.did ? @"TRUE" : @"FALSE";
    NSLog(@"Did: %@", boolString);
    NSLog(@"Date: %@", [self dateToString:thisDone.date]);
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
