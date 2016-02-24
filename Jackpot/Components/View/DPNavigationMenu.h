//
//  DPNavigationMenu.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//
//  导航栏展开菜单
//

#import <UIKit/UIKit.h>

@protocol DPNavigationMenuDelegate;

@interface DPNavigationMenu : UIView

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *itemsImage;

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, weak) UIViewController<DPNavigationMenuDelegate> *viewController;

 
- (void)show;
- (void)hide;

@end

@protocol DPNavigationMenuDelegate <NSObject>
@required
- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(int)index;
- (void)dismissNavigationMenu:(DPNavigationMenu *)menu;
@end