//
//  HRRecipeAPI.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "HRRecipeAPI.h"
#import "BaseAFN.h"
#import "HRRecipeCategory.h"
#import "HRRecipeCategoryParam.h"
#import "HRRecipeCategoryResult.h"
#import "HRRecipeQueryParam.h"
#import "HRRecipeQueryResult.h"

#import "HRRecipeResult.h"
#import <MJExtension.h>

@implementation HRRecipeAPI

/**
 *  食谱分类
 */
+ (void)recipeCategoriesWithHierarchy:(HRRecipeCategoryParam *)param success:(void (^)(HRRecipeCategoryResult *result))success failure:(void (^)(NSError *error))failure {
    NSString *url = @"http://apis.baidu.com/yi18/menu/classify";
    
    [BaseAFN getWith:url params:param.keyValues headers:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *dict) {
    
        
        HRRecipeCategoryResult *result = [HRRecipeCategoryResult objectWithKeyValues:dict];
        
        if (success && result.success) {
            success(result);
        } else {
            JRLog(@"请求出错");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  搜索食谱
 */
+ (void)queryRecipes:(HRRecipeQueryParam *)param success:(void (^)(HRRecipeQueryResult *result))success failure:(void (^)(NSError *error))failure {
    NSString *url = @"http://apis.baidu.com/yi18/menu/search";
    
    [BaseAFN getWith:url params:param.keyValues headers:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *dict) {
        
        
        HRRecipeQueryResult *result = [HRRecipeQueryResult objectWithKeyValues:dict];
        
        if (success && result.success) {
            success(result);
        } else {
            JRLog(@"请求出错");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  菜谱列表
 */
+ (void)listRecipes:(HRRecipeQueryParam *)param success:(void (^)(HRRecipeQueryResult *result))success failure:(void (^)(NSError *error))failure {
    NSString *url = @"http://apis.baidu.com/yi18/menu/list";
    
    [BaseAFN getWith:url params:param.keyValues headers:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *dict) {
        
        
        HRRecipeQueryResult *result = [HRRecipeQueryResult objectWithKeyValues:dict];
        
        if (success && result.success) {
            success(result);
        } else {
            JRLog(@"请求出错");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  菜谱详细
 */
+ (void)recipeDetail:(HRRecipeQueryParam *)param success:(void (^)(HRRecipeResult *result))success failure:(void (^)(NSError *error))failure {
    NSString *url = @"http://apis.baidu.com/yi18/menu/detail";
    
    [BaseAFN getWith:url params:param.keyValues headers:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *dict) {
        
        
        HRRecipeResult *result = [HRRecipeResult objectWithKeyValues:dict];
        
        if (success && result.success) {
            success(result);
        } else {
            JRLog(@"请求出错");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
