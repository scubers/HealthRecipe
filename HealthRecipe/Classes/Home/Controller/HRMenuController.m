//
//  HRMenuController.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/7.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "HRMenuController.h"
#import <REFrostedViewController.h>
#import "HRRecipeCategory.h"
#import "HRRecipeService.h"
#import <BlocksKit.h>
#import <MJExtension.h>
#import "HRMenuHeaderView.h"

#define MenuGroupTitleFontSize 16
#define MenuTitleFontSize 15

@interface HRMenuController () <REFrostedViewControllerDelegate>

@property (nonatomic,assign) int selectedSession;
@property (nonatomic,weak) HRMenuHeaderView *headView;

@end

@implementation HRMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupMenuData];
    
}

- (void)setupTableView {
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    HRMenuHeaderView *headerView = [[HRMenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, 200, 180)];
    self.tableView.tableHeaderView = headerView;
    self.headView = headerView;
    
}

- (void)setupMenuData {
    WEAK_SELF(ws)
    self.categories = [HRRecipeService listAllRecipeCategorisFromPlist:^(NSArray *categories) {
        ws.categories = categories;
        [ws.tableView reloadData];
    }];
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = RGBColor(62, 68, 75);
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    HRRecipeCategory *category = self.categories[sectionIndex];
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,0,tableView.frame.size.width, 34);
    [btn setTitle:category.name forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:MenuGroupTitleFontSize];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tapSession:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag = sectionIndex;
    
    return btn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[MenuControllerSelectedIndexPath] = indexPath;
    userInfo[MenuControllerMenus] = self.categories;
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuControllerDidSelectedRowNotification object:self userInfo:userInfo];
    [self.frostedViewController hideMenuViewController];
    

}


#pragma mark - UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 34;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    HRRecipeCategory *category = self.categories[sectionIndex];
    if (!category.isOpenSub) {
        return 0;
    }
    return category.subClass.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRRecipeCategory *category = [self.categories[indexPath.section] subClass][indexPath.row];
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = category.name;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:MenuTitleFontSize];
    return cell;
}

#pragma mark - 私有方法


#pragma mark - 事件响应
- (void)tapSession:(UIButton *)button {
    HRRecipeCategory *category = self.categories[self.selectedSession];
    NSMutableIndexSet *is = [NSMutableIndexSet indexSetWithIndex:self.selectedSession];
    if (self.selectedSession == button.tag) {
        category.openSub = !category.isOpenSub;
    } else {
        category.openSub = NO;
        category = self.categories[button.tag];
        category.openSub = YES;
        self.selectedSession = (int)button.tag;
        [is addIndex:button.tag];
    }
    [self.tableView reloadSections:is withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 菜单代理

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[MenuDidRecognizePanGestureNotificationUserInfoKey] = recognizer;
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuDidRecognizePanGestureNotification object:nil userInfo:userInfo];
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuWillShowMenuViewControllerNotification object:nil];
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuDidShowMenuViewControllerNotification object:nil];
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuWillHideMenuViewControllerNotification object:nil];
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuDidHideMenuViewControllerNotification object:nil];
}

@end
