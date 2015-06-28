//
//  HRNavigationController.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/7.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "HRNavigationController.h"
#import "HRMenuController.h"
#import <REFrostedViewController.h>
#import <UIViewController+REFrostedViewController.h>

@interface HRNavigationController ()

@end

@implementation HRNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}


@end
