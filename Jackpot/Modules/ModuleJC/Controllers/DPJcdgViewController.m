//
//  DPJcdgViewController.m
//  DacaiProject
//
//  Created by jacknathan on 15-1-16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPJcdgViewController.h"
#import "DPNodataView.h"
#import "DPWebViewController.h"
#import "DPJcdgDataModel.h"
#import "DPSegmentedControl.h"

@interface DPJcdgViewController () <DPJcdgTeamsViewDelegate, UITableViewDelegate,UITableViewDataSource, DPJcdgBottomDelegate, DPJcdgGameBasicCellDelegate , DPJcdgDataModelDelegate>
{
    CGPoint _contentOffset;
    BOOL _hasNetWork ;
    
    MyGameType _currentGameType ;
    
    DPJcdgDataModel *_basketdataModel;
     DPJcdgDataModel *_footdataModel;

}
@property (nonatomic, strong, readonly)DPJcdgDataModel *dataModel;
@property (nonatomic, strong, readonly)DPJcdgDataModel *basketdataModel;
@property (nonatomic, strong, readonly)DPJcdgDataModel *footdataModel;

 @property (nonatomic, strong, readonly)UITableView *tableView;

@property (nonatomic, strong, readonly) DPNodataView *noDataView;
@property (nonatomic, strong) UIView *uperView;
@property (nonatomic, strong) DPJcdgTeamsView  *teamsView;

@property (nonatomic, strong, readonly) DPSegmentedControl *titleControl;

@end

