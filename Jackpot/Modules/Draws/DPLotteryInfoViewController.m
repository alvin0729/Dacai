//
//  DPLotteryInfoViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLotteryInfoViewController.h"
#import "DPLotteryInfoSubscribViewController.h"
#import "DPLotteryInfoDockView.h"
#import "DPLotteryInfoTableViewCell.h"
#import "DPSpecifyInfoViewController.h"
#import "SVPullToRefresh.h"
#import "DPLotteryInfoRandomChipView.h"
#import "DPWebViewController.h"
#import "DPLotteryInfoWebViewController.h"
#import "DPNodataView.h"
#import "UMSocial.h"
#import "DPLotteryInfoViewModel.h"
#import "DZNEmptyDataView.h"
#import "DPAnalyticsKit.h"

@interface DPLotteryInfoCollectionCell : UICollectionViewCell
- (void)setImageName:(NSString *)imageName title:(NSString *)title;
@end

@interface DPLotteryInfoCollectionCell () {
@private
    UIImageView *_imageView;
    UILabel *_classLabel;
}
@end

@implementation DPLotteryInfoCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 1.8;
        self.contentView.layer.borderColor = [[UIColor dp_colorFromHexString:@"#d5cfbd"] CGColor];
        self.contentView.layer.borderWidth = 0.5f;

        _imageView = [[UIImageView alloc] init];
        _classLabel = [[UILabel alloc] init];
        _classLabel.font = [UIFont systemFontOfSize:13];
        _classLabel.numberOfLines = 0;

        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_classLabel];

        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.width.equalTo(@36);
            make.height.equalTo(@36);
        }];

        [_classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_imageView.mas_right).offset(5);
            make.right.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName title:(NSString *)title {
    [self setImageName:imageName];
    [self setTitle:title];
}

#pragma mark - set和get方法

- (void)setImageName:(NSString *)imageName {
    if (imageName.length > 0 && imageName != nil) {
        _imageView.image = dp_ResultImage(imageName);
    }
}

- (void)setTitle:(NSString *)title {
    if (title.length > 0 && title != nil) {
        _classLabel.text = title;
    }
}

@end

#define kArrowAnimTime 0.3f
#define kDockHeight 38
#define kcollectionCellID @"collectionCellID"
#define ktableViewRowHeight 60

@interface DPLotteryInfoViewController () <
    UITableViewDataSource,
    UITableViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UIScrollViewDelegate,
    DPLotteryInfoDockViewDelegate,
    DPLotteryInfoViewModelDelegate,
    UMSocialUIDelegate> {
@private
    DPLotteryInfoDockView *_dockView;    // 选项卡视图
    UITableView *_recommendTableView;    // 推荐视图;
    UITableView *_hotTableView;          // 热门视图;
    UICollectionView *_classView;        // 分类视图
    UIScrollView *_scrollView;           // 内容滚动视图
    NSArray *_colorArray;                // 随机色彩数组
 
}

@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, strong) DPLotteryInfoSubscribViewController *subscribController;
@property (nonatomic, strong) DPLotteryInfoViewModel *recommendViewModel;
@property (nonatomic, strong) DPLotteryInfoViewModel *announcementViewModel;
@end

static NSString *collectionCellID = kcollectionCellID;
@implementation DPLotteryInfoViewController

static NSString *titleArray[] = {@"大乐透", @"竞彩足球", @"竞彩篮球", @"双色球", @"足彩", @"福彩3D"};

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaultIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"彩票资讯";
  
    [self buildDockView];
    [self buildScorllView];
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
}


#pragma mark - 视图初始化
#pragma mark 顶部选项视图

- (void)buildDockView {
    UIView *contentView = self.view;

    // 上面选项卡视图
    DPLotteryInfoDockView *dockView = [[DPLotteryInfoDockView alloc] init];
    dockView.delegate = self;
    _dockView = dockView;

    [contentView addSubview:dockView];
    // 选项卡视图
    dockView.backgroundColor = [UIColor whiteColor];
    [dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@kDockHeight);
    }];
    
 
}

