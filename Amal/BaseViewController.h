//
//  BaseViewController.h
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 12/5/11.
//  Copyright (c) 2011 Experience Garage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UITabBarController
{
}

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*)title;

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

@end
