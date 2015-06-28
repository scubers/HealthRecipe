//
//  HRRecipeCategory.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRRecipeCategory : NSObject

/**
 *  分类名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  分类级别
 */
@property (nonatomic,strong) NSNumber *cookclass;
/**
 *  分类ID
 */
@property (nonatomic,strong) NSNumber *ID;

/**
 *  子类别
 */
@property (nonatomic,strong) NSArray *subClass;

/**
 *  是否打开子类型
 */
@property (nonatomic,assign,getter=isOpenSub) BOOL openSub;

@end