@implementation DPJcdgViewController
@synthesize tableView   = _tableView;
@synthesize noDataView  = _noDataView;
@synthesize uperView    = _uperView;
@synthesize teamsView   = _teamsView;
@synthesize dataModel   = _dataModel;
@synthesize  titleControl = _titleControl ;
@synthesize footdataModel = _footdataModel ;
@synthesize basketdataModel = _basketdataModel ;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        if (IOS_VERSION_7_OR_ABOVE) {
//            self.extendedLayoutIncludesOpaqueBars = YES;
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return self;
}
- (instancetype)initWithGameType:(MyGameType)type
{
    self = [super init];
    if (self) {
        if (type != GameTypeBasketBall) {
            type = 0 ;
        }
        _currentGameType = type ;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
 
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.dataModel dp_becomeDelegate];
    [self.dataModel dp_setProjectBuyType:3];
    
    [self.footdataModel dp_setProjectBuyType:3];
    [self.basketdataModel dp_setProjectBuyType:3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _hasNetWork = NO ;
    //数据请求
    [self.dataModel dp_sendJcdgDataRequest];
    self.title = @"单关固定";
    self.navigationItem.titleView = self.titleControl ;
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor] ;
    
    UIView *uperView = [[UIView alloc]init];
    uperView.backgroundColor = [UIColor clearColor];
    uperView.clipsToBounds = YES;
    self.uperView = uperView;
    
     [self.view addSubview:self.tableView];
    [self.view addSubview:uperView];
     [uperView addSubview:self.teamsView];

    [uperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.equalTo(@100);
        make.right.equalTo(self.view);
    }];
    
    [self.teamsView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.insets(UIEdgeInsetsZero);

    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uperView.mas_bottom);

        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dp_viewTap:)];
    [self.view addGestureRecognizer:tap];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return  [self.dataModel dp_numberOfRowsInSection:section ];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    DPJcdgGameTypeBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.dataModel dp_cellReuseIdentifierAtIndexPath:indexPath withType:_currentGameType]];

    if (_currentGameType == GameTypeFootBall) {
        if (cell == nil) {
            NSString *cellClass = [self.dataModel dp_cellClassForRowAtIndexPath:indexPath type:_currentGameType];
            
            if ([cellClass isEqualToString:@"DPjcdgTypeRqspfCell"] ) {
                cell = [[DPjcdgTypeRqspfCell alloc]initWithReuseIdentifier:cellClass WithGameType:_currentGameType];
            }else if ([cellClass isEqualToString:@"DPjcdgAllgoalCell"]) {
                cell = [[DPjcdgAllgoalCell alloc]initWithReuseIdentifier:cellClass WithGameType:_currentGameType];
            }else if ([cellClass isEqualToString:@"dpJcdgGuessWinCell"]) {
                cell = [[dpJcdgGuessWinCell alloc]initWithReuseIdentifier:cellClass WithGameType:_currentGameType];
            }else{
            
            }
            
            cell.bottomDelegate = self ;
            cell.delegate = self ;
            
           
        }

    }else{
    
        if (cell == nil) {
            NSString *cellClass = [self.dataModel dp_cellClassForRowAtIndexPath:indexPath type:_currentGameType] ;
            if ([cellClass isEqualToString:@"DPJcdgBasketRfsfCell"]) {
                cell = [[DPJcdgBasketRfsfCell alloc]initWithReuseIdentifier:cellClass WithGameType:_currentGameType];
            }else if ([cellClass isEqualToString:@"DPJcdgBasketDxfCell"]) {
                cell = [[DPJcdgBasketDxfCell alloc]initWithReuseIdentifier:cellClass WithGameType:_currentGameType];
            }else if ([cellClass isEqualToString:@"DPjcdgBasketSfcCell"]) {
                cell = [[DPjcdgBasketSfcCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClass];
            }else{
                
            }
            
            cell.bottomDelegate = self ;
            cell.delegate = self ;
            
           
        }
    
    }
    
       if ([self.dataModel dp_cellModelForIndexPath:indexPath]) [cell dp_setCelldataModel:[self.dataModel dp_cellModelForIndexPath:indexPath]];

    
    return cell;


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(_currentGameType == GameTypeFootBall){
        if ([[self.dataModel dp_cellModelForIndexPath:indexPath] isKindOfClass:[DPJcdgSpfCellModel class]]) {
            return 100 +165 ;

        }else if ([[self.dataModel dp_cellModelForIndexPath:indexPath] isKindOfClass:[DPJcdgZjqCellModel class]]){
            return 121+30+100 ;
        }else if ([[self.dataModel dp_cellModelForIndexPath:indexPath] isKindOfClass:[DPJcdgGuessCellModel class]]){
            return 116+30+100 ;
        }
    }else if ([[self.dataModel dp_cellModelForIndexPath:indexPath] isKindOfClass:[DPJcdgBasketCellModel class]] &&  ((DPJcdgBasketCellModel*)[self.dataModel dp_cellModelForIndexPath:indexPath]).gameType == GameTypeLcSfc ){
        return 225+70 ;
    }
    return 165+70 ;
}

 #pragma mark teamsView delegate
- (void)gamePageChangeFromPage:(int)oldPage toNewPage:(int)newPage
{
    self.dataModel.curGameIndex = newPage;
    [self.dataModel dp_removeTimesData];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    if (_currentGameType == GameTypeFootBall) {
        for (int i = 0; i < self.dataModel.visibleGamesFootBall.count; i++) {
            GameTypeId gameType = (GameTypeId)[self.dataModel.visibleGamesFootBall[i] intValue];
            NSArray *optionArray = [self.dataModel dp_getOpenOptionWithGameType:gameType];
            if (optionArray.count < 10) {
                return;
            }
            int selected = NO;
            for (int i = 0; i < 10; i++) {
                if ([optionArray[i] intValue] > 0) {
                    selected = YES;
                    break;
                }
            }
            
        }

    }else{
    
        for (int i = 0; i < self.dataModel.visibleGamesBasket.count; i++) {
            GameTypeId gameType = (GameTypeId)[self.dataModel.visibleGamesBasket[i] intValue];
            NSArray *optionArray = [self.dataModel dp_getOpenOptionWithGameType:gameType];
            if (optionArray.count < 10) {
                return;
            }
            int selected = NO;
            for (int i = 0; i < 10; i++) {
                if ([optionArray[i] intValue] > 0) {
                    selected = YES;
                    break;
                }
            }
            
        }

    }
    
}
#pragma mark basicCellDelegate

