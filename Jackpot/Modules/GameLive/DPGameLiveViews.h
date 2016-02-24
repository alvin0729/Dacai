//
//  DPGameLiveViews.h
//  Jackpot
//
//  Created by wufan on 15/8/17.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPGameLiveTabBarItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *badgeValue;
@property (nonatomic, assign) NSInteger tag;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title badgeValue:(NSString *)badgeValue;
@end

@interface DPGameLiveTabBar : UIView
@property (nonatomic, strong, readonly) RACSignal *rac_signalForSelectedItem;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, weak) DPGameLiveTabBarItem *selectedItem;

- (void)setSelectedItem:(DPGameLiveTabBarItem *)selectedItem animation:(BOOL)animation execute:(BOOL)execute;
@end

@interface DPGameLiveHeaderView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL unfold;
@end

@interface DPGameLiveGoalView : UIView
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *awayName;
@property (nonatomic, strong) UIImage *homeIcon;
@property (nonatomic, strong) UIImage *awayIcon;
@property (nonatomic, strong) NSAttributedString *attributedString;
@end
