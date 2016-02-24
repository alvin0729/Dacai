//
//  DPGSRankingViewController.m
//  Jackpot
//
//  Created by mu on 15/7/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGSRankingViewController.h"
#import "DPAlterViewController.h"
#import "DPGSRankingCell.h"
#import "DPGSRankingAwardController.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
//data
#import "Growthsystem.pbobjc.h"
#import "DPUARequestData.h"

@interface DPGSRankingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *tiltleBgView;
@property (nonatomic, strong) UISegmentedControl *titleSeg;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerTitle;
@property (nonatomic, strong) UILabel *headerSubTitle;
@property (nonatomic, strong) UITableView *rankTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *tableDayData;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, assign) BOOL isDayRanking;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) PBMGrowthRanking *rankingData;
@property (nonatomic, strong) MASConstraint *headViewHeightConstraint;
@end

@implementation DPGSRankingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *clearImage = [UIImage dp_imageWithColor:UIColorFromRGB(0xdc4e4c)];
    self.title = @"成长值排行榜";

    [self.navigationController.navigationBar setBackgroundImage:clearImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:clearImage];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self.view addSubview:self.tiltleBgView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.rankTable];
    [self.view addSubview:self.btnView];
    [self masUI];
    [self requestDataFromServer];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)masUI{
    [self.tiltleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tiltleBgView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        self.headViewHeightConstraint = make.height.mas_equalTo(120);
    }];

    [self.rankTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.btnView.mas_top).offset(-10);
    }];
    
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}
- (void)requestDataFromServer{
    @weakify(self);
    [DPUARequestData growSystemRankingDataSuccess:^(PBMGrowthRanking *rankingData) {
        @strongify(self);
        self.rankingData = rankingData;
        
    } fail:^(NSString *error) {
        [[DPToast makeText:error color:[UIColor dp_flatBlackColor]] show];
        
        self.rankTable.emptyDataView.requestSuccess = NO;
        [self.rankTable reloadData];
    }];
}

- (void)setRankingData:(PBMGrowthRanking *)rankingData{
    _rankingData = rankingData;
    
    //headerview
    [self setHeaderData];
   
    //tableData
    for (NSInteger i = 0; i<_rankingData.totalRankArray.count; i++) {
        PBMGrowthRanking_RankItem *rankingObj = _rankingData.totalRankArray[i];
        DPGSRankingObject *object = [[DPGSRankingObject alloc]init];
        object.numberLabelStr = [NSString stringWithFormat:@"%d",rankingObj.rank];
        object.nameLabelStr = rankingObj.userName;
        object.intergralLabelStr = [NSString stringWithFormat:@"%d",rankingObj.credit];
        object.trend = (DPGSTrendType)rankingObj.trend;
        [self.tableData addObject:object];
    }

    //tableData
    for (NSInteger i = 0; i<_rankingData.dailyRankArray.count; i++) {
        PBMGrowthRanking_RankItem *rankingObj = _rankingData.dailyRankArray[i];
        DPGSRankingObject *object = [[DPGSRankingObject alloc]init];
        object.numberLabelStr = [NSString stringWithFormat:@"%d",rankingObj.rank];
        object.nameLabelStr = rankingObj.userName;
        object.intergralLabelStr = [NSString stringWithFormat:@"%d",rankingObj.credit];
        object.trend = (DPGSTrendType)rankingObj.trend;
        [self.tableDayData addObject:object];
    }
    [self getWidthInTableData];
    self.rankTable.emptyDataView.requestSuccess = YES;
    [self.rankTable reloadData];
    
}
- (void)setHeaderData{
    self.headerTitle.text = [NSString stringWithFormat:@"%d成长值",self.titleSeg.selectedSegmentIndex == 0?_rankingData.growup:_rankingData.dailyGrowup];
    NSInteger titleLength = self.headerTitle.text.length;
    if (titleLength>0) {
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:self.headerTitle.text];
        [titleStr addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xdc4e4c) range:NSMakeRange(0, titleLength-3)];
        [titleStr addAttribute:NSFontAttributeName value:(id)[UIFont systemFontOfSize:12] range:NSMakeRange(titleLength-3, 3)];
        self.headerTitle.attributedText = titleStr ;
    }
    if (self.titleSeg.selectedSegmentIndex == 0) {
        self.headerSubTitle.text = _rankingData.growupTotalTitle;
    }else{
        self.headerSubTitle.text = _rankingData.growupDailyTitle;
    }
}
#pragma mark---------titleBgView
- (UIView *)tiltleBgView{
    if (!_tiltleBgView) {
        _tiltleBgView = [[UIView alloc]init];
        _tiltleBgView.backgroundColor = UIColorFromRGB(0xdc4e4c);
        [_tiltleBgView addSubview:self.titleSeg];
        [self.titleSeg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(4);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.height.mas_equalTo(30);
        }];
    }
    return _tiltleBgView;
}

