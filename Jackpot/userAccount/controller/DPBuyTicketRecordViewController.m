 //
//  DPBuyTicketRecordViewController.m
//  Jackpot
//
//  Created by mu on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPBuyTicketRecordViewController.h"
#import "DPProjectDetailViewController.h"
#import "DPHomePageViewController.h"
#import "DPWebViewController.h"
//view
#import "DPUAItemsScrollView.h"
#import "DPBuyTicketCell.h"
#import "SVPullToRefresh.h"
#import "DZNEmptyDataView.h"
//data
#import "DPUARequestData.h"
#import "DPBuyTicketRecordViewModel.h"

typedef enum{
    topRefreshType,//下拉刷新
    downRefreshType,//上来加载
}refreshType;

@interface DPBuyTicketRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
//======================================view
@property (nonatomic, strong) DPUAItemsScrollView *contentView;
//======================================data
@property (nonatomic, strong) NSMutableDictionary *param;

@property (nonatomic, copy) NSString *userId; //用户id
@property (nonatomic, copy) NSString *type;  //选择类型
@property (nonatomic, copy) NSString *pi;    //选择行
@property (nonatomic, copy) NSString *ps;     //行的个数
@property (nonatomic, assign) refreshType refresh;//下拉上拉形式
@property (nonatomic, strong) NSMutableArray *totalArray;//全部数据
@property (nonatomic, strong) NSMutableArray *noPayArray;//待支付数据
@property (nonatomic, strong) NSMutableArray *noFinishArray;//未完结数据
@property (nonatomic, strong) NSMutableArray *rewardArray;//中奖数据
@property (nonatomic, copy) NSString *totalIndex;//全部（请求行）
@property (nonatomic, copy) NSString *noPayIndex;//待支付（请求行）
@property (nonatomic, copy) NSString *noFinishIndex;//未完结(请求行)
@property (nonatomic, copy) NSString *rewardIndex;//中奖(请求行)

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) LotteryHistoryResult *lotteryHistoryInfo;//购彩记录接口返回
@property (nonatomic, strong) DPBuyTicketRecordViewModel *viewModel;
@end

@implementation DPBuyTicketRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购彩记录";
    [self.view addSubview:self.contentView];
    [self initilizerData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.contentView.selectIndex = self.index;
}

#pragma mark---------data
//初始化
- (void)initilizerData{
    _userId=@"",_type=@"0",_pi=@"1",_ps=@"20";
    self.totalIndex = @"1";
    self.noPayIndex = @"1";
    self.noFinishIndex = @"1";
    self.rewardIndex = @"1";
    self.param = [NSMutableDictionary dictionary];
    self.viewModel = [[DPBuyTicketRecordViewModel alloc]init];
}
//请求数据
- (void)requestData{
    [self showDarkHUD];
    
    [self.param setValue:self.type forKey:@"type"];
    [self.param setValue:self.pi forKey:@"pi"];
    [self.param setValue:self.ps forKey:@"ps"];
    
    @weakify(self);
    [DPUARequestData getlotteryHistoryInfoWithParam:self.param Success:^(LotteryHistoryResult *lotteryHistoryInfo) {
        @strongify(self);

        [self dismissHUD];
        if (self.refresh == topRefreshType) {//下拉刷新
            self.lotteryHistoryInfo = lotteryHistoryInfo;
        }else{
            [self.lotteryHistoryInfo.lotteryHistoryItemArray addObjectsFromArray:lotteryHistoryInfo.lotteryHistoryItemArray];
        }

        [self dismissDarkHUD];
        self.lotteryHistoryInfo = lotteryHistoryInfo;

        //更新数据源
        switch (self.index) {
            case 0:
                if (self.refresh == topRefreshType) {
                    [self.viewModel.totalArray removeAllObjects];
                }
                self.viewModel.totalResult = lotteryHistoryInfo;
                break;
            case 1:
                if (self.refresh == topRefreshType) {
                    [self.viewModel.noPayArray removeAllObjects];
                }
                self.viewModel.noPayResult = lotteryHistoryInfo;
                break;
            case 2:
                if (self.refresh == topRefreshType) {
                    [self.viewModel.noFinishArray removeAllObjects];
                }
                self.viewModel.noFinishResult = lotteryHistoryInfo;
                break;
            case 3:
                if (self.refresh == topRefreshType) {
                    [self.viewModel.rewardArray removeAllObjects];
                }
                self.viewModel.rewardResult = lotteryHistoryInfo;
                break;
            default:
                break;
        }
        
        UITableView *table = (UITableView *)[self.contentView viewWithTag:300+self.index];
        table.emptyDataView.requestSuccess = YES;
        [table.pullToRefreshView stopAnimating];
        [table.infiniteScrollingView stopAnimating];
        table.infiniteScrollingView.enabled = self.lotteryHistoryInfo.lotteryHistoryItemArray.count<lotteryHistoryInfo.count;
        [table reloadData];
        table.showsInfiniteScrolling = table.contentSize.height>table.frame.size.height;
    } andFail:^(NSString *failMessage) {
        @strongify(self);
        [self dismissDarkHUD];
        UITableView *table = (UITableView *)[self.contentView viewWithTag:300+self.index];
        [table.pullToRefreshView stopAnimating];
        [table.infiniteScrollingView stopAnimating];
        table.infiniteScrollingView.enabled = NO;
        table.showsInfiniteScrolling= NO;
        table.emptyDataView.requestSuccess = NO;
        [table reloadData];
    }];
};

