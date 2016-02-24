//
//  DPFlowSets.m
//  Jackpot
//
//  Created by WUFAN on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPFlowSets.h"
#import "DPMemberManager.h"
#import "DPLogOnViewController.h"
#import "DPPayRedPacketViewController.h"
#import "DPLTDltViewController.h"
#import "DPJczqBuyViewController.h"
#import "DPJczqTransferViewController.h"
#import "DPJclqBuyViewController.h"
#import "DPJclqTransferVC.h"
#import "DPJczqOptimizeViewController.h"
#import "DPOpenBetServiceController.h"

@interface DPPaymentContext ()
#ifdef DEBUG
@property (nonatomic, assign) UIViewController *viewController;
#else
@property (nonatomic, weak) UIViewController *viewController;
#endif
@property (nonatomic, strong) id order;
@property (nonatomic, assign) NSInteger gameType;   // 彩种
@property (nonatomic, assign) NSInteger gameName;   // 期号, 只对数字彩有效
@property (nonatomic, assign) NSInteger followCount;    // 追号期数
@property (nonatomic, assign, getter=isChase) BOOL chase;   // 是否追号

- (void)pay;
@end

@interface DPPaymentFlow ()
@property (nonatomic, strong) NSMutableArray<DPPaymentContext *> *contextStack;
@end

@implementation DPPaymentFlow

#pragma mark - Public Method

+ (void)pushContextWithViewController:(UIViewController *)viewController {
    NSAssert([NSThread isMainThread] && viewController, @"failure...");
    
    DPPaymentContext *context = [[DPPaymentContext alloc] init];
    context.viewController = viewController;
    
    [DPPaymentFlow.sharedManager.contextStack addObject:context];
}

+ (void)popContextWithViewController:(UIViewController *)viewController {
    NSAssert([NSThread isMainThread] && viewController, @"failure...");
    NSAssert(DPPaymentFlow.sharedManager.contextStack.lastObject.viewController == viewController, @"failure...");
    
    [DPPaymentFlow.sharedManager.contextStack removeLastObject];
}

+ (void)paymentWithOrder:(PBMPlaceAnOrder *)order gameType:(NSInteger)gameType inViewController:(UIViewController *)viewController {
    [self paymentWithOrder:order gameType:gameType gameName:0 inViewController:viewController];
}

+ (void)paymentWithChase:(PBMChaseToPlaceAnOrder *)order gameType:(NSInteger)gameType followCount:(NSInteger)followCount inViewController:(UIViewController *)viewController {
    NSAssert([NSThread isMainThread] && viewController, @"failure...");
    NSAssert(DPPaymentFlow.sharedManager.contextStack.lastObject.viewController == viewController, @"failure...");
    
    DPPaymentContext *context = [DPPaymentFlow currentPaymentContext];
    context.autoNextStep = YES;
    context.gameType = gameType;
    context.chase = YES;
    context.order = order;
    context.followCount = followCount;
    [context pay];
}

+ (void)paymentWithOrder:(PBMPlaceAnOrder *)order gameType:(NSInteger)gameType gameName:(NSInteger)gameName inViewController:(UIViewController *)viewController {
    NSAssert([NSThread isMainThread] && viewController, @"failure...");
    NSAssert(DPPaymentFlow.sharedManager.contextStack.lastObject.viewController == viewController, @"failure...");
    
    DPPaymentContext *context = [DPPaymentFlow currentPaymentContext];
    context.autoNextStep = YES;
    context.gameName = gameName;
    context.gameType = gameType;
    context.chase = NO;
    context.order = order;
    [context pay];
}

#pragma mark - Life cycle

+ (DPPaymentFlow *)sharedManager {
    static DPPaymentFlow *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[DPPaymentFlow alloc] init];
    });
    return mgr;
}

- (instancetype)init {
    if (self = [super init]) {
        _contextStack = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

@end

@implementation DPPaymentFlow (DPPaymentAddition)

+ (DPPaymentContext *)currentPaymentContext {
    return DPPaymentFlow.sharedManager.contextStack.lastObject;
}

+ (BOOL)currentPaymentFlowContainViewController:(UIViewController *)viewController {
    DPPaymentContext *context = [DPPaymentFlow currentPaymentContext];
//    context.viewController.presentedViewController
    return YES;
}

@end

@implementation DPPaymentContext

- (void)confirmOrder:(PBMCreateOrderResult *)result {
    DPPayRedPacketViewController *vc = [[DPPayRedPacketViewController alloc] init];
    vc.gameType = (int)self.gameType;
    vc.dataBase = result;
    vc.gameName = [NSString stringWithFormat:@"%ld",self.gameName];
    vc.isChase = self.isChase;
    vc.totalIssue = self.followCount;
    vc.projectMoney = [self.order isKindOfClass:[PBMChaseToPlaceAnOrder class]] ? (int)[(PBMChaseToPlaceAnOrder *)self.order totalAmount] : [(PBMPlaceAnOrder *)self.order totalAmount];
    vc.isCreateOrder = YES;
    
    NSMutableArray *viewControllers = self.viewController.navigationController.viewControllers.mutableCopy;
    // 删除投注流程上的相关界面
    while (YES) {
        UIViewController *vc = [viewControllers lastObject];
        if ([vc isKindOfClass:[DPLTDltViewController class]] ||
            [vc isKindOfClass:[DPJczqBuyViewController class]] ||
            [vc isKindOfClass:[DPJczqTransferViewController class]] ||
            [vc isKindOfClass:[DPJczqOptimizeViewController class]] ||
            [vc isKindOfClass:[DPJclqBuyViewController class]] ||
            [vc isKindOfClass:[DPJclqTransferVC class]]) {
            [viewControllers removeLastObject];
        } else {
            break;
        }
    }
    [viewControllers addObject:vc];
    [self.viewController.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)openService {
    DPOpenBetServiceController *vc = [[DPOpenBetServiceController alloc] init];
    @weakify(vc, self);
    vc.openBetBlock = ^{
        @strongify(vc, self);
        [vc.navigationController dp_popViewControllerAnimated:YES completion:^{
            [self createProject];
        }];
    };
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)createProject {
    [self.viewController showDarkHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager] POST:self.isChase ? @"/service/CreateFollowProject" : @"/service/CreateProject"
        parameters:self.order
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self.viewController dismissDarkHUD];
            [self confirmOrder:[PBMCreateOrderResult parseFromData:responseObject error:nil]];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.viewController dismissDarkHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
            if (error.dp_errorCode == DPErrorCodeBetAccount) {
                NSParameterAssert(DPSharedMemberManager.isLogin);
                [self openService];
            }
        }];
}

- (void)loginWithCallback:(void(^)(void))block {
    DPLogOnViewController *viewController = [[DPLogOnViewController alloc] init];
    viewController.finishBlock = block;
//    [self.viewController.navigationController pushViewController:viewController animated:YES];
    [self.viewController presentViewController:[UINavigationController dp_controllerWithRootViewController:viewController] animated:YES completion:nil];
}

- (void)pay {
    NSParameterAssert(self.viewController);
    if (DPSharedMemberManager.isLogin) {
        [self createProject];
    } else {
        @weakify(self);
        [self loginWithCallback:^{
            @strongify(self);
            // 从登录界面返回, 是否自动执行下一步
            if (self.autoNextStep) {
                [self createProject];
            }
        }];
    }
}

@end

@implementation DPLoginFlow

+ (void)loginIfNeededAndPerform:(void (^)(void))block {
    
}

@end