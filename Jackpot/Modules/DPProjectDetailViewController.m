//
//  DPProjectDetailViewController.m
//  Jackpot
//
//  Created by sxf on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  方案详情

#import "DPCollapseTableView.h"
#import "DPDltBetData.h"
#import "DPJclqBuyViewController.h"
#import "DPJczqBuyViewController.h"
#import "DPLTDltViewController.h"
#import "DPLotteryBetInfoViewController.h"
#import "DPPayRedPacketViewController.h"
#import "DPProjectDetailCell.h"
#import "DPProjectDetailViewController.h"
#import "DPProjectDltWinView.h"
#import "DPShareRootViewController.h"
#import "DPThirdCallCenter.h"
#import "DPTicketViewController.h"
#import "LotteryHistory.pbobjc.h"
#import "NSAttributedString+DDHTML.h"
#import "Order.pbobjc.h"
#import "SVPullToRefresh.h"
#import "UMSocial.h"
#import "UMSocialSnsService.h"
#import "DPLogOnViewController.h"
@interface DPProjectDetailViewController () <
    UITableViewDelegate, UITableViewDataSource, UMSocialUIDelegate> {
@private
    DPCollapseTableView *_tableView;
    UILabel *_issueLabel;
    UILabel *_projectMoney;
    UILabel *_projectState;
    UILabel *_startTime;
    UILabel *_endTime;
    UILabel *_projectInfo;
    UILabel *_passType;
    UIButton *_gotobutton, *_selectedButton, *_payButton;
    UILabel *_winLabel;
    UILabel *_projectIdInfo;
    //    BOOL _isShow;
    //    NSIndexPath *_indexpath;
}
@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) UILabel *projectIdInfo;    //方案号
@property (nonatomic, strong, readonly) UILabel *issueLabel;       //期号
@property (nonatomic, strong, readonly) UILabel *projectMoney;     //方案金额
@property (nonatomic, strong, readonly) UILabel *projectState;     //方案状态
@property (nonatomic, strong, readonly) UILabel *startTime;        //发起时间
@property (nonatomic, strong, readonly) UILabel *endTime;          //截止时间
@property (nonatomic, strong, readonly) UILabel *projectInfo;      //方案内容
@property (nonatomic, strong, readonly) UILabel *passType;         //过关方式
@property (nonatomic, strong) NSMutableArray *winLabelArray;       //开奖号码
@property (nonatomic, strong, readonly) UILabel *winLabel;         //开奖状态
@property (nonatomic, strong, readonly) UIButton *gotobutton, *selectedButton, *payButton;    //复制投注   重新投注   立即支付
@property (nonatomic, strong) NSMutableArray *indexPathArray;//统计竞彩中方案内容是否展开

@property (nonatomic, strong) PlanDetailResult *dataBase;//方案详情数据
@end

@implementation DPProjectDetailViewController
@dynamic tableView;
@dynamic projectIdInfo;
@dynamic issueLabel;
@dynamic projectMoney;
@dynamic projectState;
@dynamic startTime;
@dynamic endTime;
@dynamic projectInfo;
@dynamic passType;
@dynamic winLabel;
@dynamic gotobutton;
@dynamic selectedButton;
@dynamic payButton;
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //由于方案详情是从不同界面进入的，所以根据传递过来的数据给猜中了可行和方案id赋值
    if (self.gameType <= 0 || self.lotteryItem) {
        self.gameType = self.lotteryItem.gameType;
    }
    if (self.projectId <= 0 || self.lotteryItem) {
        self.projectId = self.lotteryItem.projectId;
    }
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.winLabelArray = [[NSMutableArray alloc] init];
    self.indexPathArray = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 65, 0));
    }];
    //方案详情头部
    [self bulidLayOutForHeader];
    //方案详情底部
    [self bulidLayOutForBottom];
    self.navigationItem.rightBarButtonItem =
        [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png")
                                   target:self
                                   action:@selector(pvt_onShare)];

    // Do any additional setup after loading the view.
    __weak __typeof(self) weakSelf = self;
    //下拉刷新
    [self.tableView addPullToRefreshWithActionHandler:^{
        //请求数据
        [weakSelf reqeustInfoForProejectDetail];
    }];
    //直接请求方案详情数据
    [self reqeustInfoForProejectDetail];
}

