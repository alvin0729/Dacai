//
//  DPSpecifyInfoViewController.m
//  DacaiProject
//
//  Created by jacknathan on 14-9-19.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSpecifyInfoViewController.h"
#import "DPLotteryInfoTableViewCell.h"
#import "SVPullToRefresh.h"
#import "FrameWork.h"
#import "DPLotteryInfoWebViewController.h"
#import "DPNodataView.h"
@interface DPSpecifyInfoViewController ()
{
    GameTypeId      _gameType;
    NSString        *_navTitle;
    CLotteryInfo    *_infoCenter;
    DPNodataView *_noDataView ;

}
@property (nonatomic, strong, readonly) DPNodataView *noDataView;

@end

@implementation DPSpecifyInfoViewController
@dynamic gameType;
@dynamic navTitle;
@synthesize noDataView ;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _infoCenter = CFrameWork::GetInstance()->GetLotteryInfo();
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(navLeftItemClick)];
    self.tableView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
    self.tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view;
    });
    
    __block __typeof(_infoCenter) weakCenter = _infoCenter;
    __weak __typeof(self) weakSelf = self;

    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf dpn_rebindId:weakCenter->Net_RefreshLottery(true) type:Info_Lottery];
    
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [ weakSelf dpn_rebindId:weakCenter -> Net_RefreshLottery() type:Info_Lottery];
    }];
    [self.tableView setShowsInfiniteScrolling:NO];
    
    _infoCenter -> SetGameType(self.gameType);
   [ self dpn_rebindId:_infoCenter -> Net_RefreshLottery() type:Info_Lottery];
    
    [self showHUD];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[DPToast sharedToast]dismiss];
}
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoCenter -> GetLotteryCount();
}

- (DPLotteryInfoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    DPLotteryInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DPLotteryInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    string title, time, url; int gameType;
    _infoCenter -> GetLotteryTarget((int)indexPath.row, title, time, url, gameType);
    
    NSString *resTitle = [NSString stringWithUTF8String:title.c_str()];
    NSString *resTime = [NSDate dp_coverDateString:[NSString stringWithUTF8String:time.c_str()] fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm];
    NSString *urlString = [NSString stringWithUTF8String:url.c_str()];
    [cell setTitle:resTitle subTitle:resTime urlString:urlString indexPath:indexPath];
    cell.gameType = (GameTypeId)gameType;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPLotteryInfoTableViewCell *cell = (DPLotteryInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [[DPToast sharedToast]dismiss];
    [self.navigationController pushViewController:({
        DPLotteryInfoWebViewController *viewController = [[DPLotteryInfoWebViewController alloc] init];
        viewController.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:cell.urlString]];
        viewController.title = @"资讯详情";
        viewController.canHighlight = NO ;
        viewController.gameType = cell.gameType;
        viewController;
    }) animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    string title, time, url;
    int gameType;

    _infoCenter->GetLotteryTarget((int)indexPath.row, title, time, url, gameType);

    NSString *resTitle = [NSString stringWithUTF8String:title.c_str()];

    CGSize size = [resTitle sizeWithFont:[UIFont dp_systemFontOfSize:kInfoTableViewCellTitleFont] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];

    return size.height + kInfoTabelViewCellHeightDelta;
}

#pragma mark - getter和setter
- (GameTypeId)gameType
{
    return _gameType;
}
- (void)setGameType:(GameTypeId)gameType
{
    _gameType = gameType;
}

- (NSString *)navTitle
{
    return _navTitle;
}

- (void)setNavTitle:(NSString *)navTitle
{
    if (navTitle!= nil && navTitle.length > 0) {
        
        self.title = navTitle;
        _navTitle = navTitle;
    }
}
-(DPNodataView*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        _noDataView.gameType = GameTypeZcNone ;
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_infoCenter) weakCenter = _infoCenter;

        
        [_noDataView setClickBlock:^(BOOL setOrUpDate){
            if (setOrUpDate) {
                DPWebViewController *webView = [[DPWebViewController alloc]init];
                webView.title = @"网络设置";
                NSString *path = [[NSBundle mainBundle] pathForResource:@"noNet" ofType:@"html"];
                NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                NSURL *url = [[NSBundle mainBundle] bundleURL];
                DPLog(@"html string =%@, url = %@ ", str, url);
                [webView.webView loadHTMLString:str baseURL:url];
                [weakSelf.navigationController pushViewController:webView animated:YES];
            }else{
                [weakSelf dpn_rebindId:weakCenter->Net_RefreshLottery(true) type:Info_Lottery];
            }
            
        }];
    }
    return _noDataView ;
}


#pragma mark - 数据加载代理方法
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
        int rows = (int)[self.tableView numberOfRowsInSection:0];
        [self.tableView setShowsInfiniteScrolling:rows];
        [self dismissHUD];
        
        
        self.tableView.tableHeaderView = nil ;
        NSInteger sectionCount = _infoCenter -> GetLotteryCount();
        if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
            if (sectionCount <=0) {
                self.noDataView.noDataState = DPNoDataNoworkNet ;
                self.tableView.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kNoWorkNet_]show];
            }
        }else if(ret ==ERROR_TimeOut ||ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA ) {
            if (sectionCount<=0) {
                self.noDataView.noDataState =DPNoDataWorkNetFail ;
                self.tableView.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kWorkNetFail_]show];
            }
        }else if (sectionCount <= 0){
            self.noDataView.noDataState = DPNoData ;
            self.noDataView.noDataView.attrString = kAttributStr(kNoData_) ;
            self.tableView.tableHeaderView = self.noDataView ;
        }

    });
}

- (void)navLeftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    _infoCenter -> ClearLottery();
}
@end
