//
//  HRMenuController.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/7.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#define MenuControllerDidSelectedRowNotification @"MenuControllerDidSelectedRowNotification"
#define MenuControllerSelectedIndexPath @"MenuControllerSelectedIndexPath"
#define MenuControllerMenus @"MenuControllerMenus"



#import <UIKit/UIKit.h>
#import "HRRecipeCategory.h"

@interface HRMenuController : UITableViewController

@property (nonatomic,strong) NSArray *categories;

@end
