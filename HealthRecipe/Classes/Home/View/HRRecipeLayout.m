//
//  HRRecipeLayout.m
//  
//
//  Created by 王俊仁 on 15/6/16.
//
//

#import "HRRecipeLayout.h"

@implementation HRRecipeLayout


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [[UICollectionViewLayoutAttributes alloc] init];
    attr.size = CGSizeMake(150, 100);
    return attr;
}

@end
