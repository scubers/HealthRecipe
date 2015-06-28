//
//  HRHomeController.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//
#define BaseHeightForRow 100


#import "HRRecipeCell.h"
#import "HRHomeController.h"
#import "HRRecipe.h"
#import "HRRecipeService.h"
#import "HRRecipeCategory.h"
#import <BlocksKit.h>
#import "HRMenuController.h"
#import <REFrostedViewController.h>
#import <MJRefresh.h>
#import "HRMenuDetailView.h"
#import "HRRecipeLayout.h"
#import "HMWaterflowLayout.h"
#import "HRRecipeDetailController.h"
#import <ReactiveCocoa.h>
#import "HRFavoriteController.h"
#import "HRSearchController.h"
#import "LTInfiniteScrollView.h"


@interface HRHomeController () <LTInfiniteScrollViewDelegate,LTInfiniteScrollViewDataSource>


@property (nonatomic,assign) int currentPage;
@property (nonatomic,strong) HRRecipeCategory *currentCategory;
@property (nonatomic,weak) LTInfiniteScrollView *infiniteView;

@end

@implementation HRHomeController

#pragma mark - 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNvigationBar];
    //加载数据
    [self loadRecipesData:self.currentPage];
    //初始化通知
    [self setupNotification];
    //初始化刷新控件
    [self setupRefresh];
    
    //设置顶部滚动栏
    [self setupScrollView];
    
}

/**
 *  设置顶部滚动栏
 */
- (void)setupScrollView {
    LTInfiniteScrollView *infiniteView = [[LTInfiniteScrollView alloc]initWithFrame:CGRectMake(0, -100, CGRectGetWidth(self.view.bounds), 100)];
    self.infiniteView = infiniteView;
    [self.collectionView addSubview:infiniteView];
    infiniteView.dataSource = self;
    [self.infiniteView reloadData];
    
//    infiniteView.pagingEnabled = YES;
//    infiniteView.scrollEnabled = YES;
    
    JRLog(@"%d %d",infiniteView.scrollEnabled,infiniteView.pagingEnabled);
    
    UIEdgeInsets insets = self.collectionView.contentInset;
    self.collectionView.contentInset = UIEdgeInsetsMake(insets.top+100, insets.left, insets.bottom, insets.right);

}

- (void)setupNvigationBar {
    self.navigationItem.title = @"菜谱列表";
    UIButton *ribut = [UIButton buttonWithType:UIButtonTypeCustom];
    ribut.titleLabel.font = [UIFont systemFontOfSize:12];
    [ribut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ribut setTitle:@"我的收藏" forState:UIControlStateNormal];
    ribut.size = CGSizeMake(50, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ribut];
    
    UIButton *lebut = [UIButton buttonWithType:UIButtonTypeCustom];
    lebut.titleLabel.font = [UIFont systemFontOfSize:12];
    [lebut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lebut setTitle:@"搜索" forState:UIControlStateNormal];
    lebut.size = CGSizeMake(35, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:lebut];
    
    [[ribut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        HRFavoriteController *fc = [[HRFavoriteController alloc] init];
        [self.navigationController pushViewController:fc animated:YES];
    }];
    [[lebut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        HRSearchController *fc = [[HRSearchController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
    }];

}

/**
 *  设置刷新控件
 */
- (void)setupRefresh {
    self.collectionView.legendFooter.automaticallyRefresh = NO;
    self.collectionView.legendFooter.appearencePercentTriggerAutoRefresh = -1;
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        [self loadRecipesData:++self.currentPage];
    }];
}

/**
 *  设置通知监听
 */
- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryDidChange:) name:MenuControllerDidSelectedRowNotification object:nil];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - LTInfiniteViewDataSource,LTInfiniteViewDelegate

- (NSInteger)numberOfViews {
    return 100;
}
- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view) {
        ((UILabel*)view).text = [NSString stringWithFormat:@"%ld", index];
        return view;
    }
    
    UILabel *aView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    aView.backgroundColor = [UIColor blackColor];
    aView.layer.cornerRadius = 32;
    aView.layer.masksToBounds = YES;
    aView.backgroundColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    aView.textColor = [UIColor whiteColor];
    aView.textAlignment = NSTextAlignmentCenter;
    aView.text = [NSString stringWithFormat:@"%ld", index];
    return aView;
}

- (NSInteger)numberOfVisibleViews {
    return 1;
}

#pragma mark - 通知响应方法
- (void)categoryDidChange:(NSNotification *)noti {
    NSArray *categories = noti.userInfo[MenuControllerMenus];
    NSIndexPath *indexPath = noti.userInfo[MenuControllerSelectedIndexPath];
    HRRecipeCategory *category = categories[indexPath.section];
    category = category.subClass[indexPath.row];
    self.currentCategory = category;
    self.navigationItem.title = category.name;
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self loadRecipesData:0];

}

#pragma mark - 私有内部方法


- (void)loadRecipesData:(int)page {
    [HRRecipeService listRecipes:self.currentCategory.ID page:page count:0 orderType:HRRecipeOrderTypeID success:^(NSArray *recipes) {
        if (!recipes || !recipes.count) {
            [MBProgressHUD showError:@"没有更多菜谱了" toView:self.view];
        }
        if (page == 0) {
            self.recipes = [NSMutableArray arrayWithArray:recipes];
        } else {
            [self.recipes addObjectsFromArray:recipes];
        }
        [self.collectionView reloadData];
        [self.collectionView.legendFooter endRefreshing];
    } failure:^(NSError *error) {
        JRLog(@"%@",error);
        [self.collectionView.legendFooter endRefreshing];
    }];
}




@end
