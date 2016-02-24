//
//  DPPayRedPacketViewController.m
//  Jackpot
//
//  Created by sxf on 15/8/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPAnalyticsKit.h"
#import "DPCollapseTableView.h"
#import "DPImageLabel.h"
#import "DPLotteryBetInfoViewController.h"
#import "DPPayRedPacketCell.h"
#import "DPPayRedPacketViewController.h"
#import "DPPaytoBuySuccessViewController.h"

#import "DPAlterViewController.h"
#import "DPLosePayPassWordViewController.h"
#import "DPMemberManager+Private.h"
#import "DPProjectDetailViewController.h"
#import "DPTChaseNumberCenterInfoViewController.h"
#import "Order.pbobjc.h"
#import "Wages.pbobjc.h"
#import <AlipaySDK/AlipaySDK.h>
@interface DPPayRedPacketViewController () <UITableViewDelegate,
    UITableViewDataSource,
    DPPayChargeCellDelegate> {
    DPCollapseTableView* _tableView;
    BOOL _isEnoughMoney; //是否有充足的钱
    BOOL _isRedPacket; //是否有红包
    UIButton *_sureButton;
    NSInteger _selectedChargeType;//选择充值方式
//    UITextField *_payPassWord;//支付密码
}
@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) UIButton *sureButton;
@property (nonatomic, assign) float redPacket;
@property (nonatomic, assign) NSInteger redPacketId;//选中的红包id（支付用）
@property (nonatomic, copy) NSString *payMoney; //待支付金额
@property (nonatomic, copy) NSString *drawTime; //开奖时间
//@property (nonatomic, strong, readonly) UITextField *payPassWord; //支付密码
@property (nonatomic, strong) UIView *HeartLoveHeader; //心水支付头部
@end

@implementation DPPayRedPacketViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedChargeType = 0;
    self.redPacket = 0.0;
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    //是否有充足的钱
    if ([[self pvt_profitMoney] floatValue] == 0) {
        _isEnoughMoney = YES;
    }
    else {
        _isEnoughMoney = NO;
    }
    //用户是否有红包
    _isRedPacket = self.dataBase.redPacketArray.count > 0 ? YES : NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];

    //顶部
    UIView* tableHeaderView = [UIView dp_viewWithColor:[UIColor clearColor]];
    tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, self.isChase ? 17 : 70);
    if (!self.isChase)//当前不是追号方案
    {
        UIImageView* titleImageView = [[UIImageView alloc] init];
        titleImageView.backgroundColor = [UIColor clearColor];
        titleImageView.image = dp_AccountImage(@"newreminder.png");
        [tableHeaderView addSubview:titleImageView];
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont dp_systemFontOfSize:12.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = UIColorFromRGB(0xfa9796);
        titleLabel.numberOfLines = 2;
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:@"根据国家彩票管理条例细则，您的投注内容可能会被拆分合并成若干张票进行投递。"];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5]; //调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
        titleLabel.attributedText = attributedString;
        [tableHeaderView addSubview:titleLabel];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(tableHeaderView).offset(15);
            make.width.equalTo(@16);
            make.centerY.equalTo(tableHeaderView);
            make.height.equalTo(@16);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(titleImageView.mas_right).offset(5);
            make.width.equalTo(@(kScreenWidth - 61));
            make.centerY.equalTo(tableHeaderView);
            make.height.equalTo(@40);
        }];

        UIButton* homebutton = [[UIButton alloc] init];
        homebutton.backgroundColor = [UIColor clearColor];
        [homebutton setTitle:@"查看详情> >" forState:UIControlStateNormal];
        [homebutton setTitleColor:UIColorFromRGB(0x0069cc) forState:UIControlStateNormal];
        homebutton.titleLabel.font = [UIFont dp_systemFontOfSize:12];
        [homebutton addTarget:self action:@selector(pvt_orderInfo) forControlEvents:UIControlEventTouchUpInside];
        [tableHeaderView addSubview:homebutton];
        [homebutton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(tableHeaderView).offset(-15);
            make.width.equalTo(@70);
            make.height.equalTo(@16);
            make.bottom.equalTo(titleLabel).offset(-3);
        }];
    }
    UIView* lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
    [tableHeaderView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(tableHeaderView);
        make.right.equalTo(tableHeaderView);
        make.bottom.equalTo(tableHeaderView);
        make.height.equalTo(@0.5);
    }];
    if (self.orderType == HeartLoveOrderType) {
        self.tableView.tableHeaderView = self.HeartLoveHeader;
    }else{
        self.tableView.tableHeaderView = tableHeaderView;
    }

    //底部
    UIView* tableviewFootView = [UIView dp_viewWithColor:[UIColor clearColor]];
    tableviewFootView.frame = CGRectMake(0, 0, kScreenWidth, 55); //+40

    //下一步
    UIButton* nextButton = [[UIButton alloc] init];
    nextButton.backgroundColor = [UIColor clearColor];
    [nextButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    nextButton.layer.cornerRadius = 5;
    [nextButton addTarget:self action:@selector(pvt_pay) forControlEvents:UIControlEventTouchUpInside];
    [tableviewFootView addSubview:nextButton];

    [nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(tableviewFootView);
        make.width.equalTo(@(kScreenWidth - 20));
        make.top.equalTo(tableviewFootView).offset(12);
        make.height.equalTo(@40);
    }];
    UIView* lineView2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
    [tableviewFootView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(tableviewFootView);
        make.right.equalTo(tableviewFootView);
        make.top.equalTo(tableviewFootView);
        make.height.equalTo(@0.5);
    }];
    self.tableView.tableFooterView = tableviewFootView;

    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    self.sureButton.hidden = _isEnoughMoney;
    self.tableView.tableFooterView.hidden = !_isEnoughMoney;

    self.title = @"订单确认";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //删除键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//返回到某个页面