//请求方案详情数据
- (void)reqeustInfoForProejectDetail {
    [self showHUD];
    self.title = @"方案详情";
     @weakify(self);
    //方案详情的网络数据
    //需要参数  projectid:方案id   gametypeid:彩种类型
    [[AFHTTPSessionManager dp_sharedManager] GET:@"/Project/detail"
                                      parameters:@{@"projectid" : @(self.projectId),@"gametypeid" : @(self.gameType)}
        success:^(NSURLSessionDataTask *task, id responseObject) {
              @strongify(self);
            [self dismissHUD];
            //停止下拉刷新
            [self.tableView.pullToRefreshView stopAnimating];
            //解析获取到的数据
            self.dataBase =[PlanDetailResult parseFromData:responseObject error:nil];
            //方案详情赋值
            [self gainAllDataForProejectDetail];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
              @strongify(self);
            [self dismissHUD];
            [self.tableView.pullToRefreshView stopAnimating];
            if (error.dp_errorCode==-1000)//登录超时或者未登录
            {
                //如果进入方案详情发现当前登录超时或者未登录，先进入登录页面，登录成功后返回来重新请求数据
                [self loginWithCallback:^{
                    [self reqeustInfoForProejectDetail];
                }];
                return ;
  
            }
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}
//未登录时进入登录页面
- (void)loginWithCallback:(void(^)(void))block {
    DPLogOnViewController *viewController = [[DPLogOnViewController alloc] init];
    viewController.finishBlock = block;
    //    [self.viewController.navigationController pushViewController:viewController animated:YES];
    [self presentViewController:[UINavigationController dp_controllerWithRootViewController:viewController] animated:YES completion:nil];
}
//分享
- (void)pvt_onShare {
    DPShareRootViewController *shareController =[[DPShareRootViewController alloc] init];
    shareController.object.shareTitle = self.dataBase.shareItem.shareTitle;
    shareController.object.shareContent = self.dataBase.shareItem.shareContent;
    shareController.object.shareUrl = self.dataBase.shareItem.shareURL;
    [self dp_showViewController:shareController
                   animatorType:DPTransitionAnimatorTypeAlert
                     completion:nil];
}

- (void)gainAllDataForProejectDetail {
    //初始化当前的状态（所有竞彩方案内容默认不展开）
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
        for (int i = 0; i < self.dataBase.jcItemArray.count; i++) {
            [self.indexPathArray addObject:[NSNumber numberWithBool:NO]];
        }
    }
    //判断底部的状态
    if (self.dataBase.payStatus == 1 && self.dataBase.projectStatus == 1) {
        [self.payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        self.payButton.hidden = NO;
        self.gotobutton.hidden = YES;
        self.selectedButton.hidden = YES;
    } else {
        if (self.gameType == GameTypeDlt) {
            self.payButton.hidden = YES;
            self.gotobutton.hidden = NO;
            self.selectedButton.hidden = NO;
        }
        if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
            [self.payButton setTitle:@"继续投注" forState:UIControlStateNormal];
            self.payButton.hidden = NO;
            self.gotobutton.hidden = YES;
            self.selectedButton.hidden = YES;
        }
    }
   //大乐透根据具体是否开奖采用不同的ui布局
    if (self.gameType == GameTypeDlt) {
        self.issueLabel.text =[NSString stringWithFormat:@"第%@期", self.dataBase.issue];
        if (self.dataBase.drawBluesArray.count +self.dataBase.drawRedsArray.count >=self.winLabelArray.count &&self.winLabelArray.count == 7) {
            self.winLabel.hidden = YES;
            //写入奖号
            for (int i = 0; i < self.winLabelArray.count; i++) {
                UILabel *label = [self.winLabelArray objectAtIndex:i];
                label.hidden = NO;
                if (i < 5 && (self.dataBase.drawRedsArray.count >= 5)) {
                    label.text = [NSString stringWithFormat:@"%@",[self.dataBase.drawRedsArray objectAtIndex:i]];
                } else if (i > 4 && self.dataBase.drawBluesArray.count >= 2) {
                    label.text = [NSString stringWithFormat:@"%@", [self.dataBase.drawBluesArray objectAtIndex:i - 5]];
                }
            }
        } else {
            //如果当前未开奖，则显示开奖时间
            self.winLabel.hidden = NO;
            self.winLabel.text = [NSString stringWithFormat:@"%@开奖",[NSDate dp_coverDateString:self.dataBase.drawTime
                                                                                      fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss
                                                                                        toFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm]];
            [self.winLabelArray enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
                obj.hidden = YES;
            }];
        }
    }
    //方案金额
    self.projectMoney.text =[NSString stringWithFormat:@"%d", self.dataBase.amount];
    //方案状态
    self.projectState.attributedText = [NSAttributedString attributedStringFromHTML:self.dataBase.projectStatusDesc];
    //开始时间
    self.startTime.text =[NSDate dp_coverDateString:self.dataBase.startTime
                                         fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss
                                           toFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm];
    //截止时间
    self.endTime.text =[NSDate dp_coverDateString:self.dataBase.endTime
                                       fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss
                                         toFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm];
    [self.tableView reloadData];
}

