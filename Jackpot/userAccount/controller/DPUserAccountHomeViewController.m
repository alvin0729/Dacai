//
//  DPUserAccountHomeViewController.m
//  Jackpot
//
//  Created by mu on 15/8/12.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPUserAccountHomeViewController.h"
#import "DPUASetViewController.h"
#import "DPRechangeViewController.h"
#import "DPDrawMoneyViewController.h"
#import "DPBuyTicketRecordViewController.h"
#import "DPGSHomeViewController.h"
#import "DPMessageCenterViewController.h"
#import "DPLoginViewController.h"
#import "DPLogOnViewController.h"
#import "DPSecurityCenterViewController.h"
#import "DPAlterViewController.h"
#import "DPUAFundDetailViewController.h"
#import "DPIconNameSetViewController.h"
#import "DPUARedGiftViewController.h"
#import "DPOpenBetServiceController.h"
//view
#import "DPUAHomeHeaderView.h"
#import "DPAccountFunctionCell.h"
#import "DPUARequestData.h"

@interface DPUserAccountHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) DPUAHomeHeaderView *headerView;//头部信息
@property (nonatomic, strong) UITableView *functionTable;
@property (nonatomic, strong) PBMMyInforItem *userInfo;//用户信息用
@property (nonatomic, strong) NSArray *cellTitles;//名称数组
@property (nonatomic, strong) NSArray *cellImages;//图标数组
@property (nonatomic, strong) NSMutableArray *tableData;//数据源
/**
 * reach：请求数据是否成功
 */
@property (nonatomic, assign) BOOL reach;
@end

@implementation DPUserAccountHomeViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        [self configureDailyTask];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self initilizerUI];
}
- (void)initilizerUI {
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(220);
    }];
    
    [self.view addSubview:self.functionTable];
    [self.functionTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([DPMemberManager sharedInstance].isLogin) {
        [self requestData];
    }else{
        [self errorForUserHome];
    }
}
- (void)errorForUserHome {
    self.headerView.nameLabel.text = @"请登录";
    self.headerView.fundsValueLab.text = @"--";
    self.headerView.redGiftValueLab.text = @"--个";
    self.headerView.iconImage.image = dp_AccountImage(@"UAIconDefalt.png");
    CGSize userMoneySize = [NSString dpsizeWithSting:@"--" andFont:[UIFont boldSystemFontOfSize:17] andMaxWidth:kScreenWidth];
    self.headerView.fundsValueWidthConstraint.mas_equalTo(userMoneySize.width+2);
    [[DPMemberManager sharedInstance] logout];
    [UMComLoginManager userLogout];
    [self.functionTable reloadData];
}

#pragma mark---------导航栏
- (void)setUpNavigationBar {
    self.title = @"我的彩票";
    self.navigationItem.backBarButtonItem = nil;
    self.dp_shouldNavigationBarHidden = YES;
    UIBarButtonItem *rightItem =[UIBarButtonItem dp_itemWithTitle:@"设置" target:self action:@selector(setItemTapped)];
    self.navigationItem.rightBarButtonItem = rightItem;

    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:dp_AccountImage(@"UASet.png") forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setItemTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    
}
//设置
- (void)setItemTapped {
    [self.navigationController pushViewController:[[DPUASetViewController alloc]init] animated:YES];
}
#pragma mark---------headerView
//view
- (DPUAHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DPUAHomeHeaderView alloc]initWithFrame:CGRectZero];
        @weakify(self);
        //头像点击事件
        _headerView.iconTap = ^{
            @strongify(self);
            if ([self login]) {
                return ;
            }
            //昵称
            DPIconNameSetViewController *controller = [[DPIconNameSetViewController alloc]init];
            controller.userInfo = self.userInfo;
            [self.navigationController pushViewController:controller  animated:YES];
        };
        _headerView.fundTap = ^{
            @strongify(self);
            if ([self login]) {
                return ;
            }
            //资金明细
            DPUAFundDetailViewController *controller = [[DPUAFundDetailViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        };
        _headerView.redGiftTap = ^{
            [[DPToast makeText:@"红包功能尚未开通"] show];
            return;
        };
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(login)];
        [_headerView addGestureRecognizer:tapGesture];
    }
    return _headerView;
}
//判断当前是否登录
- (BOOL)login {
    if (![DPMemberManager sharedInstance].isLogin) {
       
        DPLogOnViewController *controller = [[DPLogOnViewController alloc]init];
//        [self.navigationController pushViewController:controller animated:YES];
        UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
        return YES;
    }else{
        return NO;
    }
    
}

