//
//  DPPaytoBuySuccessViewController.m
//  DacaiProject
//
//  Created by sxf on 14/11/17.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBuyTicketRecordViewController.h"
#import "DPPaytoBuySuccessViewController.h"
#import "DPProjectDetailViewController.h"
#import "DPTChaseNumberCenterInfoViewController.h"
@interface DPPaytoBuySuccessViewController () {
@private
    UILabel *_bonusTimeLabel;
}
@property (nonatomic, strong, readonly) UILabel *bonusTimeLabel;
@end

@implementation DPPaytoBuySuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.title = @"支付成功";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.hidesBackButton = YES;
    //原本没有返回按钮。用这种方法，屏蔽系统自带返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithTitle:@"" target:self action:@selector(pvt_onBack)];
    [self buildLayout];
    // Do any additional setup after loading the view.
}
- (void)buildLayout
{
    UIView* topView = [UIView dp_viewWithColor:[UIColor clearColor]];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(15);
        make.height.equalTo(@180);
    }];
    //成功图标
    UIImageView* successView = [[UIImageView alloc] init];
    successView.image = dp_AccountImage(@"account_success.png");
    [topView addSubview:successView];
    [successView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(topView);
        make.width.equalTo(@80);
        make.top.equalTo(topView).offset(20);
        make.height.equalTo(@80);
    }];
    //成功描述
    UILabel* label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"恭喜您，%@方案支付成功！", dp_GameTypeFirstName(self.gameType)];
    label.textColor = UIColorFromRGB(0x1d911a);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont dp_systemFontOfSize:18.0];
    [topView addSubview:label];
    [topView addSubview:self.bonusTimeLabel];
    [label mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(topView);
        make.right.equalTo(topView);
        make.top.equalTo(successView.mas_bottom).offset(15);
        make.height.equalTo(@25);
    }];
    //预计开奖时间
    self.bonusTimeLabel.text = [NSString stringWithFormat:@"预计开奖时间:%@", [NSDate dp_coverDateString:self.drawTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_MM_dd_HH_mm]];
    [self.bonusTimeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(topView);
        make.width.equalTo(@240);
        make.top.equalTo(label.mas_bottom).offset(5);
        make.height.equalTo(@25);
    }];
   
    UIButton* gotoButton = ({
        UIButton* button = [[UIButton alloc] init];
        [button setBackgroundColor:UIColorFromRGB(0xdd524e)];
        [button addTarget:self action:@selector(pvt_goBuy) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"返回首页" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:20.0]];
        button;
    });
    [self.view addSubview:gotoButton];
    [gotoButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(topView.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];

    UIButton* lookRechargeBtn = ({
        UIButton* button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor dp_flatWhiteColor];
        [button addTarget:self action:@selector(pvt_lookRC) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"查看方案" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x9b9b9b) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:20.0]];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = UIColorFromRGB(0xcacaca).CGColor;
        button.layer.borderWidth = 1;
        button;
    });
    [self.view addSubview:lookRechargeBtn];
    [lookRechargeBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(gotoButton.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
}
- (UILabel*)bonusTimeLabel
{
    if (_bonusTimeLabel == nil) {
        _bonusTimeLabel = [[UILabel alloc] init];
        _bonusTimeLabel.backgroundColor = [UIColor clearColor];
        _bonusTimeLabel.text = @"预计开奖时间:";
        _bonusTimeLabel.textAlignment = NSTextAlignmentCenter;
        _bonusTimeLabel.textColor = UIColorFromRGB(0xbdad98);
        _bonusTimeLabel.font = [UIFont dp_regularArialOfSize:14.0];
    }
    return _bonusTimeLabel;
}

- (void)pvt_onBack
{
}
//返回首页
- (void)pvt_goBuy
{
    UITabBarController* tabbar = (UITabBarController*)[[UIApplication sharedApplication].delegate window].rootViewController;
    [tabbar setSelectedViewController:tabbar.viewControllers.firstObject];
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//查看方案
- (void)pvt_lookRC
{
    NSMutableArray* viewControllers = self.navigationController.viewControllers.mutableCopy;
    if (self.isChase) {
        DPTChaseNumberCenterInfoViewController* vc = [[DPTChaseNumberCenterInfoViewController alloc] init];
        vc.gameType = self.gameType;
        vc.projectId = self.projectId;
        [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:vc];
    }
    else {
        DPProjectDetailViewController* vc = [[DPProjectDetailViewController alloc] init];
        vc.gameType = self.gameType;
        vc.projectId = self.projectId;
        [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:vc];
    }

    [self.navigationController setViewControllers:viewControllers animated:YES];
}

@end
