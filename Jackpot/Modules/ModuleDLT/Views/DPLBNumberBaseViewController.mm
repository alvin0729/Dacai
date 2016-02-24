
//
//  DPLBNumberBaseViewController.m
//  DacaiProject
//
//  Created by WUFAN on 15/1/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPLBNumberBaseViewController.h"
#import "DPDropDownList.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DPLBNumberBasicModel.h"
#import <objc/message.h>

@interface DPLBNumberBaseViewController () <DPNavigationMenuDelegate, DPDropDownListDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL showHistory;

//历史记录
@end

@implementation DPLBNumberBaseViewController
@synthesize dataModel               = _dataModel;
@synthesize headerView              = _headerView;
@synthesize numberTable             = _numberTable;
@synthesize trendTableView          = _trendTableView;
@synthesize bottomView              = _bottomView;
@synthesize scrollTopConstraint     = _scrollTopConstraint;
@synthesize showHistory             = _showHistory;
@synthesize titleButton             = _titleButton;
@synthesize menu                    = _menu;
@synthesize deadlineTimeLab         = _deadlineTimeLab;
@synthesize bonusLab                = _bonusLab;
@synthesize introduceLab            = _introduceLab;
@synthesize zhushuLabel             = _zhushuLabel;
@synthesize sevenSwitch             = _sevenSwitch;
@synthesize controlView             = _controlView;
@synthesize digitalRandomBtn        = _digitalRandomBtn;
- (instancetype)init
{
    if (self = [super init]) {
        _showHistory = NO;
        _recentWinArray=[NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeSpaceNotify) name:kDPNumberTimerNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotify) name:kDPNumberRefreshNotificationKey object:nil];
    
    [self.view addSubview:self.trendTableView];
    [self.view addSubview:self.numberTable];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.headerView];
    CGFloat headerHeight=26;
    if (_gameType==GameTypeSdpks) {
        headerHeight=75;
    }else if (_gameType==GameTypeNmgks){
        headerHeight=65;
    }
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(headerHeight));
    }];
    
    [self.trendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
//        make.height.equalTo(self.view).offset(- 50);
        make.height.equalTo(@235);
    }];
    
    [self.numberTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self buildNavigationStyle];
    [self customBuild];   // 自定义布局
    [self layOutTopView]; // 头部布局
    [self layOutBottomView];  // 底部布局
    [self buildYilouSwitch];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    [self.timer invalidate];
     self.timer = nil ;
}

-(void)gonglvBottomView{
    
    
    _adView = [[UIImageView alloc]init];
    _adView.image=dp_NumberHighList(@"扑克3-001_03.png");
    _adView.clipsToBounds = YES ;
    _adView.backgroundColor = [UIColor clearColor];
    _adView.userInteractionEnabled = YES ;
    [self.view addSubview:_adView];
    
    if(_gameType==GameTypeNmgks){
    [_adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-70);
        make.height.equalTo(@30);
        make.width.equalTo(@234.5) ;
        make.centerX.equalTo(self.view) ;
    }];
    }else{
        [_adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-55);
            make.height.equalTo(@30);
            make.width.equalTo(@234.5) ;
            make.centerX.equalTo(self.view) ;
        }];
    }
    UIView *backView=[UIView dp_viewWithColor:[UIColor clearColor]];
    [_adView addSubview:backView];
    backView.clipsToBounds = YES ;
    backView.userInteractionEnabled=YES;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(5, 10, 0, 0));
    }];
    UIImageView *arrow=[[UIImageView alloc] init];
    arrow.backgroundColor=[UIColor clearColor];
    arrow.image=dp_NumberHighList(@"renxuanRight.png");
    self.gonglueArrow=arrow;
    [_adView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_adView).offset(-2) ;
        make.centerY.equalTo(_adView).offset(2.5);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
        
    }];
