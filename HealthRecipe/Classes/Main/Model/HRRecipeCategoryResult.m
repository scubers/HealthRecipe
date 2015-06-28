//
//  HRRecipeCategoryResult.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "HRRecipeCategoryResult.h"
#import "MJExtension.h"
#import "HRRecipeCategory.h"

@implementation HRRecipeCategoryResult

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"categories" : @"yi18"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"categories":[HRRecipeCategory class]};
}


@end
