//
//  HRRecipe.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRRecipe : NSObject <NSCoding>

/**
 *  菜谱名称
 */
@property (nonatomic,copy) NSString *name;

/**
 *  图片地址
 */
@property (nonatomic,copy) NSString *img;

/**
 *  标签
 */
@property (nonatomic,copy) NSString *tag;

/**
 *  食材
 */
@property (nonatomic,copy) NSString *food;

/**
 *  食谱做法
 */
@property (nonatomic,copy) NSString *message;

/**
 *  浏览次数
 */
@property (nonatomic,strong) NSNumber *count;

//"fcount": 0,
//"rcount": 0,
/**
 *  食谱ID
 */
@property (nonatomic,strong) NSNumber *ID;

/**
 *  功能
 */
@property (nonatomic,copy) NSString *content;


@end
