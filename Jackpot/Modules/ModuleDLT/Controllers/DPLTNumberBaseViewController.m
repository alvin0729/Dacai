//
//  DPNumberBaseViewController.m
//  DacaiProject
//
//  Created by WUFAN on 15/1/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPLTNumberBaseViewController.h"
#import "DPLTNumberCell.h"
#import "DPLTNumberViewModel.h"
#import "SVPullToRefresh.h"
#import "DPWebViewController.h"
#import "DPSmartPlanSetView.h"
#import "DPLTNumberViewModel+Singletons.h"
#import "DZNEmptyDataStyle+CustomStyle.h"
#import "DPPayRedPacketViewController.h"
#import "DPUARequestData.h"
#import "DPLogOnViewController.h"
#import "Order.pbobjc.h"
#import "DPFlowSets.h"
#import "DPOpenBetServiceController.h"

#define kAgreementBtnTag 1002

@interface DPLTNumberBaseViewController () <UITableViewDataSource> {
@private
    UITableView *_tableView;
    DPDigitalBottomView *_bottomView;
    UIView *_coverView;
    DPDigitalTimeSpaceView *_timeView;
}
@property (nonatomic, strong, readonly) UIView *coverView;//键盘弹出时的蒙版页面
@property (nonatomic, strong) DZNEmptyDataStyle *emptyDataStyle;


@end

@implementation DPLTNumberBaseViewController
@synthesize viewModel       = _viewModel;
@synthesize agreementLabel  = _agreementLabel;
@dynamic gameType;

- (instancetype)init {
    if (self = [super init]) {
        //注册倒计时刷新等的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateSpaceTime) name:kDPNumberTimerNotificationKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertGameName) name:kDPNumberSwitchNotificationKey object:nil];
       
        self.viewModel.gameIndex=0;
         //保存当前付款上下文, 必须在 init 方法中调用
        [DPPaymentFlow pushContextWithViewController:self];
        [self.viewModel setupWithControllerName:@"DPLTNumberViewModel"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor dp_colorFromHexString:@"#faf9f2"];
    self.title = self.viewModel.gameTypeName;
    [self buildLayout];

    __weak __typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf dp_pullToRefresh];
    }];
    
    UITapGestureRecognizer *tagesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tagesture.delegate = self;
    [self.view addGestureRecognizer:tagesture];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(onBtnBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_DigitLotteryImage(@"ballAdd.png") title:@"手动添加" target:self action:@selector(onBtnAdd)];
    [self customStyle];
   
    self.tableView.emptyDataSetSource = self.emptyDataStyle;
    self.tableView.emptyDataSetDelegate = self.emptyDataStyle;
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.tableView reloadData];
    //更新金额注数
    [self.bottomView dp_refreshMoneyContent];
    //如果当前注数为0，则显示下拉机选一注，
    self.tableView.tableFooterView.hidden = !self.viewModel.note;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)gameType {
    DPException(@"不应该被执行");
}

- (void)dealloc{
    [self.viewModel uninstall];
     //销毁当前付款上下文, 必须在 dealloc 方法方法中调用
    [DPPaymentFlow popContextWithViewController:self];
}

