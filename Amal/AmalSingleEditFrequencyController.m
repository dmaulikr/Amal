//
//  AmalSingleEditFrequencyController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/28/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "AmalSingleEditFrequencyController.h"
#import "Amal.h"

@interface AmalSingleEditFrequencyController ()
-(void)configureView;
@end

@implementation AmalSingleEditFrequencyController

@synthesize amal = _amal;
@synthesize listOfFrequency = _listOfFrequency;
@synthesize currentFrequency = _currentFrequency;

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)configureView
{
    // Update the user interface for the detail item.
    Amal *theAmal = self.amal;
    
    if (theAmal) {
        // ** IMPORTANT - Put checkmark as amal frequency HERE
        NSInteger freqIndex = [self.listOfFrequency indexOfObject:self.currentFrequency];
        NSIndexPath *freqIndexPath = [NSIndexPath indexPathForRow:freqIndex inSection:0];

        UITableViewCell *currentFrequencyCell = [self.tableView cellForRowAtIndexPath:freqIndexPath];
        currentFrequencyCell.accessoryType = UITableViewCellAccessoryCheckmark;
        currentFrequencyCell.textLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:132.0/255.0 alpha:1.0];
    }
}

- (void)setAmal:(Amal *)newAmal
{
    if (_amal != newAmal) {
        _amal = newAmal;
        
        // Update the view.
        [self configureView];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self configureView];
    NSMutableArray *listfreq = [[NSMutableArray alloc] 
                                initWithObjects:@"Daily",
                                @"Twice a day",
                                @"Weekly",
                                @"Twice a week",
                                @"3 times a week",
                                @"4 times a week",
                                @"5 times a week",
                                @"6 times a week",
                                @"Monthly", 
                                nil];
    
    self.listOfFrequency = listfreq;
    self.currentFrequency = self.amal.frequency;
    
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
//    self.navigationItem.rightBarButtonItem = doneButton;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];

    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listOfFrequency count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditFrequencyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString *currentFrequency = [self.listOfFrequency objectAtIndex:indexPath.row];    
    cell.textLabel.text = currentFrequency;
    
    NSInteger freqIndex = [self.listOfFrequency indexOfObject:self.currentFrequency];
    
    if(freqIndex == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:132.0/255.0 alpha:1.0];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger freqIndex = [self.listOfFrequency indexOfObject:self.currentFrequency];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:freqIndex inSection:0];
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldCell.textLabel.textColor = [UIColor blackColor];
    }
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:132.0/255.0 alpha:1.0];
        self.currentFrequency = [self.listOfFrequency objectAtIndex:indexPath.row];
    }
}

- (IBAction)done:(id)sender 
{
    [[self delegate] amalSingleEditFrequencyControllerDidFinish:self frequency:self.currentFrequency];
}

- (IBAction)cancel:(id)sender 
{
    [[self delegate] amalSingleEditFrequencyControllerDidCancel:self];
}
@end
