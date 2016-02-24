//
//  DPNumberBaseViewController.m
//  DacaiProject
//
//  Created by WUFAN on 15/1/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPLTNumberBaseViewController.h"
#import "DPLTNumberCell.h"
#import "DPLTNumberViewModel.h"
#import "SVPullToRefresh.h"
#import "DPWebViewController.h"
 #import "DPAccountViewControllers.h"
#import "FrameWork.h"
#import "DPSmartPlanSetView.h"
  #import "DPRedPacketViewController.h"
#import "DPLTNumberViewModel+Singletons.h"
#import "JKTAppDelegate.h"
 #define kAgreementBtnTag 1002

@interface DPLTNumberBaseViewController () <
    UITableViewDataSource, DPRedPacketViewControllerDelegate
> {
@private
    UITableView *_tableView;
    DPDigitalBottomView *_bottomView;
     UIView *_coverView;
    DPDigitalTimeSpaceView *_timeView;
    
}
@property (nonatomic, strong, readonly) UIImageView *addOneNoteView; // 机选一注图标
@property (nonatomic, strong, readonly) UIView *coverView;
@end

@implementation DPLTNumberBaseViewController
@synthesize addOneNoteView  = _addOneNoteView;
@synthesize viewModel       = _viewModel;
@synthesize agreementLabel  = _agreementLabel;
@dynamic gameType;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateSpaceTime) name:kDPNumberTimerNotificationKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertGameName) name:kDPNumberSwitchNotificationKey object:nil];
        
        [self.viewModel setup];
        self.viewModel.gameIndex=0;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tagesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tagesture.delegate = self;
    [self.view addGestureRecognizer:tagesture];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(onBtnBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_DigitLotteryImage(@"ballAdd.png") title:@"手动添加" target:self action:@selector(onBtnAdd)];
    [self customStyle];
   
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.bottomView dp_refreshMoneyContent];
    
    
    self.addOneNoteView.hidden = self.viewModel.note;
    self.tableView.tableFooterView.hidden = !self.viewModel.note;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
}

- (NSInteger)gameType {
    DPException(@"不应该被执行");
}

