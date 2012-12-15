//
//  AmalListViewController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/8/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//

#import "AmalListViewController.h"

#import "AmalSettingViewController.h"
#import "AmalSingleViewController.h"
#import "AmalSingleEditController.h"
#import "AmalDataController.h"
#import "Amal.h"
#import "Score.h"
#import "Done.h"
#import "AmalNewViewController.h"
#import "Utility.h"

#define AMALTITLE_TAG 1
#define AMALSCALEFREQUENCY_TAG 2
#define AMALSCORE_TAG 3
#define AMALIMAGE_TAG 4

@interface AmalListViewController () <AmalNewViewControllerDelegate, AmalSettingViewControllerDelegate>
@end

@interface AmalListViewController ()
-(void)configureView;
-(void)printLogAmal:(Amal *)amal;
-(NSString *)dateStringFormattedTodayFromString:(NSString *)dateString;
-(NSString *)dateStringFormattedToday:(NSDate *)date;
-(NSDate *)formatDate:(NSDate *)date;
-(NSString *)dateToString:(NSDate *)date;
-(NSDate *)stringToDate:(NSString *)string;
@end

@implementation AmalListViewController

@synthesize dataController = _dataController;
@synthesize amalTitleLabel = _amalTitleLabel;
@synthesize amalScaleFrequencyLabel = _amalScaleFrequencyLabel;

#pragma mark - View lifecycle

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

//------------------------------------------------------------
- (void)configureView
{
    UIImage *bgtable;
    
    if ([self.dataController countOfList] > 0) 
        bgtable = [UIImage imageNamed:@"background-simple.png"];
    else
        bgtable = [UIImage imageNamed:@"background-simple-no-amal-arrow.png"];
    
    CGSize imgSize = self.navigationController.view.frame.size;
    
    UIGraphicsBeginImageContext( imgSize );
    [bgtable drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.dataController calculateAllScores];
    
    [self.tableView reloadData];
}

//------------------------------------------------------------
- (void)viewDidLoad
{
    [self configureView];
    
    UIImage *bgtable;
    
    if ([self.dataController countOfList] > 0) 
        bgtable = [UIImage imageNamed:@"background-simple.png"];
    else
        bgtable = [UIImage imageNamed:@"background-simple-no-amal-arrow.png"];
    
    CGSize imgSize = self.navigationController.view.frame.size;
    
    UIGraphicsBeginImageContext( imgSize );
    [bgtable drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//------------------------------------------------------------
- (void)viewDidUnload
{
    [self setAmalTitleLabel:nil];
    [self setAmalScaleFrequencyLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    if ([self isViewLoaded]) 
        [self configureView];
    
    [super viewWillAppear:animated];
}

//------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

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
    //return [self.amals count];
//    NSInteger numberOfRows;
//    
//    if (![self.dataController countOfList])
//        numberOfRows = 1;
//    else
//        numberOfRows = [self.dataController countOfList];
    return [self.dataController countOfList];
}

//------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AmalCell";
    
    UILabel *amalTitle, *amalScaleFrequency, *amalScore;
    UIImageView *amalImage, *amalBackgroundCell;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        amalBackgroundCell = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 55.0)];
        UIImage *backgroundCell = [UIImage imageNamed:@"table_cell_bg.png"];
        amalBackgroundCell.image = backgroundCell;
        [cell.contentView addSubview:amalBackgroundCell];
        
        amalTitle = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 8.0, 230.0, 25.0)];
        amalTitle.tag = AMALTITLE_TAG;
        amalTitle.font = [UIFont boldSystemFontOfSize:20.0];
        amalTitle.backgroundColor = [UIColor clearColor];
        self.amalTitleLabel = amalTitle;
        [cell.contentView addSubview:self.amalTitleLabel];
        
        amalScaleFrequency = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 33.0, 230.0, 15.0)];
        amalScaleFrequency.tag = AMALSCALEFREQUENCY_TAG;
        amalScaleFrequency.font = [UIFont systemFontOfSize:13.0];
        amalScaleFrequency.textColor = [UIColor grayColor];
        amalScaleFrequency.backgroundColor = [UIColor clearColor];
        self.amalScaleFrequencyLabel = amalScaleFrequency;
        [cell.contentView addSubview:self.amalScaleFrequencyLabel];

        amalScore = [[UILabel alloc] initWithFrame:CGRectMake(232.0, 13.0, 50, 25.0)];
        amalScore.tag = AMALSCORE_TAG;
        amalScore.font = [UIFont boldSystemFontOfSize:24.0];
        amalScore.textAlignment = UITextAlignmentRight;
        amalScore.textColor = [UIColor colorWithRed:0.0 green:0.75 blue:0.82 alpha:1.0];
        amalScore.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:amalScore];
        
