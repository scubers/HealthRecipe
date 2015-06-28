//
//  HRRecipeQueryResult.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "HRRecipeQueryResult.h"
#import "HRRecipe.h"

@implementation HRRecipeQueryResult

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"recipes" : @"yi18" };
}

+ (NSDictionary *)objectClassInArray {
    return @{@"recipes" : [HRRecipe class]};
}

@end