- (void)dealloc{
    [self.viewModel uninstall];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)buildLayout {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.bottomView];
   
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
   
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.coverView setHidden:YES];
    [self.addOneNoteView setBounds:CGRectMake(0, 0, 154, 112)];
    [self.addOneNoteView setCenter:CGPointMake(160, 180)];
    [self.tableView addSubview:self.addOneNoteView];

}
- (void)pvt_onTap {
    [self.view endEditing:YES];

}
- (void)dp_pullToRefresh
{
    [self.viewModel generateNumber:self.viewModel.gameIndex];
    [self.tableView.pullToRefreshView stopAnimating];
    self.addOneNoteView.hidden = self.viewModel.note;
    self.tableView.tableFooterView.hidden = !self.viewModel.note;
    [self.bottomView dp_refreshMoneyContent];
    [self.tableView reloadData];
}
#pragma mark - 点击事件
- (void)onBtnBack {
    // 跳转逻辑
    if (self.viewModel.note <= 0){
        if (self.navigationController.viewControllers.firstObject == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"返回将清空所有已选号码" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (self.navigationController.viewControllers.firstObject == self) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

- (void)onBtnAdd {
    [self.view endEditing:YES];
    [self.navigationController pushViewController:[[self.viewModel.lotteryClass alloc]init] animated:YES];
}

- (void)onBtnAgreementLabel {
    DPWebViewController *webCtrl = [[DPWebViewController alloc]init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.canHighlight = NO ;
    [self.navigationController pushViewController:webCtrl animated:YES];
}
#pragma mark - DPLTNumberMutualDelegate

- (void)onBtnGoPay {
    [self.view endEditing:YES];
    int index= (int)self.viewModel.note;
    int money = (int)(index  * self.viewModel.multiple * self.viewModel.followCount*(self.viewModel.isAddition?3:2));
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
    

    __weak __typeof(self) weakSelf = self;

    void(^finishBlock)(int ret) = ^(int ret){
        CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();
        [weakSelf dismissDarkHUD];
        if (ret < 0) {
            [[DPToast makeText:DPAccountErrorMsg(ret)] show];
            return ;
        }
        BOOL isRedpacket=NO;
        if (moduleInstance->GetPayRedPacketCount()) {
            isRedpacket=YES;
        }
        DPRedPacketViewController *viewController = [[DPRedPacketViewController alloc] init];
        viewController.gameTypeText = dp_GameTypeFullName((GameTypeId)weakSelf.viewModel.gameType);
        viewController.projectAmount = money;
        viewController.delegate = weakSelf;
        viewController.isredPacket=isRedpacket;
        viewController.gameType = (GameTypeId)weakSelf.viewModel.gameType;
        if (weakSelf.viewModel.followCount > 1) {
            viewController.entryType = kEntryTypeFollow;
        }
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    };
    
    void (^block)(void) = ^() {
        [weakSelf.viewModel dp_setTogetherAndPayType:NO];
        int regindex = (int)[(id)weakSelf.viewModel dpn_rebindId:CFrameWork::GetInstance()->GetAccount()->Net_RefreshRedPacket((int)weakSelf.viewModel.gameType, 1, money, 0) type:ACCOUNT_RED_PACKET] ;
        if (regindex < 0) {
            [[DPToast makeText:@"请求数据失败"] show];
            return;
        }
        [weakSelf showDarkHUD];
    };
    void (^reloadBlock)() = ^(){
        [weakSelf dismissDarkHUD];
        DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
        viewController.finishBlock = block;
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    };
    
    self.viewModel.goPayFinish = finishBlock;
    self.viewModel.reloginBlock = reloadBlock;
    
    if (CFrameWork::GetInstance()->IsUserLogin()) {
        block();
    } else {
        reloadBlock();
    }
}

- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType
{
    if (ret >= 0) {
        NSString *ulrString = [self.viewModel dp_orderInfoUrl];
        if (ulrString.length < 1) {
            [[DPToast makeText:@"返回网址为空"] show];
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ulrString]];
        kAppDelegate.gotoHomeBuy = YES;

    }
}
 
- (void)onBtnDeleteSingleCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        [self.viewModel deleteSingleCellAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.addOneNoteView.hidden = self.viewModel.note;
        if (self.viewModel.note <= 0) {
            self.tableView.tableFooterView.hidden = YES;
        }
        [self.bottomView dp_refreshMoneyContent];
    }
    
}

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
    if (self.bottomView.tag == 1 && CGRectGetHeight(endFrame) > 0) {
        height = 60;
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
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setAllowsSelection:YES];
        _tableView.tableFooterView = self.agreementLabel;
    }
    return _tableView;
}
-(DPDigitalBottomView *)bottomView{
    if (_bottomView==nil) {
        _bottomView=[[DPDigitalBottomView alloc] initWithFrame:CGRectZero lotteryType:self.viewModel.gameType];
        _bottomView.backgroundColor=[UIColor clearColor];
        _bottomView.mdelegate=self;
        _bottomView.mdataSource=self.viewModel;
    }
    return _bottomView;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
}
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
    return YES;
}
- (id<DPLTNumberMainDataSource, DPLTNumberMutualDataSource, DPLTNumberTimerDataSource>)viewModel {
    if (_viewModel == nil) {
        _viewModel = (id)[DPLTNumberViewModel sharedModel:self.gameType];
    }
    return _viewModel;
}
- (UIImageView *)addOneNoteView
{
    if (_addOneNoteView == nil) {
        _addOneNoteView = [[UIImageView alloc] init];
        _addOneNoteView.backgroundColor = [UIColor clearColor];
        
        UIImage *image = [UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"addyiZhuBall.png")];
         _addOneNoteView.image = image;
    }
    return _addOneNoteView;
}
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (smartView) {
                [smartView removeFromSuperview];
            }
        });
        [self.viewModel switchHandled];
    }
}

@end
