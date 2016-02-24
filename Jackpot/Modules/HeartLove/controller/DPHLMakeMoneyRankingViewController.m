//
//  DPHLMakeMoneyRankingViewController.m
//  Jackpot
//
//  Created by mu on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLMakeMoneyRankingViewController.h"
#import "DPOpenBetServiceController.h"
#import "DPHLExpertViewController.h"
#import "DPHLMakingMoneyRankingCell.h"
#import "DPLogOnViewController.h"
#import "DPItemsScrollView.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
//data
#import "Wages.pbobjc.h"
@interface DPHLMakeMoneyRankingViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  表头
 */
@property (nonatomic, strong) UIView *headerView;
/**
 *  内容表单
 */
@property (nonatomic, strong) UITableView *contentView;
/**
 *  过滤器表单
 */
@property (nonatomic, strong) UITableView *selectTabel;
/**
 *  日期选择项
 */
@property (nonatomic, strong) UILabel *dateLabel;
/**
 *  赛事选择项
 */
@property (nonatomic, strong) UILabel *matchLabel;
/**
 *  日期选择项箭头图标
 */
@property (nonatomic, strong) UIImageView *dateImage;
/**
 *  赛事选择项箭头图标
 */
@property (nonatomic, strong) UIImageView *matchImage;
/**
 *  日期选择项对应的内容数组
 */
@property (nonatomic, strong) NSArray *dateArray;
/**
 *  赛事选择项对应的内容数组
 */
@property (nonatomic, strong) NSArray *matchArray;
/**
 *  日期选择项选择索引
 */
@property (nonatomic, strong) NSIndexPath *dateIndex;
/**
 *  过滤器背景遮罩
 */
@property (nonatomic, strong) UIView *backView;
/**
 *  内容表单数据
 */
@property (nonatomic, strong) ProfitRanking *profitRanking;
/**
 *  赛事选择项选择索引
 */
@property (nonatomic, assign) NSInteger leagueType;
/**
 *  是否赛事选择项点击
 */
@property (nonatomic, assign) BOOL matchSelect;
/**
 *  过滤器是否打开
 */
@property (nonatomic, assign) BOOL selectTableOpen;
@end

@implementation DPHLMakeMoneyRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"赚钱排行榜";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self setupUI];
    [self setupData];
}
- (void)setupUI{
    //添加内容表单
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(37);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    //添加过滤器阴影背景
    self.backView = [[UIView alloc]initWithFrame:self.view.frame];
    self.backView.alpha = 0;
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.userInteractionEnabled = YES;
    [self.view addSubview:self.backView];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTabelHiddle)];
    [self.backView addGestureRecognizer:gesture];
    //添加过滤器
    [self.view addSubview:self.selectTabel];
    //添加表头
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(37);
    }];
    
}
/**
 *  初始化数据
 */
- (void)setupData{
    self.dateArray = @[@"近7天统计",@"近30天统计"];
    self.matchArray = @[@"全部赛事",@"英超",@"法甲",@"德甲",@"西甲",@"意甲",@"其他"];
    self.leagueType = 1;
    self.selectTableOpen = NO;
    [self requestDataFromServer];
}
#pragma mark---------headerView
//初始化表头
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor dp_flatWhiteColor];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewTapped:)];
        [_headerView addGestureRecognizer:gesture];
        
        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [_headerView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        
        UIView *verLiner = [[UIView alloc]init];
        verLiner.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [_headerView addSubview:verLiner];
        [verLiner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.centerX.equalTo(_headerView.mas_centerX);
            make.bottom.mas_equalTo(-6);
            make.width.mas_equalTo(0.5);
        }];
        
        self.dateLabel = [UILabel dp_labelWithText:@"近7天统计" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x7e6b5a) font:[UIFont systemFontOfSize:15]];
        [_headerView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView.mas_centerX).offset(-kScreenWidth*0.25-9);
            make.centerY.equalTo(_headerView.mas_centerY);
        }];
        
        UIImageView *arrow = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLDownArrow.png")];
        [_headerView addSubview:arrow];
        self.dateImage = arrow;
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView.mas_centerY);
            make.left.equalTo(self.dateLabel.mas_right).offset(4);
        }];
        
        self.matchLabel = [UILabel dp_labelWithText:@"全部赛事" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x7e6b5a) font:[UIFont systemFontOfSize:15]];
        [_headerView addSubview:self.matchLabel];
        [self.matchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView.mas_centerX).offset(kScreenWidth*0.25-9);
            make.centerY.equalTo(_headerView.mas_centerY);
        }];
        
        UIImageView *arrowRight = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLDownArrow.png")];
        [_headerView addSubview:arrowRight];
        self.matchImage = arrowRight;
        [arrowRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView.mas_centerY);
            make.left.equalTo(self.matchLabel.mas_right).offset(4);
        }];
    }
    return _headerView;
}
//选择项点击
- (void)headerViewTapped:(UITapGestureRecognizer *)gesture {
    
    if (self.selectTableOpen) {
        [self selectTabelHiddle];
        return;
    }
    
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (touchPoint.x<kScreenWidth*0.5) {
        self.matchSelect = NO;
        [self resetDateSelectItemColor:[UIColor dp_flatRedColor] andImage:dp_HeartLoveImage(@"HLUpArrow.png")];
        [self resetMatchSelectItemColor:UIColorFromRGB(0x7e6b5a) andImage:dp_HeartLoveImage(@"HLDownArrow.png")];
    }else{
        self.matchSelect = YES;
        [self resetDateSelectItemColor:UIColorFromRGB(0x7e6b5a) andImage:dp_HeartLoveImage(@"HLDownArrow.png")];
        [self resetMatchSelectItemColor:[UIColor dp_flatRedColor] andImage:dp_HeartLoveImage(@"HLUpArrow.png")];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.selectTabel.frame = CGRectMake(0, 37, kScreenWidth, 44*(self.matchSelect?self.matchArray.count:self.dateArray.count));
        self.backView.alpha = 0.666;
        self.selectTableOpen = YES;
    }];
    [self.selectTabel reloadData];
}
//重置日期选择项字体颜色和箭头图片
- (void)resetDateSelectItemColor:(UIColor *)color andImage:(UIImage *)image{
    self.dateLabel.textColor = color;
    self.dateImage.image =  image;
}
//重置赛事选择项字体颜色和箭头图片
- (void)resetMatchSelectItemColor:(UIColor *)color andImage:(UIImage *)image{
    self.matchLabel.textColor = color;
    self.matchImage.image =  image;
}
#pragma mark---------selectTabel
/**
 *  初始化过滤器
 */