#pragma mark 初始化内容视图scrollView
- (void)buildScorllView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor dp_flatBackgroundColor];
    scrollView.delegate = self;

    // 添加推荐视图
    UITableView *recommendTableView = [self createTableViewWithTag:0];
    DZNEmptyDataView *recomEmpty = [[DZNEmptyDataView alloc]init];
    recomEmpty.textForNoData = @"暂无数据" ;
    recomEmpty.imageForNoData = dp_LoadingImage(@"noMatch.png") ;
    recomEmpty.showButtonForNoData = NO ;
    recommendTableView.emptyDataView = recomEmpty ;
    
    
    
    
    // 添加热门视图
    UITableView *hotTableView = [self createTableViewWithTag:1];
    DZNEmptyDataView *hotEmpty = [[DZNEmptyDataView alloc]init];
    hotEmpty.textForNoData = @"暂无数据" ;
    hotEmpty.imageForNoData = dp_LoadingImage(@"noMatch.png") ;
    hotEmpty.showButtonForNoData = NO ;
    hotTableView.emptyDataView = hotEmpty ;

    @weakify(self);
    [recommendTableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self.recommendViewModel fetch];
    } position:SVPullToRefreshPositionTop];
    [hotTableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self.announcementViewModel fetch];
    } position:SVPullToRefreshPositionTop];
    [recommendTableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [self.recommendViewModel fetchMore];
      }];
    
    [[RACObserve(self.recommendViewModel, currentCount)distinctUntilChanged]subscribeNext:^(id x) {
        
        NSInteger value = [x intValue];
         if (value/kPageSize+(value%kPageSize?1:0) == 2) {
             [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeLotteryPage2)] props:nil];
        }else if (value/kPageSize+(value%kPageSize?1:0) == 3) {
            
            [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeLotteryPage3)] props:nil];
        }else if (value/kPageSize+(value%kPageSize?1:0) == 6) {
            
            [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeLotteryPage6)] props:nil];
        }
    }];
    
    [hotTableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [self.announcementViewModel fetchMore];
    }];

    [recommendTableView setShowsInfiniteScrolling:NO];
    [hotTableView setShowsInfiniteScrolling:NO];
    //
    // 添加分类的collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(140, 45);
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 20, 15);

    UICollectionView *collectionView = ({
        UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [collect registerClass:[DPLotteryInfoCollectionCell class] forCellWithReuseIdentifier:collectionCellID];
        collect.dataSource = self;
        collect.delegate = self;
        collect.backgroundColor = [UIColor dp_flatBackgroundColor];
        collect.tag = 3;
        collect;
    });

    [self.view addSubview:scrollView];
    [scrollView addSubview:recommendTableView];
    [scrollView addSubview:self.subscribController.view];
    [scrollView addSubview:hotTableView];
    [scrollView addSubview:collectionView];

    _scrollView = scrollView;
    _recommendTableView = recommendTableView;
    _hotTableView = hotTableView;
    _classView = collectionView;

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dockView.mas_bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [recommendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(scrollView);
        make.width.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];

    [self.subscribController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(recommendTableView.mas_right);
        make.width.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];
    
    
    [hotTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(self.subscribController.view.mas_right);
        make.width.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];

    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(hotTableView.mas_right);
        make.right.equalTo(scrollView);
        make.width.equalTo(scrollView);
        make.height.equalTo(scrollView);

    }];

    // 初始化刷新数据
     
    [_dockView selectedItemChangeTo:self.defaultIndex isDelegateSend:YES];    // 默认选中第一个
    [self refreshDataWithTargetTag:self.defaultIndex];
 
 
}
#pragma mark---------
- (DPLotteryInfoSubscribViewController *)subscribController{
    if (!_subscribController) {
        _subscribController = [[DPLotteryInfoSubscribViewController alloc]init];
        [self addChildViewController:_subscribController];
    }
    return _subscribController;
}
#pragma mark - 初始化dockButton按钮方法
- (UIButton *)dockItemWithTitle:(NSString *)title tag:(int)tag target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = tag;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];

    return btn;
}
#pragma mark - 初始化tableView
- (UITableView *)createTableViewWithTag:(int)tag {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = ktableViewRowHeight;
    tableView.tag = tag;
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor dp_colorFromHexString:@"#d2cebf"];
    tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });

    if (IOS_VERSION_7_OR_ABOVE) {
        tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return tableView;
}

