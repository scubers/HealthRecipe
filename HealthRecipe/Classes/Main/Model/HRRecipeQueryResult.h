//
//  HRRecipeQueryResult.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRBaseResult.h"

@interface HRRecipeQueryResult : HRBaseResult

/**
 *  每夜返回条数
 */
@property (nonatomic,strong) NSNumber *total;

/**
 *  返回的菜谱数组
 */
@property (nonatomic,strong) NSArray *recipes;

@end
