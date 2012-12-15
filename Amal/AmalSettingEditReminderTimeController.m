//
//  AmalSettingEditReminderTimeController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 2/18/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "AmalSettingEditReminderTimeController.h"

@interface AmalSettingEditReminderTimeController ()
-(void)configureView;
@end

@implementation AmalSettingEditReminderTimeController
@synthesize delegate = _delegate;
@synthesize tempReminderTime = _tempReminderTime;
@synthesize reminderTimePicker = _reminderTimePicker;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

//------------------------------------------------------------
-(void)configureView
{
    [self.reminderTimePicker setDate:self.tempReminderTime animated:YES];
}

//------------------------------------------------------------
- (void)viewDidUnload
{
    [self setReminderTimePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - segue stuff

//------------------------------------------------------------
- (IBAction)getReminderTime:(id)sender 
{
    NSDate *selectedDate = [self.reminderTimePicker date];
    self.tempReminderTime = selectedDate;
}

//------------------------------------------------------------
- (IBAction)done:(id)sender 
{
    [[self delegate] amalSettingEditReminderTimeControllerDidFinish:self reminderTime:self.tempReminderTime];
}
@end
