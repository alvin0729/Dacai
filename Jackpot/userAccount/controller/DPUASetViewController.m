//
//  DPUASetViewController.m
//  Jackpot
//
//  Created by mu on 15/8/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPUASetViewController.h"
#import "DPUAPushSetViewController.h"
#import "DPFeedbackViewController.h"
#import "DPAlterViewController.h"
#import "DPLogOnViewController.h"
#import "DPAboutVC.h"
//view
#import "DPAccountFunctionCell.h"
#import "DPWebViewController.h"
//data
#import "UMComLoginManager.h"
#import "UMSocial.h"
@interface DPUASetViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property (nonatomic, strong) UITableView *functionTable;
@property (nonatomic, strong) UIButton *exitBtn;//退出当前用户
@property (nonatomic, strong) UIView *headerView;//头部
@property (nonatomic, strong) UIView *footerView;//底部
//=========data
@property (nonatomic, strong) PBMPushItem *pushItem;//推送设置
@property (nonatomic, strong) NSMutableArray *tableData;
@end

@implementation DPUASetViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor dp_flatWhiteColor];
    self.pushItem = [[PBMPushItem alloc]init];
    self.pushItem.winningPush = YES;
    self.pushItem.gametypeId = @"4";
    self.pushItem.notroble = YES;
    [self requestData];
    
    [self.view addSubview:self.functionTable];
    [self.functionTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.view addSubview:self.exitBtn];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_thirdShareFinish:) name:dp_ThirdShareFinishKey object:nil];
}
//分享回调
- (void)dp_thirdShareFinish:(NSNotification *)info
{
    [[DPToast makeText:[info.userInfo[dp_ThirdShareResultKey] boolValue]?@"分享成功":@"分享失败"] show];
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 获取推送设置信息
- (void)requestData {
    @weakify(self);
    self.pushItem.pushDevice = [KTMUtilities pushDeviceToken];
    [DPUARequestData pushSetWithParam:self.pushItem Success:^(PBMPushItem *pushItem) {
        @strongify(self);
        self.pushItem = pushItem;
    } andFail:^(NSString *failMessage) {
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
}
#pragma mark---------functionTable
//列表
- (UITableView *)functionTable {
    if (!_functionTable) {
        _functionTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _functionTable.delegate = self;
        _functionTable.dataSource = self;
        _functionTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _functionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _functionTable.tableHeaderView = self.headerView;
        _functionTable.tableFooterView = self.footerView;
        _functionTable.delaysContentTouches = NO;
    
    }
    return _functionTable;
}
//数据源
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [NSMutableArray array];
        NSArray *titles = @[@"推送",@"客服",@"意见反馈",@"推荐给好友",@"帮助中心",@"关于"];
        NSArray *imageNames = @[@"userPush.png",@"userCustomerService.png",@"feedback.png",@"UASetShare.png",@"helpCenter.png",@"userAbout.png"];
        for (NSInteger i = 0; i < titles.count; i++) {
            DPUAObject *object = [[DPUAObject alloc]init];
            object.title = titles[i];
            object.imageName = imageNames[i];
            [_tableData addObject:object];
        }
    }
    return _tableData;
}
//头部
-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 11)];
        _headerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = UIColorFromRGB(0xc7c8cc);
        [_headerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return _headerView;
}
//底部
-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]init];
        _footerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = UIColorFromRGB(0xc7c8cc);
        [_footerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _footerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPAccountFunctionCell *cell = [[DPAccountFunctionCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    cell.object = self.tableData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tableviewCellTapped:indexPath];
}
//
- (void)tableviewCellTapped:(NSIndexPath *)indexPath{
    DPUAObject *object = self.tableData[indexPath.row];
    //点击不同行的不同处理方式
    if ([object.title isEqualToString:@"推送"]) {
        DPUAPushSetViewController *controller = [[DPUAPushSetViewController alloc]init];
        controller.pushItem = self.pushItem;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    if ([object.title isEqualToString:@"客服"]) {
        DPAlterViewController *controller = [[DPAlterViewController alloc]initWithAlterType:AlterTypeService];
        @weakify(self);
        controller.sevice = ^{
            @strongify(self);
            DPWebViewController *controller = [[DPWebViewController alloc]init];
            controller.requset = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://chat56.live800.com/live800/chatClient/chatbox.jsp?companyID=176377&jid=2757882303&enterurl"]];
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
        return;
    }
    
    if ([object.title isEqualToString:@"意见反馈"]) {
        [self.navigationController pushViewController:[[DPFeedbackViewController alloc]init] animated:YES];
        return;
    }
    
    if ([object.title isEqualToString:@"帮助中心"]) {
        DPWebViewController *controller = [[DPWebViewController alloc]init];
        controller.title = @"帮助中心";
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerBaseURL,@"/web/help/home"];
        controller.requset = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    if ([object.title isEqualToString:@"关于"]) {
        [self.navigationController pushViewController:[[DPAboutVC alloc]init] animated:YES];
        return;
    }
    
    if ([object.title isEqualToString:@"推荐给好友"]) {
        //wx
        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://m.dacai.com/activity/selectuseragent";
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://m.dacai.com/activity/selectuseragent";
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"大彩APP口袋里的投注站";
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"大彩APP口袋里的投注站";
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText =  @"抓住随时随地的幸运，邂逅你的彩票梦想！";
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = dp_AccountImage(@"Icon.png");// dp_AccountImage(@"Icon.png");
        [UMSocialData defaultData].extConfig.wechatSessionData.shareImage =  dp_AccountImage(@"Icon.png");
        //qq
        [UMSocialData defaultData].extConfig.qqData.url = @"http://m.dacai.com/activity/selectuseragent";
        [UMSocialData defaultData].extConfig.qzoneData.url = @"http://m.dacai.com/activity/selectuseragent";
        [UMSocialData defaultData].extConfig.qqData.title = @"大彩APP口袋里的投注站";
        [UMSocialData defaultData].extConfig.qzoneData.title = @"大彩APP口袋里的投注站";
        [UMSocialData defaultData].extConfig.qzoneData.shareImage =  @"抓住随时随地的幸运，邂逅你的彩票梦想！";
        [UMSocialData defaultData].extConfig.qzoneData.shareText =  @"抓住随时随地的幸运，邂逅你的彩票梦想！";
        [UMSocialData defaultData].extConfig.qzoneData.shareImage =  dp_AccountImage(@"Icon.png");
        [UMSocialData defaultData].extConfig.qqData.shareImage =  dp_AccountImage(@"Icon.png");
        //sina
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@%@", @"抓住随时随地的幸运，邂逅你的彩票梦想！",@"http://m.dacai.com/activity/selectuseragent"];
        [UMSocialData defaultData].extConfig.sinaData.shareImage =  dp_AccountImage(@"Icon.png");
        [UMSocialData defaultData].extConfig.title = @"大彩APP口袋里的投注站";
        
        [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:dp_UM_appID
                                          shareText: @"抓住随时随地的幸运，邂逅你的彩票梦想！"
                                         shareImage: dp_AccountImage(@"Icon.png")
                                    shareToSnsNames:@[UMShareToWechatTimeline, UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToSina]
                                           delegate:self];
        return;
    }
}
//分享回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [[DPToast makeText:@"分享成功"] show];
    }else{
        [[DPToast makeText:@"分享失败"] show];
    }
    
}
#pragma mark---------exitBtn
//退出当前账户
- (UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn.backgroundColor = UIColorFromRGB(0xd14d49);
        _exitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_exitBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
         [_exitBtn setTitle:@"退出当前账户" forState:UIControlStateNormal];
        _exitBtn.hidden = ![DPMemberManager sharedInstance].isLogin;
        [_exitBtn addTarget:self action:@selector(exitBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}
- (void)exitBtnTapped{
    
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要退出当前登录帐号吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alter.rac_buttonClickedSignal subscribeNext:^(id x) {
        if ([x integerValue] == 1) {
            //    // iOS8 下崩溃， 在tabBarConroller中处理
            //    [self.navigationController popViewControllerAnimated:NO];
            [[DPMemberManager sharedInstance] logout];
            [UMComLoginManager userLogout];
            UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
            [tabbar setSelectedViewController:tabbar.viewControllers.firstObject];
        }
    }];
    [alter show];


}

@end