//方案详情顶部
- (void)bulidLayOutForHeader {
    UIView *headerView = [UIView dp_viewWithColor:[UIColor clearColor]];
    headerView.frame = CGRectMake(0, 0, kScreenWidth,(IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) ? 195 : 225);//竞彩和数字彩头部不同
    UIView *topView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [headerView addSubview:topView];
    UIView *bottomView = [UIView dp_viewWithColor:[UIColor clearColor]];
    [headerView addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView);
        make.right.equalTo(headerView);
        make.top.equalTo(headerView);
        make.height.equalTo(@55);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView);
        make.right.equalTo(headerView);
        make.bottom.equalTo(headerView);
        make.top.equalTo(topView.mas_bottom);
    }];
    UIView *line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcdcdc)];
    [topView addSubview:line1];
    UIView *line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcdcdc)];
    [bottomView addSubview:line2];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView);
        make.right.equalTo(topView);
        make.bottom.equalTo(topView);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);
        make.bottom.equalTo(bottomView);
        make.height.equalTo(@0.5);
    }];
    //彩种图标
    UIImageView *lotteryIcon = [[UIImageView alloc] init];
    lotteryIcon.backgroundColor = [UIColor clearColor];
    UILabel *lotteryTitle = [self createLabel:@""
                                    textColor:UIColorFromRGB(0x000000)
                                textAlignment:NSTextAlignmentLeft
                                         font:[UIFont systemFontOfSize:17.0]];
    lotteryTitle.adjustsFontSizeToFitWidth = YES;
    [topView addSubview:lotteryIcon];
    [topView addSubview:lotteryTitle];
    [topView addSubview:self.projectIdInfo];
    //彩种图标
    [lotteryIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.centerY.equalTo(topView);
    }];
    //彩种名称
    [lotteryTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lotteryIcon.mas_right).offset(10);
        make.height.equalTo(@20);
        make.centerY.equalTo(topView).offset(-8);
    }];
    //方案id
    [self.projectIdInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lotteryTitle);
        make.height.equalTo(@13);
        make.top.equalTo(lotteryTitle.mas_bottom).offset(4);
    }];
    if (self.projectId <= 0 || self.lotteryItem) {
        self.projectId = self.lotteryItem.projectId;
    }
    self.projectIdInfo.text =[NSString stringWithFormat:@"方案号：%lld", self.projectId];
    if (IsGameTypeJc(self.gameType)) {
        lotteryIcon.image = dp_AppRootImage(@"jczq.png");
        lotteryTitle.text = @"竞彩足球";
    } else if (IsGameTypeLc(self.gameType)) {
        lotteryIcon.image = dp_AppRootImage(@"jclq.png");
        lotteryTitle.text = @"竞彩篮球";
    } else if (self.gameType == GameTypeDlt) {
        lotteryIcon.image = dp_AppRootImage(@"dlt.png");
        lotteryTitle.text = @"大乐透";
        [topView addSubview:self.issueLabel];
        [self.issueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lotteryTitle.mas_right).offset(5);
            make.height.equalTo(@16);
            make.bottom.equalTo(lotteryTitle);
        }];
        //大乐透中奖介绍
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"如何算中奖？" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x1d68e4)
                     forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [button addTarget:self
                      action:@selector(winIntroduceClick)
            forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(topView).offset(-10);
            make.width.equalTo(@80);
            make.top.equalTo(self.issueLabel);
            make.bottom.equalTo(lotteryTitle);
        }];
    }
    
    UILabel *moneyLabel = [self createLabel:@"方案金额:"
                                  textColor:UIColorFromRGB(0x999999)
                              textAlignment:NSTextAlignmentLeft
                                       font:[UIFont systemFontOfSize:12.0]];
    UILabel *stateLabel = [self createLabel:@"方案状态:"
                                  textColor:UIColorFromRGB(0x999999)
                              textAlignment:NSTextAlignmentLeft
                                       font:[UIFont systemFontOfSize:12.0]];
    UILabel *startLabel = [self createLabel:@"发起时间:"
                                  textColor:UIColorFromRGB(0x999999)
                              textAlignment:NSTextAlignmentLeft
                                       font:[UIFont systemFontOfSize:12.0]];
    UILabel *endLabel = [self createLabel:@"截止时间:"
                                textColor:UIColorFromRGB(0x999999)
                            textAlignment:NSTextAlignmentLeft
                                     font:[UIFont systemFontOfSize:12.0]];
    UILabel *moneyUnit = [self createLabel:@"元"
                                 textColor:UIColorFromRGB(0x333333)
                             textAlignment:NSTextAlignmentLeft
                                      font:[UIFont systemFontOfSize:10.0]];
    moneyUnit.adjustsFontSizeToFitWidth = YES;
    moneyLabel.adjustsFontSizeToFitWidth = YES;
    stateLabel.adjustsFontSizeToFitWidth = YES;
    startLabel.adjustsFontSizeToFitWidth = YES;
    endLabel.adjustsFontSizeToFitWidth = YES;
    self.projectMoney.adjustsFontSizeToFitWidth = YES;
    self.projectState.adjustsFontSizeToFitWidth = YES;
    self.startTime.adjustsFontSizeToFitWidth = YES;
    self.endTime.adjustsFontSizeToFitWidth = YES;
    [bottomView addSubview:moneyLabel];
    [bottomView addSubview:stateLabel];
    [bottomView addSubview:startLabel];
    [bottomView addSubview:endLabel];
    [bottomView addSubview:moneyUnit];
    [bottomView addSubview:self.projectMoney];
    [bottomView addSubview:self.projectState];
    [bottomView addSubview:self.startTime];
    [bottomView addSubview:self.endTime];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(16);
        make.top.equalTo(bottomView).offset(16);
        make.height.equalTo(@25);
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(16);
        make.top.equalTo(moneyLabel.mas_bottom).offset(5);
        make.height.equalTo(@25);
    }];
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(16);
        make.top.equalTo(stateLabel.mas_bottom).offset(5);
        make.height.equalTo(@25);
    }];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(16);
        make.top.equalTo(startLabel.mas_bottom).offset(5);
        make.height.equalTo(@25);
    }];
    [self.projectMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLabel.mas_right).offset(5);
        make.top.equalTo(moneyLabel);
        make.bottom.equalTo(moneyLabel);
    }];
    [moneyUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.projectMoney.mas_right);
        make.centerY.equalTo(self.projectMoney).offset(0.5);
        make.height.equalTo(@20);
    }];
    [self.projectState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stateLabel.mas_right).offset(5);
        make.top.equalTo(stateLabel);
        make.bottom.equalTo(stateLabel);
    }];
    [self.startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startLabel.mas_right).offset(5);
        make.top.equalTo(startLabel);
        make.bottom.equalTo(startLabel);
    }];
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endLabel.mas_right).offset(5);
        make.top.equalTo(endLabel);
        make.bottom.equalTo(endLabel);
    }];
    //大乐透开奖号码
    if (self.gameType == GameTypeDlt) {
        UILabel *winTitleLabel = [self createLabel:@"开奖号码:"
                                         textColor:UIColorFromRGB(0x969696)
                                     textAlignment:NSTextAlignmentLeft
                                              font:[UIFont systemFontOfSize:12.0]];
        [bottomView addSubview:winTitleLabel];
        [winTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView).offset(15);
            make.top.equalTo(endLabel.mas_bottom).offset(5);
            make.height.equalTo(@25);
        }];
        for (int i = 0; i < 7; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"%02d", i + 1];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12.0];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 12.5;
            if (i < 5) {
                label.backgroundColor = UIColorFromRGB(0xd34b48);
            } else {
                label.backgroundColor = UIColorFromRGB(0x195ecd);
            }
            [self.winLabelArray addObject:label];
        }
        [self.winLabelArray
            enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
                [bottomView addSubview:obj];
            }];
        for (int i = 0; i < self.winLabelArray.count; i++) {
            UILabel *obj = self.winLabelArray[i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@25);
                make.centerY.equalTo(winTitleLabel);
                make.height.equalTo(@25);
                if (i == 0) {
                    make.left.equalTo(winTitleLabel.mas_right).offset(5);
                }
            }];
            if (i >= self.winLabelArray.count - 1) {
                continue;
            }

            UILabel *obj1 = self.winLabelArray[i];
            UILabel *obj2 = self.winLabelArray[i + 1];
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(5);
            }];
        }
        [bottomView addSubview:self.winLabel];
        [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.endTime);
            make.top.equalTo(winTitleLabel);
            make.bottom.equalTo(winTitleLabel);
        }];
        [self.winLabelArray enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
                obj.hidden = YES;
            }];
    }
    self.tableView.tableHeaderView = headerView;
}

//方案详情底部
- (void)bulidLayOutForBottom {
    UIView *bottomView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    UIView *lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    [bottomView addSubview:lineView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(5);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.height.equalTo(@1);
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);

    }];
    [bottomView addSubview:self.gotobutton];
    [bottomView addSubview:self.selectedButton];
    [bottomView addSubview:self.payButton];
    //继续投注
    [self.gotobutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.height.equalTo(@44);
        make.left.equalTo(bottomView).offset(16);
        make.right.equalTo(bottomView.mas_centerX).offset(-16);
    }];
    //重新选号
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.height.equalTo(@44);
        make.right.equalTo(bottomView).offset(-16);
        make.left.equalTo(bottomView.mas_centerX).offset(16);
    }];
    //立即支付
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.height.equalTo(@44);
        make.left.equalTo(bottomView).offset(16);
        make.right.equalTo(bottomView).offset(-16);
    }];
    //根据不同的彩种，底部显示不同
    if (self.gameType == GameTypeDlt) {
        self.payButton.hidden = YES;
        self.gotobutton.hidden = NO;
        self.selectedButton.hidden = NO;
    }
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
        [self.payButton setTitle:@"继续投注" forState:UIControlStateNormal];
        self.payButton.hidden = NO;
        self.gotobutton.hidden = YES;
        self.selectedButton.hidden = YES;
    }
}

