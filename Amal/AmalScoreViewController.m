//
//  SecondViewController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/5/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//

#import "AmalScoreViewController.h"
#import "AmalDataController.h"
#import "Amal.h"
#import "Score.h"
#import "Done.h"
#import "Utility.h"

@interface AmalScoreViewController ()
-(void)configureView;
// UTILITY
-(NSString *)concatenateScaleFrequency:(NSString *)scale frequency:(NSString *)frequency;
-(NSString *)dateToString:(NSDate *)date;
-(void)printLogAmal:(Amal *)amal;
-(void)printLogAmal:(Amal *)amal doneIndex:(int)doneIndex;
-(void)addDummyAmal;
-(NSDate *)getDayByOffset:(NSDate *)date offset:(int)offset;
@end

@implementation AmalScoreViewController
@synthesize dataController = _dataController;
@synthesize tableView = _tableView;
@synthesize amalOverallScoreLabel = _amalOverallScoreLabel;

//------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    //[self printLogAmal:firstAmal];
    //[self printLogAmal:secondAmal];
    [self configureView];
}

//------------------------------------------------------------
-(void)configureView
{
    self.amalOverallScoreLabel.text = [NSString stringWithFormat:@"%d", 0];
    [self calculateAllScores];
    [self.tableView reloadData];
}

//------------------------------------------------------------
- (void)viewDidUnload
{
    [self setAmalOverallScoreLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    if([self isViewLoaded])
    {
        [self configureView];           
    }

    [super viewWillAppear:animated];
}

//------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

//------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

//------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View Data source delegate

//------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataController countOfList];
}

//------------------------------------------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [self.dataController objectInListAtIndex:indexPath.row].title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[self.dataController objectInListAtIndex:indexPath.row].scores.mark];
    NSLog(@"amal score: %d", [self.dataController objectInListAtIndex:indexPath.row].scores.mark);
    
    return cell;
}

#pragma mark - Calculation

//------------------------------------------------------------
-(void)calculateAllScores
{
    if ([self.dataController countOfList] == 0)
        return;
    
    Amal *amal;
    NSInteger overallMark = 0;
    
    for (int i = 0; i < [self.dataController countOfList]; i++) 
    {
        amal = [self.dataController objectInListAtIndex:i];
        
        //[amal.scores calculateCurrentMonthTotalMark];
        [amal.scores calculateOverallTotalMark];
        overallMark = overallMark + amal.scores.mark;
    }
    
    overallMark = overallMark / [self.dataController countOfList];

    self.amalOverallScoreLabel.text = [NSString stringWithFormat:@"%d", overallMark];
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
-(NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    return stringFromDate;
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
-(void)printLogAmal:(Amal *)amal doneIndex:(int)doneIndex
{
    NSLog(@"Amal Title: %@", amal.title);
    Done *thisDone = [amal.scores.dones objectAtIndex:doneIndex];
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

#pragma mark - TEST

// TEST
//------------------------------------------------------------
-(void)addDummyAmal
{
    Utility *util = [[Utility alloc] init];
    NSDate *dateToday = [util getDateReset:[NSDate date]];
    
    NSDate *yesterday = [self getDayByOffset:dateToday offset:-1];
    NSDate *twoDaysBack = [self getDayByOffset:dateToday offset:-2];
    NSDate *threeDaysBack = [self getDayByOffset:dateToday offset:-3];

    Amal* firstAmal = [self.dataController objectInListAtIndex:0];
    [firstAmal.scores addDoneWithDate:yesterday did:TRUE];
    [firstAmal.scores addDoneWithDate:twoDaysBack did:TRUE];
    [firstAmal.scores addDoneWithDate:threeDaysBack did:FALSE];
}

@end
