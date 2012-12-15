//
//  AmalLogWizardViewController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/5/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//

#import "AmalLogWizardViewController.h"
#import "AmalLogWizardSubViewController.h"
#import "AmalDataController.h"
#import "AmalScoreViewController.h"
#import "Amal.h"
#import "Score.h"
#import "Done.h"
#import "Utility.h"

#define NUMBER_OF_AMAL 3
#define AMALSCORE_TAB 1

@interface AmalLogWizardViewController () <AmalLogWizardSubViewControllerDelegate>
-(void)printLogAmal:(Amal *)amal;
-(NSDate *)formatDate:(NSDate *)date;
-(NSString *)dateToString:(NSDate *)date;
-(NSDate *)stringToDate:(NSString *)string;
-(NSDate *)getDayByOffset:(NSDate *)date offset:(int)offset;
@end

@implementation AmalLogWizardViewController

@synthesize dataController = _dataController;
@synthesize amalScrollView = _amalScrollView;
@synthesize amalPageControl = _amalPageControl;
@synthesize amalViewControllers = _amalViewControllers;
@synthesize pageControlBeingUsed = _pageControlBeingUsed;
@synthesize numberOfAmal = _numberOfAmal;

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
    
    [self configureView];
    
    // initialiase array of viewcontrollers set:
    // - one date represent a set of subviewcontroller.
    // - many dates represent a subviewcontrollers list.    
    [self initViewControllers:self.dataController.currentVisibleDate];
    [self initScrollView];
    [self initSubViewController:self.dataController.currentVisibleDate];

    self.pageControlBeingUsed = NO;
}

