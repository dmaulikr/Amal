//
//  AmalLogWizardSubViewController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 2/1/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Amal;
@class ConversationLibrary;
@class AmalDataController;

@protocol AmalLogWizardSubViewControllerDelegate;

// 
@interface AmalLogWizardSubViewController : UIViewController

@property (weak, nonatomic) id <AmalLogWizardSubViewControllerDelegate> delegate;

@property (nonatomic, retain) AmalDataController *dataController;

@property (weak, nonatomic) Amal *amal;
@property (weak, nonatomic) IBOutlet UILabel *amalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amalDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *amalDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomYesLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomNoLabel;
@property (strong, nonatomic) ConversationLibrary *conversationLibrary;
@property (weak, nonatomic) IBOutlet UIButton *amalLogYesIndicator;
@property (weak, nonatomic) IBOutlet UIButton *amalLogNoIndicator;
@property (assign, nonatomic) NSInteger amalNumber; // dummy. after this will use actual amal
@property (weak, nonatomic) IBOutlet UIButton *buttonDateNext;
@property (weak, nonatomic) IBOutlet UIButton *buttonDatePrevious;

-(void)configureView;
-(void)initConversationLibrary;
-(NSString *)concatenateScaleFrequency:(NSString *)scale frequency:(NSString *)frequency;
-(void)doToggleAmalLogYes:(BOOL)boolean;
-(void)doToggleAmalLogNo:(BOOL)boolean;
- (IBAction)buttonDateNext:(id)sender;
- (IBAction)buttonDatePrevious:(id)sender;
- (IBAction)nextPageYes:(id)sender;
- (IBAction)nextPageNo:(id)sender;

//UTILITY
-(NSDate *)formatDate:(NSDate *)date;
-(NSString *)dateToString:(NSDate *)date;
-(NSDate *)stringToDate:(NSString *)string;
-(NSDate *)getDayByOffset:(NSDate *)date offset:(int)offset;

@end

// protocol
@protocol AmalLogWizardSubViewControllerDelegate <NSObject>
-(void)amalLogWizardSubViewControllerNextPageYes:(AmalLogWizardSubViewController *)controller;
-(void)amalLogWizardSubViewControllerNextPageNo:(AmalLogWizardSubViewController *)controller;
-(void)amalLogWizardSubViewControllerButtonDateNext:(AmalLogWizardSubViewController *)controller currentDate:(NSDate *)currentDate;
-(void)amalLogWizardSubViewControllerButtonDatePrevious:(AmalLogWizardSubViewController *)controller currentDate:(NSDate *)currentDate;
@end
