//
//  AmalNewViewController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/17/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AmalNewViewControllerDelegate;

@interface AmalNewViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <AmalNewViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *amalTitleInput;
@property (weak, nonatomic) IBOutlet UITextField *amalScaleInput;
@property (weak, nonatomic) IBOutlet UILabel *amalFrequencyInput;
@property (weak, nonatomic) NSString *tempFrequency;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

@protocol AmalNewViewControllerDelegate <NSObject>

-(void)amalNewViewControllerDidCancel:(AmalNewViewController *)controller;
-(void)amalNewViewControllerDidFinish:(AmalNewViewController *)controller name:(NSString *)name scale:(NSString *)scale frequency:(NSString *)frequency;

@end
