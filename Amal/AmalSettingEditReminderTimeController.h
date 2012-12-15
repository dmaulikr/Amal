//
//  AmalSettingEditReminderTimeController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 2/18/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AmalSettingEditReminderTimeControllerDelegate;

@interface AmalSettingEditReminderTimeController : UIViewController
@property (weak, nonatomic) id <AmalSettingEditReminderTimeControllerDelegate> delegate;
@property (strong,nonatomic) NSDate *tempReminderTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *reminderTimePicker;

- (IBAction)getReminderTime:(id)sender;
- (IBAction)done:(id)sender;
@end

@protocol AmalSettingEditReminderTimeControllerDelegate <NSObject>
-(void)amalSettingEditReminderTimeControllerDidFinish:(AmalSettingEditReminderTimeController *)controller reminderTime:(NSDate *)reminderTime;
@end