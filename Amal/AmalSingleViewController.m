//
//  AmalSingleViewController.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/8/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//

#import "AmalSingleViewController.h"
#import "AmalSingleEditController.h"
#import "Amal.h"
#import "Score.h"

@interface AmalSingleViewController () <AmalSingleEditControllerDelegate>
@end

@interface AmalSingleViewController ()
-(void)configureView;
@end

@implementation AmalSingleViewController

@synthesize amal = _amal;
@synthesize amalTitleLabel = _amalTitleLabel;
@synthesize amalDetailLabel = _amalDetailLabel;
@synthesize amalScoreLabel = _amalScoreLabel;
@synthesize amalImage = _amalImage;


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
- (void)setAmal:(Amal *)newAmal
{
    if (_amal != newAmal) {
        _amal = newAmal;
        
        // Update the view.
        [self configureView];
    }
}

//------------------------------------------------------------
- (void)configureView
{
    // Update the user interface for the detail item.
    Amal *theAmal = self.amal;
    
    if (theAmal) {
        self.amalTitleLabel.text = (NSString *)theAmal.title;
        
        // Concatenate Scale and Frequency
        self.amalDetailLabel.text = [self concatenateScaleFrequency:theAmal.scale frequency:theAmal.frequency];
        
        self.amalScoreLabel.text = [NSString stringWithFormat:@"%d", theAmal.scores.mark];
        //NSLog(@"new image url: %@", theAmal.imageUrl);
        self.amalImage.image = [UIImage imageNamed:theAmal.imageUrl];
    }
}

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */

//------------------------------------------------------------
- (void)viewDidLoad
{
    // MANUAL EDIT BUTTON
//    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editBarButtonItemPressed:)];
//    
//    self.navigationItem.rightBarButtonItem = edit;
    
    [self configureView];
    
    [super viewDidLoad];
}

//------------------------------------------------------------
- (void)viewDidUnload
{
    [self setAmalTitleLabel:nil];
    [self setAmalDetailLabel:nil];
    [self setAmalScoreLabel:nil];
    [self setAmalImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated
{
    if([self isViewLoaded])
        [self configureView];
    
    [super viewWillAppear:animated];
}

//------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//------------------------------------------------------------
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"EditAmalSingle"])
    {
        Amal *theAmal = self.amal;

        AmalSingleEditController *amalSingleEditController = (AmalSingleEditController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];;
        amalSingleEditController.delegate = self;
        [amalSingleEditController setAmal:theAmal];
    }
}

//------------------------------------------------------------
-(void)amalSingleEditControllerDidFinish:(AmalSingleEditController *)controller title:(NSString *)title scale:(NSString *)scale frequency:(NSString *)frequency imageUrl:(NSString *)imageUrl
{
    //NSLog(@"new photo image url: %@", imageUrl);
    if([title length])
        self.amal.title = title;
    
    if([scale length])
        self.amal.scale = scale;
    
    if([frequency length])
        self.amal.frequency = frequency;
    
    if(imageUrl != nil)
        self.amal.imageUrl = imageUrl;

    [self.navigationController dismissModalViewControllerAnimated:YES];
}

//------------------------------------------------------------
-(void)amalSingleEditControllerDidCancel:(AmalSingleEditController *)controller
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
@end