//        amalImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 55.0, 80.0)];
//        amalImage.tag = AMALIMAGE_TAG;
//        [cell.contentView addSubview:amalImage];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.amalTitleLabel = (UILabel *)[cell.contentView viewWithTag:AMALTITLE_TAG];
        self.amalScaleFrequencyLabel = (UILabel *)[cell.contentView viewWithTag:AMALSCALEFREQUENCY_TAG];
        amalScore = (UILabel *)[cell.contentView viewWithTag:AMALSCORE_TAG];
        //amalImage = (UIImageView *)[cell.contentView viewWithTag:AMALIMAGE_TAG];
    }
    
    // Configure the cell...
    if ([self.dataController countOfList])
    {
        Amal *amalAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
        
        self.amalTitleLabel.text = amalAtIndex.title;
        
        if ([amalAtIndex.scale length] != 0) {
            self.amalScaleFrequencyLabel.text = [NSString stringWithFormat:@"%@ %@", amalAtIndex.scale, amalAtIndex.frequency];
        } else {
            self.amalScaleFrequencyLabel.text = amalAtIndex.frequency;
        }
        
        amalScore.text = [NSString stringWithFormat:@"%d", amalAtIndex.scores.mark];
        amalImage.image = [UIImage imageNamed:amalAtIndex.imageUrl];
    }
    else // Empty data sets for table - PENDING
    {
        if (indexPath.row == 0) 
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.amalTitleLabel.text = @"You have no amal.";
            self.amalScaleFrequencyLabel.text = @"Click the + sign to create one.";
        }
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
//------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        // if its clean, updated, baru la remove from dict.
        //[self.dataController removeAmalAtDictSubViewControllerList:indexPath.row];  

        [self.dataController removeAmalAtIndex:indexPath.row];
        self.dataController.isAmalSubViewControllerListDirty = TRUE;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self configureView];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

//------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Amal *selectedAmal = [self.dataController objectInListAtIndex:indexPath.row];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if([self.dataController countOfList])
        [self performSegueWithIdentifier:@"ShowAmalSingle" sender:self];
}

//------------------------------------------------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - Segue delegate

//------------------------------------------------------------
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowAmalSingle"])
    {
        AmalSingleViewController *amalSingleViewController = [segue destinationViewController];
        [amalSingleViewController setAmal:[self.dataController objectInListAtIndex:[self.tableView indexPathForSelectedRow].row]];
    }
    else if ([[segue identifier] isEqualToString:@"ShowAmalNew"])
    {
        AmalNewViewController *amalNewViewController = (AmalNewViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        amalNewViewController.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"ShowSettings"])
    {
        AmalSettingViewController *amalSettingViewController = [segue destinationViewController];
        [amalSettingViewController setDataController:self.dataController];
        amalSettingViewController.delegate = self;
    }
}

//------------------------------------------------------------
-(void)amalNewViewControllerDidFinish:(AmalNewViewController *)controller name:(NSString *)name scale:(NSString *)scale frequency:(NSString *)frequency
{
    Utility *util = [[Utility alloc] init];
    
    if ([name length] || [scale length] || [frequency length]) {
        NSDate *dateToday = [util getDateReset:[NSDate date]];
        Done *done = [[Done alloc] initWithDate:dateToday did:FALSE];
        NSMutableArray* dones = [[NSMutableArray alloc] init];
        NSNumber *currentIndex = [NSNumber numberWithInt:[dones count]];
        [dones addObject:done];
        NSMutableDictionary* dictDones = [[NSMutableDictionary alloc] init];
        [dictDones setObject:currentIndex forKey:[self dateToString:dateToday]];
        Score *scores = [[Score alloc] initWithMark:0 dones:dones];
        
        [self.dataController addAmalWithName:name scale:scale frequency:frequency scores:scores imageUrl:@"amaldefaulticon.png"];
        [[self tableView] reloadData];
    }
    [self dismissModalViewControllerAnimated:YES];
}

//------------------------------------------------------------
-(void)amalNewViewControllerDidCancel:(AmalNewViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//------------------------------------------------------------
-(void)amalSettingViewControllerDidFinish:(AmalSettingViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
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
-(NSString *)dateStringFormattedTodayFromString:(NSString *)dateString
{
    return [self dateToString:[self formatDate:[self stringToDate:dateString]]];
}

//------------------------------------------------------------
-(NSString *)dateStringFormattedToday:(NSDate *)date
{
    return [self dateToString:[self formatDate:date]];
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

@end
