//
//  DPRootPageController.m
//  Jackpot
//
//  Created by wufan on 15/6/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPRootPageController.h"
#import "DPHomePageViewController.h"
#import "DPFindViewController.h"
#import "DPLotteryResultViewController.h"
#import "DPMemberCenterViewController.h"
#import "DPMemberLoginViewController.h"
#import "DPGameLiveViewController.h"
#import "DPUserAccountHomeViewController.h"
#import "DPLogOnViewController.h"
#import "DPAnalyticsKit.h"
const static NSInteger kTabBarTagIndex = 1000;

@interface DPRootPageController () <UITabBarControllerDelegate>

@end

@implementation DPRootPageController

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationController *homeBuyPage = [UINavigationController dp_controllerWithRootViewController:[[DPHomePageViewController alloc] init]];
    UINavigationController *gameLivePage = [UINavigationController dp_controllerWithRootViewController:({
        DPGameLiveViewController *viewController = [[DPGameLiveViewController alloc] init];
        viewController.defaultIndex = 0;
        viewController.defaultItem = 0;
        viewController;
    })];
    UINavigationController *findPage = [UINavigationController dp_controllerWithRootViewController:[[DPFindViewController alloc] init]];
    UINavigationController *drawPage = [UINavigationController dp_controllerWithRootViewController:[[DPLotteryResultViewController alloc] init]];
    UINavigationController *myTicketPage = [UINavigationController dp_controllerWithRootViewController:[[DPUserAccountHomeViewController alloc] init]];
    homeBuyPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购彩大厅" image:dp_AppRootImage(@"homebuyNormal.png") tag:kTabBarTagIndex + 1];
    gameLivePage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"比分直播" image:dp_AppRootImage(@"gameliveNormal.png") tag:kTabBarTagIndex + 2];
    findPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:dp_AppRootImage(@"homefind.png") tag:kTabBarTagIndex + 3];
    drawPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"开奖公告" image:dp_AppRootImage(@"resultNormal.png") tag:kTabBarTagIndex + 4];
    myTicketPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的彩票" image:dp_AppRootImage(@"myTicketNormal.png") tag:kTabBarTagIndex + 5];

    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.viewControllers = @[ homeBuyPage, gameLivePage, findPage, drawPage, myTicketPage ];
    self.tabBar.tintColor = [UIColor yellowColor];
    self.tabBar.translucent = NO;
    self.tabBar.barTintColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Layout

- (void)makeViewConstraints {
}

#pragma mark - Public Interface

#pragma mark - Internal Interface

#pragma mark - Override

#pragma mark - User Interaction

// - (void)foobarButtonTapped;

#pragma mark - Delegate

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UINavigationController *nav = (UINavigationController *)viewController;
    UINavigationController *slelectNav = (UINavigationController *)self.selectedViewController;
    if ([slelectNav.viewControllers[0] isKindOfClass:[DPUserAccountHomeViewController class]]) {
        return YES;
    }
    
    if ([nav.viewControllers[0] isKindOfClass:[DPUserAccountHomeViewController class]]) {
        //如果用户未登录，则跳转到登录页面
        if (![DPMemberManager sharedInstance].isLogin) {
            [nav popToRootViewControllerAnimated:NO];
            UINavigationController *loginNav = [UINavigationController dp_controllerWithRootViewController:[[DPLogOnViewController alloc]init]];
            [self presentViewController:loginNav animated:YES completion:nil];
        } else {
            // 修复退出登录crash， 退出登录时保留Nav状态
            if (nav.topViewController != nav.viewControllers.firstObject) {
                [nav popToRootViewControllerAnimated:NO];
            }
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSInteger eventId = DPAnalyticsTypeHomeFirst + tabBarController.selectedIndex;
    [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(eventId)] props:nil];
    if(tabBarController.selectedIndex == 2 && ((UINavigationController*)viewController).viewControllers.count >1 ){
        
         [(UINavigationController*)viewController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - Properties (getter, setter)

@end
