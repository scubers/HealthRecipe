//
//  HRSearchController.m
//  
//
//  Created by 王俊仁 on 15/6/23.
//
//

#import "HRSearchController.h"
#import <ReactiveCocoa.h>
#import <BlocksKit.h>
#import "HRRecipeService.h"
#import <MJRefresh.h>
#import "HRMineTool.h"
#import <Masonry.h>


@interface HRSearchController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

/**
 *  搜索控件
 */
@property (nonatomic,weak) UISearchBar *searchBar;
/**
 *  中转输入框
 */
@property (nonatomic,strong) UITextField *tempField;

@property (nonatomic,assign) int currentPage;

@property (nonatomic,weak) HRMineTool *mineTool;

@property (nonatomic,weak) UITableView *searchRecordView;

@end

@implementation HRSearchController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self stupNavigationBar];
    [self setupRefresh];
    [self setupSubviews];
    
    //使用响应式绑定数据
    [self setupSignal];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchRecordView reloadData];
}

- (void)setupSubviews {
    UITableView *srv = [[UITableView alloc] init];
    srv.dataSource = self;
    srv.delegate = self;
    
    self.searchRecordView = srv;
    
    srv.frame = CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT);
    [self.view addSubview:srv];

    
}

- (void)stupNavigationBar {
    UISearchBar *sb = [[UISearchBar alloc] init];
    self.navigationItem.titleView = sb;
    self.searchBar = sb;
    sb.delegate = self;
    
    UIButton *lebut = [UIButton buttonWithType:UIButtonTypeCustom];
    lebut.titleLabel.font = [UIFont systemFontOfSize:12];
    [lebut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lebut setTitle:@"取消" forState:UIControlStateNormal];
    lebut.size = CGSizeMake(35, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:lebut];
    
//    WEAK_SELF ws = self;
    WEAK_SELF(ws)
    [[lebut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [ws dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

/**
 *  设置刷新控件
 */
- (void)setupRefresh {
    self.collectionView.legendFooter.automaticallyRefresh = NO;
    self.collectionView.legendFooter.appearencePercentTriggerAutoRefresh = -1;
    WEAK_SELF(ws)
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        [ws startSearch:++ws.currentPage];
    }];
}

- (void)test {
    JRLog(@"3333");
}

#pragma mark - ReactiveCocoa响应
- (void)setupSignal {
    
    [[[[[[[self.tempField rac_signalForSelector:@selector(setText:)]

    filter:^BOOL(RACTuple *tuple) {
        
        if ([tuple.first length] > 0) {
            return YES;
        } else {
            self.searchRecordView.hidden = NO;
            return NO;
        }

    }] throttle:0.6]
        
    flattenMap:^RACStream *(id value) {
        JRLog(@"2----%@",value);
        return [self signalForQueryRecipe];
        
    }] map:^id(NSArray *recipes) {
        return [NSMutableArray arrayWithArray:recipes];
        
    }] deliverOnMainThread]
     
    subscribeNext:^(NSMutableArray *recipes) {
        self.recipes = recipes;
        [self.collectionView reloadData];
    }];
}

- (RACSignal *)signalForQueryRecipe {
    
    WEAK_SELF(ws)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        ws.searchRecordView.hidden = YES;
       [HRRecipeService queryRecipesWithKeyword:ws.tempField.text page:0 count:0 success:^(NSArray *recipes) {
           [subscriber sendNext:recipes];
           [subscriber sendCompleted];
       } failure:^(NSError *error) {
           [subscriber sendError:error];
       }];
        return nil;
    }];
}


#pragma mark - UITableView数据源 | 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mineTool.searchRecord.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSString *text = self.mineTool.searchRecord[indexPath.row];
    cell.textLabel.text = text;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.searchBar.text = cell.textLabel.text;
    [self.searchBar endEditing:YES];
    [self startSearch:0];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [self.searchBar endEditing:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    JRLog(@"0---%@",searchText);
    self.tempField.text = searchText;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchRecordView.hidden = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
    [self startSearch:0];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *keyword = self.searchBar.text;
    [self.mineTool addSearchRecord:keyword];
}

#pragma mark - 私有内部方法

- (void)startSearch:(int)page {
    self.searchRecordView.hidden = YES;
    NSString *keyword = self.searchBar.text;
    [self.mineTool addSearchRecord:keyword];
    WEAK_SELF(ws)
    [HRRecipeService queryRecipesWithKeyword:keyword page:page count:0 success:^(NSArray *recipes) {
        if (page == 0) {
            ws.recipes = [NSMutableArray arrayWithArray:recipes];
        } else {
            [ws.recipes addObjectsFromArray:recipes];
        }
        [ws.collectionView reloadData];
        [ws.collectionView.legendFooter endRefreshing];
    } failure:^(NSError *error) {
        JRLog(@"%@",error);
        [ws.collectionView.legendFooter endRefreshing];
    }];
}

#pragma mark - Getter Setter
- (HRMineTool *)mineTool {
    return [HRMineTool sharedHRMineTool];
}

- (UITextField *)tempField {
    if (!_tempField) {
        _tempField = [[UITextField alloc] init];
    }
    return _tempField;
}

- (void)dealloc {
    JRLog(@"searchcontroller销毁了");
}



@end
