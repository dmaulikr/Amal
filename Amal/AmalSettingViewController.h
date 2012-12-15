//
//  AmalSettingViewController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 2/18/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmalDataController;

@protocol AmalSettingViewControllerDelegate;

@interface AmalSettingViewController : UITableViewController
@property (weak, nonatomic) id <AmalSettingViewControllerDelegate> delegate;
@property (weak, nonatomic) AmalDataController *dataController;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (weak, nonatomic) IBOutlet UILabel *reminderTimeLabel;
@property (strong, nonatomic) NSDate *tempReminderTime;

- (IBAction)done:(id)sender;
@end

@protocol AmalSettingViewControllerDelegate <NSObject>
-(void)amalSettingViewControllerDidFinish:(AmalSettingViewController *)controller;
@end
