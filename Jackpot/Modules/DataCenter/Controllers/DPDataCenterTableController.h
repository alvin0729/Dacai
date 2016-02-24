//
//  DPDataCenterController.h
//  Jackpot
//
//  Created by wufan on 15/9/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPDataCenterBaseViewModel.h"

@protocol DPDataCenterTableControllerDelegate;

@interface DPDataCenterTableController : NSObject <DPDataCenterViewModelDelegate>
@property (nonatomic, weak) id<DPDataCenterTableControllerDelegate> delegate;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) DPDataCenterBaseViewModel *viewModel;
@property (nonatomic, assign, readonly) NSInteger matchId;
@property (nonatomic, assign) BOOL isDownLoad;//是否是下la加载


@property (nonatomic, strong) UINavigationController *navController;

- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate;

- (void)request;             // 强制刷新
- (BOOL)requestIfNeeded;     // 如果是首次请求, 则进行刷新
/**
 *  底部提示文字
 *
 *  @return <#return value description#>
 */
+ (UILabel *)signlLabel ;


@end

// 子类实现该接口
@protocol IDPDataCenterTableController <NSObject>
@required
@end

@protocol DPDataCenterTableControllerDelegate <NSObject>
@required
- (void)requestDidStart:(DPDataCenterTableController *)controller;
- (void)requestDidFinish:(DPDataCenterTableController *)controller error:(NSError *)error;
@end

#define  kLayerColor [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1]
#define  kBackColor UIColorFromRGB(0xfaf9f2)