//数字彩中奖介绍
- (void)winIntroduceClick {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIView *covvewView = [[UIView alloc] init];
    covvewView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    [self.navigationController.view addSubview:covvewView];

    [covvewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    //大乐透中奖说明
    DPProjectDltWinView *Intview = [[DPProjectDltWinView alloc] init];
    Intview.alpha = 1;
    Intview.backgroundColor = UIColorFromRGB(0xfaf9f2);
    [covvewView addSubview:Intview];

    [Intview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(covvewView).offset(25);
        make.right.equalTo(covvewView).offset(-25);
        make.height.equalTo(@(323));
        make.centerY.equalTo(covvewView.mas_centerY);
    }];

    [Intview setClickBlock:^(DPProjectDltWinView *cancelView) {
        [UIView animateWithDuration:0.2
            animations:^{
                [covvewView setAlpha:0];
            }
            completion:^(BOOL finished) {
                [covvewView removeFromSuperview];
            }];
    }];
}
//优化投注-获取优化投注内容
- (NSString *)OptimizeMatchInfoString:(NSArray *)matchItemArray {
    NSString *matchString = @"";
    for (int i = 0; i < matchItemArray.count; i++) {
        PlanDetailResult_OptimizeMatchItem *item = [matchItemArray objectAtIndex:i];
        NSString *nextString = [NSString stringWithFormat:@"[%@,%@]", item.orderNumberName, item.option];
        matchString = (i == 0) ? nextString: [NSString stringWithFormat:@"%@*%@", matchString,nextString];
    }
    return matchString;
}

#pragma UITableView
- (NSInteger)numberOfSectionsInTableView:(DPCollapseTableView *)tableView {
    //分区 0:投注内容  1:优化投注
    if (self.dataBase.optimizeItemArray.count > 0) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(DPCollapseTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return MAX(self.dataBase.optimizeItemArray.count, 0);
    }
    if (self.gameType == GameTypeDlt) {
        if (self.dataBase.isFilter) {
            return 1;
        }
        return MAX(self.dataBase.dltItemArray.count, 0);
    }
    return MAX(self.dataBase.jcItemArray.count, 0);
}

- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //过滤->如果当前是过滤方案，则需要给出单独页面提醒用户
    if (self.dataBase.isFilter) {
        static NSString *CellIdentifier = @"filterProjectCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"过滤详情请前往网页端查看";
            label.textColor = UIColorFromRGB(0xb5b5b5);
            label.font = [UIFont systemFontOfSize:11.0];
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];

            UIView *lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdcdcdc)];
            [cell.contentView addSubview:lineView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.height.equalTo(@0.5);
            }];
        }
        return cell;
    }
    //优化投注
    if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"OptimizeProjectCell";
        DPJcOptimizeProjectDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPJcOptimizeProjectDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //点击优化投注单元格
            [cell setClickBlock:^(DPJcOptimizeProjectDetailCell *optimizeCell) {
                NSIndexPath *modelIndex =[self.tableView modelIndexForCell:optimizeCell];
                //是否展开
                BOOL isexpande = [self.tableView isExpandAtModelIndex:modelIndex];
                //箭头方向
                [optimizeCell analysisViewIsExpand:[self.tableView isExpandAtModelIndex:modelIndex]];
                [self.tableView toggleCellAtModelIndex:modelIndex animation:YES];
                if (!isexpande) {
                    NSIndexPath *indexpath =[self.tableView indexPathForCell:optimizeCell];
                    NSArray *indexPathsForVisibleRows =[self.tableView indexPathsForVisibleRows];
                    NSIndexPath *tempIndexPath = [indexPathsForVisibleRows objectAtIndex:indexPathsForVisibleRows.count - 1];
                    if ((indexpath.section == tempIndexPath.section) &&(indexpath.row == tempIndexPath.row)) {
                        NSIndexPath *newIndexPath =[self.tableView tableIndexFromModelIndex:modelIndex expand:NO];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath
                                               indexPathForRow:newIndexPath.row
                                                     inSection:newIndexPath.section]
                                              atScrollPosition:UITableViewScrollPositionMiddle
                                                      animated:YES];
                    }
                }

            }];
        }
        //安全判断
        if (indexPath.row >= self.dataBase.optimizeItemArray.count) {
            return cell;
        }
        //获取优化投注信息
        PlanDetailResult_OptimizeItem *item =[self.dataBase.optimizeItemArray objectAtIndex:indexPath.row];
        [cell setOptimizeInfoLabelText:[NSString stringWithFormat:@"%@ %@", item.ggfs,[self OptimizeMatchInfoString:item.optimizeMatchItemArray]]];
        [cell setZhuLabelText:[NSString stringWithFormat:@"%lld", item.quantity]];
        [cell setBonusLabelText:item.bonus];
        return cell;
    }
    //大乐透投注详情
    if (self.gameType == GameTypeDlt) {
        static NSString *CellIdentifier = @"dltProjectCell";
        DPProjectDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell =[[DPProjectDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //获取大乐透投注数据
        PlanDetailResult_DltItem *item =[self.dataBase.dltItemArray objectAtIndex:indexPath.row];
        [cell titleLabelText:[NSString stringWithFormat:@"%@   %lld注",item.gameplayDesc,item.quantity]];
        if (item.dltDtResultsArray.count > 0)//判断当前是否胆拖
        {
            [cell infoLabelText:[self dltProjectInfo:item.dltDtResultsArray isDan:YES]];
        } else {
            [cell infoLabelText:[self dltProjectInfo:item.dltResultsArray isDan:NO]];
        }
        return cell;
    }
    //竞彩投注详情
    static NSString *CellIdentifier = @"jcProjectCell";
    DPJcProjectDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =[[DPJcProjectDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //投注详情赋值
    [self gainJCInfoForProjectCell:cell IndexPath:indexPath];
    return cell;
}
//获取竞彩方案详情
- (void)gainJCInfoForProjectCell:(DPJcProjectDetailCell *)cell  IndexPath:(NSIndexPath *)indexPath {
    PlanDetailResult_JcItem *jcItem =[self.dataBase.jcItemArray objectAtIndex:indexPath.row];
    [cell orderNumberText:jcItem.dataNum];
    //竞彩是否设胆
    cell.danImageView.hidden = !jcItem.isDan;
    if (IsGameTypeJc(self.gameType))//当前彩种是竞彩足球
    {
        if (jcItem.rqs == 0 || (![self showRqs:jcItem]))//当前没有让球
        {
            NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", jcItem.homeTeam]];
            [hinstring addAttribute:NSForegroundColorAttributeName
                              value:UIColorFromRGB(0x737373)
                              range:NSMakeRange(0, hinstring.length)];
            cell.leftNameLabel.attributedText = hinstring;
        } else  //当前有让球
        {
            NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:jcItem.rqs > 0?
                                                    [NSString stringWithFormat:@"%@(+%d)",jcItem.homeTeam,jcItem.rqs]
                                                  : [NSString stringWithFormat:@"%@(%d)",jcItem.homeTeam,jcItem.rqs]];
            [hinstring addAttribute:NSForegroundColorAttributeName
                              value:UIColorFromRGB(0x737373)
                              range:NSMakeRange(0, hinstring.length)];
            [hinstring addAttribute:NSForegroundColorAttributeName
                              value:jcItem.rqs > 0 ? UIColorFromRGB(0xd2332f): UIColorFromRGB(0x5783e7)
                              range:NSMakeRange(jcItem.homeTeam.length + 1,jcItem.rqs > 0? [NSString stringWithFormat:@"+%d", jcItem.rqs].length
                                                                                         : [NSString stringWithFormat:@"%d", jcItem.rqs].length)];
            cell.leftNameLabel.attributedText = hinstring;
        }
        cell.rightNameLabel.text = jcItem.awayTeam;
    } else if (IsGameTypeLc(self.gameType))//当前彩种是篮彩
    {
        if (jcItem.rqs == 0 || (![self showRqs:jcItem]))//当前没有让分
        {
            NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", jcItem.homeTeam]];
            [hinstring addAttribute:NSForegroundColorAttributeName
                              value:UIColorFromRGB(0x737373)
                              range:NSMakeRange(0, hinstring.length)];
            cell.rightNameLabel.attributedText = hinstring;
        } else {
            NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc]
                initWithString:jcItem.rqs > 0? [NSString stringWithFormat:@"%@(+%.1f)",jcItem.homeTeam,jcItem.rqs / 100000.0]
                                             : [NSString stringWithFormat:@"%@(%.1f)",jcItem.homeTeam,jcItem.rqs / 100000.0]];
            [hinstring addAttribute:NSForegroundColorAttributeName
                              value:UIColorFromRGB(0x737373)
                              range:NSMakeRange(0, hinstring.length)];
            [hinstring addAttribute:NSForegroundColorAttributeName
                              value:jcItem.rqs > 0 ? UIColorFromRGB(0xd2332f): UIColorFromRGB(0x5783e7)
                              range:NSMakeRange(jcItem.homeTeam.length + 1,jcItem.rqs > 0? [NSString stringWithFormat:@"+%.1f",jcItem.rqs /100000.0].length
                                                                                         : [NSString stringWithFormat:@"%.1f",jcItem.rqs /100000.0].length)];
            cell.rightNameLabel.attributedText = hinstring;
        }
        cell.leftNameLabel.text = jcItem.awayTeam;
    }
    //彩果赋值
    [cell resultText:jcItem.score];
    //选项
    cell.infoLabel.attributedText = [self jcProjectResultArray:jcItem.jcResultArray isCutOut:![[self.indexPathArray objectAtIndex:indexPath.row]boolValue]];
    CGFloat contentHeight =[NSString dpsizeWithSting:[[self jcProjectResultArray:jcItem.jcResultArray isCutOut:NO] string]
                                             andFont:[UIFont systemFontOfSize:12]
                                         andMaxWidth:kScreenWidth - 85].height;
    //判断选项是否一行可以显示完全，判断当前是否展开
    [cell imageSelectedView:(contentHeight > 20) ? YES : NO];
    //如果显示不全，则点击后更新展开状态
    [cell setClickBlock:^(DPJcProjectDetailCell *toggleCell, BOOL isShow) {
        [self.indexPathArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:isShow]];
        [self.tableView reloadData];
    }];
}
//遍历所有判断当前页面是否有让球
- (BOOL)showRqs:(PlanDetailResult_JcItem *)item {
    for (int i = 0; i < item.jcResultArray.count; i++) {
        PlanDetailResult_JcResult *jcResult = [item.jcResultArray objectAtIndex:i];
        if (jcResult.gameType == GameTypeJcRqspf ||
            jcResult.gameType == GameTypeLcRfsf) {
            return YES;
        }
    }
    return NO;
}

