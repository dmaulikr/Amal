//
//  AmalSingleEditFrequencyController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 1/28/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Amal;

@protocol AmalSingleEditFrequencyControllerDelegate;

@interface AmalSingleEditFrequencyController : UITableViewController <UITableViewDelegate>

@property (weak, nonatomic) id <AmalSingleEditFrequencyControllerDelegate> delegate;
@property (weak, nonatomic) Amal *amal;
@property (nonatomic, strong) NSMutableArray *listOfFrequency;
@property (nonatomic, strong) NSString *currentFrequency;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end


@protocol AmalSingleEditFrequencyControllerDelegate <NSObject>

-(void)amalSingleEditFrequencyControllerDidFinish:(AmalSingleEditFrequencyController *)controller frequency:(NSString *)frequency;
-(void)amalSingleEditFrequencyControllerDidCancel:(AmalSingleEditFrequencyController *)controller;

@end