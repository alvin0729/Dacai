//
//  DPLogoutAccountViewController.m
//  Jackpot
//
//  Created by sxf on 15/8/24.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  注销账户

#import "DPAlterViewController.h"
#import "DPBuyTicketRecordViewController.h"
#import "DPLogoutAccountViewController.h"
#import "DPUAFundDetailViewController.h"
#import "Security.pbobjc.h"
@interface DPLogoutAccountViewController () {
@private
    UILabel *_noPayInfoLabel;
    UILabel *_moneyInfoLabel;
}
@property (nonatomic, strong, readonly) UILabel *noPayInfoLabel;//未结投注
@property (nonatomic, strong, readonly) UILabel *moneyInfoLabel;//账户余额
@property (nonatomic, strong) PBMLoginOutAcoount *dataBase;
@end

@implementation DPLogoutAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"注销投注账户";
    [self layOutView];
    [self requestAllData];
    // Do any additional setup after loading the view.
}
- (void)layOutView
{
    UIView* titleView = [UIView dp_viewWithColor:[UIColor clearColor]];
    [self.view addSubview:titleView];
    UIView* infoView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    [self.view addSubview:infoView];

    [titleView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(25);
        make.height.equalTo(@30);
    }];
    [infoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(titleView.mas_bottom).offset(10);
        make.height.equalTo(@88);
    }];

    UIImageView* titleImageView = [[UIImageView alloc] init];
    titleImageView.backgroundColor = [UIColor clearColor];
    titleImageView.image = dp_AccountImage(@"newreminder.png");
    [titleView addSubview:titleImageView];
    UILabel* topLabel = [self createLabel:@"注销账户必须完结所有投注并且账户没有余额。" textColor:UIColorFromRGB(0xfa9796) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:12.0]];
    UILabel* bottomLabel = [self createLabel:@"注销后您的账户所有信息将被清除！！！" textColor:UIColorFromRGB(0xfa9796) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:12.0]];
    [titleView addSubview:topLabel];
    [titleView addSubview:bottomLabel];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(titleView);
        make.width.equalTo(@16);
        make.centerY.equalTo(titleView);
        make.height.equalTo(@16);
    }];
    [topLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(titleImageView.mas_right).offset(5);
        make.right.equalTo(titleView);
        make.top.equalTo(titleView);
        make.height.equalTo(@15);
    }];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(topLabel);
        make.right.equalTo(topLabel);
        make.bottom.equalTo(titleView);
        make.height.equalTo(@15);
    }];

    UIView* infoTopView = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView* infoBottomView = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line1];
    UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line2];
    UIView* line3 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line3];
    [infoView addSubview:infoTopView];
    [infoView addSubview:infoBottomView];

    [infoTopView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.top.equalTo(infoView);
        make.height.equalTo(@44);
    }];
    [infoBottomView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(infoView);
        make.height.equalTo(@44);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.top.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.right.equalTo(infoView);
        make.centerY.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];

    UILabel* noPayTitle = [self createLabel:@"未结投注:" textColor:UIColorFromRGB(0x9f9f9f) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:16.0]];
    UILabel* moneyTitle = [self createLabel:@"账户余额:" textColor:UIColorFromRGB(0x9f9f9f) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:16.0]];
    UIImageView* nopayImageView = [[UIImageView alloc] init];
    nopayImageView.backgroundColor = [UIColor clearColor];
    nopayImageView.image = dp_AccountImage(@"rightArrow.png");
    UIImageView* moneyImageView = [[UIImageView alloc] init];
    moneyImageView.backgroundColor = [UIColor clearColor];
    moneyImageView.image = dp_AccountImage(@"rightArrow.png");
    [infoTopView addSubview:noPayTitle];
    [infoTopView addSubview:self.noPayInfoLabel];
    [infoTopView addSubview:nopayImageView];
    [infoBottomView addSubview:moneyTitle];
    [infoBottomView addSubview:self.moneyInfoLabel];
    [infoBottomView addSubview:moneyImageView];

    [noPayTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoTopView).offset(15);
        make.width.equalTo(@70);
        make.top.equalTo(infoTopView);
        make.bottom.equalTo(infoTopView);
    }];
    [nopayImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(infoTopView).offset(-15);
        make.width.equalTo(@8);
        make.centerY.equalTo(infoTopView);
        make.height.equalTo(@15);
    }];
    [self.noPayInfoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(noPayTitle.mas_right).offset(5);
        make.right.equalTo(nopayImageView.mas_left).offset(-5);
        make.top.equalTo(infoTopView);
        make.bottom.equalTo(infoTopView);
    }];

    [moneyTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(noPayTitle);
        make.right.equalTo(noPayTitle);
        make.top.equalTo(infoBottomView);
        make.bottom.equalTo(infoBottomView);
    }];
    [self.moneyInfoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.noPayInfoLabel);
        make.right.equalTo(self.noPayInfoLabel);
        make.top.equalTo(infoBottomView);
        make.bottom.equalTo(infoBottomView);
    }];
    [moneyImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(nopayImageView);
        make.right.equalTo(nopayImageView);
        make.centerY.equalTo(infoBottomView);
        make.height.equalTo(@15);
    }];
    //注销
    UIButton* nextButton = [[UIButton alloc] init];
    nextButton.backgroundColor = [UIColor clearColor];
    [nextButton setTitle:@"确认注销" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    nextButton.layer.cornerRadius = 5;
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(infoView.mas_bottom).offset(15);
        make.height.equalTo(@44);
    }];

    [infoTopView addGestureRecognizer:({
                     UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_noPay)];
                     tapRecognizer;
                 })];
    [infoBottomView addGestureRecognizer:({
                        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_money)];
                        tapRecognizer;
                    })];
}
- (void)requestAllData
{

    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] GET:@"/account/GetUnCompleteProjectCount"
        parameters:nil
        success:^(NSURLSessionDataTask* task, id responseObject) {

            [self dismissHUD];
            self.dataBase = [PBMLoginOutAcoount parseFromData:responseObject error:nil];
            self.noPayInfoLabel.text = [NSString stringWithFormat:@"您有%@个未结投注", self.dataBase.noBetTotal];
            NSMutableAttributedString* hinstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", self.dataBase.userMoney]];
            [hinstring addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xdb4e4d) range:NSMakeRange(0, hinstring.length)];
            [hinstring addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0x333333) range:NSMakeRange(hinstring.length - 1, 1)];
            self.moneyInfoLabel.attributedText = hinstring;
        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}
