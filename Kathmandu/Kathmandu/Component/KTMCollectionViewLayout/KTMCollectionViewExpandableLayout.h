//
//  KTMCollectionViewExpandableLayout.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/11.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMCollectionViewExpandableLayout : UICollectionViewLayout

@end


@protocol KTMCollectionViewDelegateExpandableLayout <NSObject>
@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForExpandAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForFooterInSection:(NSInteger)section;
@end