- (void)buildLayout {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.bottomView];
    UIView *backTopView=[UIView dp_viewWithColor:UIColorFromRGB(0xf9faf2)];
    [self.view addSubview:backTopView];
    [backTopView addSubview:self.agreementLabel];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [backTopView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@39);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.agreementLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.coverView setHidden:YES];

}
//取消键盘
- (void)pvt_onTap {
    [self.view endEditing:YES];

}
//下拉刷新一注
- (void)dp_pullToRefresh
{
    //随机生成一注并保存在数据源里
    [self.viewModel generateNumber:self.viewModel.gameIndex];
    [self.tableView.pullToRefreshView stopAnimating];
    self.tableView.tableFooterView.hidden = !self.viewModel.note;
    [self.bottomView dp_refreshMoneyContent];
    [self.tableView reloadData];
}
#pragma mark - 点击事件
//返回
- (void)onBtnBack {
    // 跳转逻辑 当前注数为0，则不作任何提示
    if (self.viewModel.note <= 0){
        if (self.navigationController.viewControllers.firstObject == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    //当前注册为0，则提示用户清空号码
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"返回将清空所有已选号码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    @weakify(self);
    @weakify(alertView);
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        @strongify(self);
        @strongify(alertView);
        if (buttonIndex.integerValue != alertView.cancelButtonIndex) {
            if (self.navigationController.viewControllers.firstObject == self) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    [alertView show];
}
//手动添加一注
- (void)onBtnAdd {
    [self.view endEditing:YES];
    [self.navigationController pushViewController:[[self.viewModel.lotteryClass alloc]init] animated:YES];
}
//代购协议
- (void)onBtnAgreementLabel {
    DPWebViewController *webCtrl = [[DPWebViewController alloc]init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.canHighlight = NO ;
    [self.navigationController pushViewController:webCtrl animated:YES];
}
#pragma mark - DPLTNumberMutualDelegate
//点击付款
- (void)onBtnGoPay {
   [self.view endEditing:YES];
    int index= (int)self.viewModel.note;
    self.viewModel.followCount=[self.bottomView dp_addSelectedBetIssue];
    int money = (int)(index  * self.viewModel.multiple * self.viewModel.followCount*(self.viewModel.isAddition?3:2));
    int  gameName=(int)self.viewModel.gameName;
    if (index<1) {
        [[DPToast makeText:@"请至少选择一注"]show];
        return ;
    }
    if (self.viewModel.multiple < 1) {
        [[DPToast makeText:@"请至少选择一倍"]show];
        return ;
    }
    
    if (self.viewModel.followCount <1) {
        [[DPToast makeText:@"请至少选择一期"]show];
        return ;
    }
    if (money > 2000000){
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;
        
    }
    if (self.agreementLabel.selected == NO) {
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }
    if (!self.viewModel.enable) {
        [[DPToast makeText:@"当前玩法已停售"] show];
        return;
    }
   
    if ( self.viewModel.followCount==1) {
        PBMPlaceAnOrder *item=[[PBMPlaceAnOrder alloc] init];
        item.betDescription=[self.viewModel goBodyStrinfForPay:1];
        item.betOrderNumbers=@"";
        item.betType=[self.viewModel projectBetType];
        item.channelType=1;
        item.deviceNum=@"";
        item.gameId=(int)self.viewModel.gameId;
        item.gameTypeId=(int)self.gameType;
        item.multiple=[self.bottomView dp_addSelectedBetTimes];
        item.platformType=1;
        item.quantity=(int)self.viewModel.note;
        item.totalAmount=money;
        item.betTypeDesc=[self betTypeDescString:item.betType];
        item.projectBuyType=1;
        item.passTypeDesc=@"";
        //大乐透付款动作
        [DPPaymentFlow paymentWithOrder:item gameType:self.gameType gameName:gameName inViewController:self];
    }else{
        PBMChaseToPlaceAnOrder *chaseItem=[[PBMChaseToPlaceAnOrder alloc] init];
        chaseItem.disseminate=@"";
        chaseItem.followContent=[self.viewModel goBodyStrinfForPay:self.viewModel.followCount];
        chaseItem.followStopCondition=@"";
        chaseItem.followStopTypeId=2;
        chaseItem.followTypeId=4;
        chaseItem.gameName=[NSString stringWithFormat:@"%d",gameName];
        chaseItem.gameId=(int)self.viewModel.gameId;
        chaseItem.gameTypeId=(int)self.gameType;
        chaseItem.totalAmount=money;
        chaseItem.totalCount=self.viewModel.followCount;
        //大乐透追号付款动作
        [DPPaymentFlow paymentWithChase:chaseItem gameType:self.gameType followCount:self.viewModel.followCount inViewController:self];
    }
   
}

//清空所有的数据
- (void)onBTnDeleteAllData{
    [self.viewModel.infoArray removeAllObjects];
    [self.tableView reloadData];
    if (self.viewModel.note <= 0) {
        self.tableView.tableFooterView.hidden = YES;
    }
    [self.bottomView dp_refreshMoneyContent];
}

//获取投注类别描述
-(NSString *)betTypeDescString:(int)index{
    switch (index) {
        case 1:
            return @"单式";
        case 2:
            return @"复式";
        case 3:
            return @"单式,复式";
        case 4:
            return @"带胆复式";
            
        default:
            break;
    }
    return @"";
}
//删除某注
- (void)onBtnDeleteSingleCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        [self.viewModel deleteSingleCellAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        if (self.viewModel.note <= 0) {
            self.tableView.tableFooterView.hidden = YES;
        }
        [self.bottomView dp_refreshMoneyContent];
    }
    
}
//键盘消息
- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.bottomView && obj.firstAttribute == NSLayoutAttributeBottom) {
            obj.constant = keyboardY - screenHeight;
            *stop = YES;
        }
    }];
    CGFloat height = 0;
    BOOL hidden = YES;
    if (endFrame.origin.y <kScreenHeight) {
        height = 35;
        hidden = NO;
    }
    [self.bottomView dp_showMiddleContentWithHeight:height lineHidden:hidden];
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [UIView animateWithDuration:duration delay:0 options:curve << 16 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    if (keyboardY != UIScreen.mainScreen.bounds.size.height) {
        [self pvt_hiddenCoverView:NO];
    }else{
        [self pvt_hiddenCoverView:YES];
    }
    
}
//隐藏模板
- (void)pvt_hiddenCoverView:(BOOL)hidden {
    if (hidden) {
        if (!self.coverView.hidden) {
            self.coverView.alpha = 1;
            [UIView animateWithDuration:0.2 animations:^{
                self.coverView.alpha = 0;
//                _midlleLine.alpha = 0;
//                _bottomLine.alpha = 0;
            } completion:^(BOOL finished) {
                self.coverView.hidden = YES;
            }];
        }
    } else {
        if (self.coverView.hidden) {
            self.coverView.alpha = 0;
            self.coverView.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.coverView.alpha = 1;
            }];
        }
    }
}
#pragma mark - table view data source and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    DPLTNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [(DPLTNumberCell *)[self.viewModel.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    [cell styleForModel:[self.viewModel modelForCellAtIndex:indexPath.row]];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 57;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DPLTNumberCell heightForNumberContent:[[[self.viewModel modelForCellAtIndex:indexPath.row] numberString] string]];
}
#pragma mark - getter
//选号列表view
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setAllowsSelection:YES];
//        _tableView.tableFooterView = self.agreementLabel;
    }
    return _tableView;
}
// 底部交互view
-(DPDigitalBottomView *)bottomView{
    if (_bottomView==nil) {
        _bottomView=[[DPDigitalBottomView alloc] initWithFrame:CGRectZero lotteryType:self.viewModel.gameType];
        _bottomView.backgroundColor=[UIColor clearColor];
        _bottomView.mdelegate=self;
        _bottomView.mdataSource=self.viewModel;
    }
    return _bottomView;
}
//蒙版
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
}
//增加一注
- (DZNEmptyDataStyle *)emptyDataStyle {
    if (_emptyDataStyle == nil) {
        _emptyDataStyle =[[DZNEmptyDataStyle alloc] init];
        _emptyDataStyle.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"addyiZhuBall.png")];
        _emptyDataStyle.shouldDisplay = YES;
    }
    return _emptyDataStyle;
}
//手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"DPDigitalIssueControl"]) {
        return NO;
    }
    if (gestureRecognizer.view.tag==5) {
        return NO;
    }
    return YES;
}
//中转模型初始化
- (id<DPLTNumberMainDataSource, DPLTNumberMutualDataSource, DPLTNumberTimerDataSource>)viewModel {
    if (_viewModel == nil) {
        _viewModel = (id)[DPLTNumberViewModel sharedModel:self.gameType];
    }
    return _viewModel;
}
// 同意协议
- (DPAgreementLabel *)agreementLabel
{
    if (_agreementLabel == nil) {
        _agreementLabel = [DPAgreementLabel purchaseLabelWithTarget:self action:@selector(onBtnAgreementLabel)];
        _agreementLabel.attrString = self.viewModel.attStr;
        _agreementLabel.selected = YES;
        _agreementLabel.frame = CGRectMake(0, 0, 320, 35);
    }
    return _agreementLabel;
}
//倒计时
-(DPDigitalTimeSpaceView *)timeView{
    if (_timeView==nil) {
        _timeView=[[DPDigitalTimeSpaceView alloc] initWithFrame:CGRectZero lotteryType:self.gameType];
        _timeView.backgroundColor=[UIColor clearColor];
    }
    return _timeView;

}

- (void)alertGameName {

    UIViewController *currentController = self.navigationController.viewControllers.lastObject;
    if (!(currentController == self) && // 中转界面
        ![self isBuyController:currentController]  // 投注界面
        
         ) {    
        return;
    }

    if (self.viewModel.isSwitchGame) {
        UIView* smartView = ({
            DPSmartCountSureView * view = [[DPSmartCountSureView alloc]init];
            view.alertText = self.viewModel.switchGameString ;
            DPLog(@"self.viewModel.switchGameString=%@", self.viewModel.switchGameString);
            view ;
        }) ;
        [kAppDelegate.window addSubview:smartView];
        [smartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            //            make.edges.equalTo(self.navigationController.view.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        //如果不做任何处理，则10秒后关闭弹框
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (smartView) {
                [smartView removeFromSuperview];
            }
        });
        [self.viewModel switchHandled];
    }
}


 - (void)customStyle {}
- (void)dp_refreshBottomData {}
- (void)upDateSpaceTime {}
- (BOOL)isBuyController:(UIViewController *)viewController { return NO; }


@end