//注销
- (void)nextClick
{
    if ([self.dataBase.noBetTotal integerValue] > 0 || [self.dataBase.userMoney floatValue] > 0) {
        [[DPToast makeText:@"未达到注销条件，暂不能注销"] show];
        return;
    }
    DPAlterViewController* alterView = [[DPAlterViewController alloc] initWithAlterType:AlterTypeCancelledBetSuccess];
    alterView.fullBtnTapped = ^(UIButton* btn) {
        [self showHUD];
        [[AFHTTPSessionManager dp_sharedManager] GET:@"/account/DestroyedAccount"
            parameters:nil
            success:^(NSURLSessionDataTask* task, id responseObject) {

                [self dismissHUD];
                [self.navigationController popViewControllerAnimated:YES];
            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
    };
    [self dp_showViewController:alterView animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}
//未结投注
- (void)pvt_noPay
{
    DPBuyTicketRecordViewController* vc = [[DPBuyTicketRecordViewController alloc] init];
    vc.index = 2;
    [self.navigationController pushViewController:vc animated:YES];
}
//账户余额
- (void)pvt_money
{
    DPUAFundDetailViewController* vc = [[DPUAFundDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - getter, setter

//未结投注
- (UILabel*)noPayInfoLabel
{
    if (_noPayInfoLabel == nil) {
        _noPayInfoLabel = [[UILabel alloc] init];
        _noPayInfoLabel.backgroundColor = [UIColor clearColor];
        _noPayInfoLabel.textColor = UIColorFromRGB(0x333333);
        ;
        _noPayInfoLabel.font = [UIFont systemFontOfSize:16.0];
        _noPayInfoLabel.textAlignment = NSTextAlignmentLeft;
        //        _noPayInfoLabel.text=@"您有4个未结投注";
    }
    return _noPayInfoLabel;
}
//账户余额
- (UILabel*)moneyInfoLabel
{
    if (_moneyInfoLabel == nil) {
        _moneyInfoLabel = [[UILabel alloc] init];
        _moneyInfoLabel.backgroundColor = [UIColor clearColor];
        _moneyInfoLabel.textColor = UIColorFromRGB(0x333333);
        _moneyInfoLabel.font = [UIFont systemFontOfSize:16.0];
        _moneyInfoLabel.textAlignment = NSTextAlignmentLeft;
        //        _moneyInfoLabel.text=@"100.00元";
    }
    return _moneyInfoLabel;
}
- (UILabel*)createLabel:(NSString*)text textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont*)font
{
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.font = font;
    return label;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
