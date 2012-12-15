//
//  AppDelegate.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/5/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//

#import "AppDelegate.h"

#import "AmalDataController.h"
#import "AmalListViewController.h"
#import "AmalScoreViewController.h"
#import "AmalLogWizardViewController.h"
#import "Amal.h"
#import "Utility.h"

#define AMALLOG_TAB 2

@implementation AppDelegate

@synthesize window = _window;
@synthesize amalDataController = _amalDataController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.amalDataController = [[AmalDataController alloc] init];

    // load some stuff and presets
    [self.amalDataController loadSettings];
    [self loadPresets:self.amalDataController];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    // Pass data controller to AMAL_LIST
    UINavigationController *navigationControllerAmalList = [[tabBarController viewControllers] objectAtIndex:0];
    AmalListViewController *amalListViewController = (AmalListViewController *)[[navigationControllerAmalList viewControllers] objectAtIndex:0];
    
    // Replace the navbar
//    if ([navigationControllerAmalList.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
//        UIImage *image = [UIImage imageNamed:@"navbarbg.png"];
//        [navigationControllerAmalList.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    }
    
    amalListViewController.dataController = self.amalDataController;
    
    // Pass data controller to AMAL_SCORE
    UINavigationController *navigationControllerAmalScore = [[tabBarController viewControllers] objectAtIndex:1];
    AmalScoreViewController *amalScoreViewController = (AmalScoreViewController *)[[navigationControllerAmalScore viewControllers] objectAtIndex:0];
    
    amalScoreViewController.dataController = self.amalDataController;
    
    // Pass data controller to AMAL_LOG
    UINavigationController *navigationControllerAmalLog = [[tabBarController viewControllers] objectAtIndex:2];
    AmalLogWizardViewController *amalLogWizardViewController = (AmalLogWizardViewController *)[[navigationControllerAmalLog viewControllers] objectAtIndex:0];

    amalLogWizardViewController.dataController = self.amalDataController;
    
    return YES;
}

-(void)loadPresets:(AmalDataController *)dataController
{
    if (dataController == nil)
        return;
    
    // If app is not already launched for the first time
    if (!self.amalDataController.launchedFirstTime)
    {        
        Utility *util = [[Utility alloc] init];
    
        // If it's the first time the app is launch,
        NSDate *dateToday = [util getDateReset:[NSDate date]];
    
        // Add
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:dateToday];
        
        NSDate *dateReminderDefault;
    
        [components setHour:23]; // Set to 11pm
        [components setMinute:0];
        [components setSecond:0];
        dateReminderDefault = [cal dateByAddingComponents:components toDate:dateToday options:0];
        self.amalDataController.reminderTime = dateReminderDefault;
    
        // Set the flag to TRUE to mark that this app has been launch for the first time
        self.amalDataController.launchedFirstTime = TRUE;
    }
    else
    {
        // only load dataController after saving has been done ie not launch for first time.
        // hopefully this doesnt cause bug. 
        // e.g. if app goes crash, and save doesnt trigger?
        [dataController loadDataController];
    }
    
    // regardless if it's starting first time or not, set it to dirty on launch
    self.amalDataController.isAmalSubViewControllerListDirty = TRUE;
    self.amalDataController.isAmalComingFromPopUpReminder = FALSE;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if(state == UIApplicationStateInactive)
    {
        self.amalDataController.isAmalComingFromPopUpReminder = TRUE;
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        tabBarController.selectedIndex = AMALLOG_TAB;
    }
    else if (state == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Amal"
                              message: @"Time to log your amal. It will take less than a minute. Promise."
                              delegate:self
                              cancelButtonTitle:@"Nah"
                              otherButtonTitles:@"Alrite", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) 
    {
        self.amalDataController.isAmalComingFromPopUpReminder = TRUE;
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        tabBarController.selectedIndex = AMALLOG_TAB;
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    if(self.amalDataController.reminderEnable)
    {
        [self scheduleAlarmForDate];
    }
    [self.amalDataController saveDataController];
    [self.amalDataController saveSettings];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self.amalDataController saveDataController];
    [self.amalDataController saveSettings];
}

//------------------------------------------------------------
- (void)scheduleAlarmForDate
{
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    
    // Create a new notification.
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    
    Utility *util = [[Utility alloc] init];
    NSDate *dateToRemind, *dateToRemindTomorrow;
    NSDate *dateTodayAtTwelveAm = [util getDateReset:[NSDate date]];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self.amalDataController.reminderTime];
    
    [components setHour:[components hour]];
    [components setMinute:[components minute]];
    [components setSecond:[components second]];
    dateToRemind = [cal dateByAddingComponents:components toDate:dateTodayAtTwelveAm options:0];
    
    // compare dateToRemind with current date    
    if((NSInteger)[dateToRemind timeIntervalSinceDate:[NSDate date]] < 0)
    {
        components = [cal components:( NSDayCalendarUnit ) fromDate:[NSDate date]];
        [components setDay:1];
        dateToRemind = [cal dateByAddingComponents:components toDate:dateToRemind options:0];
    }
        
    
    NSLog(@"hour: %d", [components hour]);
    NSLog(@"minute: %d", [components minute]);
    NSLog(@"second: %d", [components second]);
    NSLog(@"date to remind: %@", [NSDateFormatter localizedStringFromDate:dateToRemind dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    NSLog(@"self.amalDataController.reminderTime: %@", [NSDateFormatter localizedStringFromDate:self.amalDataController.reminderTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    
    if (alarm)
    {
        alarm.fireDate = dateToRemind;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
        alarm.soundName = @"alarmsound.caf";
        alarm.alertAction = @"OK I'll do it";
        alarm.alertBody = @"Time to log your amal. It will take less than a minute. Promise";
        
        [app scheduleLocalNotification:alarm];
    }
}


@end

@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
}
@end