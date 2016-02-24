//
//  DPGSHomeViewController.m
//  Jackpot
//
//  Created by mu on 15/7/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

//controller
#import "DPGSHomeViewController.h"
#import "DPFeedbackViewController.h"
#import "DPGSRankingViewController.h"
#import "DPGSPrerogativeViewController.h"
#import "DPAlterViewController.h"
//view
#import "DPGSHomeHeaderView.h"
#import "DPGSHomeHeaderObject.h"
#import "CreditConstant.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "DPGSItemsScrollView.h"
#import "DPSuperPlayerCell.h"
#import "DPGSTaskCell.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
//data
#import "DPGSTaskObject.h"
#import "Growthsystem.pbobjc.h"
//UMeng
#import "UMCommunity.h"
#import "UMComUserAccount.h"
#import "UMComLoginManager.h"
#import "UMComNavigationController.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"

@interface DPGSHomeViewController()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
//=======================================================view
@property (nonatomic, strong) DPGSHomeHeaderView *headerView;
@property (nonatomic, strong) DPGSItemsScrollView *contentView;
@property (nonatomic, strong) UIButton *helpBtn;
//=======================================================data
@property (nonatomic, strong) DPGSHomeHeaderObject *headerObject;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *taskDayArray;
@property (nonatomic, strong) NSMutableArray *taskAchieveArray;
@property (nonatomic, strong) NSMutableArray *taskArray;
@end

@implementation DPGSHomeViewController
#pragma mark---------life cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDataFrowServer];
}

- (void)viewDidLoad{

    [super viewDidLoad] ;
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    //headerView
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(220);
    }];
    //contentView
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    self.dp_shouldNavigationBarHidden = YES;
}

#pragma mark---------data


- (void)requestDataFrowServer{
    if (!self.growHomeData) {
        [self showHUD];
    }
    @weakify(self);
    [DPUARequestData growSystemHomeDataSuccess:^(PBMGrowthHome *homeData) {
        @strongify(self);
        [self dismissHUD];
        self.growHomeData = homeData;
    } fail:^(NSString *error) {
        @strongify(self);
        [self dismissHUD];
        for (NSInteger i = 0; i < 3; i++) {
            UITableView *table = [self.contentView.tablesView viewWithTag:200+i];
            table.emptyDataView.requestSuccess = NO;
            [table.pullToRefreshView stopAnimating];
            [table reloadData];
        }
    }];
}

- (void)setGrowHomeData:(PBMGrowthHome *)growHomeData{
    _growHomeData = growHomeData;
    if (_growHomeData.userInfo.checkIn) {
        NSString *title = [NSString stringWithFormat:@"已签%d天",_growHomeData.userInfo.checkInCount];
        [self.checkInBtn setTitle:title forState:UIControlStateNormal];
    }else{
        [self.checkInBtn setTitle:@"签到" forState:UIControlStateNormal];
    }
    
    self.headerView.object = self.headerObject;

    
    self.taskArray = [self setTableDataWithArray:_growHomeData.rookieArray];
    self.taskDayArray = [self setTableDataWithArray:_growHomeData.dailyArray];
    self.taskAchieveArray = [self setTableDataWithArray:_growHomeData.achievementArray];
    
    for (NSInteger i = 0; i < 3; i++) {
        UITableView *table = [self.contentView.tablesView viewWithTag:200+i];
        table.emptyDataView.requestSuccess = YES;
        [self setTableDataWithIndex:i];
        [table.pullToRefreshView stopAnimating];
        [table reloadData];
    }
    
    [self getRedPointHiddle];
    
    self.contentView.selectIndex = growHomeData.tagIndex;
}
- (void)setTableDataWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            self.tableData = self.taskArray;
        }
            break;
        case 1:
        {
            self.tableData = self.taskDayArray;
        }
            break;
        case 2:
        {
            self.tableData = self.taskAchieveArray;
        }
            break;
        default:
            break;
    }
}

