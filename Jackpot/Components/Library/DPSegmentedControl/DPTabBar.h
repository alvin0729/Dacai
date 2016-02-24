//
//  DPTabBar.h
//  Jackpot
//
//  Created by wufan on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTabBarItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *badgeValue;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) NSInteger tag;
@end

@protocol DPTabBarDelegate;
@interface DPTabBar : UIView
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) DPTabBarItem *selectedItem;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id<DPTabBarDelegate> delegate;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedColor;
@end

@protocol DPTabBarDelegate <NSObject>
@required
- (void)tabBar:(DPTabBar *)tabBar didSelectItem:(DPTabBarItem *)item;
@end