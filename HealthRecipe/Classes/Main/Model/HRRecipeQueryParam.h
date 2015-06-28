//
//  HRRecipeQueryParam.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRBaseResult.h"

@interface HRRecipeQueryParam : NSObject

/**
 *  请求页数，默认是1
 */
@property (nonatomic,strong) NSNumber *page;

/**
 *  每页返回的条数，默认是20
 */
@property (nonatomic,strong) NSNumber *limit;

/**
 *  搜索的关键词
 */
@property (nonatomic,copy) NSString *keyword;

/**
 *  菜谱分类
 */
@property (nonatomic,strong) NSNumber *ID;

/**
 *  排序方式
 */
@property (nonatomic,copy) NSString *type;

@end