#pragma mark---------titleSeg
- (UISegmentedControl *)titleSeg{
    if (!_titleSeg) {
        NSArray *items = @[@"总排行",@"每日排行"];
        _titleSeg = [[UISegmentedControl alloc]initWithItems:items];
        _titleSeg.layer.cornerRadius = 0;
        _titleSeg.tintColor = [UIColor whiteColor];
        _titleSeg.selectedSegmentIndex = 0;
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
        [_titleSeg setTitleTextAttributes:dic forState:UIControlStateNormal];
        [[_titleSeg rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(UISegmentedControl *seg) {
            self.isDayRanking = seg.selectedSegmentIndex;
            [self setHeaderData];
            [self.rankTable reloadData];
        }];
    }
    return _titleSeg;
}
#pragma mark---------headerView
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"rankingIcon.png")];
        iconImage.contentMode = UIViewContentModeCenter;
        iconImage.layer.cornerRadius = 30;
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = [UIFont boldSystemFontOfSize:24];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textColor = [UIColor lightGrayColor];
        titleLab.text = @"--成长值";
        self.headerTitle = titleLab;
        
        UILabel *subTitleLab = [[UILabel alloc]init];
        subTitleLab.font = [UIFont systemFontOfSize:12];
        subTitleLab.textAlignment = NSTextAlignmentCenter;
        subTitleLab.numberOfLines = 0;
        subTitleLab.textColor = UIColorFromRGB(0x666666);
        subTitleLab.backgroundColor = [UIColor clearColor];
        self.headerSubTitle = subTitleLab;
        [_headerView addSubview:iconImage];
        [_headerView addSubview:titleLab];
        [_headerView addSubview:subTitleLab];
        
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.centerX.mas_equalTo(_headerView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImage.mas_bottom).offset(6);  
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(24);
        }];
        
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom).offset(6);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
        }];
        
    }
    return _headerView;
}

#pragma mark---------myTable
- (UITableView *)rankTable{
    if (!_rankTable) {
        _rankTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rankTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rankTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _rankTable.dataSource = self;
        _rankTable.delegate = self;
        _rankTable.emptyDataView = [self creatEmptyView];
        @weakify(self);
        _rankTable.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
            @strongify(self);
            switch (type) {
                case DZNEmptyDataViewTypeNoData:
                {
                    [self requestDataFromServer];
                }
                    break;
                case DZNEmptyDataViewTypeFailure:
                {
                    [self requestDataFromServer];
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
    return _rankTable;
}
//emptyView
- (DZNEmptyDataView *)creatEmptyView{
    DZNEmptyDataView * emptyView = [DZNEmptyDataView emptyDataView];
    emptyView.showButtonForNoData = NO;
    emptyView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
    emptyView.textForNoData = @"暂无数据";
    return emptyView;
}
- (NSMutableArray *)tableData{
    if (!_tableData) {
        _tableData = [NSMutableArray array];
    }
    return _tableData;
}

- (NSMutableArray *)tableDayData{
    if (!_tableDayData) {
        _tableDayData = [NSMutableArray array];
    }
    return _tableDayData;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isDayRanking){
        self.headViewHeightConstraint.mas_equalTo(self.tableDayData.count==0?0:120);
        return self.tableDayData.count;
    }else{
        self.headViewHeightConstraint.mas_equalTo(self.tableData.count==0?0:120);
        return self.tableData.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseId = [NSString stringWithFormat:@"DPGSRankingCell%ld",(long)indexPath.row];
    DPGSRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[DPGSRankingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    DPGSRankingObject *object = nil;
    if (self.isDayRanking) {
        object = self.tableDayData[indexPath.row];
    }else{
        object = self.tableData[indexPath.row];
    }
    object.indexPath = indexPath.row;
    object.isDayRanking = self.isDayRanking;
    cell.object = object;
    return cell;
}

- (void)getWidthInTableData{
    CGFloat baseWidth = 0;
    for (NSInteger i = 0 ;i<self.tableDayData.count;i++) {
        DPGSRankingObject *obj = self.tableDayData[i];
        if (i==0) {
            obj.width = 1; 
            baseWidth = [obj.intergralLabelStr floatValue];
        }else{
            obj.width = [obj.intergralLabelStr floatValue]/baseWidth;
        }
    }
    for (NSInteger i = 0 ;i<self.tableData.count;i++) {
        DPGSRankingObject *obj = self.tableData[i];
        if (i==0) {
            obj.width = 1;
            baseWidth = [obj.intergralLabelStr floatValue];
        }else{
            obj.width = [obj.intergralLabelStr floatValue]/baseWidth;
        }
    }
   
}

- (CGFloat)maxWidth{
    if (!_maxWidth) {
        DPGSRankingObject *object = self.tableData[0];
        CGFloat maxFloat = [object.intergralLabelStr floatValue];
        for (DPGSRankingObject *obj in self.tableData) {
            if (maxFloat < [obj.intergralLabelStr floatValue]) {
                maxFloat = [obj.intergralLabelStr floatValue];
            }
        }
        _maxWidth = maxFloat;
    }
    return _maxWidth;
}

#pragma mark---------btnView
- (UIView *)btnView{
    if (!_btnView) {
        _btnView = [[UIView alloc]init];
        _btnView.backgroundColor = [UIColor dp_flatWhiteColor];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = UIColorFromRGB(0xd2d1cf);
        [_btnView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        [btn setTitle:@"领取排名奖励" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rankTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-6);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(36);
        }];
        
    }
    return _btnView;
}

- (void)rankTapped:(UIButton *)btn{
    DPGSRankingAwardController *controller = [[DPGSRankingAwardController alloc]init];
    controller.type = self.isDayRanking?1:2;
    controller.userRegisterTime = self.userRegisterTime;
    [self.navigationController pushViewController:controller animated:YES];
}
@end






