- (void)clickButtonWithCell:(DPJcdgGameTypeBasicCell *)cell gameType:(int)gameType index:(int)index isSelected:(BOOL)isSelected
{
    [self.dataModel dp_setOpenOptionWithGameType:(GameTypeId)gameType index:index isSelected:isSelected];
 
    [cell dp_reloadMoneyWithTimeTex:nil gameIndex:self.dataModel.curGameIndex];


}
- (void)dpjcdgInfoButtonClick:(DPJcdgGameTypeBasicCell *)cell
{
    
    [self.view endEditing:YES];
    DPJcdgWarnView *warnView = [[DPJcdgWarnView alloc]init];
    warnView.gameTypeLabel.text = cell.gameTypeLabel.text;
    warnView.titleText = cell.warnContent;
    
    [self.view addSubview:warnView];
    [warnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - DPJcdgBottomDelegate delegate
- (void)bottomCommit:(DPJcdgGameTypeBasicCell *)cell times:(int)times
{
    [self.view endEditing:YES];
    
    [self.dataModel dp_goPayWithGameType:cell.gameType times:times];
    __weak __typeof(self) weakSelf = self;
    void(^block)(void) = ^() {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showDarkHUD];
        [strongSelf.dataModel dp_sendGoPayRequest];
    };
    
    // TODO:
    if (/* CFrameWork::GetInstance()->IsUserLogin() */ NO) {
        block();
    } else {
//        DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
//        viewController.finishBlock = block;
//        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)bottomBonusBetterClick:(DPJcdgGameTypeBasicCell *)cell times:(NSString *)times
{
    [self.dataModel dp_setSingleSelectedTargetWithGameType:cell.gameType];
    [self.view endEditing:YES];
    [self.dataModel.timesDict setObject:times forKeyedSubscript:@(cell.gameType)];

    int note = 0;
    NSInteger result = [self.dataModel dp_getNoteWithGameType:cell.gameType note:&note];
    if (result < 0) {
        [self dismissDarkHUD];
        [[DPToast makeText:@"请求失败, 请重试"] show];
        return;
    }
    if (note <2) {
        [self dismissDarkHUD];
        [[DPToast makeText:@"至少选择2个选项!"] show];
        return ;
    }
    if ([self.dataModel dp_sendNetBalance] >= 0) {
        if(self.dataModel.balanceCost > 2000000){
            [[DPToast makeText:@"方案金额最大支持200万"]show];
            return  ;
        }
        [self.dataModel dp_setProjectBuyType:4];    }

    
//    _lotteryJczq->NetBalance() ;
}
- (void)bottomOfCell:(DPJcdgGameTypeBasicCell *)cell endEditingWithText:(NSString *)text
{
    [self.dataModel.timesDict setObject:text forKey:@(cell.gameType)];
}

- (void)bottomOfCell:(DPJcdgGameTypeBasicCell *)cell keyboardVisible:(BOOL)keyboardVisible options:(UIViewAnimationOptions)options duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd
{
    // chong xin xie
    if (keyboardVisible) {
        _contentOffset = self.tableView.contentOffset;
        CGFloat addHeight = 110;
        if ([[UIScreen mainScreen]bounds].size.height <= 480) {
            addHeight = 30;
        }
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(frameEnd) + addHeight, 0);
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    } else {
        self.tableView.scrollEnabled = YES;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            self.tableView.contentInset = _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
            [self.tableView setContentOffset:_contentOffset];
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

-(void)addNodataViewWithMyGameType:(MyGameType)type withRet:(int)ret{

    if (self.noDataView.superview) {
        [self.noDataView removeFromSuperview];
    }
 
    int gameCount = type == GameTypeBasketBall ? self.dataModel.gameCountBasketBall :self.dataModel.gameCountFootBall;
    
    if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
        
        if (gameCount <= 0) {
            self.noDataView.noDataState= DPNoDataNoworkNet ;
            [self.view addSubview:self.noDataView];
        }else{
            [[DPToast makeText:@"当前网络不可用"]show];
        }
       
        _hasNetWork = NO ;
        [self.tableView reloadData];
        
        return ;
//    }else if (ret ==ERROR_TimeOut ||ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA ){
//        if (gameCount <= 0) {
//            self.noDataView.noDataState = DPNoDataWorkNetFail ;
//            [self.view addSubview:self.noDataView];
//        }else{
//            [[DPToast makeText:@"网络加载失败"]show];
//        }
//        
//        _hasNetWork = NO ;
//        [self.tableView reloadData];
//        
//        return ;
    }else {
   
        if (type == GameTypeFootBall) {
            self.noDataView.gameType =  GameTypeJcNone ;
            self.tableView.scrollEnabled = self.dataModel.gameCountFootBall;
           
            if (self.dataModel.gameCountFootBall<=0) {
                self.noDataView.noDataState = DPNodataDanGuan ;
                [self.view addSubview:self.noDataView];
            }
            
 
        }else{
            self.noDataView.gameType =  GameTypeLcNone ;
            self.tableView.scrollEnabled = self.dataModel.gameCountBasketBall;
            
            if (self.dataModel.gameCountBasketBall<=0) {
                self.noDataView.noDataState = DPNodataDanGuan ;

                [self.view addSubview:self.noDataView];
            }
        }

        _hasNetWork = YES ;
        [self rebulidTeamsCell];
        [self.tableView reloadData];

    }

   
}
- (void)handleNotify:(int)cmdId result:(int)ret type:(int)cmdtype
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        switch (cmdtype) {
//            case JCZQ_SingleList:{
//                [self dismissHUD];
//                
//                if (_currentGameType == GameTypeFootBall) {
//                    [self addNodataViewWithMyGameType:GameTypeFootBall withRet:ret];
//                }
//               
//            }
//                break;
//            case Jclq_Single:{
//                [self dismissHUD];
//                  if (_currentGameType == GameTypeBasketBall) {
//                    [self addNodataViewWithMyGameType:GameTypeBasketBall withRet:ret];
//                }
//                
//            }
//                break;
//            case ACCOUNT_RED_PACKET: {
//                [self dismissDarkHUD];
//                if (ret < 0) {
////                    [[DPToast makeText:DPAccountErrorMsg(ret)] show];
//                    break;
//                }
////                DPRedPacketViewController *viewController = [[DPRedPacketViewController alloc] init];
////                viewController.gameTypeText = dp_GameTypeFirstName((GameTypeId)self.dataModel.payGameType);
////                viewController.projectAmount = (int)(self.dataModel.payNote * self.dataModel.payMultiple * 2);
////                viewController.delegate = self;
////                viewController.gameType = (GameTypeId)self.dataModel.payGameType;
////                viewController.isredPacket= CFrameWork::GetInstance()->GetAccount()->GetPayRedPacketCount() > 0;
////                viewController.delegate = self;
////                [self.navigationController pushViewController:viewController animated:YES];
//            }
//                break;
//            case JCZQ_Balance: {
//                
//            }
//                break;
//            default:
//                break;
//        }
    });

}

- (void)rebulidTeamsCell
{
    int count = 0 ;
    if (_currentGameType == GameTypeFootBall) {
        
        count = self.dataModel.gameCountFootBall ;

    }else{
       
        count = self.dataModel.gameCountBasketBall ;
    }
    
    self.teamsView.myGameType = _currentGameType ;
    [self.teamsView cleanAllTeamView];
    self.teamsView.gameCount = count;

    if(count<=0){
        self.teamsView.hidden = YES ;
        return ;
    }else{
        self.teamsView.hidden = NO ;
    }

//    self.teamsView.gameCount = self.dataModel.gameCount;
    // 界面内容
    
        
    for (int i = 0; i < count ; i++) {
       
        [self.teamsView setSingleTeamAtIndex:i withDataModel:[self.dataModel dp_perTeamModelForIndex:i withGameType:_currentGameType]];
    }

         if (count > 1)
        self.teamsView.scrollView.contentOffset = CGPointMake([[UIScreen mainScreen]bounds].size.width*(1+self.dataModel.curGameIndex), 0);
    

 }


#pragma mark - single tap
- (void)dp_viewTap:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

-(void)pvt_changeGameStyle:(DPSegmentedControl*)control{

     if (control.selectedIndex != _currentGameType) {
         [[DPToast sharedToast]dismiss];
        _currentGameType = control.selectedIndex ;
        if (self.CurrentType) {
            self.CurrentType(_currentGameType) ;
        }
         [self.dataModel dp_sendJcdgDataRequest];

        int count = 0 ;
        if (_currentGameType == GameTypeFootBall) {
            count = self.dataModel.gameCountFootBall ;
            self.noDataView.gameType = GameTypeJcNone ;
        }else{
            count = self.dataModel.gameCountBasketBall ;
            self.noDataView.gameType = GameTypeLcNone ;
        }
        
        if (count>0) {
            [self addNodataViewWithMyGameType:_currentGameType withRet:1];
        }
        
     }
    
}
#pragma mark getter & setter

-(DPSegmentedControl*)titleControl{

    if (_titleControl == nil ) {
        _titleControl = [[DPSegmentedControl alloc]initWithItems:@[@"足球",@"篮球"]] ;
        _titleControl.frame = CGRectMake(0, 0, 120, 30) ;
        _titleControl.tintColor= UIColorFromRGB(0x7C0C0F) ;
        _titleControl.containerView.backgroundColor = [UIColor clearColor] ;
        [_titleControl addTarget:self action:@selector(pvt_changeGameStyle:) forControlEvents:UIControlEventValueChanged];
        _titleControl.selectedIndex = (int)_currentGameType ;
    }
    
    return _titleControl ;
}
- (DPJcdgTeamsView *)teamsView
{
    if (_teamsView == nil) {
        _teamsView = [[DPJcdgTeamsView alloc]initWithGameType:_currentGameType];

        _teamsView.backgroundColor = UIColorFromRGB(0xfaf9f2);
        _teamsView.delegate = self;
    }
    return _teamsView;
}
- (DPJcdgDataModel *)dataModel
{
    
    if (_currentGameType == GameTypeFootBall) {
        return self.footdataModel ;
    }else if (_currentGameType == GameTypeBasketBall){
        return self.basketdataModel ;
    }
    return nil ;
    
}
- (DPJcdgDataModel *)basketdataModel
{
    if (_basketdataModel == nil) {
        _basketdataModel = [[DPJcdgDataModel alloc]initWithMyGameType:GameTypeBasketBall];
        _basketdataModel.delegate = self;
    }
    return _basketdataModel;
}

- (DPJcdgDataModel *)footdataModel
{
    if (_footdataModel == nil) {
        _footdataModel = [[DPJcdgDataModel alloc]initWithMyGameType:GameTypeFootBall];
        _footdataModel.delegate = self;
    }
    return _footdataModel;
}

 
-(UITableView*)tableView{

    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        _tableView.showsHorizontalScrollIndicator = NO ;
        _tableView.bounces = YES ;
        _tableView.backgroundColor = [UIColor clearColor] ;
        _tableView.delegate =self ;
        _tableView.dataSource =self ;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        _tableView.clipsToBounds = NO ;
        
        
    }
    
    return _tableView ;
}

-(DPNodataView*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame))];
        _noDataView.gameType = _currentGameType == GameTypeBasketBall? GameTypeLcNone : GameTypeJcNone ;
        _noDataView.noDataState =  DPNodataDanGuan ;

        __weak __typeof(self) weakSelf = self;
        
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

                [weakSelf.dataModel dp_sendJcdgDataRequest];
            }
            
        }];
    }
    return _noDataView ;
}

@end
