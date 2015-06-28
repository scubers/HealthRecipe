//
//  HRRecipeService.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HRRecipe;

typedef enum {
    HRRecipeOrderTypeID,   //根据最新事件排序
    HRRecipeOrderTypeCount //根据浏览量排序
} HRRecipeOrderType;

@interface HRRecipeService : NSObject
/**
 *  根据层级ID获取食谱类别
 */
+ (void)getRecipeCategoriesWithHierarchy:(int)hierarchy success:(void (^)(NSArray *categories))success failure:(void (^)(NSError *error))failure ;
/**
 *  根据关键字查询食谱
 */
+ (void)queryRecipesWithKeyword:(NSString *)keyword page:(int)page count:(int)count success:(void (^)(NSArray *recipes))success failure:(void (^)(NSError *error))failure ;

/**
 *  食谱列表
 */
+ (void)listRecipes:(NSNumber *)ID page:(int)page count:(int)count orderType:(HRRecipeOrderType)type success:(void (^)(NSArray *recipes))success failure:(void (^)(NSError *error))failure;

/**
 *  根据ID获取单个食谱
 */
+ (void)getRecipeById:(NSNumber *)ID success:(void (^)(HRRecipe *recipe))success failure:(void (^)(NSError *error))failure;

/**
 *  返回所有食谱类别
 */
+ (NSArray *)listAllRecipeCategorisFromPlist:(void (^)(NSArray *categories))completion;

/**
 *  把最新的数据写入到plist文件中
 */
+ (void)getRecipeCategoriesFromServer:(void (^)())success failure:(void (^)(NSError *error))failure ;

@end