- (CGFloat)tableView:(DPCollapseTableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //当前行为过滤方案
    if (self.dataBase.isFilter) {
        return 33;
    }
    //当前行为优化投注
    if (indexPath.section == 1) {
        return 33;
    }
    //当前行为大乐透的投注内容
    if (self.gameType == GameTypeDlt) {
        NSMutableAttributedString *string =[[NSMutableAttributedString alloc] initWithString:@""];
        PlanDetailResult_DltItem *item =[self.dataBase.dltItemArray objectAtIndex:indexPath.row];
        if (item.dltDtResultsArray.count > 0)//当前大乐透投注内容为胆拖
        {
            string = [self dltProjectInfo:item.dltDtResultsArray isDan:YES];
        } else {
            string = [self dltProjectInfo:item.dltResultsArray isDan:NO];
        }
        [string addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:12.0]
                       range:NSMakeRange(0, [string length])];
        //自动获取当前string所占用的空间（高和宽）
        CGRect rect =[string boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 10000)
                                          options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                          context:nil];
        return 35 + rect.size.height;
    }
    //安全判断
    if (self.indexPathArray.count < indexPath.row ||self.indexPathArray.count == 0) {
        return 40 + 20;
    }
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
        PlanDetailResult_JcItem *jcItem =[self.dataBase.jcItemArray objectAtIndex:indexPath.row];
        if ([[self.indexPathArray objectAtIndex:indexPath.row] boolValue]) {
            //自动获取当前string所占用的空间（高和宽）
            CGRect rect =[[self jcProjectResultArray:jcItem.jcResultArray isCutOut:NO] boundingRectWithSize:CGSizeMake(kScreenWidth - 85, FLT_MAX)
                                                                                                    options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                                                                                    context:nil];
            return ceil(43 + rect.size.height);
        }
    }

    return 43 + 20;
}

- (CGFloat)tableView:(DPCollapseTableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 62;
    }
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
        if (self.dataBase.ggfs.length < 1) {
            return 90;
        }
        CGSize size =[NSString dpsizeWithSting:self.dataBase.ggfs andFont:[UIFont systemFontOfSize:14.0] andMaxSize:CGSizeMake(kScreenWidth - 82, FLT_MAX)];
        return ceil(size.height + 75);
    }
    return 42;
}

