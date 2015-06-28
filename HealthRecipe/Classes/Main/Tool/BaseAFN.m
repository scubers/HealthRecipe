//
//  BaseAFN.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "BaseAFN.h"
#import "AFNetworking.h"

@implementation BaseAFN

/**
 *  基本的创建POST连接方法
 */
+ (void)postWith:(NSString *)url params:(NSDictionary *)params headers:(NSDictionary *)headers success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    if (headers) {
        NSArray *headerKeys = [headers allKeys];
        for (NSString *header in headerKeys) {
            [mgr.requestSerializer setValue:headers[header] forHTTPHeaderField:header];
        }
    }
    
    [mgr.requestSerializer setValue:@"7a54a824afa1b3c1b8e5c0c66502bf08" forHTTPHeaderField:@"apikey"];
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *errors) {
        failure(operation,errors);
    }];
    
    
}
/**
 *  基本的创建GET连接方法
 */
+ (void)getWith:(NSString *)url params:(NSDictionary *)params headers:(NSDictionary *)headers success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    if (headers) {
        NSArray *headerKeys = [headers allKeys];
        for (NSString *header in headerKeys) {
            [mgr.requestSerializer setValue:headers[header] forHTTPHeaderField:header];
        }
    }
    
    [mgr.requestSerializer setValue:@"7a54a824afa1b3c1b8e5c0c66502bf08" forHTTPHeaderField:@"apikey"];
    
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *errors) {
        failure(operation,errors);
    }];
    
}

@end
