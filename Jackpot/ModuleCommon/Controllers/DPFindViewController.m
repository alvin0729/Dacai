//
//
//  Jackpot
//
//  Created by sxf on 15/7/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

//controller
#import "DPFindViewController.h"
#import "DPLotteryInfoViewController.h"
#import "UMComHomeFeedViewController.h"
#import "DPUserAccountHomeViewController.h"
#import "DPLogOnViewController.h"
#import "DPHLHomeViewController.h"
//UM
#import "UMCommunity.h"
#import "UMComUserAccount.h"
#import "UMComLoginManager.h"
#import "UMComHttpManager.h"
//BASE
#import "DPUARequestData.h"
#import "DPAnalyticsKit.h"

@interface DPFindViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}

@property (nonatomic, strong, readonly) UITableView *tableView;

@end

static NSString *title[] = {@"微社区", @"彩票资讯",@"赛事中心", @"活动中心",@"心水交易"};
static NSString *titleDetail[] = {@"晒单、女神、应有尽有",@"彩票圈大事小事随时更新",@"权威赛事中心", @"彩票圈大事小事随时更新",@"跟单牛人，一起中大奖"};
static NSString *images[] = {@"find_sq.png", @"find_zx.png",@"DPFindMatchCenter.png" ,@"find_hd.png", @"DPFindWage.png"};

@implementation DPFindViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发现";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController dp_applyGlobalTheme];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentify = @"reuseIdentify";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }

        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
       //玩法
        UILabel *titleLabel = ({
            UILabel *labe = [[UILabel alloc] init];
            labe.font = [UIFont dp_systemFontOfSize:17];
            labe.textColor = UIColorFromRGB(0x37383A);
            labe.backgroundColor = [UIColor clearColor];
            labe.tag = 1111;
            labe;
        });
       //玩法描述
        UILabel *descLabel = ({
            UILabel *labe = [[UILabel alloc] init];
            labe.font = [UIFont dp_systemFontOfSize:11];
            labe.textColor = UIColorFromRGB(0x98999A);
            labe.backgroundColor = [UIColor clearColor];
            labe.tag = 1112;
            labe;
        });

        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:descLabel];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.imageView.mas_right).offset(20);
        }];

        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_centerY).offset(8);
            make.left.equalTo(cell.imageView.mas_right).offset(20);
        }];
    }

    cell.imageView.image = dp_AppRootImage(images[indexPath.row]);

    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1111];
    UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:1112];
    titleLabel.text = title[indexPath.row];
    descLabel.text = titleDetail[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeFindCommunity + indexPath.row)] props:nil];

    if (indexPath.row == 0) {//微社区
        [self joinInCommunity];
    } else if (indexPath.row == 1) {
        DPLotteryInfoViewController *vc = [[DPLotteryInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        
    }else if (indexPath.row == 3) {
        
    }else if (indexPath.row == 4) {
        [self.navigationController pushViewController:[[DPHLHomeViewController alloc]init] animated:YES];
    }
}

#pragma mark - setter/getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 75;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }

        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }

        _tableView.tableFooterView = [[UIView alloc] init];
    }

    return _tableView;
}
//跳转到微社区
- (void)joinInCommunity {
    void (^loginCommunityBlock)() = ^{
        DPLogOnViewController *loginViewController = [[DPLogOnViewController alloc] init];
        loginViewController.pathSource = DPPathSourceUmengLib;//友盟
        // 设置登录SDK实现对象
        [UMComLoginManager setLoginHandler:loginViewController];
        UIViewController *communityViewController = [UMCommunity getFeedsViewController];
        [self.navigationController pushViewController:communityViewController animated:YES];
    };
    
    //获取用户信息
    [self showHUD];
    [DPUARequestData userInfoWithParam:nil Success:^(PBMMyInforItem *myInforItem) {
         [self dismissHUD];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setImageWithURL:[NSURL URLWithString:myInforItem.userIcon]];
        //使用第三方登录方法后得到的登录数据构造此类
        UMComUserAccount *userAccount = [[UMComUserAccount alloc]init];
        userAccount.iconImage = imageView.image;
        userAccount.name = myInforItem.userName;
        //更新登录用户数据
        [UMComPushRequest updateWithUser:userAccount completion:^(NSError *error) {
            if (!error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"update user profile success!" object:self];
            }
        }];
        loginCommunityBlock();
    } andFail:^(NSError *failMessage) {
        [self dismissHUD];
        if ([failMessage dp_errorCode]==DPErrorCodeUserUnlogin) {
            //用户注销方法
            [UMComLoginManager userLogout];
            loginCommunityBlock();
        }else{
            [[DPToast makeText:[failMessage dp_errorMessage]] show];
        }
    }];
}


@end
