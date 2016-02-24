//
//  DPAppURLRoutes.m
//  Jackpot
//
//  Created by WUFAN on 15/10/16.
//  Copyright © 2015年 dacai. All rights reserved.
//
//  App 支持跳转页面: http://60.191.74.146:1111/cp-svn/zx/%E5%A4%A7%E5%BD%A9_App%20v5.0_PRD/#p=支持跳转页面
//

#import "DPAppURLRoutes.h"
#import "DPConstants.h"
#import <JLRoutes/JLRoutes.h>

#import "DPHomePageViewController.h"
#import "DPLBDltViewController.h"
#import "DPLTDltViewController.h"
#import "DPProjectDetailViewController.h"
#import "DPWebViewController.h"

//UM微社区
#import "DPLogOnViewController.h"
#import "UMComHomeFeedViewController.h"
#import "UMComHttpManager.h"
#import "UMComLoginManager.h"
#import "UMComUserAccount.h"
#import "UMCommunity.h"
//消息中心
#import "DPMessageCenterViewController.h"
//购彩记录
#import "DPBuyTicketRecordViewController.h"
//成长体系
#import "DPGSHomeViewController.h"
//安全中心
#import "DPSecurityCenterViewController.h"
//充值
#import "DPRechangeViewController.h"
//开通投注服务
#import "CreditNavigationController.h"
#import "CreditWebViewController.h"
#import "DPAlterViewController.h"
#import "DPFeedbackViewController.h"
#import "DPGSPrerogativeViewController.h"
#import "DPGSRankingViewController.h"
#import "DPOpenBetServiceController.h"

#import "DPJclqBuyViewController.h"
#import "DPJclqTransferVC.h"
#import "DPJczqBuyViewController.h"
#import "DPJczqTransferViewController.h"
#import "DPLBDltViewController.h"
#import "DPLTDltViewController.h"
#import "DPResultListViewController.h"

#import "DPDataCenterViewController.h"
#import "DPGameLiveViewController.h"
#import "DPLotteryInfoWebViewController.h"
#import "DPChaseNumberCenterViewController.h"
#import "DPTChaseNumberCenterInfoViewController.h"
static NSString *const kAppRouteSchemeKey = @"hzdacai";

@interface JLRoutes (Jackpot)
+ (JLRoutes *)dp_sharedRoutes;
@end

@implementation JLRoutes (Jackpot)

+ (JLRoutes *)dp_sharedRoutes {
    static dispatch_once_t onceToken;
    static JLRoutes *routes;
    dispatch_once(&onceToken, ^{
        routes = [JLRoutes routesForScheme:kAppRouteSchemeKey];
    });
    return routes;
}

@end

@interface DPAppURLRoutes ()
@property (nonatomic, strong) UINavigationController *nav;
@end

typedef NS_ENUM(NSInteger, DPAppRoutesModule) {
    DPAppRoutesModuleHomePage = 0,
    DPAppRoutesModuleGameLive,
    DPAppRoutesModuleDiscover,
    DPAppRoutesModuleDrawNotice,
    DPAppRoutesModuleMemberCenter,
};

@implementation DPAppURLRoutes

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillFinishLaunching:) name:UIApplicationWillFinishLaunchingNotification object:nil];
    });
}

+ (void)switchToRootControllerOfModule:(DPAppRoutesModule)module {
    [self dismissModalViewControllers];

    UITabBarController *tabBarController = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    NSParameterAssert(module < tabBarController.viewControllers.count);
    NSAssert([tabBarController.viewControllers containsObject:[KTMHierarchySearcher topmostViewController].navigationController], @"failure...");
    
    UINavigationController *originController = (UINavigationController *)tabBarController.selectedViewController;

    UINavigationController *navigationController = tabBarController.viewControllers[module];
    [navigationController popToRootViewControllerAnimated:NO];
    tabBarController.selectedViewController = tabBarController.viewControllers[module];
    
    [originController popToRootViewControllerAnimated:NO];
}

