//
//  AmalNewViewController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/17/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "AmalNewViewController.h"
#import "AmalNewFrequencyController.h"

@interface AmalNewViewController () <AmalNewFrequencyControllerDelegate>
-(void)configureView;
-(void) validateTextFields:(NSString *)textField string:(NSString *)string;
@end

@implementation AmalNewViewController

@synthesize amalTitleInput = _amalTitleInput;
@synthesize amalScaleInput = _amalScaleInput;
@synthesize amalFrequencyInput = _amalFrequencyInput;
@synthesize tempFrequency = _tempFrequency;
@synthesize buttonDone = _buttonDone;

@synthesize delegate = _delegate;

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
    [self validateTextFields:self.amalTitleInput.text string:@""];
    self.tempFrequency = self.amalFrequencyInput.text;
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//------------------------------------------------------------
-(void)configureView
{
    self.amalFrequencyInput.text = self.tempFrequency;
}

//------------------------------------------------------------
- (void)viewDidUnload
{
    [self setAmalTitleInput:nil];
    [self setAmalScaleInput:nil];
    [self setAmalFrequencyInput:nil];
    [self setButtonDone:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [self.amalTitleInput becomeFirstResponder];
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

//------------------------------------------------------------
- (IBAction)cancel:(id)sender 
{
    [[self delegate] amalNewViewControllerDidCancel:self];
}

//------------------------------------------------------------
- (IBAction)done:(id)sender 
{
    [[self delegate] amalNewViewControllerDidFinish:self name:self.amalTitleInput.text scale:self.amalScaleInput.text frequency:self.amalFrequencyInput.text];
}

#pragma mark - Text field delegate

//------------------------------------------------------------
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.amalTitleInput) || (textField == self.amalScaleInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

//------------------------------------------------------------
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    [self validateTextFields:textField.text string:string];
    return TRUE;
}

//------------------------------------------------------------
-(void) validateTextFields:(NSString *)textField string:(NSString *)string
{    
    BOOL isAddingText = string.length > 0;

    if (isAddingText) 
    {
        self.buttonDone.enabled = YES;
    }
    else // isDeletingText
    {
        if (textField.length < 2)
            self.buttonDone.enabled = NO;
        else if (textField.length > 1)
            self.buttonDone.enabled = YES;
    }
    
    return;
}

#pragma mark - child segue delegate

-(void)amalNewFrequencyControllerDidFinish:(id)controller frequency:(NSString *)frequency
{
    if ([frequency length]) 
    {
        self.tempFrequency = frequency;
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self configureView];
}

-(void)amalNewFrequencyControllerDidCancel:(AmalNewFrequencyController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    [self configureView];
}

//------------------------------------------------------------
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowNewListFrequency"])
    {
        AmalNewFrequencyController *amalNewFrequencyController = [segue destinationViewController];
        amalNewFrequencyController.delegate = self;
        amalNewFrequencyController.currentFrequency = self.tempFrequency;
    }
}
@end
