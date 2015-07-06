//
//  HRRecipeService.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "MJExtension.h"
#import "HRRecipeService.h"
#import "HRRecipeAPI.h"
#import "HRRecipeCategoryParam.h"
#import "HRRecipeCategoryResult.h"
#import "HRRecipeQueryResult.h"
#import "HRRecipeQueryParam.h"
#import "HRRecipeCategory.h"
#import "HRRecipe.h"
#import "HRRecipeResult.h"
#import "HRTempDataTool.h"

#define CategoriesFile @"Categories.plist"

@implementation HRRecipeService

/**
 *  根据层级ID获取食谱类别
 */
+ (void)getRecipeCategoriesWithHierarchy:(int)hierarchy success:(void (^)(NSArray *categories))success failure:(void (^)(NSError *error))failure {
    
    HRRecipeCategoryParam *param = [[HRRecipeCategoryParam alloc] init];
    param.ID = @(hierarchy);
    [HRRecipeAPI recipeCategoriesWithHierarchy:param success:^(HRRecipeCategoryResult *result) {
        if (success) {
            success(result.categories);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  根据关键字查询食谱
 */
+ (void)queryRecipesWithKeyword:(NSString *)keyword page:(int)page count:(int)count success:(void (^)(NSArray *recipes))success failure:(void (^)(NSError *error))failure {

    HRRecipeQueryParam *query = [[HRRecipeQueryParam alloc] init];
    if (keyword) {
        query.keyword = keyword;
    }
    if (page) {
        query.page = @(page);
    }
    if (count) {
        query.limit = @(count);
    }
    
    [HRRecipeAPI queryRecipes:query success:^(HRRecipeQueryResult *result) {
        if (success) {
            success(result.recipes);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  食谱列表
 */
+ (void)listRecipes:(NSNumber *)ID page:(int)page count:(int)count orderType:(HRRecipeOrderType)type success:(void (^)(NSArray *recipes))success failure:(void (^)(NSError *error))failure {
    
    HRRecipeQueryParam *query = [[HRRecipeQueryParam alloc] init];
    if (page) {
        query.page = @(page);
    }
    if (count) {
        query.limit = @(count);
    }
    if (ID) {
        query.ID = ID;
    }
    switch (type) {
        case HRRecipeOrderTypeID:
            query.type = @"id";
            break;
            
        case HRRecipeOrderTypeCount:
            query.type = @"count";
        default:
            break;
    }
    
    [HRRecipeAPI listRecipes:query success:^(HRRecipeQueryResult *result) {
        if (success) {
            success(result.recipes);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 *  根据ID获取单个食谱
 */
+ (void)getRecipeById:(NSNumber *)ID success:(void (^)(HRRecipe *recipe))success failure:(void (^)(NSError *error))failure {
    
    if (!ID) return;
    
    HRRecipeQueryParam *query = [[HRRecipeQueryParam alloc] init];
    query.ID = ID;
    
    HRRecipe *recipe = [HRTempDataTool tempRecipeWithID:ID];
    
    if (!recipe) {
        [HRRecipeAPI recipeDetail:query success:^(HRRecipeResult *result) {
            [HRTempDataTool saveTempRecipe:result.recipe];
            if (success) {
                success(result.recipe);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    } else {
        if (success) {
            success(recipe);
        }
        if (failure) {
            failure(nil);
        }
    }
}

/**
 *  返回所有食谱类别
 */
+ (NSArray *)listAllRecipeCategorisFromPlist:(void (^)(NSArray *categories))completion {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"plist"];
    NSString *path2 = [NSString stringWithFormat:@"%@/%@",SandboxPath,CategoriesFile];
    NSArray *array = [NSArray arrayWithContentsOfFile:path2];
    if (!array) {
        [self getRecipeCategoriesFromServer:^{
            NSArray *array = [NSArray arrayWithContentsOfFile:path2];
            NSArray *arr = [HRRecipeCategory objectArrayWithKeyValuesArray:array];
            completion(arr);
        } failure:^(NSError *error) {
            JRLog(@"%@",error);
        }];
    }

    NSArray *arr = [HRRecipeCategory objectArrayWithKeyValuesArray:array];
    return arr;
}


/**
 *  把最新的数据写入到plist文件中
 */
+ (void)getRecipeCategoriesFromServer:(void (^)())success failure:(void (^)(NSError *error))failure {
    //获得根类别
    [HRRecipeService getRecipeCategoriesWithHierarchy:0 success:^(NSArray *categories1) {
        
        for (int i=0; i<categories1.count; i++) {
            HRRecipeCategory *category = categories1[i];
            
            [HRRecipeService getRecipeCategoriesWithHierarchy:category.ID.intValue success:^(NSArray *categories2) {
                
                category.subClass = categories2;
                
                if (i == categories1.count-1) {
                    [self writeCategoriesToPlist:categories1];
                    success();
                }
                
            } failure:^(NSError *error) {
                JRLog(@"%@",error);
            }];
        }
    } failure:^(NSError *error) {
        JRLog(@"%@",error);
    }];
}

+ (void)writeCategoriesToPlist:(NSArray *)categories {
    JRLog(@"%@",SandboxPath);
    NSMutableArray *ma = [NSMutableArray array];

    for (HRRecipeCategory *cat in categories) {
        NSDictionary *dic = cat.keyValues;
        [ma addObject:dic];
        
    }
    
    [ma writeToFile:[NSString stringWithFormat:@"%@/%@",SandboxPath,CategoriesFile] atomically:YES];
}

@end