+ (void)dismissModalViewControllers {
    UIViewController *topmostViewController = [KTMHierarchySearcher topmostViewController];
    while (topmostViewController.presentingViewController) {
        topmostViewController = topmostViewController.presentingViewController;
        [topmostViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

+ (void)applicationWillFinishLaunching:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

#if defined(DEBUG)
    [JLRoutes setVerboseLoggingEnabled:YES];
#endif
    [self addHomePageRoute];
    [self addLotteryRoute];
    [self addLivePageRoute];
    [self addDrawNoticeRoute];
    [self addNewsPageRoute];
    [self addCommunityRoute];
    [self addMessageCenterRoute];
    [self addMemberCenterRoute];
    [self addGrowSystemRoute];
    [self addHTML5PageRoute];
    [self addSecurityCenter];
    [self addSignIn];
    [self addRechange];
}

+ (BOOL)handleURL:(NSURL *)url {
    if (![url.scheme isEqualToString:kAppRouteSchemeKey]) {
        return NO;
    }
    return [[JLRoutes dp_sharedRoutes] routeURL:url];
}

// 首页
+ (void)addHomePageRoute {
    [[JLRoutes dp_sharedRoutes] addRoute:@"/home" handler:^BOOL(NSDictionary *parameters) {
        [self switchToRootControllerOfModule:DPAppRoutesModuleHomePage];
        return YES;
    }];
}

// 投注页面和中转页面  //gameType:彩种类型
+ (void)addLotteryRoute {
    [[JLRoutes dp_sharedRoutes] addRoute:@"/lottery/bet" handler:^BOOL(NSDictionary *parameters) {
        NSArray *nextViewControllers;
        NSInteger gameType = [[parameters dp_objectForCaseInsensitiveKey:@"gameType"] integerValue];
        switch (gameType) {
            case GameTypeDlt:
                nextViewControllers = @[ [[DPLTDltViewController alloc] init], [[DPLBDltViewController alloc] init] ];
                break;
            case GameTypeJcNone:
            case GameTypeJcRqspf:
            case GameTypeJcBf:
            case GameTypeJcZjq:
            case GameTypeJcBqc:
            case GameTypeJcGJ:
            case GameTypeJcGYJ:
            case GameTypeJcHt:
            case GameTypeJcSpf:
            case GameTypeJcDg:
            case GameTypeJcDgAll:
                nextViewControllers = @[ [[DPJczqBuyViewController alloc] init] ];
                break;
            case GameTypeLcNone:
            case GameTypeLcSf:
            case GameTypeLcRfsf:
            case GameTypeLcSfc:
            case GameTypeLcDxf:
            case GameTypeLcHt:
                nextViewControllers = @[ [[DPJclqBuyViewController alloc] init] ];
                break;
            default:
                break;
        }
        // 消除所有modal view controller
        [self dismissModalViewControllers];

        // 构建页面路径
        UINavigationController *navigationController = [self topmostNavigationController];
        NSMutableArray *viewControllers = navigationController.viewControllers.mutableCopy;
        [viewControllers addObjectsFromArray:nextViewControllers];
        [navigationController setViewControllers:viewControllers animated:YES];
        return YES;
    }];

    [[JLRoutes dp_sharedRoutes] addRoute:@"/lottery/betTransfer" handler:^BOOL(NSDictionary *parameters) {
        NSArray *nextViewControllers;
        NSInteger gameType = [[parameters dp_objectForCaseInsensitiveKey:@"gameType"] integerValue];
        switch (gameType) {
            case GameTypeDlt:
                nextViewControllers = @[ [[DPLTDltViewController alloc] init] ];
                break;
            case GameTypeJcNone:
            case GameTypeJcRqspf:
            case GameTypeJcBf:
            case GameTypeJcZjq:
            case GameTypeJcBqc:
            case GameTypeJcGJ:
            case GameTypeJcGYJ:
            case GameTypeJcHt:
            case GameTypeJcSpf:
            case GameTypeJcDg:
            case GameTypeJcDgAll:
                nextViewControllers = @[ [[DPJczqBuyViewController alloc] init], [[DPJczqTransferViewController alloc] init] ];
                break;
            case GameTypeLcNone:
            case GameTypeLcSf:
            case GameTypeLcRfsf:
            case GameTypeLcSfc:
            case GameTypeLcDxf:
            case GameTypeLcHt:
                nextViewControllers = @[ [[DPJclqBuyViewController alloc] init], [[DPJclqTransferVC alloc] init] ];
                break;
            default:
                break;
        }
        // 消除所有modal view controller
        [self dismissModalViewControllers];

        // 构建页面路径
        UINavigationController *navigationController = [self topmostNavigationController];
        NSMutableArray *viewControllers = navigationController.viewControllers.mutableCopy;
        [viewControllers addObjectsFromArray:nextViewControllers];
        [navigationController setViewControllers:viewControllers animated:YES];
        return YES;
    }];
}

// 比分直播和数据中心
+ (void)addLivePageRoute {
    [[JLRoutes dp_sharedRoutes] addRoute:@"/gamelive" handler:^BOOL(NSDictionary *parameters) {
        [self switchToRootControllerOfModule:DPAppRoutesModuleGameLive];

        // defaultIndex 0:代表足球  1:代表篮球
        GameTypeId gameType = (GameTypeId)[[parameters dp_objectForCaseInsensitiveKey:@"gameType"] integerValue];
        NSInteger barIndex = [[parameters dp_objectForCaseInsensitiveKey:@"barIndex"] integerValue];
        DPGameLiveViewController *viewController = [KTMHierarchySearcher topmostViewController];
        viewController.defaultIndex = IsGameTypeJc(gameType) ? 0 : 1;
        viewController.defaultItem = barIndex;
        return YES;
    }];

    // 数据中心需要matchID ,gameType== GameTypeJcNone / GameTypeLcNone  titleString标题
    [[JLRoutes dp_sharedRoutes] addRoute:@"/datacenter" handler:^BOOL(NSDictionary *parameters) {
        GameTypeId gameType = [[parameters dp_objectForCaseInsensitiveKey:@"gameType"] intValue];
        NSInteger matchId = [[parameters dp_objectForCaseInsensitiveKey:@"matchId"] integerValue];
        NSString *title = [parameters dp_objectForCaseInsensitiveKey:@"titleString"];

        DPDataCenterViewController *vc = [[DPDataCenterViewController alloc] init];
        vc.gameType = gameType;
        vc.matchId = matchId;
        vc.titleString = title;

        [self dismissModalViewControllers];
        [self.topmostNavigationController pushViewController:vc animated:YES];
        return YES;
    }];
}

// 开奖和详情公告
+ (void)addDrawNoticeRoute {
    //开奖公告
    [[JLRoutes dp_sharedRoutes] addRoute:@"/drawNotice" handler:^BOOL(NSDictionary *parameters) {
        [self switchToRootControllerOfModule:DPAppRoutesModuleDrawNotice];
        return YES;
    }];
    //详情  gameType:彩种类型  gameTime:时间
    [[JLRoutes dp_sharedRoutes] addRoute:@"/drawNoticeInfo" handler:^BOOL(NSDictionary *parameters) {
        DPResultListViewController *vc = [[DPResultListViewController alloc] init];
        vc.gameType = (GameTypeId)[[parameters dp_objectForCaseInsensitiveKey:@"gameType"] integerValue];
        vc.gameTime = [parameters dp_objectForCaseInsensitiveKey:@"gameTime"];

        [self dismissModalViewControllers];
        [self.topmostNavigationController pushViewController:vc animated:YES];
        return YES;
    }];
}

// 资讯和详情页面
+ (void)addNewsPageRoute {
    //    [[JLRoutes dp_sharedRoutes] addRoute:@"/newsPage" handler:^BOOL(NSDictionary *parameters) {
    //        return YES;
    //    }];

    //需要gameType,web页面的url
    [[JLRoutes dp_sharedRoutes] addRoute:@"/newsPage/detail" handler:^BOOL(NSDictionary *parameters) {
        GameTypeId gameType = [[parameters dp_objectForCaseInsensitiveKey:@"gameType"] intValue];
        DPLotteryInfoWebViewController *viewController = [[DPLotteryInfoWebViewController alloc] initWithGameType:gameType];
        NSString *url = [parameters dp_objectForCaseInsensitiveKey:@"url"];
        if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) {
            url = [@"http://" stringByAppendingString:url];
        }
        viewController.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        viewController.title = @"资讯详情";
        viewController.canHighlight = NO;

        [self dismissModalViewControllers];
        [self.topmostNavigationController pushViewController:viewController animated:YES];
        return YES;
    }];
}

// 微社区
+ (void)addCommunityRoute {
    [[JLRoutes dp_sharedRoutes] addRoute:@"/community" handler:^BOOL(NSDictionary *parameters) {
        UMComUserAccount *userAccount = [[UMComUserAccount alloc] init];
        userAccount.iconImage = [DPMemberManager sharedInstance].iconImage;
        userAccount.name = [DPMemberManager sharedInstance].nickName;
        [UMComPushRequest updateWithUser:userAccount completion:^(NSError *error) {
            if (!error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"update user profile success!" object:self];
            }
        }];
        DPLogOnViewController *loginViewController = [[DPLogOnViewController alloc] init];
        [UMComLoginManager setLoginHandler:loginViewController];
        UIViewController *communityViewController = [UMCommunity getFeedsViewController];
        [self dismissModalViewControllers];
        [self.topmostNavigationController pushViewController:communityViewController animated:YES];
        return YES;
    }];
}

