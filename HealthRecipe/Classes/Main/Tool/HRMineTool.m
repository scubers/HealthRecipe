//
//  HRMineTool.m
//  
//
//  Created by 王俊仁 on 15/6/22.
//
//

#define MyFavoriteFile @"MyFavoriteFile.data"
#define MySearchRecord @"MySearchRecord.data"

#import "HRMineTool.h"
#import "HRRecipe.h"

@interface HRMineTool()



@end

@implementation HRMineTool

singleton_implementation(HRMineTool)

- (void)saveData {
    [NSKeyedArchiver archiveRootObject:self.favoriteRecipes toFile:[NSString stringWithFormat:@"%@/%@",SandboxPath,MyFavoriteFile]];
    [NSKeyedArchiver archiveRootObject:self.searchRecord toFile:[NSString stringWithFormat:@"%@/%@",SandboxPath,MySearchRecord]];
}

- (void)loadData {
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SandboxPath,MyFavoriteFile]];
    self.favoriteRecipes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSData *data1 = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SandboxPath,MySearchRecord]];
    self.searchRecord = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
}

#pragma mark - 公共方法
- (void)addFavoriteRecipes:(HRRecipe *)recipe {
    if (!recipe) return;
    [self.favoriteRecipes addObject:recipe];
    [self saveData];
}

- (void)addSearchRecord:(NSString *)text {
    if (!text || [self.searchRecord containsObject:text]) return ;
    
    [self.searchRecord insertObject:text atIndex:0];
    if (self.searchRecord.count > 10) {
        [self.searchRecord removeLastObject];
    }
    [self saveData];
}

#pragma mark - Getter Setter
- (NSMutableArray *)favoriteRecipes {
    if (!_favoriteRecipes) {
        [self loadData];
        
        if (!_favoriteRecipes) {
            _favoriteRecipes = [NSMutableArray array];
        }
    }
    return _favoriteRecipes;
}

- (NSMutableArray *)searchRecord {
    if (!_searchRecord) {
        [self loadData];
        if (!_searchRecord) {
            _searchRecord = [NSMutableArray array];
        }
    }
    return _searchRecord;
}
@end
