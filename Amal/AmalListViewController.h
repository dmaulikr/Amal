//
//  AmalListViewController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/8/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmalDataController;

@interface AmalListViewController : UITableViewController

@property (nonatomic, retain) AmalDataController *dataController;
@property (weak, nonatomic) IBOutlet UILabel *amalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amalScaleFrequencyLabel;

@end
