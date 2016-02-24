//
//  DPLotteryResultViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//  开奖公告首页

#import "DPLotteryResultViewController.h"
#import "DPShareRootViewController.h"
#import "DPShareRootViewController.h"
#import "DZNEmptyDataView.h"
#import "DPResultListViewController.h"
#import "DPLotteryResultCell.h"
#import "DPCalendarView.h"
#import "SVPullToRefresh.h"
#import "DrawNotice.pbobjc.h"
#import "DPAnalyticsKit.h"
#import "DPWebViewController.h"
#import "UMSocial.h"
#import "DPThirdCallCenter.h"

@interface DPLotteryResultViewController () <UITableViewDelegate, UITableViewDataSource,UMSocialUIDelegate,UIViewControllerTransitioningDelegate> {
@private
    UITableView *_tableView;
}

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) PBMDrawHomeList *dataBase;
@property(nonatomic,strong) NSURLSessionDataTask *task ;
@end

@implementation DPLotteryResultViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.dataBase) {
        [self requestDrawHomeList];
     }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"开奖公告";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    __weak __typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.pullToRefreshView stopAnimating];
        [strongSelf requestDrawHomeList];
    }];
    [self.tableView.pullToRefreshView setDelay:0.15];
    [self requestDrawHomeList];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png") target:self action:@selector(navBarRightItemClick:)];
    
}
- (void)navBarRightItemClick:(id)sender {

    if (self.dataBase) {

        DPShareRootViewController *shareController = [[DPShareRootViewController alloc]init];
        shareController.object.shareTitle = self.dataBase.shareParam.shareTitle;
        shareController.object.shareContent = self.dataBase.shareParam.shareContent;
        shareController.object.shareUrl = self.dataBase.shareParam.shareURL;
        [self dp_showViewController:shareController animatorType:DPTransitionAnimatorTypeAlert completion:nil];
        
    }
   
}
//other
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    [[DPToast makeText:[NSString stringWithFormat:@"分享类型%zd",response.responseCode]] show];
}

