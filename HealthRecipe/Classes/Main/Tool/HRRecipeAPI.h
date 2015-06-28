//
//  HRRecipeAPI.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HRRecipeCategoryParam,HRRecipeCategoryResult,HRRecipeQueryParam,HRRecipeQueryResult,HRRecipeResult;

@interface HRRecipeAPI : NSObject

+ (void)recipeCategoriesWithHierarchy:(HRRecipeCategoryParam *)param success:(void (^)(HRRecipeCategoryResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  搜索食谱
 */
+ (void)queryRecipes:(HRRecipeQueryParam *)param success:(void (^)(HRRecipeQueryResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  菜谱列表
 */
+ (void)listRecipes:(HRRecipeQueryParam *)param success:(void (^)(HRRecipeQueryResult *result))success failure:(void (^)(NSError *error))failure ;

/**
 *  菜谱详细
 */
+ (void)recipeDetail:(HRRecipeQueryParam *)param success:(void (^)(HRRecipeResult *result))success failure:(void (^)(NSError *error))failure;

@end
