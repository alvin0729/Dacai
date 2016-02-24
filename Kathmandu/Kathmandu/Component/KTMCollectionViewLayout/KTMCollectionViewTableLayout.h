//
//  KTMCollectionViewTableLayout.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/8.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMCollectionViewTableLayout : UICollectionViewLayout
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) CGFloat sectionFooterHeight;
@property (nonatomic, assign) BOOL allowsSectionHeaderFloat;
@property (nonatomic, assign) BOOL allowsSectionFooterFloat;
@end

@protocol KTMCollectionViewDelegateTableLayout <NSObject>
@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForFooterInSection:(NSInteger)section;
@end