//    _labelShow2 = [[UILabel alloc]init];
//    _labelShow2.textColor  = [UIColor redColor];
//    _labelShow2.font = [UIFont dp_systemFontOfSize:10];
//    _labelShow2. userInteractionEnabled = YES ;
//    [backView addSubview:_labelShow2];
//    _labelShow2.textAlignment = NSTextAlignmentLeft ;
//    
//    _labelShow2.backgroundColor = [UIColor clearColor] ;
//    
//    [_labelShow2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(backView.mas_bottom) ;
//        make.right.equalTo(backView) ;
//        make.height.equalTo(backView);
//        make.left.equalTo(backView) ;
//    }];
    
    
    _labelShow = [[UILabel alloc]init];
    _labelShow.userInteractionEnabled = YES ;
    _labelShow.textAlignment = NSTextAlignmentLeft ;
    _labelShow.font = [UIFont dp_systemFontOfSize:10];
    [backView addSubview:_labelShow];
    _labelShow.backgroundColor = [UIColor clearColor] ;
    _labelShow.textColor  = [UIColor redColor];
    [_labelShow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(backView) ;
        make.right.equalTo(backView) ;
        make.height.equalTo(backView);
        make.left.equalTo(backView) ;
        
    }];
    [self.adView addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onMatchInfo)];
//        tap.delegate = self;
        tap;
    })];

    _index = 0 ;   
    }
-(void)pvt_onMatchInfo{

}
- (void)moveLabel {
    if (_recentWinArray.count<=0) {
        return;
    }
     _index++;
    if (_recentWinArray.count<=_index+1) {
        _index=0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _labelShow.frame;
        frame.origin.y =-24;
        _labelShow.frame = frame;
    } completion:^(BOOL finished) {
        CGRect frame = _labelShow.frame;
        frame.origin.y =24;
        _labelShow.frame = frame;
        _labelShow.attributedText=[_recentWinArray objectAtIndex:_index];
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = _labelShow.frame;
            frame.origin.y =0;
            _labelShow.frame = frame;
        }];
    }];
//    [UIView animateWithDuration:0.5 animations:^{
//        if (_secondLab.frame.origin.y==29.5) {
//             _secondLab.attributedText = [_recentWinArray objectAtIndex:_index+1];
//            CGRect frame = _firstLab.frame;
//            frame.origin.y = 0;
//            _firstLab.frame = frame;
//            
//            CGRect frame2 = _secondLab.frame;
//            frame2.origin.y =24;
//            _secondLab.frame = frame2;
//            return ;
//        }
//        _firstLab.attributedText = [_recentWinArray objectAtIndex:_index];
//    
//        CGRect frame = _firstLab.frame;
//        frame.origin.y = 0;
//        
//        _firstLab.frame = frame;
//        
//        CGRect frame2 = _secondLab.frame;
//        frame2.origin.y =-24;
//        _secondLab.frame = frame2;
//        
//    } completion:^(BOOL finished) {
//
//        if (_index + 1 >= _recentWinArray.count) {
//            return;
//        }
//        _secondLab.attributedText = [_recentWinArray objectAtIndex:_index + 1];
//    
//        _index += 1;
//        if (_index >= _recentWinArray.count-1) {
//            _index = 0;
//        }
//        _secondLab = _firstLab;
//        
//        if ([_firstLab isEqual:_labelShow]) {
//            CGRect frame = _labelShow2.frame;
//            frame.origin.y = self.adView.frame.size.height;
//            _labelShow2.frame = frame;
//            _firstLab = _labelShow2;
//        } else {
//            CGRect frame = _labelShow.frame;
//            frame.origin.y = self.adView.frame.size.height;
//            _labelShow.frame = frame;
//            _firstLab = _labelShow;
//        }
//       
//    
//    }];
    
}
- (void)layOutTopView
{
    [self.headerView addSubview:self.deadlineTimeLab];
    [self.deadlineTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView);
        make.left.equalTo(self.headerView).offset(3);
        make.height.equalTo(@22);
    }];
    [self.headerView addSubview:self.bonusLab];
    [self.bonusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView);
        make.right.equalTo(self.headerView).offset(-3);
        make.height.equalTo(@22);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:225.0 / 255 green:215.0 / 255 blue:195.0 / 255 alpha:1.0];
    [self.headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView).offset(0.5);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.headerView);
        make.right.equalTo(self.headerView);
    }];
    
    
    
    UIView *backView=[[UIView alloc]init];
    backView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberTable.mas_top);
        make.height.equalTo(@10.5);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithRed:225.0/255 green:215.0/255 blue:195.0/255 alpha:1.0];
    [backView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView);
        make.height.equalTo(@0.5);
        make.left.equalTo(backView);
        make.right.equalTo(backView);
    }];
    UIButton *kuangView=[UIButton buttonWithType:UIButtonTypeCustom];
    kuangView.backgroundColor=[UIColor clearColor];
    [kuangView setImage:dp_DigitLotteryImage(@"digitalPage001_03.png") forState:UIControlStateNormal];
    [kuangView setImage:dp_DigitLotteryImage(@"digitalPage001_03.png") forState:UIControlStateHighlighted];
    [kuangView addTarget:self action:@selector(pvt_onTrend) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:kuangView];
    [kuangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
        make.centerX.equalTo(backView);
        make.width.equalTo(@31.5);
    }];

}
- (void)layOutBottomView {
    
    UIView *contentView = self.bottomView;
    
    UIButton *cleanupButton = [[UIButton alloc] init];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image=[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
    UIView *lineView = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1]];
    
    // config control
    confirmButton.backgroundColor = [UIColor colorWithRed:0.91 green:0.09 blue:0.1 alpha:1];
    
    // bind event
    [cleanupButton addTarget:self action:@selector(pvt_onCleanup) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // move to view
    [contentView addSubview:cleanupButton];
    [contentView addSubview:confirmButton];
    [contentView addSubview:self.zhushuLabel];
    [contentView addSubview:confirmView];
    [contentView addSubview:lineView];
    
    // layout
    [cleanupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@54);
    }];
    [cleanupButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"delete001_21.png")] forState:UIControlStateNormal];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(cleanupButton.mas_right);
        make.right.equalTo(contentView);
    }];
    [self.zhushuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton).offset(10);
        make.centerY.equalTo(confirmButton);
    }];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(confirmButton).offset(-20);
        make.centerY.equalTo(confirmButton);
        make.width.equalTo(@23.5);
        make.height.equalTo(@23);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)customBuild{
    
}
- (void)buildNavigationStyle
{
//    self.titleButton.titleText = self.dataModel.titleArray[self.dataModel.gameIndex];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(btnOnBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png") target:self action:@selector(btnOnMore)];
    self.navigationItem.titleView = self.titleButton;
}
- (void)buildYilouSwitch {
    
    [self.controlView addSubview:self.sevenSwitch];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 82 - 23, 10, 30, 20)];
    label.text = @"遗漏";
    label.textColor = [UIColor dp_flatBlackColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont dp_lightSystemFontOfSize:11.0];
    [self.controlView addSubview:label];
    
    [self.controlView addSubview:self.digitalRandomBtn];
