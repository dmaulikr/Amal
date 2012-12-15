//
//  AmalNewFrequencyController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 2/16/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AmalNewFrequencyControllerDelegate;

@interface AmalNewFrequencyController : UITableViewController <UITableViewDelegate>

@property (weak, nonatomic) id <AmalNewFrequencyControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *listOfFrequency;
@property (nonatomic, strong) NSString *currentFrequency;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
@end

@protocol AmalNewFrequencyControllerDelegate <NSObject>
-(void)amalNewFrequencyControllerDidFinish:(AmalNewFrequencyController *)controller frequency:(NSString *)frequency;
-(void)amalNewFrequencyControllerDidCancel:(AmalNewFrequencyController *)controller;
@end