- (void)pvt_onBack
{
    if (!self.isCreateOrder)//当前不是从需要创建订单页面进入，则直接返回上个页面
    {
        if (self.navigationController.viewControllers.firstObject == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    };
    //如果从创建订单页面进入，返回时则有弹框提示
    DPAlterViewController* alterView = [[DPAlterViewController alloc] initWithAlterType:AlterTypeBackForNoPay];
    alterView.fullBtnTapped = ^(UIButton* btn) {
        if (self.navigationController.viewControllers.firstObject == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            for (UIViewController* vc in self.navigationController.viewControllers) {
                if ([NSStringFromClass([vc class]) isEqualToString:@"DPBuyTicketRecordViewController"]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            for (UIViewController* vc in self.navigationController.viewControllers) {
                if ([NSStringFromClass([vc class]) isEqualToString:@"DPChaseNumberCenterViewController"]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    @weakify(self);
    alterView.sevice = ^(UIButton* btn) {
        @strongify(self);
        if (self.isChase) {
            DPTChaseNumberCenterInfoViewController* vc = [[DPTChaseNumberCenterInfoViewController alloc] init];
            vc.projectId = self.dataBase.orderId;
            vc.gameType = self.gameType;
            NSMutableArray* tempArray = self.navigationController.viewControllers.mutableCopy;
            [tempArray replaceObjectAtIndex:tempArray.count - 1 withObject:vc];
            [self.navigationController setViewControllers:tempArray animated:YES];
        }
        else {
            DPProjectDetailViewController* vc = [[DPProjectDetailViewController alloc] init];
            vc.projectId = self.dataBase.orderId;
            vc.gameType = self.gameType;
            NSMutableArray* tempArray = self.navigationController.viewControllers.mutableCopy;
            [tempArray replaceObjectAtIndex:tempArray.count - 1 withObject:vc];
            [self.navigationController setViewControllers:tempArray animated:YES];
        }

    };
    [self dp_showViewController:alterView animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}
//去拆票详情
- (void)pvt_orderInfo
{
    DPLotteryBetInfoViewController* vc = [[DPLotteryBetInfoViewController alloc] init];
    vc.gameType = self.gameType;
    vc.projectId = self.dataBase.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}
//去支付
- (void)pvt_pay
{

    DPAlterViewController* controller = [[DPAlterViewController alloc] initWithAlterType:AlterTypePayPassowrd];
    controller.passwordBlock = ^(NSString* password) {
        if (password.length <= 0) {
            [[DPToast makeText:@"请输入大彩支付密码"] show];
            return;
        }

        PBMPay* payItem = [[PBMPay alloc] init];
        payItem.orderId = self.dataBase.orderId;
        payItem.redPkgId = self.redPacketId;
        payItem.payPassword = password;
        payItem.nightPay = NO;
        payItem.gameId=self.gameId;
        payItem.gameName=self.gameName;
        payItem.gameTypeId = self.gameType;
        [self goToPay:payItem];

    };
    //忘记密码
    controller.forgetPassword = ^(NSString* password) {
        DPLosePayPassWordViewController* vc = [[DPLosePayPassWordViewController alloc] init];
        vc.isFromPay = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}

/**
 *  支付错误信息的处理(主要处理夜间不出票和过期截止的问题)
 *
 *  @param result     // 支付成功接口返回
 *  @param error      //错误信息
 *  @param passWord   //支付密码
 *  @param payIndex   //0 普通下单  1支付宝 2.银联
 *
 *  @return
 */
- (void)errorInfoToAgainPay:(PBMPayResult*)result
                      error:(NSError*)error
                   passWord:(NSString*)passWord
                   payIndex:(NSInteger)payIndex

{
   
    if (self.gameType == GameTypeDlt)//大乐透
    {
        if (error.dp_errorCode == -15)//当前期截止
        {
            DPAlterViewController* controller = [[DPAlterViewController alloc] initWithAlterType:AlterTypeDLTNumStop];
            @weakify(self);
            controller.confirmBlock = ^(UIButton* btn) {
                @strongify(self);
                //复制订单加支付接口 请求
                PBMCopyOrderAndPay* payCopeItem = [[PBMCopyOrderAndPay alloc] init];
                payCopeItem.projectId = result.projectId;
                payCopeItem.gameId = result.gameIdNew;// 新期主键id
                payCopeItem.gameTypeId = self.gameType;
                payCopeItem.password = passWord;
                self.gameName=result.gameNameNew;// 新期号
                [self showHUD];
                //重新创建订单
                [[AFHTTPSessionManager dp_sharedManager] POST:@"/service/CopyProject"
                    parameters:payCopeItem
                    success:^(NSURLSessionDataTask* task, id responseObject) {
                        [self dismissHUD];
                        PBMPayResult* payResult = [PBMPayResult parseFromData:responseObject error:nil];
                       
                        if (payIndex == 0)//钱够
                        {
 
                            PBMPay* payItem = [[PBMPay alloc] init];
                            payItem.orderId = payResult.projectId;
                            payItem.redPkgId = self.redPacketId;
                            payItem.payPassword = passWord;
                            payItem.nightPay = NO;
                            payItem.gameName=self.gameName;
                            payItem.gameTypeId = self.gameType;
                            [self goToPay:payItem];
                        }
                        else //钱不够
                        {
                            PBMPayParams* payItem = [[PBMPayParams alloc] init];
                            payItem.sourceId = payResult.projectId;
                            payItem.payPassword = passWord;
                            payItem.amt = self.payMoney;
                            payItem.sourceType = 1;
                            payItem.nightPay = NO;
                            [self goToPayForNoPay:payItem index:payIndex - 1];
                        }

                    }
                    failure:^(NSURLSessionDataTask* task, NSError* error) {
                        [self dismissHUD];
                        [[DPToast makeText:error.dp_errorMessage] show];
                        [self.tableView reloadData];
                    }];
            };

            controller.cancelBlock = ^(UIButton* btn) {

            };

            [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
            controller.contentLabel.text = [NSString stringWithFormat:@"%@期已经截止，当前期为%@期，预计开奖时间：%@ \n是否确认购买下一期%@期吗？", self.gameName, result.gameNameNew, [NSDate dp_coverDateString:result.drawDate fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_MM_dd_HH_mm], result.gameNameNew];
            return;
        }
    }
   //竞彩
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {

        if (error.dp_errorCode == -1002)//夜间不出票
        {
            DPAlterViewController* controller = [[DPAlterViewController alloc] initWithAlterType:AlterTypeJcUnGetBuy];
            controller.confirmBlock = ^(UIButton* btn) {
                if (payIndex == 0) {
                    PBMPay* payItem = [[PBMPay alloc] init];
                    payItem.orderId = self.dataBase.orderId;
                    payItem.redPkgId = self.redPacketId;
                    payItem.payPassword = passWord;
                    payItem.nightPay = YES;
                    payItem.gameId=self.gameId;
                    payItem.gameTypeId = self.gameType;
                    [self goToPay:payItem];
                }
                else {
                    PBMPayParams* payItem = [[PBMPayParams alloc] init];
                    payItem.sourceId = self.dataBase.orderId;
                    payItem.payPassword = passWord;
                    payItem.amt = self.payMoney;
                    payItem.sourceType = 1;
                    payItem.nightPay = YES;
                    [self goToPayForNoPay:payItem index:payIndex - 1];
                }

            };

            [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
            return;
        }
    }
}

//钱够的情况下去支付->网络请求
- (void)goToPay:(PBMPay*)payItem
{
    if (self.orderType == HeartLoveOrderType) {
        [self HeartLoveGoToPayWithPassword:payItem.payPassword];
        return;
    }
    
    [self showHUD];
    //isChase 1:追号  0:不追号
    [[AFHTTPSessionManager dp_sharedManager] POST:self.isChase ? @"/service/ActiveFollowProject" : @"/service/ActiveProject"
        parameters:payItem
        success:^(NSURLSessionDataTask* task, id responseObject) {
            [self dismissHUD];
            PBMPayResult* result = [PBMPayResult parseFromData:responseObject error:nil];
            NSString* ulrString = [NSString stringWithFormat:@"%@/Web/Service/Pay?buyToken=%@&gameTypeId=%d&userSession=%@&redPkgId=%d&type=%d", [AFHTTPSessionManager dp_sharedManager].baseURL, result.token, self.gameType, [DPMemberManager sharedInstance].sessionToken, (int)self.redPacketId, self.isChase ? 1 : 0];
            if (ulrString.length < 1) {
                [[DPToast makeText:@"返回网址为空"] show];
                return;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ulrString]];
            //移除当前视图，返回的时候，则返回到前视图
            [self.navigationController popViewControllerAnimated:NO];
        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            if (!self.isChase) {
                PBMPayResult* result = [PBMPayResult parseFromData:error.dp_errorProtobuf error:nil];
                //竞彩夜间不出票和数字彩期号截止单独处理
                if ((error.dp_errorCode == -1002) || (error.dp_errorCode == -15)) {
                    [self errorInfoToAgainPay:result error:error passWord:payItem.payPassword payIndex:0];
                    return;
                }
            }
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}

//钱不够的时候去支付->网络请求
- (void)goToPayForNoPay:(PBMPayParams*)payItem index:(NSInteger)index
{
    switch (index) {
    case 0: {
        [self showHUD];
        [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/Topup"
            parameters:payItem
            success:^(NSURLSessionDataTask* task, id responseObject) {
                [self dismissHUD];
                if (self.orderType == HeartLoveOrderType) {
                    if (self.buyWagesSuccess) {
                        self.buyWagesSuccess();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                
                PBMPayParamsResult* alipay = [PBMPayParamsResult parseFromData:responseObject error:nil];
                self.drawTime = alipay.drawTime;
                //                                                         [[AlipaySDK defaultService] payOrder:alipay.params fromScheme:@"2014032100004368" callback:^(NSDictionary *resultDic) {
                //                                                         }];
                //由于支付宝没有接进来，因此直接处理成成功 sxf
                DPPaytoBuySuccessViewController* vc = [[DPPaytoBuySuccessViewController alloc] init];
                vc.drawTime = self.drawTime;
                vc.gameType = self.gameType;
                vc.isChase = self.isChase;
                vc.projectId = (long long)payItem.sourceId;
                NSMutableArray* viewControllers = self.navigationController.viewControllers.mutableCopy;
                [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:vc];
                [self.navigationController setViewControllers:viewControllers animated:YES];
            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                if (!self.isChase) {
                    PBMPayResult* result = [PBMPayResult parseFromData:error.dp_errorProtobuf error:nil];
                    //夜间不出票or期号截止，单独处理
                    if ((error.dp_errorCode == -1002) || (error.dp_errorCode == -15)) {
                        [self errorInfoToAgainPay:result error:error passWord:payItem.payPassword payIndex:_selectedChargeType + 1];
                        return;
                    }
                }
                [[DPToast makeText:error.dp_errorMessage] show];
            }];

    } break;
    case 1:

        break;
    case 2:

        break;

    default:
        break;
    }
}
//钱不够的时候，用第三方支付
- (void)pvt_noPay
{
    DPAlterViewController* controller = [[DPAlterViewController alloc] initWithAlterType:AlterTypePayPassowrd];
    controller.passwordBlock = ^(NSString* password) {
        if (password.length <= 0) {
            [[DPToast makeText:@"请输入大彩支付密码"] show];
            return;
        }

        
        
        PBMPayParams* item = [[PBMPayParams alloc] init];
        item.sourceId = self.dataBase.orderId;
        item.payPassword = password;
        item.amt = self.payMoney;
        item.nightPay = NO;
        item.sourceType = self.orderType == HeartLoveOrderType?3:(self.isChase ? 2 : 1);
        [self goToPayForNoPay:item index:_selectedChargeType];
        //        switch (_selectedChargeType) {
        //            case 0:    //支付宝钱包
        //            {
        //                [self showHUD];
        //                [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/Topup"
        //                    parameters:item
        //                    success:^(NSURLSessionDataTask *task, id responseObject) {
        //                        [self dismissHUD];
        //                        PBMPayParamsResult *alipay = [PBMPayParamsResult parseFromData:responseObject error:nil];
        //                        self.drawTime = alipay.drawTime;
        //                        //                                                         [[AlipaySDK defaultService] payOrder:alipay.params fromScheme:@"2014032100004368" callback:^(NSDictionary *resultDic) {
        //                        //                                                         }];
        //                        DPPaytoBuySuccessViewController *vc = [[DPPaytoBuySuccessViewController alloc] init];
        //                        vc.drawTime = self.drawTime;
        //                        vc.gameType = self.gameType;
        //                        vc.isChase = self.isChase;
        //                        vc.projectId = (long long)item.sourceId;
        //                        NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
        //                        [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:vc];
        //                        [self.navigationController setViewControllers:viewControllers animated:YES];
        //                    }
        //                    failure:^(NSURLSessionDataTask *task, NSError *error) {
        //                        [self dismissHUD];
        //                        if (!self.isChase) {
        //                            PBMPayResult *result = [PBMPayResult parseFromData:error.dp_errorProtobuf error:nil];
        //                            if ((error.dp_errorCode == -1002) || (error.dp_errorCode == -15)) {
        //                                [self errorInfoToAgainPay:result error:error passWord:password payIndex:_selectedChargeType + 1];
        //                                return;
        //                            }
        //                        }
        //                        [[DPToast makeText:error.dp_errorMessage] show];
        //                    }];
        //                //                NSString *content;
        //                //                NSString *sign;
        //                //                NSString * appScheme = @"hzdacai";
        //                //
        //                //                NSString * orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
        //                //                                          content,  sign, @"RSA"];
        //                //
        //                //                dispatch_async(dispatch_get_main_queue(), ^{
        //                //                    __weak __typeof(self) weakSelf = self;
        //                //                    [[AlipaySDK defaultService]payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        //                //                        int result = [resultDic[@"resultStatus"] intValue];
        //                //                        if (result==9000) {
        //                //                            //                        [DPAnalyticsKit logKeyValueEvent:logTopupID props:@{@"金额": weakSelf.moneyTextField.text, @"方式": @"支付宝充值"}];
        //                //                            //                        [weakSelf dp_saveRechargeTypeWithType:kRechargeTypeAlipay];
        //                //                            //                        DPRechargeSuccessVC *vc=[[DPRechargeSuccessVC alloc] init];
        //                //                            //                        [weakSelf.navigationController pushViewController:vc animated:YES];
        //                //                            return;
        //                //                        }
        //                //                        if (result!=6001){
        //                //                            [[DPToast makeText:[resultDic objectForKey:@"memo"]]show];
        //                //                        }
        //                //                    }];
        //                //                });
        //            } break;
        //            case 1:    //银行卡快捷支付
        //            {
        //                //                NSString *token;
        //                //                NSError *error;
        //                //                id obj = [NSJSONSerialization JSONObjectWithData:[token dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        //                //                [self.sdk presentPaySdkInViewController:self withTraderInfo:obj];
        //            } break;
        //            case 2:    //银联卡在线支付
        //            {
        //            } break;
        //
        //            default:
        //                break;
        //        }

    };
    controller.forgetPassword = ^(NSString* password) {
        DPLosePayPassWordViewController* vc = [[DPLosePayPassWordViewController alloc] init];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    };
    [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}
#pragma mark---------心水
- (UIView *)HeartLoveHeader{
    if (!_HeartLoveHeader) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UILabel *headerLab = [UILabel dp_labelWithText:[NSString stringWithFormat:@"购买 %@ 发起的心水",self.wagesUserName] backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15]];
        [headerView addSubview:headerLab];
        [headerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-8);
            make.left.mas_equalTo(16);
        }];
        
        _HeartLoveHeader = headerView;
    }
    return _HeartLoveHeader;
}
- (void)HeartLoveGoToPayWithPassword:(NSString *)password{
//    if (self.projectMoney >[self.dataBase.accountAmt integerValue]) {
//        self goToPayForNoPay:<#(PBMPayParams *)#> index:<#(NSInteger)#>
//        return;
//    }
    
    PayWagesInput *param = [[PayWagesInput alloc]init];
    param.wagesId = self.dataBase.orderId;
    param.password = password;
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/PayWages" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        if (self.buyWagesSuccess) {
            self.buyWagesSuccess();
        }
        [self dismissHUD];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]]show];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(DPCollapseTableView*)tableView
{
    return _isEnoughMoney ? 1 : 2; //钱是否够 钱不够的情况下，显示第三方支付的分区
}

- (NSInteger)tableView:(DPCollapseTableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    //钱够
    if (_isEnoughMoney) {
        return _isRedPacket ? 4 : 3;
    }
    //钱不够
    if (section == 0) {
        return _isRedPacket ? 5 : 4;
    }
    //第二区，充值方式
    return 3;
}

- (UITableViewCell*)tableView:(DPCollapseTableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //彩种信息和期号信息
            static NSString* CellIdentifier = @"LotteryInfoTableViewCell";
            DPPayLotteryTitleCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DPPayLotteryTitleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.gameType == GameTypeDlt) {
                cell.iconView.image = dp_AppRootImage(@"dlt.png");
                cell.titleLabel.text = @"大乐透";
                if (self.isChase) {
                    cell.issueLabel.text = [NSString stringWithFormat:@"共追%ld期", self.totalIssue];
                }
                else {
                    cell.issueLabel.text = [NSString stringWithFormat:@"%@期", self.gameName];
                }

                return cell;
            }
            if (IsGameTypeJc(self.gameType)) {
                cell.iconView.image = dp_AppRootImage(@"jczq.png");
                cell.titleLabel.text = @"竞彩足球";
                return cell;
            }
            if (IsGameTypeLc(self.gameType)) {
                cell.iconView.image = dp_AppRootImage(@"jclq.png");
                cell.titleLabel.text = @"竞彩篮球";
                return cell;
            }
            
            return cell;
        }
        //使用红包
        if (_isRedPacket && indexPath.row == 2) {
            static NSString* CellIdentifier = @"RedPacketTableViewCell";
            DPPayRedPacketCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DPPayRedPacketCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f", self.redPacket];
            return cell;
        }
        //钱不够的情况下，还需要支付多少元
        if ((!_isEnoughMoney) && (indexPath.row == (_isRedPacket ? 4 : 3))) {
            static NSString* CellIdentifier = @"NopayTableViewCell";
            NoPayInfocell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[NoPayInfocell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            self.payMoney = [self pvt_profitMoney];
            NSMutableAttributedString* hinstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"还需要支付%@元", self.payMoney]];
            NSRange numberRange11 = [[NSString stringWithFormat:@"%@", hinstring] rangeOfString:self.payMoney options:NSCaseInsensitiveSearch];
            [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4b4b4b) range:NSMakeRange(0, hinstring.length)];
            [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xd80600) range:numberRange11];
            cell.payMoney.attributedText = hinstring;
            if ([[self pvt_profitMoney] floatValue] > [[self pvt_profitMoney] integerValue]) {
                cell.payIntrouceLabel.hidden = NO;
            }
            else {
                cell.payIntrouceLabel.hidden = YES;
            }
            return cell;
        }
        //方案金额，账户余额共用一个
        static NSString* CellIdentifier = @"PayNormalTableViewCell";
        DPPayNormalCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPPayNormalCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 1) {
            cell.normalTitleLabel.text = @"方案金额";
            cell.moneyLabel.text = [NSString stringWithFormat:@"%d", self.projectMoney];
            cell.line.hidden = _isRedPacket;
        }
        else {
            cell.normalTitleLabel.text = @"账户余额";
            cell.moneyLabel.text = [NSString stringWithFormat:@"%@", self.dataBase.accountAmt.length > 0 ? self.dataBase.accountAmt : @"0"];
            cell.line.hidden = _isEnoughMoney;
        }

        return cell;
    }
    //充值方式
    static NSString* CellIdentifier = @"chargeTableViewCell";
    DPChargePayForCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPChargePayForCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray* titleArray = [NSArray arrayWithObjects:@"支付宝钱包", @"银行卡快捷支付", @"银联卡在线支付", nil];
    NSArray* infoArray = [NSArray arrayWithObjects:@"支持支付宝余额和银行卡充值", @"支持银行卡快捷支付", @"无需开通网银", nil];
    NSArray* imageArray = [NSArray arrayWithObjects:dp_RedPacketImage(@"aliPay.png"), dp_RedPacketImage(@"bank.png"), dp_RedPacketImage(@"yinlian.png"), nil];
    [cell iconImageViewImage:[imageArray objectAtIndex:indexPath.row]];
    [cell payTitleString:[titleArray objectAtIndex:indexPath.row]];
    [cell payInfoString:[infoArray objectAtIndex:indexPath.row]];
     //设置当前是否被选中
    [cell paySelectedView:NO];
    if (indexPath.row == _selectedChargeType) {
        [cell paySelectedView:YES];
    }
    else {
        [cell paySelectedView:NO];
    }
    return cell;
}
- (CGFloat)tableView:(DPCollapseTableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.orderType == HeartLoveOrderType) {
                return 0;
            }
            return 55;
        }
        if ((!_isEnoughMoney) && (indexPath.row == (_isRedPacket ? 4 : 3))) {
            if ([[self pvt_profitMoney] floatValue] > [[self pvt_profitMoney] integerValue]) {
                return 78;
            }
        }
        return 44;
    }
    return 75;
}
- (UITableViewCell*)tableView:(DPCollapseTableView*)tableView expandCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (!_isRedPacket) {
        return nil;
    }
    if (indexPath.row != 2) {
        return nil;
    }
    NSString* CellIdentifier = [NSString stringWithFormat:@"redPacketCell%d", 10];
    RedPacketInfocell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RedPacketInfocell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell bulidLayOut:self.dataBase.redPacketArray];
    }
    return cell;
}
- (CGFloat)tableView:(DPCollapseTableView*)tableView expandHeightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 2 && _isRedPacket) {
        return 120;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 50;
    }
    return 0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [UIView dp_viewWithColor:[UIColor clearColor]];
    if (section == 0) {
        return view;
    }
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"选择充值方式";
    label.textColor = UIColorFromRGB(0x7d7e7b);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:12.0];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view);
        make.top.equalTo(view).offset(20);
        make.height.equalTo(@20);
    }];
    UIView* lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    UIView* lineView2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
    [view addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.top.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    return view;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    if (_selectedChargeType == indexPath.row) {
        return;
    }

    DPChargePayForCell* cell1 = (DPChargePayForCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedChargeType inSection:1]];
    [cell1 paySelectedView:NO];
    DPChargePayForCell* cell2 = (DPChargePayForCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:1]];
    [cell2 paySelectedView:YES];
    _selectedChargeType = indexPath.row;
}
//支付订单还需要多少钱
- (NSString*)pvt_profitMoney
{
    NSDecimalNumber* needAmt = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", self.projectMoney]];
    NSDecimalNumber* redAmt = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", self.redPacket]];
    NSDecimalNumber* accountAmt = [NSDecimalNumber decimalNumberWithString:self.dataBase.accountAmt.length > 0 ? self.dataBase.accountAmt : @"0"];
    NSDecimalNumber* totalAmt = [accountAmt decimalNumberByAdding:redAmt];
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle]; // 类型
    [formatter setMaximumFractionDigits:2]; // 保留2位小数
    [formatter setMinimumFractionDigits:2]; // 保留2位小数
    [formatter setMinimumIntegerDigits:1]; // 整位保留1位
    [formatter setRoundingMode:NSNumberFormatterRoundFloor]; // 截取
    if (([needAmt compare:totalAmt] == NSOrderedAscending) || (([needAmt compare:totalAmt] == NSOrderedSame))) {
        return @"0.00";
    }
    NSDecimalNumber* finalAmt = [needAmt decimalNumberBySubtracting:totalAmt];
    return [formatter stringFromNumber:finalAmt];
}
//点击红包页面
- (void)clickRedpacketInfo:(DPPayRedPacketCell*)cell
{
    NSIndexPath* modelIndex = [self.tableView modelIndexForCell:cell];
    BOOL isexpande = [self.tableView isExpandAtModelIndex:modelIndex];
    [cell analysisViewIsExpand:[self.tableView isExpandAtModelIndex:modelIndex]];
    [self.tableView toggleCellAtModelIndex:modelIndex animation:YES];

    if (!isexpande) {
        NSIndexPath* indexpath = [self.tableView indexPathForCell:cell];
        NSArray* indexPathsForVisibleRows = [self.tableView indexPathsForVisibleRows];
        NSIndexPath* tempIndexPath = [indexPathsForVisibleRows objectAtIndex:indexPathsForVisibleRows.count - 1];
        if ((indexpath.section == tempIndexPath.section) && (indexpath.row == tempIndexPath.row)) {
            NSIndexPath* newIndexPath =[self.tableView tableIndexFromModelIndex:modelIndex expand:NO];
            [self.tableView
                scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section]
                      atScrollPosition:UITableViewScrollPositionMiddle
                              animated:YES];
        }
    }
}

