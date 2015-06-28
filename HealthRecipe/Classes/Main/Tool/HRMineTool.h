//
//  HRMineTool.h
//  
//
//  Created by 王俊仁 on 15/6/22.
//
//

#import <Foundation/Foundation.h>
@class HRRecipe;

@interface HRMineTool : NSObject

singleton_interface(HRMineTool)


@property (nonatomic,strong) NSMutableArray *favoriteRecipes;

@property (nonatomic,strong) NSMutableArray *searchRecord;

- (void)saveData;
- (void)loadData;

- (void)addFavoriteRecipes:(HRRecipe *)recipe;
- (void)addSearchRecord:(NSString *)text;

@end
