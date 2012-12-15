//
//  AmalSingleEditController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/28/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "AmalSingleEditController.h"
#import "Amal.h"
#import "AmalSingleEditFrequencyController.h"

#define AMALTITLE_LABEL 1
#define AMALSCALE_LABEL 2
#define AMALFREQUENCY_LABEL 3

@interface AmalSingleEditController () <AmalSingleEditFrequencyControllerDelegate>
-(void)configureView;
-(void) validateTextFields:(NSString *)textField string:(NSString *)string;
@end

@implementation AmalSingleEditController

@synthesize amal = _amal;
@synthesize amalTitleLabel = _amalTitleLabel;
@synthesize amalScaleLabel = _amalScaleLabel;
@synthesize amalFrequencyLabel = _amalFrequencyLabel;
@synthesize amalImage = _amalImage;
@synthesize pickedImageUrl = _pickedImageUrl;
@synthesize tempFrequency = _tempFrequency;
@synthesize tableView = _tableView;

@synthesize imgPicker = _imgPicker;
@synthesize buttonDone = _buttonDone;

@synthesize delegate = _delegate;

//------------------------------------------------------------
// Only called when it enters from parent
- (void)configureViewInit
{
    Amal *theAmal = self.amal;
    
    if (theAmal) {
//        self.amalTitleLabel.text = (NSString *)theAmal.title;
//        self.amalTitleLabel.placeholder = @"e.g. Read Quran";
//        self.amalScaleLabel.text = (NSString *)theAmal.scale;
//        self.amalScaleLabel.placeholder = @"e.g. 10 pages";
//        self.amalFrequencyLabel.text = (NSString *)theAmal.frequency;
//        self.amalImage.image = [UIImage imageNamed:theAmal.imageUrl];
        self.tempFrequency = (NSString *)theAmal.frequency;
        [self validateTextFields:theAmal.title string:@""];
    }
}

//------------------------------------------------------------
// Called when it goes back from its child
- (void)configureView
{
    // Update the user interface for the detail item.
    Amal *theAmal = self.amal;
    
    if (theAmal)
    {
        // do something with stuff other than in tableview
        [self.tableView reloadData];
    }
}

//------------------------------------------------------------
- (void)setAmal:(Amal *)newAmal
{
    if (_amal != newAmal) {
        _amal = newAmal;
    }
}

//------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self configureViewInit];
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.allowsEditing = NO;
    self.imgPicker.delegate = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
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
    [self setAmalScaleLabel:nil];
    [self setAmalFrequencyLabel:nil];
    [self setButtonDone:nil];
    [self setAmalImage:nil];
    [self setTableView:nil];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0)
        return 1;
    else // if (section == 1)
        return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Title";
    else // if (section == 1)
        return @"Detail";
}

//------------------------------------------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    
    UITextField *titleInput, *scaleInput;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        if (indexPath.section == 1 && indexPath.row == 1)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.section == 0)
            {
                titleInput = [[UITextField alloc] initWithFrame:CGRectMake(8, 12, 285, 31)];
                titleInput.adjustsFontSizeToFitWidth = YES;
                titleInput.placeholder = @"e.g. Read Quran";
                titleInput.returnKeyType = UIReturnKeyDone;
                titleInput.tag = AMALTITLE_LABEL;
                self.amalTitleLabel = titleInput;
                self.amalTitleLabel.delegate = self;
                [cell.contentView addSubview:self.amalTitleLabel];
            }
            else if (indexPath.section == 1) // indexPath.row == 0
            {
                scaleInput = [[UITextField alloc] initWithFrame:CGRectMake(8, 12, 285, 31)];
                scaleInput.adjustsFontSizeToFitWidth = YES;
                scaleInput.placeholder = @"e.g. 10 pages";
                scaleInput.returnKeyType = UIReturnKeyDone;
                scaleInput.tag = AMALSCALE_LABEL;
                self.amalScaleLabel = scaleInput;
                self.amalScaleLabel.delegate = self;
                [cell.contentView addSubview:self.amalScaleLabel];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    // Configure the cell..
    Amal *amal = self.amal;
    
    if (indexPath.section == 0) 
    {
        self.amalTitleLabel = (UITextField *)[cell.contentView viewWithTag:AMALTITLE_LABEL];
        self.amalTitleLabel.text = amal.title;
    }
    else // indexPath.section == 1
    {
        if (indexPath.row == 0) 
        {
            self.amalScaleLabel = (UITextField *)[cell.contentView viewWithTag:AMALSCALE_LABEL];
            self.amalScaleLabel.text = amal.scale;
        }
        else // indexPath.row == 1
        {
            cell.textLabel.text = @"Frequency";
            cell.detailTextLabel.text = self.tempFrequency;
        }
    }
    
    return cell;
}

//------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if(indexPath.section == 1 && indexPath.row == 1)
        [self performSegueWithIdentifier:@"ShowListFrequency" sender:self];
}

#pragma mark - Text field delegate

//------------------------------------------------------------
-(BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if ((textField == self.amalTitleLabel) || (textField == self.amalScaleLabel)) 
    {
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

// both of these should be our concern when we have thumbnail. for now. no thumbnail.
////------------------------------------------------------------
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    self.tableView.frame = CGRectMake(0.0,44.0,320.0,200.0);
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 259);
//    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//}
//
////------------------------------------------------------------
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    self.tableView.frame = CGRectMake(0.0,44.0,320.0,416.0);
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    return YES;
//}

#pragma mark - delegate function

//------------------------------------------------------------
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowListFrequency"])
    {
        Amal *theAmal = self.amal;
        
        AmalSingleEditFrequencyController *amalSingleEditFrequencyController = [segue destinationViewController];
        amalSingleEditFrequencyController.delegate = self;
        [amalSingleEditFrequencyController setAmal:theAmal];
    }
}

//------------------------------------------------------------
-(void)amalSingleEditFrequencyControllerDidFinish:(AmalSingleEditFrequencyController *)controller frequency:(NSString *)frequency
{
    if([frequency length])
    {
        self.tempFrequency = frequency;
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self configureView];
}

//------------------------------------------------------------
-(void)amalSingleEditFrequencyControllerDidCancel:(AmalSingleEditFrequencyController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    [self configureView];
}

//------------------------------------------------------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.pickedImageUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    //NSLog(@"NSURL picking: %@", [self.pickedImageUrl absoluteString]);

    self.amalImage.image = pickedImage;
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - button function

//------------------------------------------------------------
- (IBAction)done:(id)sender 
{
    NSString* finalFrequency;
    
    if (self.tempFrequency == @"")
        finalFrequency = self.amal.frequency;
    else
    {
        finalFrequency = self.tempFrequency;
        self.tempFrequency = @"";
    }

    //NSLog(@"NSURL new: %@", self.pickedImageUrl);
    [[self delegate] amalSingleEditControllerDidFinish:self title:self.amalTitleLabel.text scale:self.amalScaleLabel.text frequency:finalFrequency imageUrl:[self.pickedImageUrl absoluteString]];
}

//------------------------------------------------------------
- (IBAction)cancel:(id)sender 
{
    [[self delegate] amalSingleEditControllerDidCancel:self];
    self.tempFrequency = @"";
}

- (IBAction)grabImage:(id)sender 
{
    [self presentModalViewController:self.imgPicker animated:YES];
}
@end