#pragma mark---------functionTable
- (NSMutableArray *)tableData{
    if (!_tableData) {
        _tableData = [NSMutableArray array];
        NSArray *iconNameArray = @[@"UAReChange.png",@"UADrawMoney.png",@"UABuyRecord.png",@"DPUARun.png",@"UAGrowSystem.png",@"UAMessageCenter.png",@"UASafeCenter.png"];
        NSArray *titlesArray = @[@"充值",@"提款",@"购彩纪录",@"追号中心",@"会员体系",@"消息中心",@"安全中心"];
        for (NSInteger i = 0; i < iconNameArray.count; i++) {
            DPUAObject *object = [[DPUAObject alloc]init];
            object.title = titlesArray[i];
            object.imageName = iconNameArray[i];
            [_tableData addObject:object];
        }
    }
    return _tableData;
}
- (UITableView *)functionTable{
    if (!_functionTable) {
        _functionTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _functionTable.delegate = self;
        _functionTable.dataSource = self;
        _functionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _functionTable.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _functionTable.backgroundColor = [UIColor dp_flatBackgroundColor];
    }
    return _functionTable;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    DPAccountFunctionCell *cell = [[DPAccountFunctionCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    
    DPUAObject *object = self.tableData[indexPath.row];
    if ([object.title isEqualToString:@"安全中心"]){
        if(self.userInfo.betOpen){
             cell.detailTextLabel.text = @"";
        }else{
             cell.detailTextLabel.text =  @"开通投注服务";
        }
    }
    if ([object.title isEqualToString:@"会员体系"]) {
        object.value = [NSString stringWithFormat:@"%zd",self.userInfo.giftCount];
    }
    if ([object.title isEqualToString:@"消息中心"]) {
        object.value = [NSString stringWithFormat:@"%zd",self.userInfo.messageCount];
    }
    cell.object = object;
    //未登录情况下处理
    if (![DPMemberManager sharedInstance].isLogin) {
        cell.messageCountLab.hidden = YES;
        cell.detailTextLabel.text =  @"";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([DPMemberManager sharedInstance].isLogin) {
        if (!self.reach) {
            [[DPToast makeText:@"数据请求错误"]show];
            return;
        }
        
        DPUAObject *object = self.tableData[indexPath.row];
        BOOL needOpenBet =  [object.title isEqualToString:@"充值"]||[object.title isEqualToString:@"提款"]||[object.title isEqualToString:@"购彩纪录"]||[object.title isEqualToString:@"追号中心"];
        
        if (![DPMemberManager sharedInstance].betOpen&&needOpenBet) {
                DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
        }else{
            NSArray *controlles = @[@"DPRechangeViewController",@"DPDrawMoneyViewController",@"DPBuyTicketRecordViewController",@"DPChaseNumberCenterViewController",@"DPGSHomeViewController",@"DPMessageCenterViewController",@"DPSecurityCenterViewController"];
            if (indexPath.row<controlles.count) {
                [self.navigationController pushViewController:[[NSClassFromString(controlles[indexPath.row]) alloc]init] animated:YES];
            }
        }
    }else{
        UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:[[DPLogOnViewController alloc]init]];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

/**
 *  激活任务
 */
- (void)configureDailyTask {
    //1,开启定时器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    double date = [[NSDate dp_date] timeIntervalSince1970];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    double date1 = [[calendar dateFromComponents:components] timeIntervalSince1970];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:date1];
    NSString *reactiveDateStr = [formatter stringFromDate:nowDate];
    NSDate *reactiveDate = [formatter dateFromString:reactiveDateStr];
    NSTimeInterval timeInterval = 24*60*60+[reactiveDate timeIntervalSinceNow];
    NSTimer *timer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(reactiveTask) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [self reactiveTask];
}
- (void)reactiveTask {
    //1,当前日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dp_DateFormatter_yyyy_MM_dd];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *reactiveDate = [formatter stringFromDate:[NSDate dp_date]];
    //2,激活日期
    NSString *lastReactiveDate = [[NSUserDefaults standardUserDefaults]objectForKey:kDPReactiveTaskNotificationKey];
    //3,校验是否已激活
    if ([lastReactiveDate isEqualToString:reactiveDate]) {
        return;
    }
    //4,激活任务
    [DPUARequestData reactiveTasksuccess:^{
        [formatter setDateFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
        [[NSUserDefaults standardUserDefaults]setObject:reactiveDate forKey:kDPReactiveTaskNotificationKey];
    } fail:^(NSString *error) {
    }];
}
#pragma mark---------data
//请求用户信息
- (void)requestData {
    if (!self.userInfo) {
        [self showHUD];
    }
    @weakify(self);
    [DPUARequestData userInfoWithParam:nil Success:^(PBMMyInforItem *myInforItem) {
        @strongify(self);
        [self dismissHUD];
        self.reach = YES;
        self.userInfo = myInforItem;
        if (myInforItem.userIcon.length>0) {
            [self.headerView.iconImage setImageWithURL:[NSURL URLWithString:myInforItem.userIcon]];
        }
        self.headerView.nameLabel.text = myInforItem.userName;
        CGSize userMoneySize = [NSString dpsizeWithSting:myInforItem.userMoney andFont:[UIFont boldSystemFontOfSize:17] andMaxWidth:kScreenWidth];
        self.headerView.fundsValueWidthConstraint.mas_equalTo(userMoneySize.width+75>kScreenWidth*0.5?kScreenWidth*0.5-76:userMoneySize.width+4);
        self.headerView.fundsValueLab.text = [NSString stringWithFormat:@"%@",myInforItem.userMoney];
        self.headerView.redGiftValueLab.text = [NSString stringWithFormat:@"%zd个",myInforItem.redGiftCount];
        DPMemberManager *memberManager = [DPMemberManager sharedInstance];
        if (myInforItem.userIcon.length>0) {
            memberManager.iconImageURL = myInforItem.userIcon;
        }else{
            self.headerView.iconImage.image = dp_AccountImage(@"UAIconDefalt.png");
        }
        
        [self.functionTable reloadData];
    } andFail:^(NSError *failMessage) {
        @strongify(self);
        [self dismissHUD];
        self.reach = NO;
        if ([failMessage dp_errorCode]==DPErrorCodeUserUnlogin) {
            UIAlertView *outLoginAlter = [[UIAlertView alloc]initWithTitle:@"身份过期" message:@"帐号身份已过期，请重新登录" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [[outLoginAlter rac_buttonClickedSignal] subscribeNext:^(id x) {
                UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:[[DPLogOnViewController alloc]init]];
                [self presentViewController:nav animated:YES completion:nil];
            }];
            [outLoginAlter show];
            [self errorForUserHome];
        }else{
            [[DPToast makeText:[failMessage dp_errorMessage] color:[UIColor dp_flatBlackColor]] show];
        }
    }];
    
}

@end
