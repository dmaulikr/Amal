//
//  AmalSingleEditController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/28/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Amal;

@protocol AmalSingleEditControllerDelegate;

@interface AmalSingleEditController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) id <AmalSingleEditControllerDelegate> delegate;
@property (weak, nonatomic) Amal *amal;
@property (weak, nonatomic) IBOutlet UITextField *amalTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *amalScaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amalFrequencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *amalImage;
@property (weak, nonatomic) NSURL *pickedImageUrl;
@property (weak, nonatomic) NSString *tempFrequency;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;

-(void)configureViewInit;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)grabImage:(id)sender;

@end

//
@protocol AmalSingleEditControllerDelegate <NSObject>
-(void)amalSingleEditControllerDidFinish:(AmalSingleEditController *)controller title:(NSString *)title scale:(NSString *)scale frequency:(NSString *)frequency imageUrl:(NSString *)imageUrl;
-(void)amalSingleEditControllerDidCancel:(AmalSingleEditController *)controller;
@end