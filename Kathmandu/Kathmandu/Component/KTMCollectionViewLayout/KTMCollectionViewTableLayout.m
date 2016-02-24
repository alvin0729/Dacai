//
//  KTMCollectionViewTableLayout.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/8.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMCollectionViewTableLayout.h"

#if CGFLOAT_IS_DOUBLE
#define CGFLOAT_EPSILON DBL_EPSILON
#else
#define CGFLOAT_EPSILON FLT_EPSILON
#endif

@interface KTMCollectionViewTableLayout ()
@property (nonatomic, weak, readonly) id<KTMCollectionViewDelegateTableLayout> delegate;
@property (nonatomic, strong) NSArray<NSArray<UICollectionViewLayoutAttributes *> *> *cellLayoutAttributes;
@property (nonatomic, strong) NSArray<UICollectionViewLayoutAttributes *> *supplementaryLayoutAttributes;
@property (nonatomic, strong) NSArray<UICollectionViewLayoutAttributes *> *headerLayoutAttributes;
@property (nonatomic, strong) NSArray<UICollectionViewLayoutAttributes *> *footerLayoutAttributes;
@property (nonatomic, assign) CGSize collectionViewContentSize;
@end

@implementation KTMCollectionViewTableLayout

- (instancetype)init {
    if (self = [super init]) {
        _rowHeight = 44;
    }
    return self;
}

#pragma mark - Override

- (void)prepareLayout {
    struct {
        unsigned heightForRowAtIndexPath : 1;
        unsigned heightForHeaderInSection : 1;
        unsigned heightForFooterInSection : 1;
    } hasDelegate;
    
    // 是否实现了代理方法
    hasDelegate.heightForRowAtIndexPath = [self.delegate respondsToSelector:@selector(collectionView:heightForRowAtIndexPath:)];
    hasDelegate.heightForHeaderInSection = [self.delegate respondsToSelector:@selector(collectionView:heightForHeaderInSection:)];
    hasDelegate.heightForFooterInSection = [self.delegate respondsToSelector:@selector(collectionView:heightForFooterInSection:)];
    
    // 属性集合
    NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> *cellLayoutAttributes = [NSMutableArray array];
    NSMutableArray<UICollectionViewLayoutAttributes *> *supplementaryLayoutAttributes = [NSMutableArray array];
    NSMutableArray<UICollectionViewLayoutAttributes *> *headerLayoutAttributes = [NSMutableArray array];
    NSMutableArray<UICollectionViewLayoutAttributes *> *footerLayoutAttributes = [NSMutableArray array];
    
    CGFloat offsetY = 0, offsetX = 0;
    CGFloat itemWidth = CGRectGetWidth(self.collectionView.bounds);
    
    // 遍历
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    for (int section = 0; section < numberOfSections; section++) {
        NSIndexPath *supplementaryIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        
        // Section Header
        CGFloat heightForHeader = hasDelegate.heightForHeaderInSection ?
            [self.delegate collectionView:self.collectionView heightForHeaderInSection:section] : self.sectionHeaderHeight;
        
        if (heightForHeader > CGFLOAT_EPSILON) {
            UICollectionViewLayoutAttributes *headerItemAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:supplementaryIndexPath];
            headerItemAttribute.frame = CGRectMake(offsetX, offsetY, itemWidth, heightForHeader);
            headerItemAttribute.zIndex = NSIntegerMax;
            
            offsetY += heightForHeader;
            
            [headerLayoutAttributes addObject:headerItemAttribute];
            [supplementaryLayoutAttributes addObject:headerItemAttribute];
        }
            
        // Section Items
        NSMutableArray<UICollectionViewLayoutAttributes *> *cellInSectionAttributes = [NSMutableArray array];
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < numberOfItemsInSection; row++) {
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            CGFloat heightForCell = hasDelegate.heightForRowAtIndexPath ? [self.delegate collectionView:self.collectionView heightForRowAtIndexPath:itemIndexPath] : self.rowHeight;
            UICollectionViewLayoutAttributes *cellItemAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
            cellItemAttribute.frame = CGRectMake(offsetX, offsetY, itemWidth, heightForCell);
            
            offsetY += heightForCell;
            
            [cellInSectionAttributes addObject:cellItemAttribute];
        }
        
            
        CGFloat heightForFooter = hasDelegate.heightForFooterInSection ?
            [self.delegate collectionView:self.collectionView heightForFooterInSection:section] : self.sectionFooterHeight;
        if (heightForFooter > CGFLOAT_EPSILON) {
            UICollectionViewLayoutAttributes *footerItemAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:supplementaryIndexPath];
            footerItemAttribute.frame = CGRectMake(offsetX, offsetY, itemWidth, heightForFooter);
            footerItemAttribute.zIndex = NSIntegerMax;
            
            offsetY += heightForFooter;
            
            [footerLayoutAttributes addObject:footerItemAttribute];
            [supplementaryLayoutAttributes addObject:footerItemAttribute];
        }
            
        [cellLayoutAttributes addObject:cellInSectionAttributes];
    }
    
    self.collectionViewContentSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), offsetY);
    self.cellLayoutAttributes = cellLayoutAttributes;
    self.supplementaryLayoutAttributes = supplementaryLayoutAttributes;
    self.headerLayoutAttributes = headerLayoutAttributes;
    self.footerLayoutAttributes = footerLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellLayoutAttributes[indexPath.section][indexPath.row];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    for (UICollectionViewLayoutAttributes *attribute in self.supplementaryLayoutAttributes) {
        if ([attribute.representedElementKind isEqualToString:elementKind] && [attribute.indexPath isEqual:indexPath]) {
            return attribute;
        }
    }
    return nil;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *elements = [NSMutableArray array];
    // performance
    for (NSArray<UICollectionViewLayoutAttributes *> *cellInSectionAttributes in self.cellLayoutAttributes) {
        for (UICollectionViewLayoutAttributes *cellItemAttribute in cellInSectionAttributes) {
            if (CGRectIntersectsRect(rect, cellItemAttribute.frame)) {
                [elements addObject:cellItemAttribute];
            }
        }
    }
    
    if (self.allowsSectionHeaderFloat) {
    }
    if (self.allowsSectionFooterFloat) {
        
    }
    
    for (UICollectionViewLayoutAttributes *supplementaryItemAttribute in self.supplementaryLayoutAttributes) {
        if (CGRectIntersectsRect(rect, supplementaryItemAttribute.frame)) {
            [elements addObject:supplementaryItemAttribute];
        }
    }
    return elements;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return CGRectGetWidth(newBounds) != CGRectGetWidth(self.collectionView.frame);
}

#pragma mark - Property (getter, setter)

- (id<KTMCollectionViewDelegateTableLayout>)delegate {
    return (id)self.collectionView.delegate;
}

@end
