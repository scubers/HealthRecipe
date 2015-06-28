//
//  HRRecipeCategoryResult.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRRecipeCategory.h"
#import "HRBaseResult.h"

@interface HRRecipeCategoryResult : HRBaseResult

/**
 *  返回的分类数组
 */
@property (nonatomic,strong) NSArray *categories;

@end
