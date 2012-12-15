//
//  AppDelegate.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/5/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmalDataController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AmalDataController *amalDataController;

-(void)loadPresets:(AmalDataController *)dataController;
-(void)scheduleAlarmForDate;

@end