// 获取数据. pop
- (void)requestDrawHomeList {
    if (self.task) {
        return;
    }

    [self showHUD];
    @weakify(self);
    self.task = [[AFHTTPSessionManager dp_sharedManager] GET:@"/draw/drawhome"
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self dismissHUD];
            self.dataBase = [PBMDrawHomeList parseFromData:responseObject error:nil];

            [self dismissHUD];
            [self.tableView.pullToRefreshView stopAnimating];
            self.tableView.emptyDataView.requestSuccess = YES;
            [self.tableView reloadData];

            self.task = nil;
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            self.tableView.emptyDataView.requestSuccess = NO;
            [self dismissHUD];
            [self.tableView reloadData];
            if ([self.tableView numberOfRowsInSection:0]) {
                [[DPToast makeText:error.dp_errorMessage] show];
            }
            self.task = nil;

        }];
 }

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 75;
        _tableView.separatorColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataView = [DZNEmptyDataView emptyDataView];
        @weakify(self);
        _tableView.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
             @strongify(self);
            switch (type) {
                case DZNEmptyDataViewTypeNoData:
                {
                    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
                    [tabbar setSelectedViewController:tabbar.viewControllers.firstObject];
                }
                    break;
                case DZNEmptyDataViewTypeFailure:
                {
                    [self requestDrawHomeList];
                }
                    break;
                case DZNEmptyDataViewTypeNoNetwork:
                {
                     [self.navigationController pushViewController:[DPWebViewController setNetWebController] animated:YES];
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _tableView;
}

#pragma mark - event

// 返回. pop
- (void)pvt_onHome {
    NSUInteger num = self.navigationController.viewControllers.count;
    if (num > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - table view's data source and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMDrawHomeList_Item *item = [self.dataBase.itemsArray objectAtIndex:indexPath.row];
    int gameType = item.gameType;
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", gameType];
    DPLotteryResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPLotteryResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell buildLayout];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        [cell layoutWithGameType:(GameTypeId)gameType];

        switch (gameType) {
            case GameTypeJcNone:
            case GameTypeJcHt:
                cell.gameTypeLabel.text = @"竞彩足球";
                break;
            case GameTypeLcNone:
            case GameTypeLcHt:
                cell.gameTypeLabel.text = @"竞彩篮球";
                break;
            case GameTypeZcNone:
            case GameTypeZc14:
            case GameTypeZc9:
                cell.gameTypeLabel.text = @"胜负彩/任选九";
                break;
            case GameTypeSd:
            case GameTypeSsq:
            case GameTypeQlc:
            case GameTypeDlt:
            case GameTypePs:
            case GameTypePw:
            case GameTypeQxc:

                cell.gameTypeLabel.text = dp_GameTypeFullName((GameTypeId)gameType);
                break;
            default:
                break;
        }
    }

    if (IsGameTypeJc(gameType) || IsGameTypeLc(gameType)) {
        cell.gameNameLabel.text = [[NSDate dp_coverDateString:item.drawTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:@"yyyy-MM-dd"] stringByAppendingString:@"期"];
        cell.matchLabel.text = [NSString stringWithFormat:@"今天有%d场比赛，已开%d场", item.totalGames, item.endedGames];

        [cell.matchLabel.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
            if (obj.firstItem == cell.matchLabel && obj.firstAttribute == NSLayoutAttributeWidth) {
                obj.constant = cell.matchLabel.intrinsicContentSize.width + 20;
            }
        }];

        return cell;
    }

    cell.gameNameLabel.text = [NSString stringWithFormat:@"%@期", item.gameName];
    cell.drawTimeLabel.text = [NSDate dp_coverDateString:item.drawTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm];

    switch (gameType) {
        case GameTypeSsq:
        case GameTypeQlc:
        case GameTypeDlt: {
            NSString *resultString = [item.resluts stringByReplacingOccurrencesOfString:@"|" withString:@","];
            NSArray *array = [resultString componentsSeparatedByString:@","];
            if (array.count != cell.labels.count) {
                return cell;
            }
            for (int i = 0; i < cell.labels.count; i++) {
                UILabel *label = cell.labels[i];
                label.text = [NSString stringWithFormat:@"%@", array[i]];
            }
        } break;
        case GameTypeSd: {
            // 设置试机号
            NSArray *array = [item.resluts componentsSeparatedByString:@"|"];
            NSString *resultString = [array objectAtIndex:0];
            NSString *proResultString = [array objectAtIndex:1];
            if (proResultString.length < 3) {
                return cell;
            }
            cell.preResultLabel.text = [NSString stringWithFormat:@"%@  %@  %@", [proResultString substringWithRange:NSMakeRange(0, 1)], [proResultString substringWithRange:NSMakeRange(1, 1)], [proResultString substringWithRange:NSMakeRange(2, 1)]];

            // 只有试机号没有奖号时隐藏
            for (int i = 0; i < cell.labels.count; i++) {
                UILabel *label = cell.labels[i];
                label.hidden = resultString.length < 3 ? YES : NO;
                if (resultString.length == 3) {
                    label.text = [proResultString substringWithRange:NSMakeRange(i, 1)];
                }
            }
        } break;
        case GameTypePs:
        case GameTypePw:
        case GameTypeQxc:
        case GameTypeZcNone:
        case GameTypeZc14:
        case GameTypeZc9: {
            for (int i = 0; i < cell.labels.count; i++) {
                UILabel *label = cell.labels[i];
                if (i < item.resluts.length) {
                    label.text = [NSString stringWithFormat:@"%@", [item.resluts substringWithRange:NSMakeRange(i, 1)]];
                }
            }
        } break;

            break;
        default:
            break;
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataBase.itemsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeResultDlt+indexPath.row)] props:nil];

    PBMDrawHomeList_Item *item = [self.dataBase.itemsArray objectAtIndex:indexPath.row];
    DPResultListViewController *viewController = [[DPResultListViewController alloc] init];
    viewController.isFromClickMore = NO;
    if (IsGameTypeJc(item.gameType)) {
        viewController.gameType = GameTypeJcNone;
    } else if (IsGameTypeLc(item.gameType)) {
        viewController.gameType = GameTypeLcNone;
    } else if (IsGameTypeZc(item.gameType)) {
        viewController.gameType = GameTypeZcNone;
    } else {
        viewController.gameType = (GameTypeId)item.gameType;
    }

    if (IsGameTypeJc(item.gameType) || IsGameTypeLc(item.gameType)) {
        viewController.gameTime = item.drawTime;
        //        [[NSDate dp_coverDateString:item.drawTime fromFormat:dp_DateFormatter_yyyy_MM_dd toFormat:@"yyyyMMdd"]intValue];
    }

    [self.navigationController pushViewController:viewController animated:YES];
}

@end
