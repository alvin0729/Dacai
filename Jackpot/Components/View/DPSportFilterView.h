//
//  DPSportFilterView.h
//  DacaiProject
//
//  Created by sxf on 14-7-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//
//  删选界面
//

#import <UIKit/UIKit.h>


typedef void(^RelodFilter)(NSArray *selectedGroups);
 @interface DPSportFilterView : UIViewController

@property (nonatomic, assign, readonly) CGSize contentSize;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (void)addGroupWithTitle:(NSString *)title allItems:(NSArray *)allItems selectedItems:(NSArray *)selectedItems;

@property(nonatomic,copy)RelodFilter reloadFilter ;
- (instancetype)initWithGroupTitles:(NSArray *)titles allGroup:(NSArray*)allGroup selectGroup:(NSArray*)selectGroup ;


@end