- (NSMutableArray *)setTableDataWithArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i<dataArray.count; i++) {
        PBMGrowthTaskItem *obj = dataArray[i];
        DPGSTaskObject *object = [[DPGSTaskObject alloc]init];
        object.stata = (DPTaskState)obj.state;
        object.type = (DPTaskType)obj.type;
        object.iconImageURL = obj.taskIcon;
        object.taskEvent = obj.taskEvent;
        object.taskId = [NSString stringWithFormat:@"%zd",obj.taskId];
        if(obj.type== DPTaskTypeUp){
            object.titleLabelStr = [NSString stringWithFormat:@"%@(等级%@)",obj.taskName,obj.taskLevel];
        }else{
            object.titleLabelStr = obj.taskName;
        }
        object.subTitleLabStr = [NSString stringWithFormat:@"完成进度：%@",obj.taskStep];
        object.moneyLabStr = [NSString stringWithFormat:@"奖励：成长值%@  积分：%@",obj.taskGrowup,obj.taskCredit];
        for(NSInteger i =0 ;i<obj.subitemListArray.count;i++){
            PBMGrowthTaskItem_SubItem *playType = obj.subitemListArray[i];
            DPPlayKind *playKind = [[DPPlayKind alloc]init];
            playKind.title = playType.gameTitle;
            playKind.isFinished = playType.gameState;
            [object.kindArray addObject:playKind];
        }
        [array addObject:object];
    }
    return array;
}

