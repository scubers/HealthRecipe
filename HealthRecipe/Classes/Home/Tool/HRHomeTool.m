//
//  HRHomeTool.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/7.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "HRHomeTool.h"

@implementation HRHomeTool

+ (REFrostedViewController *)frostedViewController {
    // Create content and menu controllers
    //
    HRHomeController *homeController = [[HRHomeController alloc] init];
    HRNavigationController *navigationController = [[HRNavigationController alloc] initWithRootViewController:homeController];
    HRMenuController *menuController = [[HRMenuController alloc] initWithStyle:UITableViewStylePlain];
    
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.backgroundFadeAmount = 0.1;
    frostedViewController.limitMenuViewSize = YES;
    frostedViewController.menuViewSize = CGSizeMake(200, SCREEN_HEIGHT);
    frostedViewController.delegate = menuController;
    return frostedViewController;
}

@end
