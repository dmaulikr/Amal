//
//  SecondViewController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/5/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//  
//  How to use:
//  -(NSDate *)getDayByOffset:(NSDate *)date offset:(int)offset;
//   0: same day
//   1: tomorrow
//  -1: yesterday


#import <UIKit/UIKit.h>

@class AmalDataController;

@interface AmalScoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) AmalDataController *dataController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *amalOverallScoreLabel;

-(void)calculateAllScores;

// UTILITY

@end
