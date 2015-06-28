//
//  HRRecipeDetailController.m
//
//
//  Created by 王俊仁 on 15/6/21.
//
//

#import "HRRecipeDetailController.h"
#import <UIImageView+WebCache.h>
#import "HRRecipe.h"
#import "HRRecipeService.h"
#import "JCRBlurView.h"
#import "HRMenuDetailView.h"
#import <POP.h>
#import <Masonry.h>
#import <POP+MCAnimate.h>

@interface HRRecipeDetailController ()

@property (nonatomic,weak) HRMenuDetailView *detailView;

@property (weak, nonatomic) UIImageView *bgImgView;
@property (weak, nonatomic) UILabel *messageLabel;
@property (nonatomic,weak) UITextView *messageView;


@end

@implementation HRRecipeDetailController

#pragma mark - 初始化

- (void)viewDidLoad {
    [super viewDidLoad];

    HRMenuDetailView *dv = [[[NSBundle mainBundle] loadNibNamed:@"HRMenuDetailView" owner:nil options:nil] lastObject];
    self.detailView = dv;
    dv.recipe = self.recipe;
    self.view = dv;
}




#pragma mark - 公共方法
- (void)showWithAnimated:(BOOL)animate {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    self.view.frame = self.originRect;
    
    WEAK_SELF(ws)
    [NSObject pop_animate:^{
        ws.view.pop_spring.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        ws.view.pop_duration = 0.25;
        ws.view.pop_linear.alpha = 1;
    } completion:^(BOOL finished) {
        [ws.view pop_removeAllAnimations];
    }];
    
}

- (void)hideWithAnimated:(BOOL)animate {
    WEAK_SELF(ws)
    [NSObject pop_animate:^{
        ws.view.pop_spring.frame = ws.originRect;
        ws.view.pop_duration = 0.25;
        ws.view.pop_linear.alpha = 0.1;
    } completion:^(BOOL finished) {
        [ws.view removeFromSuperview];
        [ws.view pop_removeAllAnimations];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideWithAnimated:YES];
}

#pragma mark - Getter Setter
- (void)setRecipe:(HRRecipe *)recipe {
    _recipe = recipe;
    self.detailView.recipe = recipe;
}

@end














