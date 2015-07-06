//
//  HRTempDataTool.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/7/3.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "HRTempDataTool.h"
#import <FMDB.h>
#import "HRRecipe.h"

#define TempDataFile @"TempData.db"
#define TempRecipeData @"tb_TempRecipeData"

#define TestPath @"/Users/Jrwong/Desktop"

@implementation HRTempDataTool

static NSDateFormatter *_fmt;
static FMDatabase *_db;
+ (void)initialize {
    NSString *path = [NSString stringWithFormat:@"%@/%@",SandboxPath,TempDataFile];
    _db = [FMDatabase databaseWithPath:path];

    if (![_db open]) {
        JRLog(@"打开TempData数据库失败");
    }
    
    if (![_db tableExists:TempRecipeData]) {
        NSString *sql = [NSString stringWithFormat:@"create table %@ (recipeId long primary key,recipeObj block, expireDate datetime) ",TempRecipeData];
        [_db executeUpdate:sql];
    }

    
}

/**
 *  保存食谱缓存
 */
+ (void)saveTempRecipe:(HRRecipe *)recipe {
    NSString *sql = [NSString stringWithFormat:@" insert into %@ (recipeId,recipeObj,expireDate) values (?,?,?) ", TempRecipeData];
    [_db executeUpdate:sql,recipe.ID,[NSKeyedArchiver archivedDataWithRootObject:recipe],[self.fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:60*60*3]]];
}

/**
 *  根据食谱ID获取食谱
 */
+ (HRRecipe *)tempRecipeWithID:(NSNumber *)ID {
    NSString *sql = [NSString stringWithFormat:@" select * from %@ where recipeId = ? ", TempRecipeData];
    
    FMResultSet *rs = [_db executeQuery:sql, ID];

    if ([rs next]) {
        NSString *dateStr = [rs stringForColumn:@"expireDate"];
        NSDate *expiredDate = [self.fmt dateFromString:dateStr];
        if ([expiredDate compare:[NSDate date]] == NSOrderedAscending) {
            NSString *sql2 = [NSString stringWithFormat:@" delete from %@ where recipeId = ? ", TempRecipeData];
            [_db executeUpdate:sql2, ID];
            return nil;
        }
        
        NSData *data = [rs dataForColumn:@"recipeObj"];
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}


+ (NSDateFormatter *)fmt {
    if (!_fmt) {
        _fmt = [[NSDateFormatter alloc] init];
        _fmt.locale = [NSLocale systemLocale];
        _fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _fmt;
}

@end