- (UITableView *)selectTabel{
    if (!_selectTabel) {
        _selectTabel =  [[UITableView alloc]initWithFrame:CGRectMake(0, -kScreenHeight+37, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _selectTabel.dataSource = self;
        _selectTabel.delegate = self;
        _selectTabel.tableFooterView = [[UIView alloc]init];
        _selectTabel.backgroundColor = [UIColor clearColor];
        _selectTabel.backgroundView.userInteractionEnabled = YES;
        _selectTabel.backgroundView.backgroundColor = randomColor;

    }
    return _selectTabel;
}
/**
 *  隐藏过滤器
 */
- (void)selectTabelHiddle{
    [UIView animateWithDuration:0.25 animations:^{
        self.selectTabel.frame = CGRectMake(0, -kScreenHeight+37, kScreenWidth, kScreenHeight);
        self.backView.alpha = 0;
        self.selectTableOpen = NO;
    }];
    
    [self resetDateSelectItemColor:UIColorFromRGB(0x7e6b5a) andImage:dp_HeartLoveImage(@"HLDownArrow.png")];
    [self resetMatchSelectItemColor:UIColorFromRGB(0x7e6b5a) andImage:dp_HeartLoveImage(@"HLDownArrow.png")];
}
#pragma mark---------contentView
//初始化内容表单
- (UITableView *)contentView{
    if (!_contentView) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.emptyDataView = [self creatEmptyView];
        table.backgroundColor = [UIColor dp_flatBackgroundColor];
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 11)];
        headerView.backgroundColor = [UIColor clearColor];
        table.tableHeaderView = headerView;
        //空试图
        @weakify(self);
        table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
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
        //下拉刷新
        [table addPullToRefreshWithActionHandler:^{
            @strongify(self);
            [self requestDataFromServer];
        }];
        _contentView = table;
    }
    return _contentView;
}
//emptyView
- (DZNEmptyDataView *)creatEmptyView{
    DZNEmptyDataView * emptyView = [DZNEmptyDataView emptyDataView];
    emptyView.showButtonForNoData = NO;
    emptyView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
    emptyView.textForNoData = @"暂无数据";
    return emptyView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView == self.selectTabel ? (self.matchSelect?self.matchArray.count:self.dateArray.count):self.profitRanking.profitItemsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView == self.selectTabel ? 44:77;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.selectTabel) {//过滤器表单cell
        static NSString *reuseId = @"selectCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.textLabel.textColor = UIColorFromRGB(0x7e6b5a);
            cell.textLabel.font = [UIFont systemFontOfSize:17];
        }
      
        cell.textLabel.text = self.matchSelect ? self.matchArray[indexPath.row]:self.dateArray[indexPath.row];
        if (self.matchSelect&&[self.matchLabel.text isEqualToString:self.matchArray[indexPath.row<self.matchArray.count?indexPath.row:0]]) {
            cell.backgroundColor = UIColorFromRGB(0xe6e6e6);
        }else if(self.matchSelect==NO&&[self.dateLabel.text isEqualToString:self.dateArray[indexPath.row<self.dateArray.count?indexPath.row:0]]) {
            cell.backgroundColor = UIColorFromRGB(0xe6e6e6);
        }else{
            cell.backgroundColor = [UIColor dp_flatWhiteColor];
        }
        return cell;
    }
    //赚钱排行表单cell
    DPHLMakingMoneyRankingCell *cell = [[DPHLMakingMoneyRankingCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    cell.object = [self transformProfitItemToObject:self.profitRanking.profitItemsArray[indexPath.row]];
    @weakify(self);
    //关注与取消关注
    cell.focusBtnTapped = ^(DPHLObject *object){
        @strongify(self);
        if (![DPMemberManager sharedInstance].isLogin) {
            UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:[[DPLogOnViewController alloc]init]];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
        if (object.isSelect) {
            @weakify(self);
            EditAttention *param = [[EditAttention alloc]init];
            param.userId = object.userId;
            [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/CancelAttention" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(self);
                [self dismissHUD];
                
                [[DPToast makeText:@"取消关注成功"]show];
                [self requestDataFromServer];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                @strongify(self);
                [self dismissHUD];
                [[DPToast makeText:[error dp_errorMessage]]show];
            }];
        }else{
            @weakify(self);
            EditAttention *param = [[EditAttention alloc]init];
            param.userId = object.userId;
            [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/SetAttention" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(self);
                [self dismissHUD];
                 [[DPToast makeText:@"关注成功"]show];
                [self requestDataFromServer];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                @strongify(self);
                [self dismissHUD];
                [[DPToast makeText:[error dp_errorMessage]]show];
            }];
        }
    };
    //cell点击，跳转到专家详情
    cell.cellTapped = ^(NSIndexPath *indexPath){
        @strongify(self);
        DPHLObject *object =  [self transformProfitItemToObject:self.profitRanking.profitItemsArray[indexPath.row]];
        DPHLExpertViewController *controller = [[DPHLExpertViewController alloc] init];
        controller.uid = object.userId;
        [self.navigationController pushViewController:controller animated:YES];
    };
    cell.rankingLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
    cell.rankingBgImage.image = dp_HeartLoveImage(indexPath.row<3?@"HLRankingfront.png":@"HLRankingBack.png");
    cell.iconImage.alpha = indexPath.row<3?1:0.33;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.selectTabel) {//过滤器cell点击
        if (self.matchSelect) {
            self.matchLabel.text = self.matchArray[indexPath.row];
        }else{
            self.dateIndex = indexPath;
            self.dateLabel.text = self.dateArray[indexPath.row];
        }
        
        [UIView animateWithDuration:0.25f animations:^{
            self.selectTabel.frame = CGRectMake(0, -kScreenHeight+37, kScreenWidth, kScreenHeight);
            self.backView.alpha = 0;
            self.selectTableOpen = NO;
        }];
        
        [self resetDateSelectItemColor:UIColorFromRGB(0x7e6b5a) andImage:dp_HeartLoveImage(@"HLDownArrow.png")];
        [self resetMatchSelectItemColor:UIColorFromRGB(0x7e6b5a) andImage:dp_HeartLoveImage(@"HLDownArrow.png")];
        
        if (self.matchSelect) {
            self.leagueType = indexPath.row > 0?indexPath.row<self.matchArray.count-1?indexPath.row+2:2 :1;
        }
     
        [self requestDataFromServer];
        
        
    }
}
#pragma mark---------data
- (void)requestDataFromServer{
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager]GET:[NSString stringWithFormat:@"/wages/ProfitRanking?type=%zd&leagueType=%zd",self.dateIndex.row,self.leagueType] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        self.profitRanking = [ProfitRanking parseFromData:responseObject error:nil];
        [self.contentView.pullToRefreshView stopAnimating];
         self.contentView.emptyDataView.requestSuccess = YES;
        [self.contentView reloadData];
        [self.selectTabel reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [self.contentView.pullToRefreshView stopAnimating];
        self.contentView.emptyDataView.requestSuccess = NO;
        [self.contentView reloadData];
        [self.selectTabel reloadData];
        [[DPToast makeText:[error dp_errorMessage]]show];
    }];
}
- (DPHLObject *)transformProfitItemToObject:(ProfitRanking_profitItem *)profitItem{
    DPHLObject *object = [[DPHLObject alloc]init];
    object.title = profitItem.userName;
    object.userId = (long)profitItem.userId;
    object.subTitle = [NSString stringWithFormat:@"%zd",profitItem.fansCount];
    object.isSelect = profitItem.isFocused;
    object.value = profitItem.profit;
    object.isWeek = self.dateIndex.row==0;
    return object;
}
@end
