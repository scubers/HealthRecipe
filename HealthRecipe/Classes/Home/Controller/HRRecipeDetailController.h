//
//  HRRecipeDetailController.h
//
//
//  Created by 王俊仁 on 15/6/21.
//
//

#import <UIKit/UIKit.h>
@class HRRecipe;

@interface HRRecipeDetailController : UIViewController

@property (nonatomic,strong) HRRecipe *recipe;

/**
 *  缩放的原始位置
 */
@property (nonatomic,assign) CGRect originRect;

- (void)showWithAnimated:(BOOL)animate;
- (void)hideWithAnimated:(BOOL)animate;

@end