// 消息中心
+ (void)addMessageCenterRoute {
    [[JLRoutes dp_sharedRoutes] addRoute:@"/messageCenter/person" handler:^BOOL(NSDictionary *parameters) {
        DPMessageCenterViewController *controller = [[DPMessageCenterViewController alloc] init];
        [self dismissModalViewControllers];
        [self.topmostNavigationController pushViewController:controller animated:YES];
        return YES;
    }];
}

// 我的账户
+ (void)addMemberCenterRoute {
    //购彩记录
    [[JLRoutes dp_sharedRoutes] addRoute:@"/memberCenter/ticketRecord" handler:^BOOL(NSDictionary *parameters) {
        if (![DPMemberManager sharedInstance].isLogin) {
            return YES;
        }

        if (![DPMemberManager sharedInstance].isBetOpen) {
            DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc] init];
            [self.topmostNavigationController pushViewController:controller animated:YES];
            return YES;
        }

        DPBuyTicketRecordViewController *controller = [[DPBuyTicketRecordViewController alloc] init];
        controller.index = (indexType)[[parameters dp_objectForCaseInsensitiveKey:@"index"] intValue];
        [self.topmostNavigationController pushViewController:controller animated:YES];
        return YES;
    }];
    //方案详情  地址 /memberCenter/projectDetail  返回数据 彩种类型：gameType 方案id:projectId
    [[JLRoutes dp_sharedRoutes] addRoute:@"/memberCenter/projectDetail" handler:^BOOL(NSDictionary *parameters) {
        if (![DPMemberManager sharedInstance].isLogin) {
            return YES;
        }

        DPProjectDetailViewController *vc = [[DPProjectDetailViewController alloc] init];
        vc.gameType = (GameTypeId)[[parameters dp_objectForCaseInsensitiveKey:@"gameType"] integerValue];
        vc.projectId = [[parameters dp_objectForCaseInsensitiveKey:@"projectId"] longLongValue];
        [self.topmostNavigationController pushViewController:vc animated:YES];
        return YES;
    }];
    
    //追号记录
    [[JLRoutes dp_sharedRoutes] addRoute:@"/memberCenter/chaseCenter" handler:^BOOL(NSDictionary *parameters) {
        if (![DPMemberManager sharedInstance].isLogin) {
            return YES;
        }
        
        if (![DPMemberManager sharedInstance].isBetOpen) {
            DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc] init];
            [self.topmostNavigationController pushViewController:controller animated:YES];
            return YES;
        }
        
        DPChaseNumberCenterViewController *controller = [[DPChaseNumberCenterViewController alloc] init];
        controller.index = (indexType)[[parameters dp_objectForCaseInsensitiveKey:@"index"] intValue]+1;
        [self.topmostNavigationController pushViewController:controller animated:YES];
        return YES;
    }];
    //追号详情  地址 /memberCenter/projectDetail  返回数据 彩种类型：gameType 方案id:projectId
    [[JLRoutes dp_sharedRoutes] addRoute:@"/memberCenter/chaseDetail" handler:^BOOL(NSDictionary *parameters) {
        if (![DPMemberManager sharedInstance].isLogin) {
            return YES;
        }
        
        DPTChaseNumberCenterInfoViewController *vc = [[DPTChaseNumberCenterInfoViewController alloc] init];
        vc.gameType = (GameTypeId)[[parameters dp_objectForCaseInsensitiveKey:@"gameType"] integerValue];
        vc.projectId = [[parameters dp_objectForCaseInsensitiveKey:@"chaseId"] longLongValue];
        [self.topmostNavigationController pushViewController:vc animated:YES];
        return YES;
    }];


    //活动中心(暂且不做)
    [[JLRoutes dp_sharedRoutes] addRoute:@"/memberCenter/eventCenter" handler:^BOOL(NSDictionary *parameters) {
        return YES;
    }];
}

