//
//  HRBaseListController.m
//  
//
//  Created by 王俊仁 on 15/6/23.
//
//

#import "HRBaseListController.h"
#import "HRRecipeCell.h"
#import "HRRecipeDetailController.h"
#import "HMWaterflowLayout.h"

@interface HRBaseListController ()<UICollectionViewDelegate,UICollectionViewDataSource,HMWaterflowLayoutDelegate>



@end

@implementation HRBaseListController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化CollectionView
    [self setupCollectionView];
}

/**
 *  初始化瀑布流
 */
static NSString *ID = @"cell";
- (void)setupCollectionView {
    HMWaterflowLayout *layout = [[HMWaterflowLayout alloc] init];
    layout.delegate = self;
    layout.columnsCount = 2;
    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:cv];
    
    cv.delegate = self;
    cv.dataSource = self;
    
    self.collectionView = cv;
    cv.backgroundColor = [UIColor whiteColor];
    
    [cv registerNib:[UINib nibWithNibName:@"HRRecipeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:ID];
}


- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    return width;
    
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HRRecipeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.recipe = self.recipes[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HRRecipe *recipe = self.recipes[indexPath.row];
    
    self.detailController.recipe = recipe;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = [cell convertRect:cell.bounds toView:self.view.window];
    
    JRLog(@"%@ %@",NSStringFromCGRect(cell.frame),NSStringFromCGRect(rect));
    
    self.detailController.originRect = rect;
    [self.detailController showWithAnimated:YES];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recipes.count;
}

#pragma mark - Getter Setter
- (HRRecipeDetailController *)detailController {
    if (!_detailController) {
        _detailController = [[HRRecipeDetailController alloc] init];
    }
    return _detailController;
}

- (NSMutableArray *)recipes {
    if (!_recipes) {
        _recipes = [NSMutableArray array];
    }
    return _recipes;
}




@end
