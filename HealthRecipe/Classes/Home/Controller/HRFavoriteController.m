//
//  HRHomeController.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//
#define BaseHeightForRow 100


#import "HRRecipeCell.h"
#import "HRFavoriteController.h"
#import "HRRecipe.h"
#import "HRRecipeService.h"
#import <BlocksKit.h>
#import <MJRefresh.h>
#import "HRMenuDetailView.h"
#import "HMWaterflowLayout.h"
#import "HRRecipeDetailController.h"
#import "HRMineTool.h"
#import <ReactiveCocoa.h>


@interface HRFavoriteController () <UISearchBarDelegate>

@property (nonatomic,weak) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *searchRecord;
@property (nonatomic,strong) UITextField *tempField;


@end

@implementation HRFavoriteController

#pragma mark - 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNvigationBar];
    //加载数据
    [self loadRecipesData];
    
    //设置信号
    [self setupSignal];
}

- (void)setupNvigationBar {
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UISearchBar *bar = [[UISearchBar alloc] init];
    self.searchBar = bar;
    self.navigationItem.titleView = bar;
    bar.delegate = self;

    
}

#pragma mark - 设置响应信号
- (void)setupSignal {
    
    [[[[[self.tempField rac_signalForSelector:@selector(setText:)]
        
     filter:^BOOL(RACTuple *tuple) { //过滤搜索字符串的长度
         if ([tuple.first length] > 0) {
             return YES;
         } else {
             [self loadRecipesData];
             [self.collectionView reloadData];
             return NO;
         }
     }]
      
     throttle:0.5] //设置时间间隔
     
     map:^id(RACTuple *tuple) { //转换传递数据类型
         
         NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS %@", tuple.first];
         return [self.recipes filteredArrayUsingPredicate:pre];
         
     }]
     
     subscribeNext:^(NSArray *recipes) {  //终端处理数据
         self.recipes = [NSMutableArray arrayWithArray:recipes];
         [self.collectionView reloadData];
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.tempField.text = searchText;
}


#pragma mark - 私有内部方法


- (void)loadRecipesData {
    HRMineTool *mineTool = [HRMineTool sharedHRMineTool];
    self.recipes = mineTool.favoriteRecipes;
}

- (void)dealloc {
    JRLog(@"favorite销毁了")
}

#pragma mark - Getter Setter
- (NSMutableArray *)searchRecord {
    if (!_searchRecord) {
        _searchRecord = [NSMutableArray array];
    }
    return _searchRecord;
}

- (UITextField *)tempField {
    if (!_tempField) {
        _tempField = [[UITextField alloc] init];
    }
    return _tempField;
}

@end