- (UIView *)tableView:(DPCollapseTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //优化投注section头
    if (section == 1) {
        static NSString *HeaderIdentifier = @"OptimizeHeader";
        DPOptimizeHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
        if (view == nil) {
            view = [[DPOptimizeHeaderView alloc] initWithReuseIdentifier:HeaderIdentifier];
            [view bulidLayOut];
        }
        return view;
    }
    //方案内容的头部
    static NSString *HeaderIdentifier = @"Header";
    DPProjectHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if (view == nil) {
        view =[[DPProjectHeaderView alloc] initWithReuseIdentifier:HeaderIdentifier];
        [view bulidLayOutGameType:self.gameType];
        [view addGestureRecognizer:({UITapGestureRecognizer *tapRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_ticket)];
                    tapRecognizer;
              })];
    }
    if (IsGameTypeLc(self.gameType) || IsGameTypeJc(self.gameType)) {
        [view projectInfoText:[NSString stringWithFormat:@"%lld注*%lld倍",self.dataBase.quantity,self.dataBase.multiple]];
        [view passLabelText:self.dataBase.ggfs];
    } else if (self.gameType == GameTypeDlt) {
        [view projectInfoText:[NSString stringWithFormat:@"%lld注*%lld倍",self.dataBase.quantity,self.dataBase.multiple]];
    }
     //是否显示部分出票
    [view isShowTicketImage:self.dataBase.ticketStatus == 5 ? YES : NO];
    if (self.dataBase.ticketStatus == 2) {
        view.ticketLabel.text = @"出票中";
    } else if (self.dataBase.ticketStatus == 3 ||
               self.dataBase.ticketStatus == 5) {
        view.ticketLabel.text = @"票样";
    } else {
        view.ticketLabel.text = @"订单拆票详情";
    }

    return view;
}
//展开cell高度
- (CGFloat)tableView:(DPCollapseTableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlanDetailResult_OptimizeItem *item =[self.dataBase.optimizeItemArray objectAtIndex:indexPath.row];
    return 10 + 27 * MAX(item.optimizeMatchItemArray.count + 1, 1);
}

//展开cell
- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlanDetailResult_OptimizeItem *item =[self.dataBase.optimizeItemArray objectAtIndex:indexPath.row];
    NSInteger count = item.optimizeMatchItemArray.count + 1;
    NSString *CellIdentifier =[NSString stringWithFormat:@"AnalysisCell%ld", count];
    DPJcOptimizeListProjectDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJcOptimizeListProjectDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //获取当前需要显示的行数并渲染
        [cell bulidOutForRowCount:count];
    }
    for (int i = 0; i < cell.viewArray.count; i++) {
        //安全判断
        if (i >= item.optimizeMatchItemArray.count) {
            return cell;
        }
        PlanDetailResult_OptimizeMatchItem *infoItem =[item.optimizeMatchItemArray objectAtIndex:i];
        DPJcOptimizeView *view = [cell.viewArray objectAtIndex:i];
        //场次
        view.screeningLabel.text = infoItem.orderNumberName;
        //主场
        view.homeNameLabel.text = infoItem.homeTeamName;
        //客场
        view.awayNameLabel.text = infoItem.awayTeamName;
        //选项
        view.optionLabel.text =[NSString stringWithFormat:@"(%@) %@", infoItem.option, infoItem.sp];
    }

    return cell;
}

//获取大乐透投注内容
- (NSMutableAttributedString *)dltProjectInfo:(NSArray *)array  isDan:(BOOL)isDan {
    NSMutableAttributedString *hinstring =[[NSMutableAttributedString alloc] initWithString:@""];
    NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0],NSFontAttributeName,UIColorFromRGB(0x6f6248),NSForegroundColorAttributeName, nil];
    NSDictionary *attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0],NSFontAttributeName,UIColorFromRGB(0xa6a6a6),NSForegroundColorAttributeName, nil];
    for (int i = 0; i < array.count; i++) {
        if (i > 0) {
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        }
        if (isDan) {
            PlanDetailResult_DltDTResult *danItem = [array objectAtIndex:i];
            NSMutableAttributedString *redDanString =
                [self dltPartInfoForProject:danItem.redDansArray
                                      isRed:YES
                                resultArray:self.dataBase.drawRedsArray];
            NSMutableAttributedString *redTuoString =
                [self dltPartInfoForProject:danItem.redTuosArray
                                      isRed:YES
                                resultArray:self.dataBase.drawRedsArray];
            NSMutableAttributedString *blueDanString =
                [self dltPartInfoForProject:danItem.blueDansArray
                                      isRed:NO
                                resultArray:self.dataBase.drawBluesArray];
            NSMutableAttributedString *blueTuoString =
                [self dltPartInfoForProject:danItem.blueTuosArray
                                      isRed:NO
                                resultArray:self.dataBase.drawBluesArray];
            [hinstring appendAttributedString:redDanString];
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  #  " attributes:attributeDict1]];
            [hinstring appendAttributedString:redTuoString];
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  |  " attributes:attributeDict2]];
            if (danItem.blueDansArray.count > 0) {
                [hinstring appendAttributedString:blueDanString];
                [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  #  " attributes:attributeDict1]];
            }
            [hinstring appendAttributedString:blueTuoString];
        } else {
            PlanDetailResult_DltResult *normalItem = [array objectAtIndex:i];
            NSMutableAttributedString *redString =
            [self dltPartInfoForProject:normalItem.redsArray
                                      isRed:YES
                                resultArray:self.dataBase.drawRedsArray];
            NSMutableAttributedString *blueString =
                [self dltPartInfoForProject:normalItem.bluesArray
                                      isRed:NO
                                resultArray:self.dataBase.drawBluesArray];
            [hinstring appendAttributedString:redString];
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  |  " attributes:attributeDict2]];
            [hinstring appendAttributedString:blueString];
        }
    }

    return hinstring;
}

//获取部分彩种的选中颜色
- (NSMutableAttributedString *)dltPartInfoForProject:(NSArray *)infoArray      //投注内容（分前后）
                                               isRed:(BOOL)isRed               //判断是否红球 YES:红前区  NO:后区
                                         resultArray:(NSArray *)resultArray    //奖号
{
    NSMutableAttributedString *tempString =[[NSMutableAttributedString alloc] initWithString:@""];
    for (int i = 0; i < infoArray.count; i++) {
        NSString *partString = [infoArray objectAtIndex:i];
        NSMutableAttributedString *singeString = [[NSMutableAttributedString alloc] initWithString:(i == 0)? [NSString stringWithFormat:@"%@", partString]
                                                                                                           : [NSString stringWithFormat:@"  %@", partString]];
        if ([resultArray containsObject:partString])
        {
            if (isRed)
            {
                [singeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xd2332f) range:NSMakeRange(0, singeString.length)];
            }
            else
            {
                [singeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0058c2) range:NSMakeRange(0, singeString.length)];
            }
        }
        else
        {
            [singeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x877e6d) range:NSMakeRange(0, singeString.length)];
        }
        [tempString appendAttributedString:singeString];
    }
    return tempString;
}