#pragma mark - tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _recommendTableView) {
        return self.recommendViewModel.count;
    } else if (tableView == _hotTableView) {
        return self.announcementViewModel.count;
    } else {
        return 0;
    }
}

- (DPLotteryInfoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";

    DPLotteryInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DPLotteryInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    DPLotteryInfoViewModel *viewModel = tableView == _recommendTableView ? self.recommendViewModel : self.announcementViewModel;

    [cell setTitle:[viewModel titleAtIndex:indexPath.row]
          subTitle:[viewModel dateTextAtIndex:indexPath.row]
         urlString:[viewModel URLAtIndex:indexPath.row]
         indexPath:indexPath];
    [cell setGameType:(GameTypeId)[viewModel gameTypeAtIndex:indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPLotteryInfoViewModel *viewModel = tableView == _recommendTableView ? self.recommendViewModel : self.announcementViewModel;
    NSString *headTitle = [viewModel titleAtIndex:indexPath.row];
    CGSize size = [NSString dpsizeWithSting:headTitle andFont:[UIFont dp_systemFontOfSize:kInfoTableViewCellTitleFont] andMaxWidth:300];
    DPLog(@"size height = %f", size.height);
    return size.height + kInfoTabelViewCellHeightDelta;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#DDDBD4"];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#FAF9F2"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row<6) {
        NSInteger eventId = DPAnalyticsTypeLotteryRowOne+indexPath.row ;
        [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(eventId)] props:nil];
     }
    DPLotteryInfoViewModel *viewModel = tableView == _recommendTableView ? self.recommendViewModel : self.announcementViewModel;
    DPLotteryInfoTableViewCell *cell = (DPLotteryInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
     [self.navigationController pushViewController:({
                                   DPLotteryInfoWebViewController *viewController = [[DPLotteryInfoWebViewController alloc] initWithGameType:cell.gameType];
                                   viewController.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:cell.urlString]];
                                   viewController.title = @"资讯详情";
                                   viewController.canHighlight = NO;
                                   viewController.shareItem = [viewModel shareItemAtIndex:indexPath.row];
                                   viewController;
                               })animated:YES];
}

#pragma mark 实例化cell
- (UITableViewCell *)createCellForIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    cell.textLabel.font = [UIFont dp_systemFontOfSize:13];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor dp_colorFromHexString:@"#333333"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.textColor = [UIColor dp_colorFromHexString:@"#998f70"];
    cell.detailTextLabel.font = [UIFont dp_systemFontOfSize:10];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];

    //左边彩条
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [self getColorWithIndexPath:indexPath];
    [cell.contentView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell);
        make.left.equalTo(cell);
        make.bottom.equalTo(cell).offset(-0.5);
        make.width.equalTo(@1.8);
    }];

    return cell;
}
#pragma mark - collectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (DPLotteryInfoCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *imageName[] = { @"lottery_dlt.png",
                                     @"lottery_jczq.png",
                                     @"lottery_lq.png",
                                     @"lottery_ssq.png",
                                     @"lottery_zc.png",
                                     @"lottery_3D.png" };
    DPLotteryInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];

    if (indexPath.row <= sizeof(titleArray) && indexPath.row <= sizeof(imageName)) {
        [cell setImageName:imageName[indexPath.row] title:titleArray[indexPath.row]];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    static int gameTypeId[] = {GameTypeDlt, GameTypeJcNone, GameTypeLcNone, GameTypeSsq, GameTypeZcNone, GameTypeSd};

    DPSpecifyInfoViewController *specify = [[DPSpecifyInfoViewController alloc] initWithStyle:UITableViewStylePlain];
    specify.navTitle = titleArray[indexPath.row];
    specify.gameType = (GameTypeId)gameTypeId[indexPath.row];
    
    [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeLotteryDlt+indexPath.row)] props:nil];


    [self.navigationController pushViewController:specify animated:YES];
}

