 //
//  DPUAFundDetailViewController.m
//  Jackpot
//
//  Created by mu on 15/8/31.
//  Copyright (c) 2015年 dacai. All rights reserved.
// 当前页面注释由sxf提供，如有更改，请标示

#import "DPUAFundDetailViewController.h"
#import "DPTChaseNumberCenterInfoViewController.h"
#import "DPDrawMoneyViewController.h"
#import "DPRechangeViewController.h"
#import "DPProjectDetailViewController.h"
#import "DPUAFundDetailCell.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
//view
#import "DPUAFundHeaderView.h"
#import "DPUAItemsScrollView.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

//当前请求数据的方式
typedef enum{
    topRefreshType,//上拉请求数据
    downRefreshType,//下拉刷新数据
}refreshType;

@interface DPUAFundDetailViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) refreshType refresh;
@property (nonatomic, strong) DPUAFundHeaderView *headerView;//头部信息
@property (nonatomic, strong) DPUAItemsScrollView *footView;//主体信息（列表）
@property (nonatomic, strong) UIView *jumpView;//底部浮框
//=====================data
@property (nonatomic, strong) PBMFundDetailInfo *fundDetail; //资金明细
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) NSMutableArray *tableData;//列表数据源
@property (nonatomic, strong) NSMutableArray *fundUseDetailArray;
@property (nonatomic, strong) NSMutableArray *fundRechangeDetailArray;
@property (nonatomic, strong) NSMutableArray *fundDrawDetailArray;
@property (nonatomic, strong) NSMutableArray *fundFrozenDetailArray;
@property (nonatomic, strong) NSString *fundUseDetailIndex;//收支明细请求第几页
@property (nonatomic, strong) NSString *fundRechangeDetailIndex;//充值明细请求第几页
@property (nonatomic, strong) NSString *fundDrawDetailIndex;//体现明细请求第几页
@property (nonatomic, strong) NSString *fundFrozenDetailIndex;//冻结明细请求第几页
@property (nonatomic, copy) NSString *pageIndex;
@property (nonatomic, copy) NSString *PageSize;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *lastMonth;
@end

@implementation DPUAFundDetailViewController
//lifeCycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initilizerUI];
    [self initilizerData];
}

