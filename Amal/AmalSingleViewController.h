//
//  AmalSingleViewController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/8/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Amal;

@interface AmalSingleViewController : UIViewController

@property (weak, nonatomic) Amal *amal;
@property (weak, nonatomic) IBOutlet UILabel *amalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amalDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *amalScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *amalImage;

-(NSString *)concatenateScaleFrequency:(NSString *)scale frequency:(NSString *)frequency;

@end
