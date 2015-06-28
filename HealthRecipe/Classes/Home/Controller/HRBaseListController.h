//
//  HRBaseListController.h
//  
//
//  Created by 王俊仁 on 15/6/23.
//
//

#import <UIKit/UIKit.h>
@class HRRecipeDetailController;

@interface HRBaseListController : UIViewController

@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *recipes;

@property (nonatomic,strong) HRRecipeDetailController *detailController;

@end
