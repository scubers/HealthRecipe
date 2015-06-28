//
//  HRRecipeCell.m
//  
//
//  Created by 王俊仁 on 15/6/16.
//
//

#import "HRRecipeCell.h"
#import <UIImageView+WebCache.h>
#import "HRRecipe.h"

@interface HRRecipeCell()

/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**
 *  菜名
 */
@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;

@end

@implementation HRRecipeCell


- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)setRecipe:(HRRecipe *)recipe {
    _recipe = recipe;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:recipe.img]];
    self.recipeNameLabel.text = recipe.name;
    
}

@end
