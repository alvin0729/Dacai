//
//  DPHomePageViewController+Layout.h
//  Jackpot
//
//  Created by WUFAN on 15/10/30.
//  Copyright © 2015年 dacai. All rights reserved.
//  首页ui的搭建

#import "DPHomePageViewController.h"

@interface DPHomePageViewController () < UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, KTMBannerViewDelegte, KTMBannerViewDataSource>
@property (nonatomic, strong, readonly) UIButton *recommendButton;      // 资讯
@property (nonatomic, strong, readonly) KTMBannerView *bannerView;      // 轮播图
@property (nonatomic, strong, readonly) UITableView *tableView;         // 列表
@property (nonatomic, strong, readonly) UILabel *noticeLabel;           // 公告视图
@property (nonatomic, strong, readonly) UIView *effectView;
@end

@interface DPHomePageViewController (Layout)
- (void)setupHeaderView;
- (void)setupFooterView;
@end
