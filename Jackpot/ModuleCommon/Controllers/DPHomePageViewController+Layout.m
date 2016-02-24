//
//  DPHomePageViewController+Layout.m
//  Jackpot
//
//  Created by WUFAN on 15/10/30.
//  Copyright © 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPHomePageViewController+Layout.h"

@implementation DPHomePageViewController (Layout)

- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    [headerView addSubview:self.bannerView];
    [headerView addSubview:self.noticeLabel];
    // 轮播图
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(headerView);
        make.height.equalTo(@165);
    }];
    // 公告视图
    self.noticeLabel.hidden = YES;
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(20);
        make.height.equalTo(@28);
        make.left.and.right.equalTo(headerView);
    }];
    
    // 资讯
    [headerView addSubview:self.recommendButton];
    [self.recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.centerY.equalTo(self.bannerView.mas_bottom);
        make.centerX.equalTo(headerView);
        make.width.equalTo(@(kScreenWidth - 16));
    }];

    self.tableView.tableHeaderView = headerView;
}

//底部展示信息
- (void)setupFooterView {
    UIView *footView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 65)];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x999999);
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = @"大彩为首批获得互联网彩票牌照的公司";
        label;
    });
    [footView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView);
        make.top.equalTo(footView).offset(7);
        make.height.equalTo(@20);
    }];
    NSArray *array = [NSArray arrayWithObjects:@"账户安全", @"兑奖安全", @"提款安全", nil];
    NSArray *imageNames = [NSArray arrayWithObjects:@"security.png", @"bonusSacure.png", @"drawSafe.png", nil];
    float width = (kScreenWidth - 20) / 3.0;
    for (int i = 0; i < array.count; i++) {
        UIView *backView = [UIView dp_viewWithColor:[UIColor clearColor]];
        [footView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView).offset(10 + width * i);
            make.width.equalTo(@(width));
            make.top.equalTo(titleLabel.mas_bottom).offset(5);
            make.height.equalTo(@20);
        }];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = dp_AppRootImage([imageNames objectAtIndex:i]);
        [backView addSubview:imageView];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = [array objectAtIndex:i];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:12.0];
        label.adjustsFontSizeToFitWidth = YES;
        [backView addSubview:label];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.centerX.equalTo(backView).offset(7.5);
            make.top.equalTo(backView);
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left).offset(-5);
            make.width.equalTo(@19);
            make.centerY.equalTo(backView);
            make.height.equalTo(@19);
        }];
        // todo 测试web页面
//        [footView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTestWebView)]];
    }
    self.tableView.tableFooterView = footView;
}

@end
