//
//  HRRecipResult.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRBaseResult.h"
#import "HRRecipe.h"

@interface HRRecipeResult : HRBaseResult

@property (nonatomic,strong) HRRecipe *recipe;

@end