//    [self.controlView addSubview:self.introduceLab];
    
    if ([self.numberTable isKindOfClass:[UITableView class]]) {
        UITableView *numberTableView = (UITableView *)self.numberTable;
        numberTableView.tableHeaderView = self.controlView;
    }
    
    self.digitalRandomBtn.hidden = self.dataModel.isRandomBtnHidden;
    if (!userPreferSwitchOn) {
        _sevenSwitch.on = userPreferSwitchOn;
        [self pvt_switchAction:_sevenSwitch];
    }
}
- (void)calculateZhuShu
{
    // 重新计算注数，刷新界面（金额）
    self.zhushuLabel.text = [NSString stringWithFormat:@"共%@注  %d元", @(self.dataModel.note), 2 * (int)self.dataModel.note];
}
- (void)digitalDataRandom
{
    [self.dataModel digitalDataRandom];
     objc_msgSend(self.numberTable, @selector(reloadData));
    [self calculateZhuShu];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 摇一摇
-(BOOL)canBecomeFirstResponder
{
    return self.dataModel.canBecomeFirstResponder;
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event
{
    if (!self.dataModel.canBecomeFirstResponder) {
        return;
    }
    if(motion == UIEventSubtypeMotionShake)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self digitalDataRandom];
        
    }

}
#pragma mark - timer 通知
- (void)timeSpaceNotify
{
    self.deadlineTimeLab.attributedText=self.tranViewController.viewModel.countDownAttString;
    self.bonusLab.text=self.tranViewController.viewModel.countDownString;
}
- (void)refreshNotify
{
    // 子类重写
    [self timeSpaceNotify];
    UITableView *tableView=(UITableView *)self.numberTable;
    [tableView reloadData];
    [self.trendTableView reloadData];
}
#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.trendTableView) {
        return 10;
    }
    
    return [self.dataModel numberOfRowsInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 子类重写了
    NSString *cellClass = nil;
    
    if (tableView == self.trendTableView) {
        cellClass = self.dataModel.trendCellClass;
    }else if (tableView == self.numberTable){
        cellClass = self.dataModel.numberCellClass;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:self.dataModel.trendCellClass];
    if (cell == nil) {
        cell = [[NSClassFromString(cellClass) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.dataModel.trendCellClass];
        UITableViewCell <DPLBCellDataModelProtocol>*numberCell = (UITableViewCell <DPLBCellDataModelProtocol> *) cell;
        [numberCell setDataModel:[self.dataModel trendCellModelForIndexPath:indexPath]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.trendTableView) {
        return self.dataModel.trendCellHeight;
    }
    return [self.dataModel heightForRowAtIndexPath:indexPath];
}
#pragma mark - scrollView delegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.dataModel.hasData) {
        return;
    }
    
    if (!scrollView.isTracking) {
        return;
    }
    if (self.scrollTopConstraint.constant - scrollView.contentOffset.y < 0) {
        self.scrollTopConstraint.constant = 0;
    } else if (self.scrollTopConstraint.constant - scrollView.contentOffset.y > self.dataModel.trendDragHeight) {
        self.scrollTopConstraint.constant = self.dataModel.trendDragHeight;
        scrollView.contentOffset = CGPointZero;
    } else {
        self.scrollTopConstraint.constant = self.scrollTopConstraint.constant - scrollView.contentOffset.y;
        scrollView.contentOffset = CGPointZero;
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.showHistory) {
        self.scrollTopConstraint.constant = self.scrollTopConstraint.constant < self.dataModel.trendDragHeight - 6 ? 0 : self.dataModel.trendDragHeight;
    } else {
        self.scrollTopConstraint.constant = self.scrollTopConstraint.constant > 6 ? self.dataModel.trendDragHeight : 0;
    }

    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.showHistory = self.scrollTopConstraint.constant == self.dataModel.trendDragHeight;
        [self turnArrow];
    }];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.showHistory) {
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.showHistory) {
        *targetContentOffset = CGPointZero;
    }
}
#pragma mark - DPNavigationMenuDelegate

- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(int)index {
    [self reloadSelectTableView:(int)index];
    if ([self.menu isKindOfClass:[DPNavigationMenu class]]) {
        DPNavigationMenu *navMenu = (DPNavigationMenu *)self.menu;
        navMenu.selectedIndex = index;
    }
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
    if ([self.menu isKindOfClass:[DPNavigationMenu class]]) {
        DPNavigationMenu *navMenu = (DPNavigationMenu *)self.menu;
        [self.titleButton setTitleText:navMenu.items[navMenu.selectedIndex]];
    }
    if ([self.numberTable respondsToSelector:@selector(reloadData)]){
        [(UITableView *)self.numberTable reloadData];
    }

}

- (void)reloadSelectTableView:(int)titleIndex {
    
}
#pragma mark - single click
- (void)btnOnMore
{
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    [coverView setBackgroundColor:[UIColor clearColor]];
    [self.view.window addSubview:coverView];
    
    DPDropDownList *dropDownList = [[DPDropDownList alloc] initWithItems:self.dataModel.dropDownListArray];
    [dropDownList setDelegate:self];
    [coverView addSubview:dropDownList];
    [dropDownList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coverView).offset(64);
        make.right.equalTo(coverView).offset(-10);
    }];
    
    [coverView addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onCover:)];
        tap.delegate = self;
        tap;
    })];

    
}
- (void)turnArrow
{
    // 快三和扑克三重写，翻转箭头
}
- (void)pvt_onCleanup
{
    [self clearAllSelectedDataWithIndex:(int)self.dataModel.gameIndex];
    if ([self.numberTable respondsToSelector:@selector(reloadData)]){
        [(UITableView *)self.numberTable reloadData];
    }
}
- (void)clearAllSelectedDataWithIndex:(int)gameIndex
{
    [self.dataModel clearAllSelectedData];
    [self calculateZhuShu];
}
- (void)pvt_onCover:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}
- (void)btnOnBack
{
    [self.navigationController popViewControllerAnimated:YES];
     self.tranViewController.viewModel.gameIndex=self.dataModel.gameIndex;
}
- (void)pvt_onExpandNav {
    [self.titleButton turnArrow];
    if ([self.menu isKindOfClass:[DPNavigationMenu class]]) {
        DPNavigationMenu *navMenu = (DPNavigationMenu *)self.menu;
        [navMenu setSelectedIndex:(int)self.dataModel.gameIndex];
        [navMenu show];
    }
}
- (void)pvt_onTrend {
    if (!self.dataModel.hasData) {
        return;
    }
    if (self.showHistory) {
        self.scrollTopConstraint.constant = 0;
    } else {
        self.scrollTopConstraint.constant = self.dataModel.trendDragHeight;
    }
    
    self.showHistory = self.scrollTopConstraint.constant == self.dataModel.trendDragHeight;
    
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)submitBtnClick
{
    // 子类实现
}
- (void)pvt_switchAction:(SevenSwitch *)sender
{
    self.dataModel.isOpenSwitch = sender.on;
    if ([self.numberTable isKindOfClass:[UITableView class]]){
        UITableView *tableView = (UITableView *)self.numberTable;
        [tableView reloadData];
    }
//    preferSwitchOn = switchView.on;

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (![touch.view isMemberOfClass:[UIView class]]) {
        return NO;
    }
    return YES;
}
#pragma mark - DPLBCell delegate
- (void)buyCell:(UITableViewCell *)cell touchUp:(UIButton *)button
{
    // 子类实现
}
- (void)tableViewScroll:(BOOL)stop
{
    
}
- (void)buyCell:(UITableViewCell *)cell touchDown:(UIButton *)button
{
    
}
#pragma mark - DPDropDownListDelegate
- (void)dropDownList:(DPDropDownList *)dropDownList selectedAtIndex:(int)index {
    [dropDownList.superview removeFromSuperview];
    
    UIViewController *viewController;
    if (self.dataModel.dropDownListArray.count == 3) {
        index = index + 1; // 排三、排五、七星彩、七乐彩 没有走势图
    }
    switch (index) {
        case 0: {   // 走势图
            [self presentViewController:[self getTrendVC] animated:YES completion:nil];
            return;
        }
            break;

        case 1: {   // 开奖公告
            viewController = ({
                DPResultListViewController *viewController = [[DPResultListViewController alloc] init];
                viewController.gameType = self.dataModel.gameType;
                viewController.isFromClickMore = YES ;
                viewController;
            });
        }
            break;
        case 2: {   // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(self.dataModel.gameType)]];
                viewController.title = @"玩法介绍";
                viewController.canHighlight = NO ;
                viewController;
            });
        }
            break;
        case 3: {   // 帮助
            viewController = [[DPWebViewController alloc] init];
            DPWebViewController *webCtrl = (DPWebViewController *)viewController;
            webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kHelpCenterURL]];
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - setter & getter
- (id<DPLBNumberCommonDataSource>)dataModel
{
    if (_dataModel == nil) {
        _dataModel = [DPLBNumberBasicModel numberDataModelForGameType:_gameType];
    }
    return _dataModel;
}
- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIImageView alloc]init];
        _headerView.backgroundColor = [UIColor dp_flatWhiteColor];
        _headerView.userInteractionEnabled=YES;
    }
    return _headerView;
}
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _bottomView;
}
- (UIScrollView *)numberTable
{
    if (_numberTable == nil) {
        _numberTable = [[UIScrollView alloc]init];
//        _numberTable.backgroundColor = [UIColor clearColor];
        _numberTable.delegate = self;
        _numberTable.contentSize = CGSizeMake(320, 1000);
    }
    return _numberTable;
}
- (UITableView *)trendTableView
{
    if (_trendTableView == nil) {
        _trendTableView = [[UITableView alloc]init];
        _trendTableView.dataSource = self;
        _trendTableView.delegate = self;
        _trendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _trendTableView.allowsSelection = NO;
        _trendTableView.backgroundColor = [UIColor dp_flatWhiteColor];
//        _trendTableView.userInteractionEnabled = NO;
//        _trendTableView.scrollEnabled = YES;
    }
    return _trendTableView;
}
- (NSLayoutConstraint *)scrollTopConstraint
{
    if (_scrollTopConstraint == nil) {
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.firstItem == self.numberTable && constraint.firstAttribute == NSLayoutAttributeTop) {
                _scrollTopConstraint = constraint;
                break;
            }
        }
    }
    return _scrollTopConstraint;
}
- (DPNavigationTitleButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[DPNavigationTitleButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        [_titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onExpandNav)]];
        _titleButton.titleText = self.dataModel.titleArray[self.dataModel.gameIndex];
    }
    return _titleButton;
}
- (UIView *)menu {
    if (_menu == nil) {
        DPNavigationMenu *navMenu = [[DPNavigationMenu alloc] init];
        navMenu.viewController = self;
        navMenu.items = self.dataModel.titleArray;
        _menu = navMenu;
    }
    return _menu;
}
- (UILabel *)deadlineTimeLab
{
    if (_deadlineTimeLab == nil) {
        _deadlineTimeLab = [[UILabel alloc] init];
        [_deadlineTimeLab setNumberOfLines:0];
        [_deadlineTimeLab setTextColor:[UIColor dp_flatRedColor]];
        [_deadlineTimeLab setFont:[UIFont systemFontOfSize:11.0f]];
        [_deadlineTimeLab setBackgroundColor:[UIColor clearColor]];
        [_deadlineTimeLab setTextAlignment:NSTextAlignmentLeft];
        [_deadlineTimeLab setLineBreakMode:NSLineBreakByWordWrapping];
        _deadlineTimeLab.userInteractionEnabled=NO;
        _deadlineTimeLab.text=@"正在获取期号...";
    }
    return _deadlineTimeLab;
}
- (UILabel *)bonusLab
{
    if (_bonusLab == nil) {
        _bonusLab = [[UILabel alloc] init];
        [_bonusLab setNumberOfLines:0];
        [_bonusLab setTextColor:[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0]];
        [_bonusLab setFont:[UIFont systemFontOfSize:11.0f]];
        [_bonusLab setBackgroundColor:[UIColor clearColor]];
        [_bonusLab setTextAlignment:NSTextAlignmentRight];
        [_bonusLab setLineBreakMode:NSLineBreakByWordWrapping];
        _bonusLab.userInteractionEnabled=NO;
    }
    return _bonusLab;
}

