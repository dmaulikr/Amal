//
//  AmalLogWizardViewController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/5/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmalDataController;

@interface AmalLogWizardViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) AmalDataController *dataController;

@property (weak, nonatomic) IBOutlet UIScrollView *amalScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *amalPageControl;
// temp array to store all subvc in current date
// list of all subvcs will be stored in singleton self.dataController.dictAmalViewControllersList
@property (strong, nonatomic) NSMutableArray *amalViewControllers;

@property (assign, nonatomic) BOOL pageControlBeingUsed;
@property (assign, nonatomic) NSInteger numberOfAmal;

- (IBAction)changePage;

// OPERATIONS
-(NSMutableArray *)getAmalViewControllerListAtDate:(NSDate *)date;
-(NSInteger)getNumberOfAmalViewControllerAtDate:(NSDate *)date;

- (void)configureView;
- (void)initViewControllers:(NSDate *)date;
- (void)initScrollView;
- (void)initSubViewController:(NSDate *)date;
- (void)goToFirstPage;
- (void)goToNextPage;
-(void)goToDateToday;
-(void)goToNextDate:(NSDate *)currentDate;
-(void)goToPreviousDate:(NSDate *)currentDate;

@end