- (void)initilizerUI{
    self.title = @"资金明细";
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(178);
    }];
    
    [self.view addSubview:self.footView];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-44.5);
    }];
    
    [self.view addSubview:self.jumpView];
    [self.jumpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44.5);
    }];
    
}
#pragma mark---------headerView
//头部
- (DPUAFundHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[DPUAFundHeaderView alloc]initWithFrame:CGRectZero];
    }
    return _headerView;
}
#pragma mark---------footView
//底部
- (DPUAItemsScrollView *)footView{
    if (!_footView) {
        __weak DPUAFundDetailViewController *weakSelf = self;
        _footView  = [[DPUAItemsScrollView alloc]initWithFrame:CGRectZero andItems:@[@"收支明细",@"充值明细",@"提现明细",@"冻结明细"]];
        _footView.btnViewHeight.mas_equalTo(38);
        @weakify(self);
        //点击切换不同类型
        _footView.itemTappedBlock = ^(UIButton *btn){
            @strongify(self);
            weakSelf.type = [NSString stringWithFormat:@"%zd",btn.tag-100];
            switch ([weakSelf.type integerValue]) {
                case 0://收支明细
                {
                    if (self.fundUseDetailArray.count>0) {
                        return ;
                    }
                }
                    break;
                case 1://充值明细
                {
                    if (self.fundRechangeDetailArray.count>0) {
                        return ;
                    }
                }
                    break;
                case 2://提现明细
                {
                    if (self.fundDrawDetailArray.count>0) {
                        return ;
                    }
                }
                    break;
                case 3://冻结明细
                {
                    if (self.fundFrozenDetailArray.count>0) {
                        return ;
                    }
                }
                    break;
                    
                default:
                    break;
            }
            weakSelf.refresh=topRefreshType;
            weakSelf.pageIndex = @"1";
            [weakSelf requestData];
        };
        //列表
        for (NSInteger i = 0; i < _footView.viewArray.count; i++) {
            UIView *view = _footView.viewArray[i];
            __block UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.delegate = self;
            table.dataSource = self;
            table.backgroundColor = [UIColor dp_flatBackgroundColor];
            UIView *emptyView = [[UIView alloc]init];
            emptyView.backgroundColor = [UIColor dp_flatBackgroundColor];
            table.tableHeaderView = emptyView;
            table.tableFooterView = emptyView;
            table.emptyDataView = [self creatEmptyView];
            @weakify(self);
            table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
                @strongify(self);
                UITableView *table = [self.footView.tablesView viewWithTag:300+[self.type integerValue]];
                table.showsInfiniteScrolling = NO;
                switch (type) {
                    case DZNEmptyDataViewTypeNoData:
                    {
                        [self requestData];
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
            //下拉刷新数据
            [table addPullToRefreshWithActionHandler:^{
                @strongify(self);
                self.refresh = topRefreshType;
                self.pageIndex = @"1";
                self.fundUseDetailIndex = @"1";
                self.fundRechangeDetailIndex = @"1";
                self.fundDrawDetailIndex = @"1";
                self.fundFrozenDetailIndex = @"1";
                [weakSelf requestData];
            } position:SVPullToRefreshPositionTop];

            [table addInfiniteScrollingWithActionHandler:^{
            @strongify(self);
                self.refresh = downRefreshType;
                switch ([self.type integerValue]) {
                    case 0:
                        self.fundUseDetailIndex = [NSString stringWithFormat:@"%zd",[self.pageIndex integerValue]+1];
                        break;
                    case 1:
                        self.fundRechangeDetailIndex = [NSString stringWithFormat:@"%zd",[self.pageIndex integerValue]+1];
                        break;
                    case 2:
                        self.fundDrawDetailIndex = [NSString stringWithFormat:@"%zd",[self.pageIndex integerValue]+1];
                        break;
                    case 3:
                        self.fundFrozenDetailIndex = [NSString stringWithFormat:@"%zd",[self.pageIndex integerValue]+1];
                        break;
                    default:
                        break;
                }
                
                [weakSelf requestData];
            }];
            table.tag = 300+i;
            [view addSubview:table];
            [table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            
            table.showsInfiniteScrolling = NO;
            [table reloadData];
        }
        
    }
    return _footView;
}
//emptyView 无数据时的页面
- (DZNEmptyDataView *)creatEmptyView{
    DZNEmptyDataView * emptyView = [DZNEmptyDataView emptyDataView];
    emptyView.showButtonForNoData = NO;
//    emptyView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
    emptyView.textForNoData = @"暂无明细";
    return emptyView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = self.tableData.count;
    return sectionCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.tableData[section];
    NSInteger rowCount = array.count;
    return rowCount; 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37.5;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 37.5)];
    sectionHeaderView.backgroundColor = [UIColor dp_flatBackgroundColor];
    UILabel *sectionTitle = [[UILabel alloc]init];
    sectionTitle.font = [UIFont systemFontOfSize:12];
    sectionTitle.textColor = UIColorFromRGB(0xc2c3be);
    [sectionHeaderView addSubview:sectionTitle];
    [sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(12);
    }];
    DPUAObject *object = self.tableData[section][0];
    NSString *otherMonth = [NSString stringWithFormat:@"%@月",[object.fundTime substringWithRange:NSMakeRange(5, 2)]];
    sectionTitle.text = section==0?@"本月":otherMonth;
    return sectionHeaderView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPUAFundDetailCell *cell = [[DPUAFundDetailCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    if (indexPath.section<self.tableData.count) {
        NSArray *objectArray = self.tableData[indexPath.section];
        if (indexPath.row<objectArray.count) {
            DPUAObject *object = self.tableData[indexPath.section][indexPath.row];
            cell.object = object;
        }
        cell.lastLine.hidden = indexPath.row != objectArray.count-1;
        cell.separatorLine.hidden = indexPath.row ==0;
        cell.firstLine.hidden = indexPath.row != 0;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   DPUAObject *object = self.tableData[indexPath.section][indexPath.row];

    if (object.sourceType == 3){
        DPProjectDetailViewController *controller = [[DPProjectDetailViewController alloc]init];
        controller.projectId = object.sourceId;
        controller.gameType = (GameTypeId)object.gameTypeId;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(object.sourceType == 6){
        DPTChaseNumberCenterInfoViewController *controller = [[DPTChaseNumberCenterInfoViewController alloc]init];
        controller.projectId = object.sourceId;
        controller.gameType = (GameTypeId)object.gameTypeId;
        [self.navigationController pushViewController:controller animated:YES];
    }

}
#pragma mark---------jumpView
- (UIView *)jumpView{
    if (!_jumpView) {
        _jumpView = [[UIView alloc]init];
        for (NSInteger i = 0; i < 2; i++) {
            
            UIButton *jumpBtn = [UIButton dp_buttonWithTitle:i==0?@"提现":@"充值" titleColor:i==0?UIColorFromRGB(0x666666):[UIColor dp_flatWhiteColor] backgroundColor:i==0?[UIColor dp_flatWhiteColor]:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:18]];
            jumpBtn.tag = i;
            jumpBtn.layer.borderColor = UIColorFromRGB(0xc8c7c3).CGColor;
            jumpBtn.layer.borderWidth = 0.5;
            [jumpBtn addTarget:self action:@selector(jumpBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [_jumpView addSubview:jumpBtn];
            [jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(kScreenWidth*0.5*i-0.5);
                make.width.mas_equalTo(kScreenWidth*0.5);
                make.bottom.mas_equalTo(0.5);
            }];
        }
    }
    return _jumpView;
    
}
- (void)jumpBtnTapped:(UIButton *)btn{
    NSArray *jumpName = @[@"DPDrawMoneyViewController",@"DPRechangeViewController"];
    [self.navigationController pushViewController:[[NSClassFromString(jumpName[btn.tag]) alloc]init] animated:YES];
}
#pragma mark---------requestData
- (void)initilizerData{

    self.PageSize = @"20";
    self.pageIndex = @"1";
    self.type =@"0";
    self.fundUseDetailIndex = @"1";
    self.fundRechangeDetailIndex = @"1";
    self.fundDrawDetailIndex = @"1";
    self.fundFrozenDetailIndex = @"1";
    [self requestData];
}
- (void)requestData{
     [self showHUD];
    @weakify(self);
    //资金明细
    [DPUARequestData getFundDetailInfoWithParam:@{@"type":self.type,@"pi":self.pageIndex,@"ps":self.PageSize} Success:^(PBMFundDetailInfo *fundInfo) {
        @strongify(self);
        UITableView *table = (UITableView *)[self.footView viewWithTag:300+[self.type integerValue]];
        [self dismissHUD];
        self.fundDetail = fundInfo;
        self.headerView.fundValueLabel.text = fundInfo.fundTotal;
        self.headerView.useableValueLabel.text = fundInfo.fundUseale;
        self.headerView.frozenValueLabel.text = fundInfo.fundFrozen;
        if (self.refresh==topRefreshType) {
            //上拉添加更新数据
            self.tableArray =  [self transformToCellObjectWithFundInfo:fundInfo.fundDetaillistArray];
        }else{
            //下拉刷新数据
            NSMutableArray *backUpArray = [self transformToFundInfoWithCellObjectArray:self.tableData];
            [backUpArray addObjectsFromArray:fundInfo.fundDetaillistArray];
            NSMutableArray *array = [self transformToCellObjectWithFundInfo:backUpArray];
            self.tableArray = array;
        }
        
        switch ([self.type integerValue]) {
            case 0:
                self.fundUseDetailArray = self.tableArray;
                break;
            case 1:
                self.fundRechangeDetailArray = self.tableArray;
                break;
            case 2:
                self.fundDrawDetailArray = self.tableArray;
                break;
            case 3:
                self.fundFrozenDetailArray = self.tableArray;
                break;
            default:
                break;
        }
        
        [table.pullToRefreshView stopAnimating];
        [table.infiniteScrollingView stopAnimating];
        table.infiniteScrollingView.enabled = fundInfo.fundDetailCount>self.tableData.count;
        table.showsInfiniteScrolling = table.contentSize.height>table.frame.size.height;
        table.emptyDataView.requestSuccess = YES;
                [table reloadData];
    } andFail:^(NSString *failMessage) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
        UITableView *table = (UITableView *)[self.footView viewWithTag:300+[self.type integerValue]];
        [self setTableInfiniteWithTableview:table andEnable:NO];
        table.emptyDataView.requestSuccess = NO;
        [table reloadData];
    }];
}
- (void)setTableInfiniteWithTableview:(UITableView *)table andEnable:(BOOL)enable{
    table.infiniteScrollingView.enabled = enable;
    table.showsInfiniteScrolling = enable;
    [table.pullToRefreshView stopAnimating];
    [table.infiniteScrollingView stopAnimating];
}
- (NSMutableArray *)tableData{
    switch ([self.type integerValue]) {
        case 0:
            _tableData = self.fundUseDetailArray;
            break;
        case 1:
            _tableData = self.fundRechangeDetailArray;
            break;
        case 2:
            _tableData = self.fundDrawDetailArray;
            break;
        case 3:
            _tableData = self.fundFrozenDetailArray;
            break;
        default:
            break;
    }
    return _tableData;
}
- (NSString *)pageIndex{
    switch ([self.type integerValue]) {
        case 0:
            _pageIndex = self.fundUseDetailIndex;
            break;
        case 1:
            _pageIndex = self.fundRechangeDetailIndex;
            break;
        case 2:
            _pageIndex = self.fundDrawDetailIndex;
            break;
        case 3:
            _pageIndex = self.fundFrozenDetailIndex;
            break;
        default:
            break;
    }
    return _pageIndex;
}
//下拉上拉更新数据
- (NSMutableArray *)transformToCellObjectWithFundInfo:(NSMutableArray *)fundInfoArray{
    NSMutableArray *array = [NSMutableArray array];
    NSString *lastMonth = @"";
    NSMutableArray *firstArray;
    for (NSInteger i = 0; i < fundInfoArray.count; i++) {
        PBMFundDetailInfo_FundDetailItem *item = fundInfoArray[i];
        NSString *time = [item.fundTime substringWithRange:NSMakeRange(5, 2)];
        NSString *lastTime = lastMonth.length>0?[lastMonth substringWithRange:NSMakeRange(5, 2)]:lastMonth;
        if ([time isEqualToString:lastTime])//判断当前是否是本月
        {
            DPUAObject *object = [[DPUAObject alloc]init];
            object.fundTime = item.fundTime;// 明细时间
            object.fundTitle = item.fundTitle;// 明细文案
            object.fundValue = item.fundValue;// 明细金额
            object.fundType = (bundKindType)[item.fundType integerValue];// 明细类型
            object.projectType = item.projectType;// 方案类型
            object.projectId = item.projectId;// 方案id
            object.sourceId = item.souceId;// 方案 3普通方案  6追号
            object.sourceType = item.souceType;// 来源Id（追号id，方案id等）
            object.gameTypeId = item.gametypeId;//彩种类型
            [firstArray addObject:object];
        }else{
            if (firstArray.count>0) {
                [array addObject:firstArray];
            }
            lastMonth = item.fundTime;
            NSMutableArray *anotherArray = [NSMutableArray array];
            firstArray = anotherArray;
            
            DPUAObject *object = [[DPUAObject alloc]init];
            object.fundTime = item.fundTime;
            object.fundTitle = item.fundTitle;
            object.fundValue = item.fundValue;
            object.fundType = (bundKindType)[item.fundType integerValue];
            object.projectType = item.projectType;
            object.projectId = item.projectId;
            object.sourceId = item.souceId;
            object.sourceType = item.souceType;
            object.gameTypeId = item.gametypeId;
            [firstArray addObject:object];
        }
    }
    if (firstArray) {
        [array addObject:firstArray];
    }
    return array;
}

- (NSMutableArray *)transformToFundInfoWithCellObjectArray:(NSMutableArray *)cellObjectArray{
    NSMutableArray *fundInfo = [NSMutableArray array];
    for (NSInteger i = 0; i < cellObjectArray.count; i++) {
        NSArray *array = cellObjectArray[i];
        for (DPUAObject *object in array) {
            PBMFundDetailInfo_FundDetailItem *item = [[PBMFundDetailInfo_FundDetailItem alloc]init];
            item.fundTime = object.fundTime;
            item.fundTitle = object.fundTitle;
            item.fundValue = object.fundValue;
            item.fundType = [NSString stringWithFormat:@"%zd",object.fundType];
            item.projectId = object.projectId;
            item.projectType = object.projectType;
            item.souceId = object.sourceId;
            item.souceType = (int)object.sourceType;
            item.gametypeId = object.gameTypeId;
            [fundInfo addObject:item];
        }
    }
    return fundInfo;
}
@end




