//
//  DPGSRankingAwardController.m
//  Jackpot
//
//  Created by mu on 15/11/13.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPGSRankingAwardController.h"
#import "DPGSRankingAwardCell.h"
#import "DPAlterViewController.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "DPUARequestData.h"
@interface DPGSRankingAwardController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *myTable;
@property (nonatomic, strong)UILabel *footerLabel;
@property (nonatomic, strong)NSMutableArray *tableData;
@property (nonatomic, strong)NSMutableArray *dailyTableData;
@property (nonatomic, strong)NSMutableArray *weekTableData;
@property (nonatomic, strong)PBMRankingAward *rankingData;
@end

@implementation DPGSRankingAwardController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取数据
    [self requestRankingData];
    //初始化导航栏
    [self initilizerNav];
    //初始化table相关
    [self initilizerTable];
}
#pragma mark---------nav
- (void)initilizerNav{
    self.title = self.type == 1? @"每日排行榜领取奖励":@"每周排行榜领取奖励";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithTitle:@"规则" target:self action:@selector(rightBarItemTapped)];
}

- (void)rightBarItemTapped{
    DPWebViewController *controller = [[DPWebViewController alloc]init];
    controller.title = @"规则";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerBaseURL,@"/web/help/user"];
    controller.requset = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark---------table
- (void)initilizerTable{
    [self.view addSubview:self.myTable];
    [self.myTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.tableData = [NSMutableArray array];
    self.weekTableData = [NSMutableArray array];
    self.dailyTableData = [NSMutableArray array];
}
- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        UILabel *footeLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xbbb8ba) font:[UIFont systemFontOfSize:12]];
        footeLabel.frame = CGRectMake(0,-20, kScreenWidth, 12);
        footeLabel.textAlignment = NSTextAlignmentCenter;   
        footeLabel.text = self.type == 1?@"仅保留近10天的榜单": @"仅保留近10周的榜单";
        footeLabel.hidden = YES;
        _myTable.emptyDataView = [DZNEmptyDataView emptyDataView];
        _myTable.emptyDataView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
        _myTable.emptyDataView.showButtonForNoData = NO;
        _myTable.emptyDataView.textForNoData = @"暂无数据";
        @weakify(self);
        _myTable.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
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
                    [self requestRankingData];
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
        self.footerLabel = footeLabel;
        _myTable.tableFooterView = footeLabel;
    }
    return _myTable;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.tableData[section];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?34:0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectZero];
    UIImageView *sectionIcon = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"monthIcon.png")];
    sectionIcon.contentMode = UIViewContentModeCenter;
    [sectionHeader addSubview:sectionIcon];
    [sectionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-4);
        make.left.mas_equalTo(8);
    }];
    
    UILabel *label =[UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x676767) font:[UIFont systemFontOfSize:11]];
    if (self.tableData.count>0) {
        NSMutableArray *array = self.tableData[section];
        if (array.count>0) {
            DPUAObject *obj = self.tableData[section][0];
            NSString *month = [obj.value substringWithRange:NSMakeRange(5, 2)];
            label.text = [NSString stringWithFormat:@"%@月",month];
        }
    }
    [sectionIcon addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionIcon.mas_centerY);
        make.left.equalTo(sectionIcon.mas_right).offset(4);
    }];
    
    return sectionHeader;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPGSRankingAwardCell *cell = [[DPGSRankingAwardCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    DPUAObject *object = self.tableData[indexPath.section][indexPath.row];
    cell.object = object;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DPUAObject *object = self.tableData[indexPath.section][indexPath.row];
    PBMRankingAwardParam *param = [[PBMRankingAwardParam alloc]init];
    param.awardDate = object.value;
    param.awardType = (int)self.type;
    if (object.isRead==NO&&[object.title integerValue]<10) {
        @weakify(self);
        [DPUARequestData growSystemRankingGiftDataWithParam:param success:^(PBMGrowthDrawTask *rankingData) {
            @strongify(self);
            DPAlterViewController *controller = [[DPAlterViewController alloc]initWithAlterType:AlterTypeSuccess];
            controller.award = rankingData;
            [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
            @weakify(self);
            controller.fullBtnTapped = ^(UIButton *btn){
                @strongify(self);
                [self requestRankingData];
            };
        } fail:^(NSString *error) {
            [[DPToast makeText:error color:[UIColor dp_flatBlackColor]] show];
        }];
    }
  
}
#pragma mark---------data
- (void)requestRankingData{
    [self showHUD];
    PBMRankingAwardParam *param = [[PBMRankingAwardParam alloc]init];
    param.awardType = (int)self.type;
    @weakify(self);
    [DPUARequestData growSystemHistoryRankingDataWithParam:param success:^(PBMRankingAward *rankingData) {
        @strongify(self);
        [self dismissHUD];
        self.rankingData = rankingData;
        self.tableData = [self transformToUAObjectWithRankingAward:rankingData.awardListArray];
        self.footerLabel.hidden = !self.tableData.count>0;
        self.myTable.emptyDataView.requestSuccess = YES;
        [self.myTable reloadData];
    } fail:^(NSString *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:error color:[UIColor dp_flatBlackColor]] show];
        self.myTable.emptyDataView.requestSuccess = NO;
        [self.myTable reloadData];
    }];
}

- (NSMutableArray *)transformToUAObjectWithRankingAward:(NSMutableArray *)rankingArray{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *firstArray = [NSMutableArray array];
    NSString *monthStr = @"";
    for (NSInteger i = 0; i < rankingArray.count; i++) {
        PBMRankingAward_RankingAwardItem *item = rankingArray[i];
        NSString *awardDate =  (NSString *)item.awardDate;
        if (i == 0) {
            monthStr = [item.awardDate substringWithRange:NSMakeRange(5, 2)];
        }
        NSString *month = [item.awardDate substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [item.awardDate substringWithRange:NSMakeRange(8, 2)];
        DPUAObject *object = [[DPUAObject alloc]init];
        object.value = item.awardDate;
        object.subTitle = day;
        object.title = [NSString stringWithFormat:@"%d",item.ranking];
        object.isRead = item.awardGet;
        if ([monthStr isEqualToString:month]) {
            if ([self compareUserRegisterTimeWithAwardDate:awardDate]>=0) {
                [firstArray addObject:object];
            }
        }else{
            if (firstArray.count>0) {
                [array addObject:firstArray];
            }
            monthStr = month;
            firstArray = [NSMutableArray array];
            if ([self compareUserRegisterTimeWithAwardDate:awardDate]>=0) {
                [firstArray addObject:object];
            }
        }
    }
    if (firstArray.count>0) {
        [array addObject:firstArray];
    }

    return array;
}
- (int)compareUserRegisterTimeWithAwardDate:(NSString *)awardDate{
//    NSString *registerStr = [NSString stringWithFormat:@"%@ 00:00:00",[self.userRegisterTime substringToIndex:10]];
    NSDate *user = [NSDate dp_dateFromString:self.userRegisterTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
    NSDate *award = [NSDate dp_dateFromString:awardDate withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
    NSDate *nextWeekAward = [award dateByAddingTimeInterval:60*60*24*7];
    NSComparisonResult result = [self.type == 1?award:nextWeekAward compare:user];
    return result;
}
@end
