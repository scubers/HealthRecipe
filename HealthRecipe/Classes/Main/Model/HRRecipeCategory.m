//
//  HRRecipeCategory.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "HRRecipeCategory.h"
#import "MJExtension.h"


@implementation HRRecipeCategory

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"subClass" : [HRRecipeCategory class]};
}



@end
