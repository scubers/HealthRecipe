//
//  HRTempDataTool.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/7/3.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HRRecipe;

@interface HRTempDataTool : NSObject

/**
 *  保存食谱缓存
 */
+ (void)saveTempRecipe:(HRRecipe *)recipe;

/**
 *  根据食谱ID获取食谱
 */
+ (HRRecipe *)tempRecipeWithID:(NSNumber *)ID;

@end