//获取当前页数据源
- (NSMutableArray *)tableData{
    switch (self.index) {
        case 0:
            _tableData = self.viewModel.totalArray;
            break;
        case 1:
            _tableData = self.viewModel.noPayArray;
            break;
        case 2:
            _tableData = self.viewModel.noFinishArray;
            break;
        case 3:
            _tableData = self.viewModel.rewardArray;
            break;
        default:
            break;
    }
    return _tableData;
}
//获取行
- (NSString *)pi{
    switch (self.index) {
        case 0:
            _pi = self.totalIndex;
            break;
        case 1:
            _pi = self.noPayIndex;
            break;
        case 2:
            _pi = self.noFinishIndex;
            break;
        case 3:
            _pi = self.rewardIndex;
            break;
        default:
            break;
    }
    return _pi;
}
#pragma mark---------contentView
//ui
- (DPUAItemsScrollView *)contentView{
    if (!_contentView) {
        _contentView  = [[DPUAItemsScrollView alloc]initWithFrame:self.view.bounds andItems:@[@"全部",@"待支付",@"未完结",@"中奖"]];
        _contentView.btnsView.backgroundColor = UIColorFromRGB(0xfefdfb);
        _contentView.btnsView.layer.borderWidth = 0;
        _contentView.btnViewHeight.mas_equalTo(37.5);
        for (NSInteger i = 0; i < _contentView.btnArray.count; i++) {
            UIButton *btn = (UIButton *)_contentView.btnArray[i];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        }
        for (NSInteger i = 0; i < self.contentView.viewArray.count; i++) {
            UIView *view = self.contentView.viewArray[i];
            UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.backgroundColor = [UIColor dp_flatBackgroundColor];
            table.delegate = self;
            table.dataSource = self;
            table.tag = 300 + i;
            table.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
            table.emptyDataView = [DZNEmptyDataView emptyDataView];
            [view addSubview:table];
            [table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            
            //1,空页面
            @weakify(self);
            table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
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
                        [self requestData];
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
            
            //btn点击
            _contentView.itemTappedBlock = ^(UIButton *btn){
                @strongify(self);
                NSString *indexStr = [NSString stringWithFormat:@"%zd",btn.tag-100];
                self.index = (indexType)[indexStr integerValue];
                switch (btn.tag) {
                    case 100:
                        self.type = @"0";
                        if (self.viewModel.totalArray.count>0) {
                            return ;
                        }
                        break;
                    case 101:
                        self.type = @"1";
                        if (self.viewModel.noPayArray.count>0) {
                            return ;
                        }
                        break;
                    case 102:
                        self.type = @"8";
                        if (self.viewModel.noFinishArray.count>0) {
                            return;
                        }
                        break;
                    case 103:
                        self.type = @"6";
                        if (self.viewModel.rewardArray.count>0) {
                            return ;
                        }
                        break;
                    default:
                        break;
                }
                self.refresh = topRefreshType;
                [self requestData];
            };
            
            //下拉刷新
            [table addPullToRefreshWithActionHandler:^{
                @strongify(self);
                self.refresh = topRefreshType;
                self.pi = @"1";
                self.totalIndex = @"1";
                self.noPayIndex = @"1";
                self.noFinishIndex = @"1";
                self.rewardIndex = @"1";
                [self requestData];
            } position:SVPullToRefreshPositionTop];
            
            //上拉加载
            [table addInfiniteScrollingWithActionHandler:^{
                @strongify(self);
                self.refresh = downRefreshType;
                switch (self.index) {
                    case 0:
                        self.totalIndex = [NSString stringWithFormat:@"%zd",[self.pi integerValue]+1];
                        break;
                    case 1:
                        self.noPayIndex = [NSString stringWithFormat:@"%zd",[self.pi integerValue]+1];
                        break;
                    case 2:
                        self.noFinishIndex = [NSString stringWithFormat:@"%zd",[self.pi integerValue]+1];
                        break;
                    case 3:
                        self.rewardIndex = [NSString stringWithFormat:@"%zd",[self.pi integerValue]+1];
                        break;
                    default:
                        break;
                }
                [self requestData];
            }];
        }
    }
    return _contentView;
}
//datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPBuyTicketCell *cell = [[DPBuyTicketCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    LotteryHistoryResult_LotteryHistoryItem *lotteryItem = self.tableData[indexPath.row];
    if (lotteryItem) {
        cell.object = [self transformToObjectWithItem:lotteryItem andIndexPath:indexPath];
    }
    cell.downSeparatorLine.hidden = !(indexPath.row == self.tableData.count-1);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DPProjectDetailViewController *controller = [[DPProjectDetailViewController alloc]init];
    LotteryHistoryResult_LotteryHistoryItem *lotteryItem = self.tableData[indexPath.row];
    controller.lotteryItem = lotteryItem;
    [self.navigationController pushViewController:controller animated:YES];
}
//将PB接口转换成模型对象
- (DPUAObject *)transformToObjectWithItem:(LotteryHistoryResult_LotteryHistoryItem *)item andIndexPath:(NSIndexPath *)indexPath{
    DPUAObject *object = [[DPUAObject alloc]init];
    object.buyDate = [NSString stringWithFormat:@"%@月\n%@",[item.time substringWithRange:NSMakeRange(5, 2)],[item.time substringWithRange:NSMakeRange(8, 2)]];
    object.buyTime =[item.time substringWithRange:NSMakeRange(11, 5)];
    object.buyValue = [NSString stringWithFormat:@"%zd元",item.amount];
    object.awardValue = item.projectDesc;
    object.state = item.projectStatus;
    object.ticketKind = dp_GameTypeFirstName(item.gameType);
    object.subTitle = item.issue;
    object.isAward = item.isWined;

    if (indexPath.row - 1>=0&&indexPath.row<self.tableData.count) {
        LotteryHistoryResult_LotteryHistoryItem *lastItem = self.tableData[indexPath.row-1];
        if ([[lastItem.time substringWithRange:NSMakeRange(0, 10)] isEqualToString:[item.time substringWithRange:NSMakeRange(0, 10)]]) {
            object.isHiddle = YES;
        }else{
            object.isHiddle = NO;
        }
    }else{
        object.isHiddle = NO;
    }
    return object;
}


@end