// 成长体系
+ (void)addGrowSystemRoute {
    //首页
    [[JLRoutes dp_sharedRoutes] addRoute:@"/growSystem" handler:^BOOL(NSDictionary *parameters) {
        DPGSHomeViewController *controller = [[DPGSHomeViewController alloc] init];
        [self dismissModalViewControllers];
        [self.topmostNavigationController pushViewController:controller animated:YES];
        return YES;
    }];
    //排行
    [[JLRoutes dp_sharedRoutes] addRoute:@"/growSystem/rank" handler:^BOOL(NSDictionary *parameters) {
        DPGSRankingViewController *controller = [[DPGSRankingViewController alloc] init];
        [self dismissModalViewControllers];
        [self.topmostNavigationController pushViewController:controller animated:YES];
        return YES;
    }];
    //特权
    [[JLRoutes dp_sharedRoutes] addRoute:@"/growSystem/privilege" handler:^BOOL(NSDictionary *parameters) {
        DPGSPrerogativeViewController *controller = [[DPGSPrerogativeViewController alloc] init];
        [self dismissModalViewControllers];
        [self.topmostNavigationController pushViewController:controller animated:YES];
        return YES;
    }];
    //积分
    [[JLRoutes dp_sharedRoutes] addRoute:@"/growSystem/integral" handler:^BOOL(NSDictionary *parameters) {
        //        CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrlByPresent:@"http://www.duiba.com.cn/test/demoRedirectSAdfjosfdjdsa"];
        //        CreditNavigationController *nav=[[CreditNavigationController alloc]initWithRootViewController:web];
        //
        return YES;
    }];
}
//安全中心
+ (void)addSecurityCenter {
    [[JLRoutes dp_sharedRoutes] addRoute:@"/userAcount/securityCenter" handler:^BOOL(NSDictionary *parameters) {
        DPSecurityCenterViewController *controller = [[DPSecurityCenterViewController alloc] init];
        [self dismissModalViewControllers];
        [self.topmostNavigationController pushViewController:controller animated:YES];
        return YES;
    }];
}

