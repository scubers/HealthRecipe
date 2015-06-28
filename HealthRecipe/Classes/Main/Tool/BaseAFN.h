//
//  BaseAFN.h
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface BaseAFN : NSObject

/**
 *  基本的创建POST连接方法
 */
+ (void)postWith:(NSString *)url params:(NSDictionary *)params headers:(NSDictionary *)headers success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  基本的创建GET连接方法
 */
+ (void)getWith:(NSString *)url params:(NSDictionary *)params headers:(NSDictionary *)headers success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
