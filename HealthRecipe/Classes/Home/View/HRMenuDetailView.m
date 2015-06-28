//
//  HRMenuDetailView.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/7.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "HRMenuDetailView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "HRRecipeService.h"
#import "HRRecipe.h"
#import "HRMineTool.h"
#import <ReactiveCocoa.h>

@interface HRMenuDetailView()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (nonatomic,weak) IBOutlet UITextView *messageView;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *countButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation HRMenuDetailView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupSignal];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setupSubviews];
        [self setupSignal];
    }
    return self;
}

- (void)setupSubviews {
    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    [self addSubview:titleLabel];
//    self.titleLabel = titleLabel;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    UIImageView *iv = [[UIImageView alloc] init];
//    [self addSubview:iv];
//    self.bgImgView = iv;
//    
//    UITextView *messageView = [[UITextView alloc] init];
//    [self addSubview:messageView];
//    self.messageView = messageView;
//    messageView.editable = NO;
//    messageView.backgroundColor = [UIColor clearColor];
//    
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(titleLabel.superview);
//        make.top.mas_equalTo(titleLabel.superview).offset(30);
//        make.height.mas_equalTo(40);
//    }];
//    
//    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(300,200));
//        make.top.mas_equalTo(80);
//        make.centerX.mas_equalTo(iv.superview);
//    }];
//    
//    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(iv.mas_bottom);
//        make.width.mas_equalTo(iv.mas_width);
//        make.bottom.mas_equalTo(messageView.superview);
//        make.centerX.mas_equalTo(messageView.superview);
//    }];
//    
}

#pragma mark - 响应信号
- (void)setupSignal {
    
    WEAK_SELF(ws)
    
    [[[self rac_signalForSelector:@selector(setRecipe:)]
      
      flattenMap:^RACStream *(RACTuple *tuple) {
          return [ws signalForRecipeChange:tuple.first];
      }]
     
     subscribeNext:^(HRRecipe *recipe) {
         ws.messageView.text = recipe.message;
         ws.titleLabel.text = recipe.name;
         NSString *countStr = [NSString stringWithFormat:@"浏览数：%d",[recipe.count intValue]];
         [ws.countButton mas_updateConstraints:^(MASConstraintMaker *make) {
             make.width.mas_equalTo(200);
         }];
         [ws.countButton setTitle:countStr forState:UIControlStateNormal];
     }];
}

- (RACSignal *)signalForRecipeChange:(HRRecipe *)sourceRecipe {

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HRRecipeService getRecipeById:sourceRecipe.ID success:^(HRRecipe *recipe) {
            [subscriber sendNext:recipe];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            JRLog(@"%@",error);
            [subscriber sendError:error];
        }];

        return nil;
    }];
}

#pragma mark - 事件响应
- (IBAction)collectionClick:(id)sender {
    self.likeButton.selected = !self.likeButton.isSelected;
    HRMineTool *mineTool = [HRMineTool sharedHRMineTool];
    
    if (self.likeButton.isSelected) {
        if (![mineTool.favoriteRecipes containsObject:self.recipe]) {
            [mineTool addFavoriteRecipes:self.recipe];
        }
    } else {
        [mineTool.favoriteRecipes removeObject:self.recipe];
        [mineTool saveData];
    }
    
}

#pragma mark - getter setter
- (void)setRecipe:(HRRecipe *)recipe {
    _recipe = recipe;
    if ([[HRMineTool sharedHRMineTool].favoriteRecipes containsObject:recipe]) {
        self.likeButton.selected = YES;
    } else {
        self.likeButton.selected = NO;
    }
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:recipe.img]];
}


@end