//充值
+ (void)addRechange {
    [[JLRoutes dp_sharedRoutes] addRoute:@"/userAcount/rechange" handler:^BOOL(NSDictionary *parameters) {
        if (![DPMemberManager sharedInstance].isBetOpen) {
            DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc] init];
            [self.topmostNavigationController pushViewController:controller animated:YES];
            return YES;
        }
        DPRechangeViewController *controller = [[DPRechangeViewController alloc] init];
        controller.rechangeCount = [parameters dp_objectForCaseInsensitiveKey:@"rechangeCount"];
        [self.topmostNavigationController pushViewController:controller animated:YES];
        return YES;
    }];
}

//签到
+ (void)addSignIn {
    [[JLRoutes dp_sharedRoutes] addRoute:@"/growSystem/signIn" handler:^BOOL(NSDictionary *parameters) {

        DPGSHomeViewController *controller = (DPGSHomeViewController *)self.topmostNavigationController.topViewController;
        if (controller.growHomeData.userInfo.checkIn) {
            DPAlterViewController *gsAlter = [[DPAlterViewController alloc] initWithAlterType:AlterTypePoint];
            gsAlter.registerTime = controller.growHomeData.userInfo.checkContinuesCount;
            [controller dp_showViewController:gsAlter animatorType:DPTransitionAnimatorTypeAlert completion:nil];
        } else {
            [DPUARequestData signInSuccess:^(PBMGrowthCheckIn *checkResult) {
                DPAlterViewController *gsAlter = [[DPAlterViewController alloc] initWithAlterType:AlterTypePoint];
                gsAlter.registerTime = checkResult.runningDays;
                gsAlter.checkIn = checkResult;
                [controller dp_showViewController:gsAlter animatorType:DPTransitionAnimatorTypeAlert completion:^{
                    [controller.checkInBtn setTitle:[NSString stringWithFormat:@"已签%d天", checkResult.hasAddupDays] forState:UIControlStateNormal];
                    [controller requestDataFrowServer];
                }];
            }
                fail:^(NSString *error) {
                    [[DPToast makeText:error] show];
                }];
        }

        return YES;
    }];
}

+ (void)addHTML5PageRoute {
    [[JLRoutes dp_sharedRoutes] addRoute:@"/html" handler:^BOOL(NSDictionary *parameters) {
        NSString *urlString = [KTMCrypto URLDecoding:[parameters dp_objectForCaseInsensitiveKey:@"url"]];
        DPWebViewController *controller = [[DPWebViewController alloc] init];
        controller.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlString]]];

        [self dismissModalViewControllers];
        [self.topmostNavigationController pushViewController:controller animated:YES];
        return YES;
    }];
}

+ (UINavigationController *)topmostNavigationController {
    return [KTMHierarchySearcher topmostNonModalViewController].navigationController;
    return [KTMHierarchySearcher topmostNavigationController];
}

@end