//获取竞彩信息详情（对于不展开完整显示选项的实现方式:遍历数组。然后依次组合，直到最大距离超过一行的距离的时候截止）
- (NSMutableAttributedString *)jcProjectResultArray:(NSArray *)jcResultArray
                                           isCutOut:(BOOL)isCutOut//当前是否展开  0:展开  1:不展开
{
    NSMutableAttributedString *hinstring =[[NSMutableAttributedString alloc] initWithString:@""];
    for (int i = 0; i < jcResultArray.count; i++) {
        PlanDetailResult_JcResult *item = [jcResultArray objectAtIndex:i];
        NSMutableAttributedString *tempstring = [[NSMutableAttributedString alloc] initWithString:i > 0 ? [NSString stringWithFormat:@"  %@", item.result]: item.result];
        [tempstring addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:12.0]
                           range:NSMakeRange(0, tempstring.length)];
        [tempstring addAttribute:NSForegroundColorAttributeName
                           value:item.isWin ? UIColorFromRGB(0xd2332f): UIColorFromRGB(0x333333)
                           range:NSMakeRange(0, tempstring.length)];
        [hinstring appendAttributedString:tempstring];
        if (isCutOut) {
            NSMutableAttributedString *cutDownString = [[NSMutableAttributedString alloc] initWithAttributedString:hinstring];
            if (i + 1 < jcResultArray.count) {
                PlanDetailResult_JcResult *tempItem =[jcResultArray objectAtIndex:i + 1];
                [cutDownString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",tempItem.result]]];
                CGFloat contentHeight =[NSString dpsizeWithSting:[cutDownString string] andFont:[UIFont systemFontOfSize:12.0] andMaxWidth:kScreenWidth - 85].height;
                if (contentHeight > 20) {
                    return hinstring;
                }
            }
        }
    }
    return hinstring;
}

