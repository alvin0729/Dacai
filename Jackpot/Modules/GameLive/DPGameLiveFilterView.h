//
//  DPGameLiveFilterView.h
//  Jackpot
//
//  Created by wufan on 15/8/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPGameLiveFilterView;
@protocol DPGameLiveFilterViewDelegate <NSObject>
@optional
- (void)confirmFilterView:(DPGameLiveFilterView *)filterView;
- (void)cancelFilterView:(DPGameLiveFilterView *)filterView;
- (void)changeFilterView:(DPGameLiveFilterView *)filterView;
@end

@interface DPGameLiveFilterItem : NSObject <NSCopying>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL selected;
@end

@interface DPGameLiveFilterGroup : NSObject <NSCopying>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *items;
@end

@interface DPGameLiveFilterView : UIView
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id<DPGameLiveFilterViewDelegate> delegate;
@property (nonatomic, assign) NSInteger visibleCount;   // 已选场数
@end