- (void)getRedPointHiddle{
    self.contentView.taskNewerGet = YES;
    self.contentView.taskDayGet = YES;
    self.contentView.taskAchieveGet = YES;
    for (PBMGrowthTaskItem *newerTask in self.growHomeData.rookieArray) {
        if (newerTask.state == 2) {
            self.contentView.taskNewerGet = NO;
        }
    
    }
    
    for (PBMGrowthTaskItem *daysTask in self.growHomeData.dailyArray) {
        if (daysTask.state == 2) {
            self.contentView.taskDayGet = NO;
        }
     
    }
    
    
    for (PBMGrowthTaskItem *achieveTask in self.growHomeData.achievementArray) {
        if (achieveTask.state == 2) {
            self.contentView.taskAchieveGet = NO;
        }
    }
    
}
#pragma mark---------导航栏
- (void)setUpNavigationBar {
    
    UIButton *leftNavItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftNavItem setImage:dp_NavigationImage(@"back.png") forState:UIControlStateNormal];
    [leftNavItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:leftNavItem];
    
    UIButton *rightNavItem = [self createNavItemWithTitle:@"签到"];
    [rightNavItem addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:rightNavItem];
    rightNavItem.selected = YES;
    self.checkInBtn = rightNavItem;
    
    UIButton *helpItem = [self createNavItemWithTitle:@"帮助"];
    [helpItem addTarget:self action:@selector(jumpToHelp:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:helpItem];
    self.helpBtn = helpItem;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor dp_flatWhiteColor];
    lineView.alpha = 0.33;
    [_headerView addSubview:lineView];
    
    [leftNavItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [helpItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(helpItem.mas_centerY);
        make.right.equalTo(helpItem.mas_left);
        make.size.mas_equalTo(CGSizeMake(0.5, 14));
    }];
    
    [rightNavItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.equalTo(lineView.mas_left).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
}
//返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
//帮助
- (void)jumpToHelp:(UIButton *)btn{
    
    DPWebViewController *controller = [[DPWebViewController alloc]init];
    controller.title = @"帮助";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerBaseURL,@"/web/help/user"];
    controller.requset = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:controller animated:YES];
}
//签到
- (void)signIn:(UIButton *)btn{
    
    if (self.growHomeData.userInfo.checkIn) {
        DPAlterViewController *gsAlter = [[DPAlterViewController alloc]initWithAlterType:AlterTypePoint];
        gsAlter.registerTime = self.growHomeData.userInfo.checkContinuesCount;
        [self dp_showViewController:gsAlter animatorType:DPTransitionAnimatorTypeAlert completion:nil];
    }else{
        [self showHUD];
        @weakify(self);
        [DPUARequestData signInSuccess:^(PBMGrowthCheckIn *checkResult) {
            @strongify(self);
            [self dismissHUD];
            DPAlterViewController *gsAlter = [[DPAlterViewController alloc]initWithAlterType:AlterTypePoint];
            gsAlter.registerTime = checkResult.runningDays;
            gsAlter.checkIn = checkResult;
            [self dp_showViewController:gsAlter animatorType:DPTransitionAnimatorTypeAlert completion:^{
                [self requestDataFrowServer];
            }];
        } fail:^(NSString *error) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:error color:[UIColor dp_flatBlackColor]] show];
        }];
    }
}
//create navItem
- (UIButton *)createNavItemWithTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    return btn;
}
#pragma mark---------headerView
//view
- (DPGSHomeHeaderView *)headerView{
    if (!_headerView) {
        __weak DPGSHomeViewController *weakSelf = self;
        _headerView = [[DPGSHomeHeaderView alloc]init];
        _headerView.tapBlock = ^(UIButton *btn){
            switch (btn.tag) {
                case 1000:
                {
                }
                    break;
                case 1001:
                {
                    DPGSRankingViewController *controller = [[DPGSRankingViewController alloc]init];
                    controller.userRegisterTime = weakSelf.growHomeData.userInfo.userLoginTime;
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        };
        _headerView.levelTappedBlock = ^(id sender){
            DPGSPrerogativeViewController  *controller = [[DPGSPrerogativeViewController alloc]init];
            controller.useInfo = weakSelf.growHomeData.userInfo;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        };
        [self setUpNavigationBar];
        
    }
    return _headerView;
}
//modal
- (DPGSHomeHeaderObject *)headerObject{
    if (!_headerObject) {
        _headerObject = [[DPGSHomeHeaderObject alloc]init];
    }
    _headerObject.levelLabelName = [NSString stringWithFormat:@"LV%d",self.growHomeData.userInfo.level];
    _headerObject.jifenLabelName = [NSString stringWithFormat:@"%d",self.growHomeData.userInfo.credit];
    _headerObject.growValueLabelName = [NSString stringWithFormat:@"%d",self.growHomeData.userInfo.growup];
    _headerObject.iconImageName = self.growHomeData.userInfo.iconURL;
    
    return _headerObject;
}
#pragma mark---------contentView
- (DPGSItemsScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[DPGSItemsScrollView alloc]init];
        for (NSInteger i = 0; i < _contentView.viewArray.count; i++) {
            UIView *view = _contentView.viewArray[i];
            view.backgroundColor = randomColor;
            UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.emptyDataView = [self creatEmptyView];
            table.backgroundColor = UIColorFromRGB(0xeef6f9);
            table.tag = 200+i;
            [view addSubview:table];
            [table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            @weakify(self);
            table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
                @strongify(self);
                switch (type) {
                    case DZNEmptyDataViewTypeNoData:
                    {
                    }
                        break;
                    case DZNEmptyDataViewTypeFailure:
                    {
                        [self requestDataFrowServer];
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
    }
    return _contentView;
}
//delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     [self setTableDataWithIndex:(tableView.tag-200)];
    return self.tableData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     [self setTableDataWithIndex:(tableView.tag-200)];
    DPGSTaskObject *obj = self.tableData[indexPath.row];
    if (obj.type == DPTaskTypeCommon || obj.type == DPTaskTypeUp) {
        return 76;
    }else{
        return 93.5;
    }
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     [self setTableDataWithIndex:(tableView.tag-200)];
    DPGSTaskObject *obj = self.tableData[indexPath.row];
    static NSString *identifier = @"mark";
    if (obj.type == DPTaskTypeCommon || obj.type == DPTaskTypeUp) {
        DPGSTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[DPGSTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.object = obj;
        return cell;
    }else{
        DPSuperPlayerCell *cell = [[DPSuperPlayerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.object = obj;
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setTableDataWithIndex:(tableView.tag-200)];
    DPGSTaskObject *obj = self.tableData[indexPath.row];
    switch (obj.stata) {
        case DPTaskStateInitilizer:
        {
            //初始状态－》跳转到相应链接
            if (obj.taskEvent.length>0) {
                NSString *urlStr =[obj.taskEvent stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSURL *url = [NSURL URLWithString:urlStr];
                [DPAppURLRoutes handleURL:url];
            }
        }
            break;
        case DPTaskStateCanGet:
        {
            [self getTaskAwardWithTaskid:obj.taskId];
        }
            break;
        case DPTaskStateFinished:
        {
            
        }
            break;
        default:
            break;
    }

}
//emptyView
- (DZNEmptyDataView *)creatEmptyView{
    DZNEmptyDataView * emptyView = [DZNEmptyDataView emptyDataView];
    emptyView.showButtonForNoData = NO;
    emptyView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
    emptyView.textForNoData = @"暂无数据";
    return emptyView;
}
//领取奖励
- (void)getTaskAwardWithTaskid:(NSString *)taskId{
    @weakify(self);
    [DPUARequestData getTaskAwardWithParam:taskId success:^(PBMGrowthDrawTask *award) {
        @strongify(self);
        //能获取状态－》吊起奖励接口
        DPAlterViewController *controller = [[DPAlterViewController alloc]initWithAlterType:AlterTypeSuccess];
        controller.award = award;
        [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
        @weakify(self);
        controller.fullBtnTapped = ^(UIButton *btn){
            @strongify(self);
            [self requestDataFrowServer];
            if (award.upgradeLevel) {
                DPAlterViewController *controller = [[DPAlterViewController alloc]initWithAlterType:AlterTypePromote];
                controller.award = award;
                [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
            }
        };
    } fail:^(NSString *error) {
        [[DPToast makeText:error color:[UIColor dp_flatBlackColor]] show];
    }];
}
@end