//点击出票状态
- (void)pvt_ticket {
    if (self.dataBase.ticketStatus == 2 || self.dataBase.ticketStatus == 3 ||self.dataBase.ticketStatus == 5)//跳转到票样
    {
        DPTicketViewController *vc = [[DPTicketViewController alloc] init];
        vc.projectId = self.projectId;
        vc.gameType = self.gameType;
        vc.drawTime = self.winLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //其他的跳转到拆票
    DPLotteryBetInfoViewController *vc =[[DPLotteryBetInfoViewController alloc] init];
    vc.projectId = self.projectId;
    vc.gameType = self.gameType;
    [self.navigationController pushViewController:vc animated:YES];
    return;
}

//数字彩继续改号
- (void)pvt_continue {
    DPLTDltViewController *vc = [[DPLTDltViewController alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataBase.dltItemArray.count; i++) {
        PlanDetailResult_DltItem *item =[self.dataBase.dltItemArray objectAtIndex:i];
        //当前是大乐透单式或者复式
        for (int j = 0; j < item.dltResultsArray.count; j++) {
        
            DPDltBetData *dltData = [[DPDltBetData alloc] init];
            int red[50] = {0};
            int blue[50] = {0};
            if (item.dltResultsArray.count > 0) {
                PlanDetailResult_DltResult *dltResult =[item.dltResultsArray objectAtIndex:j];
                for (int m = 0; m < dltResult.redsArray.count; m++) {
                    int number = [[dltResult.redsArray objectAtIndex:m] intValue];
                    red[number - 1] = 1;
                }
                for (int m = 0; m < dltResult.bluesArray.count; m++) {
                    int number = [[dltResult.bluesArray objectAtIndex:m] intValue];
                    blue[number - 1] = 1;
                }
            }
            dltData.mark = NO;
            for (int m = 0; m < 50; m++) {
                [dltData.red addObject:[NSNumber numberWithInt:red[m]]];
            }
            for (int m = 0; m < 50; m++) {
                [dltData.blue addObject:[NSNumber numberWithInt:blue[m]]];
            }
            dltData.note = [NSNumber
                numberWithInt:[DPNoteCalculater calcDltWithRed:red blue:blue]];
            [array addObject:dltData];
        }
        //当前是大乐透胆拖投注
        for (int j = 0; j < item.dltDtResultsArray.count; j++) {
            DPDltBetData *dltData = [[DPDltBetData alloc] init];
            int red[50] = {0};
            int blue[50] = {0};
            PlanDetailResult_DltDTResult *dltResult =[item.dltDtResultsArray objectAtIndex:j];
            for (int m = 0; m < dltResult.redDansArray.count; m++) {
                int number = [[dltResult.redDansArray objectAtIndex:m] intValue];
                red[number - 1] = -1;
            }
            for (int m = 0; m < dltResult.redTuosArray.count; m++) {
                int number = [[dltResult.redTuosArray objectAtIndex:m] intValue];
                red[number - 1] = 1;
            }
            for (int m = 0; m < dltResult.blueDansArray.count; m++) {
                int number = [[dltResult.blueDansArray objectAtIndex:m] intValue];
                blue[number - 1] = -1;
            }
            for (int m = 0; m < dltResult.blueTuosArray.count; m++) {
                int number = [[dltResult.blueTuosArray objectAtIndex:m] intValue];
                blue[number - 1] = 1;
            }
            dltData.mark = YES;
            for (int m = 0; m < 50; m++) {
                [dltData.red addObject:[NSNumber numberWithInt:red[m]]];
            }
            for (int m = 0; m < 50; m++) {
                [dltData.blue addObject:[NSNumber numberWithInt:blue[m]]];
            }
            dltData.note = [NSNumber numberWithInt:[DPNoteCalculater calcDltWithRed:red blue:blue]];
            [array addObject:dltData];
        }
    }
    vc.viewModel.infoArray = array;
    [self.navigationController pushViewController:vc animated:YES];
}

//数字彩重新选号
- (void)pvt_selected {
    DPLTDltViewController *vc = [[DPLTDltViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//未支付订单/竞彩重新选号
- (void)pvt_payMoney {
    //未支付
    if (self.dataBase.payStatus == 1 && self.dataBase.projectStatus < 2) {
        [self showHUD];
       // souceid 方案id     type  0:正常流程 1:追号流程  gametype 彩种类型
        [[AFHTTPSessionManager dp_sharedManager] GET:@"/account/UsableRegBag"
            parameters:@{
                @"souceid" : @(self.projectId),
                @"type" : @(0),
                @"gametype" : @(self.gameType)
            }
            success:^(NSURLSessionDataTask *task, id responseObject) {

                [self dismissHUD];
                //跳转到订单确认页面
                PBMCreateOrderResult *result =[PBMCreateOrderResult parseFromData:responseObject error:nil];
                DPPayRedPacketViewController *vc =[[DPPayRedPacketViewController alloc] init];
                vc.gameType = (int)self.gameType;
                vc.dataBase = result;
                vc.gameName = self.dataBase.issue;
                vc.projectMoney = self.dataBase.amount;
                [self.navigationController pushViewController:vc animated:YES];
            }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
        return;
    }
    //竞彩足球重新选择
    if (IsGameTypeJc(self.gameType)) {
        DPJczqBuyViewController *vc = [[DPJczqBuyViewController alloc] init];
       
        [self.navigationController pushViewController:vc animated:YES];
    }
    //篮彩重新选择
    if (IsGameTypeLc(self.gameType)) {
        DPJclqBuyViewController *vc = [[DPJclqBuyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - getter, setter

- (DPCollapseTableView *)tableView {
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
//方案id
- (UILabel *)projectIdInfo {
    if (_projectIdInfo == nil) {
        _projectIdInfo = [[UILabel alloc] init];
        _projectIdInfo.backgroundColor = [UIColor clearColor];
        _projectIdInfo.textColor = UIColorFromRGB(0x666666);
        _projectIdInfo.textAlignment = NSTextAlignmentLeft;
        _projectIdInfo.font = [UIFont systemFontOfSize:12.0];
        _projectIdInfo.adjustsFontSizeToFitWidth = YES;
    }
    return _projectIdInfo;
}
//期号
- (UILabel *)issueLabel {
    if (_issueLabel == nil) {
        _issueLabel = [[UILabel alloc] init];
        _issueLabel.backgroundColor = [UIColor clearColor];
        _issueLabel.textColor = UIColorFromRGB(0x999999);
        _issueLabel.textAlignment = NSTextAlignmentLeft;
        _issueLabel.font = [UIFont systemFontOfSize:12.0];
        _issueLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _issueLabel;
}
//方案金额
- (UILabel *)projectMoney {
    if (_projectMoney == nil) {
        _projectMoney = [[UILabel alloc] init];
        _projectMoney.backgroundColor = [UIColor clearColor];
        _projectMoney.textColor = UIColorFromRGB(0xf93538);
        _projectMoney.textAlignment = NSTextAlignmentLeft;
        _projectMoney.font = [UIFont systemFontOfSize:14.0];
        _projectMoney.adjustsFontSizeToFitWidth = YES;
    }
    return _projectMoney;
}
//方案状态
- (UILabel *)projectState {
    if (_projectState == nil) {
        _projectState = [[UILabel alloc] init];
        _projectState.backgroundColor = [UIColor clearColor];
        _projectState.textColor = UIColorFromRGB(0x333333);
        _projectState.textAlignment = NSTextAlignmentLeft;
        _projectState.font = [UIFont systemFontOfSize:12.0];
    }
    return _projectState;
}
//发起时间
- (UILabel *)startTime {
    if (_startTime == nil) {
        _startTime = [[UILabel alloc] init];
        _startTime.backgroundColor = [UIColor clearColor];
        _startTime.textColor = UIColorFromRGB(0x333333);
        _startTime.textAlignment = NSTextAlignmentLeft;
        _startTime.font = [UIFont systemFontOfSize:12.0];
    }
    return _startTime;
}
//截止时间
- (UILabel *)endTime {
    if (_endTime == nil) {
        _endTime = [[UILabel alloc] init];
        _endTime.backgroundColor = [UIColor clearColor];
        _endTime.textColor = UIColorFromRGB(0x333333);
        _endTime.textAlignment = NSTextAlignmentLeft;
        _endTime.font = [UIFont systemFontOfSize:12.0];
    }
    return _endTime;
}
//方案内容
- (UILabel *)projectInfo {
    if (_projectInfo == nil) {
        _projectInfo = [[UILabel alloc] init];
        _projectInfo.backgroundColor = [UIColor clearColor];
        _projectInfo.textColor = [UIColor dp_flatBlackColor];
        _projectInfo.textAlignment = NSTextAlignmentLeft;
        _projectInfo.font = [UIFont systemFontOfSize:12.0];
    }
    return _projectInfo;
}
//过关方式
- (UILabel *)passType {
    if (_passType == nil) {
        _passType = [[UILabel alloc] init];
        _passType.backgroundColor = [UIColor clearColor];
        _passType.textColor = [UIColor dp_flatBlackColor];
        _passType.textAlignment = NSTextAlignmentLeft;
        _passType.lineBreakMode = NSLineBreakByWordWrapping;
        _passType.font = [UIFont systemFontOfSize:12.0];
    }
    return _passType;
}
//开奖状态
- (UILabel *)winLabel {
    if (_winLabel == nil) {
        _winLabel = [[UILabel alloc] init];
        _winLabel.backgroundColor = [UIColor clearColor];
        _winLabel.textColor = [UIColor dp_flatBlackColor];
        _winLabel.textAlignment = NSTextAlignmentLeft;
        _winLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _winLabel;
}
//复制投注
- (UIButton *)gotobutton {
    if (_gotobutton == nil) {
        _gotobutton = [[UIButton alloc] init];
        _gotobutton.backgroundColor = UIColorFromRGB(0xd34b48);
        [_gotobutton setTitle:@"继续该号" forState:UIControlStateNormal];
        [_gotobutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _gotobutton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _gotobutton.layer.cornerRadius = 5;
        [_gotobutton addTarget:self action:@selector(pvt_continue) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotobutton;
}
//重新投注
- (UIButton *)selectedButton {
    if (_selectedButton == nil) {
        _selectedButton = [[UIButton alloc] init];
        _selectedButton.backgroundColor = UIColorFromRGB(0xd34b48);
        [_selectedButton setTitle:@"重新选号" forState:UIControlStateNormal];
        [_selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectedButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _selectedButton.layer.cornerRadius = 5;
        [_selectedButton addTarget:self action:@selector(pvt_selected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}
//立即支付
- (UIButton *)payButton {
    if (_payButton == nil) {
        _payButton = [[UIButton alloc] init];
        _payButton.backgroundColor = UIColorFromRGB(0xd34b48);
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _payButton.layer.cornerRadius = 5;
        [_payButton addTarget:self action:@selector(pvt_payMoney) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}
//公共生成标签方法
- (UILabel *)createLabel:(NSString *)text//内容
               textColor:(UIColor *)textColor//字体颜色
           textAlignment:(NSTextAlignment)textAlignment//偏向
                    font:(UIFont *)font//字体大小
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.font = font;
    return label;
}

//主要实现，当列表滚动的时候，区头一直跟着一起滚动，而不是停留在列表最上边
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight =
        (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) ? 70 : 40;
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y <= sectionHeaderHeight &&
            scrollView.contentOffset.y >= 0) {
            scrollView.contentInset =
                UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