#pragma mark - scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        int tag = scrollView.contentOffset.x / scrollView.bounds.size.width;

        [_dockView selectedItemChangeTo:tag isDelegateSend:YES];
        self.defaultIndex = tag ;
        
        if (tag == 0 && !self.recommendViewModel.count) {
            [self refreshDataWithTargetTag:tag];
        }else if (tag == 2 && !self.announcementViewModel.count){
            [self refreshDataWithTargetTag:tag];
        }

    }
}

#pragma mark DockView代理方法
- (void)dockItemChangedtoTag:(int)tag {
    CGFloat width = _scrollView.bounds.size.width;
    CGFloat x = _scrollView.contentOffset.x / width;
    if (tag == x) {
        return;
    }
    self.defaultIndex = tag ;
    [_scrollView setContentOffset:CGPointMake(tag * width, 0) animated:YES];
    
    if (tag == 0 && !self.recommendViewModel.count) {
        [self refreshDataWithTargetTag:tag];
    }else if (tag == 2 && !self.announcementViewModel.count){
        [self refreshDataWithTargetTag:tag];
    }
    
}


#pragma mark - 获取随机颜色
- (UIColor *)getColorWithIndexPath:(NSIndexPath *)indexPath {
    if (_colorArray == nil) {
        _colorArray = @[ [UIColor dp_colorFromHexString:@"#546b05"], [UIColor dp_colorFromHexString:@"#00849c"], [UIColor dp_colorFromHexString:@"#ff3000"], [UIColor dp_colorFromHexString:@"ff8a00"], [UIColor dp_colorFromHexString:@"#ff8a00"] ];
    }

    int index = (int)indexPath.row % _colorArray.count;
    return _colorArray[index];
}

#pragma mark - Delegate

#pragma mark - DPLotteryInfoViewModelDelegate

- (void)viewModel:(DPLotteryInfoViewModel *)viewModel fetchFinished:(NSError *)error {
    UITableView *target = viewModel == self.recommendViewModel ? _recommendTableView : _hotTableView;
    @weakify(self) ;
     target.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
        if (type == DZNEmptyDataViewTypeNoNetwork) {
            @strongify(self) ;
            [self.navigationController pushViewController:[DPWebViewController setNetWebController ] animated:YES];
        }else if (type == DZNEmptyDataViewTypeFailure){
            
            @strongify(self) ;
            [self refreshDataWithTargetTag:self.defaultIndex];
        }

    } ;
    
    target.emptyDataView.requestSuccess = error == nil;
    
    [target reloadData];

    [target.pullToRefreshView stopAnimating];
    [target.infiniteScrollingView stopAnimating];
    [target setShowsInfiniteScrolling:viewModel.count];
    [target.infiniteScrollingView setEnabled:viewModel.hasMore];
    
    [self dismissHUD];
}

#pragma mark - 刷新数据
- (void)refreshDataWithTargetTag:(int)tag {
    [self showHUD];

    switch (tag) {
        case 0:
            [self.recommendViewModel fetch];
            break;
        case 1:
            
            break;
        case 2:
            [self.announcementViewModel fetch];
            break;
        default:
            break;
    }
}

 
- (DPLotteryInfoViewModel *)recommendViewModel {
    if (_recommendViewModel == nil) {
        _recommendViewModel = [[DPLotteryInfoViewModel alloc] init];
        _recommendViewModel.url = @"/news/recommendnews";
        _recommendViewModel.delegate = self;
    }
    return _recommendViewModel;
}

- (DPLotteryInfoViewModel *)announcementViewModel {
    if (_announcementViewModel == nil) {
        _announcementViewModel = [[DPLotteryInfoViewModel alloc] init];
        _announcementViewModel.url = @"/news/getnews?type=0";
        _announcementViewModel.delegate = self;
    }
    return _announcementViewModel;
}


@end