- (TTTAttributedLabel *)introduceLab
{
    if (_introduceLab == nil) {
        _introduceLab = [[TTTAttributedLabel alloc] init];
        [_introduceLab setNumberOfLines:0];
        [_introduceLab setTextColor:[UIColor dp_flatRedColor]];
        [_introduceLab setFont:[UIFont systemFontOfSize:12.0f]];
        [_introduceLab setBackgroundColor:[UIColor clearColor]];
        [_introduceLab setTextAlignment:NSTextAlignmentRight];
        [_introduceLab setLineBreakMode:NSLineBreakByWordWrapping];
        _introduceLab.userInteractionEnabled=NO;
    }
    return _introduceLab;
}

- (UILabel *)zhushuLabel {
    if (_zhushuLabel == nil) {
        _zhushuLabel = [[UILabel alloc] init];
        _zhushuLabel.backgroundColor = [UIColor clearColor];
        _zhushuLabel.textColor = [UIColor whiteColor];
        _zhushuLabel.font = [UIFont dp_systemFontOfSize:12];
        _zhushuLabel.text = @"共0注  0元";
    }
    return _zhushuLabel;
}
- (SevenSwitch *)sevenSwitch
{
    if (_sevenSwitch == nil) {
        _sevenSwitch=[[SevenSwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 8, 51, 22)];
        _sevenSwitch.inactiveColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        _sevenSwitch.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        _sevenSwitch.onTintColor = [UIColor dp_flatRedColor];
        _sevenSwitch.on = YES;
        _sevenSwitch.onImage=[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"yilouOpen.png")];
        _sevenSwitch.offImage=[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"yilouClose.png")];
        [_sevenSwitch addTarget:self action:@selector(pvt_switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _sevenSwitch;
}
- (UIView *)controlView {
    if (_controlView == nil) {
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
        _controlView.backgroundColor = [UIColor clearColor];
    }
    return _controlView;
}
- (UIButton *)digitalRandomBtn
{
    if (_digitalRandomBtn == nil) {
        _digitalRandomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _digitalRandomBtn.frame=CGRectMake(-1, 5, 111, 27);
        _digitalRandomBtn.backgroundColor = [UIColor clearColor];
        [_digitalRandomBtn setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"randomSharkoff.png")] forState:UIControlStateNormal];
        [_digitalRandomBtn addTarget:self action:@selector(digitalDataRandom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _digitalRandomBtn;
}
- (void)setIndexPathRow:(NSInteger)indexPathRow
{
    // 设置中转页面进来的索引
    _indexPathRow = indexPathRow;
    [self.dataModel setIndexPathRow:indexPathRow];
    [self calculateZhuShu];
}
//得到中转页面
-(DPLTNumberBaseViewController *)tranViewController{
    if (_tranViewController == nil) {
        for(UIViewController *vc in self.navigationController.viewControllers){
            if ([vc isKindOfClass:[DPLTNumberBaseViewController class]]) {
                _tranViewController=(DPLTNumberBaseViewController *)vc;
                
            }
        }
    }
    return _tranViewController;

}
@end