//选择红包
- (void)selectedRedPacketIndex:(NSInteger)index
{
    PBMCreateOrderResult_RedPacket* redItem = [self.dataBase.redPacketArray objectAtIndex:index];
    self.redPacket = redItem.curAmt;
    if ([[self pvt_profitMoney] floatValue] > 0) {
        _isEnoughMoney = YES;
    }
    else {
        _isEnoughMoney = NO;
    }
    [self.tableView reloadData];
    self.redPacketId = redItem.id_p;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat sectionHeaderHeight = 50;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"通知名" object:nil userInfo:@{ @"传值key" : @"传值value" }];
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
- (void)keyboardWillChange:(NSNotification*)notification
{
    NSDictionary* userInfo = notification.userInfo;
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    if (screenHeight == keyboardY) {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
    else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 145, 0);
    }
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

#pragma mark - getter, setter
- (DPCollapseTableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[DPCollapseTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}
//确认支付
- (UIButton*)sureButton
{
    if (_sureButton == nil) {
        _sureButton = [[UIButton alloc] init];
        _sureButton.backgroundColor = [UIColor clearColor];
        [_sureButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        _sureButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        //        _sureButton.layer.cornerRadius=5;
        [_sureButton addTarget:self action:@selector(pvt_noPay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
//- (UITextField*)payPassWord
//{
//    if (_payPassWord == nil) {
//        _payPassWord = [[UITextField alloc] init];
//        _payPassWord.backgroundColor = [UIColor clearColor];
//        _payPassWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        _payPassWord.textColor = UIColorFromRGB(0x8e8e8e);
//        _payPassWord.textAlignment = NSTextAlignmentLeft;
//        _payPassWord.secureTextEntry = YES;
//        _payPassWord.font = [UIFont dp_systemFontOfSize:14];
//        _payPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _payPassWord.placeholder = @"请驶入支付密码";
//        _payPassWord.leftView = ({
//            UILabel* label = [[UILabel alloc] init];
//            label.backgroundColor = [UIColor clearColor];
//            label.text = @"支付密码:";
//            label.textAlignment = NSTextAlignmentLeft;
//            label.textColor = UIColorFromRGB(0x8e8e8e);
//            label.font = [UIFont systemFontOfSize:14.0];
//            label.frame = CGRectMake(10, 0, 80, 30);
//            label;
//
//        });
//        _payPassWord.leftViewMode = UITextFieldViewModeAlways;
//    }
//    return _payPassWord;
//}
#pragma mark - 支付宝客户端
- (void)alipayFinish:(NSNotification*)notify
{
    NSDictionary* resultDic = notify.userInfo;
    NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
    if (resultStatus == 9000) {
        DPPaytoBuySuccessViewController* vc = [[DPPaytoBuySuccessViewController alloc] init];
        vc.drawTime = self.drawTime;
        vc.gameType = self.gameType;
        vc.projectId = (int)self.dataBase.orderId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (resultStatus != 6001) {
        [[DPToast makeText:[resultDic objectForKey:@"memo"]] show];
    }
}

#pragma make - 连连支付

#pragma make - 银联支付
- (void)returnWithResult:(NSString*)strResult
{
}

@end