//------------------------------------------------------------
- (void)viewDidUnload
{
    [self setAmalPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    if ([self isViewLoaded]) 
    {
        [self goToDateToday];
        [self goToFirstPage];
    }
    
    [super viewWillAppear:animated];
}

//------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated
{
    self.dataController.isAmalComingFromPopUpReminder = FALSE;
    NSLog(@"isAmalComingFromPopUpReminder is now FALSE via viewDidDisappear");
}

//------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//------------------------------------------------------------
-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    if(!self.pageControlBeingUsed)
    {
        CGFloat pageWidth = self.amalScrollView.frame.size.width;
        int page = floor((self.amalScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.amalPageControl.currentPage = page;
    }
}

//------------------------------------------------------------
-(void)configureView
{
    NSInteger numberOfAmalInCurrentDate = [[self.dataController getAmalListAtDate:self.dataController.currentVisibleDate] count];
    if(numberOfAmalInCurrentDate > 0)
    {
        self.amalPageControl.numberOfPages = numberOfAmalInCurrentDate;
    }
    
    UIImage *bgview = [UIImage imageNamed:@"background-simple-no-amal.png"];
    CGSize imgSize = self.navigationController.view.frame.size;
    
    UIGraphicsBeginImageContext( imgSize );
    [bgview drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
}

#pragma mark - Initialization

//------------------------------------------------------------
-(void)initViewControllers:(NSDate *)date
{
    self.numberOfAmal = [[self.dataController getAmalListAtDate:date] count];
    
    //NSLog(@"Number of amal today: %d", self.numberOfAmal);
    BOOL a = self.dataController.isAmalSubViewControllerListDirty;
    NSInteger b = self.numberOfAmal;
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (unsigned j = 0; j < self.numberOfAmal; j++)
    {
		[viewControllers addObject:[NSNull null]];
    }
    self.amalViewControllers = viewControllers;
}

//------------------------------------------------------------
-(void)clearViewControllers
{
    
}

//------------------------------------------------------------
-(void)initScrollView
{
    self.amalScrollView.showsHorizontalScrollIndicator = NO;
    self.amalScrollView.showsVerticalScrollIndicator = NO;
    self.amalScrollView.scrollsToTop = NO;
    self.amalScrollView.delegate = self;
    self.amalScrollView.contentSize = CGSizeMake(self.amalScrollView.frame.size.width * self.numberOfAmal, self.amalScrollView.frame.size.height);
}

//------------------------------------------------------------
-(void)initSubViewController:(NSDate *)date
{
    AmalLogWizardSubViewController *subViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    NSMutableArray *amalListAtDate = [self.dataController getAmalListAtDate:date];
    NSMutableArray *subViewControllerList = [[NSMutableArray alloc] initWithCapacity:[amalListAtDate count]];

    NSInteger a = [amalListAtDate count];
    NSInteger b = [self.amalViewControllers count];
    
    // Check if theres existing amalsubviewcontrollers and if subviewcontroller is dirty or not
    // if exist and if not dirty, replace existing self.amalviewcontrollers. 
    // if doesnt exist or if dirty, create la apa lagi.
//    if ([self getNumberOfAmalViewControllerAtDate:date] > 0 &&
//        !self.dataController.isAmalSubViewControllerListDirty) 
//    {
//        self.amalViewControllers = [self getAmalViewControllerListAtDate:date];
//        //NSLog(@"self.amalViewControllers: %@", self.amalViewControllers);
//    }
//    else 
    if ([amalListAtDate count] == 0)
    {
        for (int i = 0; i < [self.amalViewControllers count]; i++) 
        {
            [self.amalViewControllers removeObjectAtIndex:i];
        }
    }
    else // if amal exist, and is dirty, create baru la semua
    {        
        for (int i = 0; i < [amalListAtDate count]; i++) 
        {
            // fill up all today's viewControllers at once
            subViewController = [storyboard instantiateViewControllerWithIdentifier:@"AmalLogWizardSub"];
            subViewController.dataController = self.dataController;
            [subViewController setAmal:[amalListAtDate objectAtIndex:i]];
            [subViewControllerList addObject:subViewController];
        }
        
        self.amalViewControllers = subViewControllerList;
    }
    
    for (int i = 0; i < [self.amalViewControllers count]; i++) 
    {
        subViewController = [self.amalViewControllers objectAtIndex:i];
        
        // 1. Add the frame to subview (kinda decides its position)
        // 2. Add content
        // 3. Pass delegate
        CGRect frame;
        frame.origin.x = self.amalScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.amalScrollView.frame.size;
        subViewController.view.frame = frame;        
        subViewController.delegate = self;
        
        [subViewController initConversationLibrary];
        [subViewController configureView];
        [self.amalScrollView addSubview:subViewController.view];
    }
    
    if ([self.amalViewControllers count] == 0) 
    {
        NSArray *a = self.amalScrollView.subviews;
        for (int i = 0; i < [self.amalScrollView.subviews count]; i++)
        {
            if (![[self.amalScrollView.subviews objectAtIndex:i] isKindOfClass:[UILabel class]]) 
            {
                [[self.amalScrollView.subviews objectAtIndex:i] removeFromSuperview];
            }
        }
    }
    
    // add collection of viewcontrollers in dict and masterarray
    if ([self.amalViewControllers count] > 0) 
    {
        AmalLogWizardSubViewController *tomp = [self.amalViewControllers objectAtIndex:0];
        NSString *dateString = [self dateToString:date];
        [self.dataController.dictAmalViewControllersList setObject:subViewControllerList forKey:dateString];
        AmalLogWizardSubViewController *temp = [[self.dataController.dictAmalViewControllersList objectForKey:dateString] objectAtIndex:0];
        self.dataController.isAmalSubViewControllerListDirty = FALSE;
    }
}

//------------------------------------------------------------
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlBeingUsed = NO;
}

//------------------------------------------------------------
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlBeingUsed = NO;
}

//------------------------------------------------------------
-(IBAction)changePage
{
    CGRect frame = self.amalScrollView.frame;
    frame.origin.x = frame.size.width * self.amalPageControl.currentPage;
    frame.origin.y = 0;
    [self.amalScrollView scrollRectToVisible:frame animated:NO];
    
    [self configureView];
    self.pageControlBeingUsed = YES;
}

#pragma mark - OPERATIONS

//------------------------------------------------------------
-(NSMutableArray *)getAmalViewControllerListAtDate:(NSDate *)date
{
    NSString *dateString = [self dateToString:date];
        
    NSMutableArray *amalViewControllersAtDate = [self.dataController.dictAmalViewControllersList objectForKey:dateString];
    
    return amalViewControllersAtDate;
}

//------------------------------------------------------------
-(NSInteger)getNumberOfAmalViewControllerAtDate:(NSDate *)date
{
    NSInteger numberOfAmalViewControllerAtDate = [[self getAmalViewControllerListAtDate:date] count];
    return numberOfAmalViewControllerAtDate;
}

#pragma mark - DELEGATE

//------------------------------------------------------------
-(void)amalLogWizardSubViewControllerNextPageYes:(AmalLogWizardSubViewController *)controller
{
    [self goToNextPage];
}

//------------------------------------------------------------
-(void)amalLogWizardSubViewControllerNextPageNo:(AmalLogWizardSubViewController *)controller
{
    [self goToNextPage];
}

//------------------------------------------------------------
-(void)amalLogWizardSubViewControllerButtonDateNext:(AmalLogWizardSubViewController *)controller currentDate:(NSDate *)currentDate
{
    [self goToNextDate:currentDate];
    [self configureView];
    [self goToFirstPage];
}

//------------------------------------------------------------
-(void)amalLogWizardSubViewControllerButtonDatePrevious:(AmalLogWizardSubViewController *)controller currentDate:(NSDate *)currentDate
{
    ////NSLog(@"Actual current date: %@", [self dateToString:self.dataController.currentVisibleDate]);
    [self goToPreviousDate:currentDate];
    [self configureView];
    [self goToFirstPage];
}

//------------------------------------------------------------
-(void)goToFirstPage
{
    NSInteger oldPage = self.amalPageControl.currentPage;
    
    int firstPage = self.amalPageControl.currentPage - oldPage;
    
    CGRect frame = self.amalScrollView.frame;
    frame.origin.x = frame.size.width * firstPage;
    frame.origin.y = 0;
    [self.amalScrollView scrollRectToVisible:frame animated:YES];
    self.amalPageControl.currentPage = firstPage;
    
    self.pageControlBeingUsed = YES;
}

//------------------------------------------------------------
-(void)goToNextPage
{
    NSInteger oldPage = self.amalPageControl.currentPage;
    
    Utility *util = [[Utility alloc] init];
    NSDate *dateToday = [util getDateReset:[NSDate date]];
    NSDate *dateVisible = self.dataController.currentVisibleDate;

    if(oldPage == [self.dataController getNumberOfAmalAtDate:self.dataController.currentVisibleDate]-1 && 
       (NSInteger)[self.dataController.currentVisibleDate timeIntervalSinceDate:dateToday] == 0 &&
       self.dataController.isAmalComingFromPopUpReminder) // add the flag
    {
        // should we ask first via uialertview?
        self.dataController.isAmalComingFromPopUpReminder = FALSE;
        NSLog(@"isAmalComingFromPopUpReminder is now FALSE from goToNextPage");
        UITabBarController *tabBarController = (UITabBarController *)self.tabBarController;
        tabBarController.selectedIndex = AMALSCORE_TAB;
        return;
    }
    
    int nextPage = self.amalPageControl.currentPage + 1;
    
    CGRect frame = self.amalScrollView.frame;
    frame.origin.x = frame.size.width * nextPage;
    frame.origin.y = 0;
    [self.amalScrollView scrollRectToVisible:frame animated:NO];
    self.amalPageControl.currentPage = nextPage;
    
    self.pageControlBeingUsed = YES;
}

//------------------------------------------------------------
-(void)goToDateToday
{
    Utility *util = [[Utility alloc] init];
    NSDate *dateToday = [util getDateReset:[NSDate date]];
        
//    BOOL isEqualDate = ((NSInteger)[self.dataController.currentVisibleDate timeIntervalSinceDate:dateToday] == 0);
//    if (!isEqualDate)
//    {
        //NSLog(@"goToDateToday dateToday: %@", [NSDateFormatter localizedStringFromDate:dateToday dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
        //NSLog(@"goToDateToday self.dataController.currentVisibleDate: %@", [NSDateFormatter localizedStringFromDate:self.dataController.currentVisibleDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    [self configureView];
    self.dataController.currentVisibleDate = dateToday;

    [self initViewControllers:dateToday];
    [self initScrollView];
    [self initSubViewController:dateToday];        
    //}
}

//------------------------------------------------------------
-(void)goToNextDate:(NSDate *)currentDate
{
    NSDate *nextDate = [self getDayByOffset:currentDate offset:+1];
    BOOL isAmalExistAtNextDate = ([[self.dataController getAmalListAtDate:nextDate] count] > 0);
    if (!isAmalExistAtNextDate)
        return;
    
    self.dataController.currentVisibleDate = nextDate;
    
    [self initViewControllers:nextDate];
    [self initScrollView];
    [self initSubViewController:nextDate];
}

//------------------------------------------------------------
-(void)goToPreviousDate:(NSDate *)currentDate
{
    NSDate *previousDate = [self getDayByOffset:currentDate offset:-1];
    BOOL isAmalExistAtPreviousDate = ([[self.dataController getAmalListAtDate:previousDate] count] > 0);
    if (!isAmalExistAtPreviousDate)
        return;
    
    Utility *util = [[Utility alloc] init];
    NSDate *dateToday = [util getDateReset:[NSDate date]];
    if((NSInteger)[self.dataController.currentVisibleDate timeIntervalSinceDate:dateToday] == 0)
    {
        self.dataController.isAmalComingFromPopUpReminder = FALSE;
        NSLog(@"isAmalComingFromPopUpReminder is now FALSE from goToPreviousDate");
    }

    self.dataController.currentVisibleDate = previousDate;

    [self initViewControllers:previousDate];
    [self initScrollView];
    [self initSubViewController:previousDate];
}

#pragma mark - UTILITY
// UTILITY
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
