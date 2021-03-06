//
//  AmalSettingViewController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 2/18/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "AmalSettingViewController.h"

#import "AmalDataController.h"
#import "AmalSettingEditReminderTimeController.h"

@interface AmalSettingViewController () <AmalSettingEditReminderTimeControllerDelegate>
-(void)configureView;
-(void)configureViewInit;
@end

@implementation AmalSettingViewController
@synthesize delegate = _delegate;
@synthesize dataController = _dataController;
@synthesize reminderSwitch = _reminderSwitch;
@synthesize reminderTimeLabel = _reminderTimeLabel;
@synthesize tempReminderTime = _tempReminderTime;

//------------------------------------------------------------
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

//------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureViewInit];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//------------------------------------------------------------
-(void)configureViewInit
{
    self.reminderSwitch.on = self.dataController.reminderEnable;
    self.tempReminderTime = self.dataController.reminderTime;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"hh:mm a"];
    self.reminderTimeLabel.text = [formatter stringFromDate:self.dataController.reminderTime];
}

//------------------------------------------------------------
-(void)configureView
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"hh:mm a"];
    self.reminderTimeLabel.text = [formatter stringFromDate:self.tempReminderTime];
}

//------------------------------------------------------------
- (void)viewDidUnload
{
    [self setReminderSwitch:nil];
    [self setReminderTimeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [self configureView];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

#pragma mark - segue delegate

//------------------------------------------------------------
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowEditReminderTime"])
    {
        AmalSettingEditReminderTimeController *amalSettingEditReminderTimeController = [segue destinationViewController];
        [amalSettingEditReminderTimeController setTempReminderTime:self.tempReminderTime];
        amalSettingEditReminderTimeController.delegate = self;
    }
}

//------------------------------------------------------------
-(void)amalSettingEditReminderTimeControllerDidFinish:(AmalSettingEditReminderTimeController *)controller reminderTime:(NSDate *)reminderTime
{
    if (reminderTime != nil) 
    {
        self.tempReminderTime = reminderTime;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self configureView];
}

#pragma mark - delegate

//------------------------------------------------------------
- (IBAction)done:(id)sender
{
    self.dataController.reminderEnable = self.reminderSwitch.on;
    self.dataController.reminderTime = self.tempReminderTime;
    [[self delegate] amalSettingViewControllerDidFinish:self];
}
@end
