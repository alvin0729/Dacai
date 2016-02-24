//
//  DPHLHeartLoveDetailViewController.m
//  Jackpot
//
//  Created by mu on 15/12/18.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLHeartLoveDetailViewController.h"
#import "DPPayRedPacketViewController.h"
#import "DPHLOrderViewController.h"
#import "DPLogOnViewController.h"
#import "DPOpenBetServiceController.h"
#import "UIScrollView+SVPullToRefresh.h"
//view
#import "DPHLUserHeaderView.h"
#import "DPHLHeartLoveMark.h"
//data
#import "Wages.pbobjc.h"
#import "Order.pbobjc.h"
#pragma mark---------DPHLHeartLoveContent
@interface DPHLHeartLoveContent : UIView
/**
 *  比赛时间
 */
@property (nonatomic, strong) UILabel *matchTimeLab;
/**
 *  比赛预测结果
 */
@property (nonatomic, strong) UILabel *matchResultLab;
/**
 *  比赛双方
 */
@property (nonatomic, strong) UILabel *matchFightersLab;
/**
 *  比赛实际结果
 */
@property (nonatomic, strong) UILabel *matchAwardLab;
@end

@implementation DPHLHeartLoveContent

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dp_flatBackgroundColor];
        UILabel *titleLabel = [UILabel dp_labelWithText:@"投注内容：" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15]];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(16);
        }];
        
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor dp_flatWhiteColor];
        contentView.layer.borderWidth = 0.5;
        contentView.layer.borderColor = UIColorFromRGB(0xd0cfcd).CGColor;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.left.mas_equalTo(-0.5);
            make.right.mas_equalTo(0.5);
            make.height.mas_equalTo(54);
        }];
        
        
        self.matchTimeLab = [UILabel dp_labelWithText:@"0000-00-00 -----" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:12]];
        [contentView addSubview:self.matchTimeLab];
        [self.matchTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(16.5);
            make.height.mas_equalTo(12);
        }];
        
        self.matchResultLab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:12]];
        [contentView addSubview:self.matchResultLab];
        [self.matchResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(-16.5);
            make.height.mas_equalTo(12);
        }];
        
        self.matchAwardLab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:12]];
        [contentView addSubview:self.matchAwardLab];
        [self.matchAwardLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-16.5);;
            make.height.mas_equalTo(12);
        }];
        
        self.matchFightersLab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:12]];
        [contentView addSubview:self.matchFightersLab];
        [self.matchFightersLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.left.mas_equalTo(16.5);
            make.height.mas_equalTo(12);
        }];
        
    }
    return self;
}

@end
#pragma mark---------DPHLHeartLoveDetailContent
@interface DPHLHeartLoveDetailContent : UIView
/**
 *  预计奖金
 */
@property (nonatomic, strong) UILabel *matchAwardLab;
/**
 *  推荐理由
 */
@property (nonatomic, strong) UILabel *matchReasonLab;
/**
 *  推荐标签
 */
@property (nonatomic, strong) DPHLHeartLoveMark *mark;
/**
 *  推荐理由高度约束
 */
@property (nonatomic, strong) MASConstraint *matchDetailViewHeight;
@end

@implementation DPHLHeartLoveDetailContent

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dp_flatBackgroundColor];
        
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor dp_flatWhiteColor];
        contentView.layer.borderWidth = 0.5;
        contentView.layer.borderColor = UIColorFromRGB(0xd0cfcd).CGColor;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(-0.5);
            make.right.mas_equalTo(0.5);
            self.matchDetailViewHeight = make.height.mas_equalTo(0);
        }];
        
        
        UILabel *awardTitleLabel = [UILabel dp_labelWithText:@"预计奖金：" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:12]];
        [contentView addSubview:awardTitleLabel];
        [awardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(16);
            make.height.mas_equalTo(12);
        }];
        
        UILabel *reasonTitleLabel = [UILabel dp_labelWithText:@"推荐理由：" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:12]];
        [contentView addSubview:reasonTitleLabel];
        [reasonTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(awardTitleLabel.mas_bottom).offset(12);
            make.left.mas_equalTo(16);
            make.height.mas_equalTo(12);
        }];
        
        self.matchAwardLab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:14]];
        [contentView addSubview:self.matchAwardLab];
        [self.matchAwardLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(awardTitleLabel.mas_centerY);
            make.left.equalTo(awardTitleLabel.mas_right).offset(4);
        }];
        
        DPHLHeartLoveMark *mark = [[DPHLHeartLoveMark alloc]init];
        mark.markTitleLable.text = nil;
        [contentView addSubview:mark];
        self.mark = mark;
        [mark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(reasonTitleLabel.mas_centerY);
            make.left.equalTo(reasonTitleLabel.mas_right).offset(4);
            make.size.mas_equalTo(CGSizeMake(45, 18));
        }];
        
        
        self.matchReasonLab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:12]];
        [contentView addSubview:self.matchReasonLab];
        [self.matchReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(reasonTitleLabel.mas_bottom).offset(12);
            make.left.mas_equalTo(16.5);
            make.right.mas_equalTo(-16.5);
        }];
        
    }
    return self;
}

@end

#pragma mark---------DPHLBuyHeartLoveBottomView
@interface DPHLBuyHeartLoveBottomView : UIView
/**
 *  心水价格，购买数文案
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  购买心水按钮
 */
@property (nonatomic, strong) UIButton *buyBtn;
@end

@implementation DPHLBuyHeartLoveBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        self.hidden = YES;
        self.titleLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor dp_flatWhiteColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:13]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.layer.borderColor = UIColorFromRGB(0xd0cfcd).CGColor;
        self.titleLabel.layer.borderWidth = 0.5;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(-0.5);
            make.right.mas_equalTo(0.5);
            make.height.mas_equalTo(35.5);
        }];
        
        UIButton *buyBtn = [UIButton dp_buttonWithTitle:@"购买心水" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont boldSystemFontOfSize:17]];
        buyBtn.layer.cornerRadius = 8;
        [self addSubview:buyBtn];
        [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(44);
        }];
        self.buyBtn = buyBtn;
        
    }
    return self;
}
@end

#pragma mark---------DPHLFollowHeartLoveBottomView
@interface DPHLFollowHeartLoveBottomView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *buyBtnSubTitleLabel;
@property (nonatomic, strong) UITextField *timesText;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, assign) NSInteger followCount;
@end

@implementation DPHLFollowHeartLoveBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        self.followCount = 5;
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"单倍金额：%zd元",self.followCount]];
        [title addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor dp_flatRedColor]} range:NSMakeRange(5, [NSString stringWithFormat:@"%zd",self.followCount].length)];
        self.titleLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor dp_flatWhiteColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:12]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.attributedText = title;
        self.titleLabel.layer.borderColor = UIColorFromRGB(0xd0cfcd).CGColor;
        self.titleLabel.layer.borderWidth = 0.5;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(-0.5);
            make.width.mas_equalTo(kScreenWidth*0.5);
            make.height.mas_equalTo(35);
        }];
        
        UIView *timesView = [[UIView alloc]init];
        timesView.layer.borderColor = UIColorFromRGB(0xd0cfcd).CGColor;
        timesView.layer.borderWidth = 0.5;
        [self addSubview:timesView];
        [timesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.equalTo(self.titleLabel.mas_right);
            make.width.mas_equalTo(kScreenWidth*0.5);
            make.height.mas_equalTo(35);
        }];
        
        self.timesText = [[UITextField alloc]init];
        self.timesText.borderStyle = UITextBorderStyleNone;
        self.timesText.layer.borderColor = UIColorFromRGB(0xb4b5b0).CGColor;
        self.timesText.layer.borderWidth = 0.5;
        self.timesText.layer.cornerRadius = 5;
        self.timesText.text = @"10";
        self.timesText.font = [UIFont systemFontOfSize:12];
        self.timesText.textAlignment = NSTextAlignmentCenter;
        self.timesText.textColor = UIColorFromRGB(0x333333);
        [timesView addSubview:self.timesText];
        [self.timesText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(timesView);
            make.size.mas_equalTo(CGSizeMake(73, 28));
        }];
        
        UILabel *leftLabel = [UILabel dp_labelWithText:@"投" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:12]];
        [timesView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.timesText.mas_centerY);
            make.right.equalTo(self.timesText.mas_left).offset(-2);
        }];
        
        UILabel *rightLabel = [UILabel dp_labelWithText:@"倍" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:12]];
        [timesView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.timesText.mas_centerY);
            make.left.equalTo(self.timesText.mas_right).offset(2);
        }];
        
        
        UIButton *buyBtn = [UIButton dp_buttonWithTitle:nil titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont boldSystemFontOfSize:17]];
        buyBtn.layer.cornerRadius = 8;
        [buyBtn.titleLabel sizeToFit];
        [self addSubview:buyBtn];
        [buyBtn.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(buyBtn.mas_centerY);
            make.right.mas_equalTo(-16);
        }];
        
        UILabel *buyBtnTitleLabel = [UILabel dp_labelWithText:@"跟一单" backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:17]];
        [buyBtn addSubview:buyBtnTitleLabel];
        [buyBtnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(buyBtn.mas_centerY);
            make.right.mas_equalTo(-16);
        }];
        
        UILabel *buyBtnSubTitleLabel = [UILabel dp_labelWithText:@"方案金额:100元" backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:14]];
        self.buyBtnSubTitleLabel = buyBtnSubTitleLabel;
        [buyBtn addSubview:buyBtnSubTitleLabel];
        [buyBtnSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(buyBtn.mas_centerY);
            make.left.mas_equalTo(16);
        }];
        
        [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(44);
        }];
        self.buyBtn = buyBtn;
        
        [[self.timesText rac_textSignal]subscribeNext:^(NSString *times) {
            self.buyBtnSubTitleLabel.text = [NSString stringWithFormat:@"方案金额:%zd元",[times integerValue]*self.followCount];
        }];
    
  
    }
    return self;
}
@end


#pragma mark---------controller
@interface DPHLHeartLoveDetailViewController ()<UITextFieldDelegate>
/**
 *  心水头部
 */
@property (nonatomic, strong) DPHLUserHeaderView *userHeader;
/**
 *  心水结果
 */
@property (nonatomic, strong) DPHLHeartLoveContent *matchContent;
/**
 *  心水内容
 */
@property (nonatomic, strong) DPHLHeartLoveDetailContent *matchDetail;
/**
 *  购买心水View
 */
@property (nonatomic, strong) DPHLBuyHeartLoveBottomView *buyView;
@property (nonatomic, strong) DPHLFollowHeartLoveBottomView *followView;
@property (nonatomic, strong) MASConstraint *followViewBottomConstraint;
/**
 *  未购买心水文案高度约束
 */
@property (nonatomic, strong) MASConstraint *unOpenDescribViewHeight;
/**
 *  未购买心水文案
 */
@property (nonatomic, strong) UIView *unOpenDescribView;
/**
 *  心水容器
 */
@property (nonatomic, strong) UITableView *myScroll;
@property (nonatomic, strong) UIView *myView;
/**
 *  请求心水返回参数
 */
@property (nonatomic, strong) WagesDetail *wagesDetail;
@end

@implementation DPHLHeartLoveDetailViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"心水详情";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    
    [self setupUI];
    [self setupData];
    [self setupConfig];
}
- (void)setupConfig{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)keyboardChanged:(NSNotification *)notice{
    NSDictionary *info = notice.userInfo;
    NSValue *keyBoardValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardRect = [keyBoardValue CGRectValue];
    if (self.followView.timesText.isFirstResponder) {
        self.followViewBottomConstraint.mas_equalTo(-kScreenHeight+keyBoardRect.origin.y);
    }
}
- (void)setupUI{
    //心水容器
    self.myScroll = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.myScroll.userInteractionEnabled = YES;
    self.myScroll.backgroundColor = [UIColor clearColor];
    self.myScroll.contentSize = CGSizeMake(kScreenWidth, kScreenHeight*1.5);
    UITapGestureRecognizer *closeKeyBoardGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.myScroll addGestureRecognizer:closeKeyBoardGesture];
    [self.view addSubview:self.myScroll];
    @weakify(self);
    [self.myScroll addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self requestDataFromServer];
    }];


    
    
    //心水头部
    self.userHeader = [[DPHLUserHeaderView alloc]initWithFrame:CGRectZero];
    [self.userHeader.focusBtn addTarget:self action:@selector(focusBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.myView addSubview:self.userHeader];
    [self.userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(177.5);
    }];
    
    //心水结果
    self.matchContent = [[DPHLHeartLoveContent alloc]initWithFrame:CGRectZero];
    [self.myView addSubview:self.matchContent];
    [self.matchContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userHeader.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(87);
    }];
    
    //未开通心水描述文案View
    [self.myView addSubview:self.unOpenDescribView];
    [self.unOpenDescribView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.matchContent.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        self.unOpenDescribViewHeight = make.height.mas_equalTo(27);
    }];
    
    //比赛详情
    self.matchDetail = [[DPHLHeartLoveDetailContent alloc]initWithFrame:CGRectZero];
    [self.myView addSubview:self.matchDetail];
    [self.matchDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.unOpenDescribView.mas_bottom).offset(7);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    //购买心水
    self.buyView = [[DPHLBuyHeartLoveBottomView alloc]initWithFrame:CGRectZero];
    [[self.buyView.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        DPHLObject *object = self.userHeader.object;
        object.buyBtnStr = [NSString stringWithFormat:@"%zd",self.wagesDetail.price];
        
        [self createHeartLoveOrderWithObject:object];
    }];
    [self.view addSubview:self.buyView];
    [self.buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(89);
    }];
    
    self.followView = [[DPHLFollowHeartLoveBottomView alloc]initWithFrame:CGRectZero];
    [[self.followView.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (![DPMemberManager sharedInstance].isLogin) {
            UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:[[DPLogOnViewController alloc]init]];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
        
        if (![DPMemberManager sharedInstance].isBetOpen) {
            DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
        
        DPPayRedPacketViewController *controller = [[DPPayRedPacketViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [self.view addSubview:self.followView];
    [self.followView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.followViewBottomConstraint = make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
    
    self.myScroll.tableFooterView = self.myView;
}
- (void)setupData{
    //请求心水数据
    [self requestDataFromServer];
}

-(UIView *)myView{
    if (!_myView) {
        _myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _myView;
}

//关注和取消关注
- (void)focusBtnTapped{
    if (![DPMemberManager sharedInstance].isLogin) {
        UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:[[DPLogOnViewController alloc]init]];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    if (self.userHeader.object.isSelect) {
        @weakify(self);
        EditAttention *param = [[EditAttention alloc]init];
        param.userId = self.userHeader.object.userId;
        [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/CancelAttention" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:@"取消关注成功"]show];
            [self requestDataFromServer];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:[error dp_errorMessage]]show];
        }];
    }else{
        @weakify(self);
        EditAttention *param = [[EditAttention alloc]init];
        param.userId = self.userHeader.object.userId;
        [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/SetAttention" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:@"关注成功"]show];
            [self requestDataFromServer];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:[error dp_errorMessage]]show];
        }];
    }
}
#pragma mark---------unOpenDescribView
- (UIView *)unOpenDescribView{
    if (!_unOpenDescribView) {
        _unOpenDescribView = [[UIView alloc]initWithFrame:CGRectZero];
        _unOpenDescribView.backgroundColor = [UIColor dp_flatBackgroundColor];
        
        UILabel *describLabel =  [UILabel dp_labelWithText:@"收费心水内容购买后方可查看和跟单" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xfaa09b) font:[UIFont systemFontOfSize:12]];
        [_unOpenDescribView addSubview:describLabel];
        [describLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.equalTo(_unOpenDescribView.mas_centerX).offset(22);
        }];
        
        UIImageView *describIcon = [[UIImageView alloc]initWithImage:dp_AccountImage(@"newreminder.png")];
        [_unOpenDescribView addSubview:describIcon];
        [describIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(describLabel.mas_centerY);
            make.right.equalTo(describLabel.mas_left).offset(-4);
        }];
    }
    return _unOpenDescribView;
}

#pragma mark---------function
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)closeKeyBoard{
    [self.view endEditing:YES];
}

#pragma mark---------data
- (void)requestDataFromServer{
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager]GET:[NSString stringWithFormat:@"/wages/WagesDetail?wagesid=%zd",self.wagesId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        self.wagesDetail = [WagesDetail parseFromData:responseObject error:nil];
        if (self.wagesDetail.userInfo.userId == [[DPMemberManager sharedInstance].userId integerValue]) {
            self.wagesDetail.isBuy = YES;
        }
        [self setHeaderObjectWithUserInfo:self.wagesDetail.userInfo];
        [self setHeartLoveContent];
        
        self.buyView.hidden = self.wagesDetail.isFree?YES:self.wagesDetail.isBuy;
        [self.myScroll.pullToRefreshView stopAnimating];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]]show];
        [self.myScroll.pullToRefreshView stopAnimating];
    }];
}
//设置心水头部数据
- (void)setHeaderObjectWithUserInfo:(User *)userInfo{
    DPHLObject *object = [[DPHLObject alloc]init];
    object.userIconStr = userInfo.userIcon;
    object.userNameLabelStr = userInfo.userName;
    object.userLVLabelStr = [NSString stringWithFormat:@"LV%zd",userInfo.userLever];
    object.subTitle =  [NSString stringWithFormat:@"%zd",userInfo.fansCount];
    object.value = userInfo.winRate;
    object.subValue = userInfo.recentMonthProfit;
    object.detail = userInfo.recentWeekWinRate;
    object.subDetail = userInfo.recentWeekWinRate;
    object.title = userInfo.userDescrption;
    object.isSelect = self.wagesDetail.isFocusedCreateUser;
    object.userId = userInfo.userId;
    BetItem *bet = self.wagesDetail.betItemsArray[0];
    object.endDate = bet.endDate;
    NSMutableString *markStr = [NSMutableString stringWithString:userInfo.userTag];
    object.marksArray = [NSMutableArray arrayWithArray:[markStr componentsSeparatedByString:@","]];
    self.userHeader.object = object;
}

//设置心水内容数据
- (void)setHeartLoveContent{
    BetItem *item = self.wagesDetail.betItemsArray[0];
   
    
    self.matchContent.matchTimeLab.text = [NSString stringWithFormat:@"%@ %@",item.startDate,item.orderNumberName];
    self.matchContent.matchFightersLab.text = [NSString stringWithFormat:@"%@ VS %@",item.homeTeamName,item.awayTemaName];
    self.matchContent.matchResultLab.text = item.result.length>0?[NSString stringWithFormat:@"彩果:%@",item.result]:@"";
    self.matchContent.matchAwardLab.text = [NSString stringWithFormat:@"%@@%@",item.option,item.sp];
    self.matchContent.matchAwardLab.hidden =  self.wagesDetail.isFree?NO:!self.wagesDetail.isBuy;
    self.matchContent.matchAwardLab.textColor = item.isWin?[UIColor dp_flatRedColor]:UIColorFromRGB(0x333333);
    self.unOpenDescribViewHeight.mas_equalTo(self.wagesDetail.isFree?0:(self.wagesDetail.isBuy?0:27));
    self.unOpenDescribView.hidden = self.wagesDetail.isFree?YES:(self.wagesDetail.isBuy?YES:NO);
    
    self.matchDetail.hidden = self.wagesDetail.isFree?NO:(self.wagesDetail.isBuy?NO:YES);
    NSMutableAttributedString *matchAwardLabelStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",self.wagesDetail.winAmount]];
    [matchAwardLabelStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x333333)} range:NSMakeRange(self.wagesDetail.winAmount.length,1)];
    self.matchDetail.matchAwardLab.attributedText = matchAwardLabelStr;
    self.matchDetail.mark.markTitleLable.text = self.wagesDetail.recommandAttitude;
    CGSize recommandReasonSize = [NSString dpsizeWithSting:self.wagesDetail.recommandReason andFont:[UIFont systemFontOfSize:14] andMaxWidth:kScreenWidth-32];
    self.matchDetail.matchDetailViewHeight.mas_equalTo(self.wagesDetail.recommandReason.length>0?75+recommandReasonSize.height:60);
    self.matchDetail.matchReasonLab.text = self.wagesDetail.recommandReason;
    
    NSString *titleStr = [NSString stringWithFormat:@"心水售价：%zd元，已买数量：%zd",self.wagesDetail.price,self.wagesDetail.sellCount];
    NSString *priceStr = [NSString stringWithFormat:@"%zd",self.wagesDetail.price];
    NSString *sellCountStr = [NSString stringWithFormat:@"%zd",self.wagesDetail.sellCount];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:titleStr];
    [title addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor dp_flatRedColor]} range:NSMakeRange(5, priceStr.length)];
    [title addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(title.length - sellCountStr.length, sellCountStr.length)];
    self.buyView.titleLabel.attributedText = title;
}
/**
  *  创建订单:先判断是否登录，如果未登录跳转到登录页面，然后判断是否开通投注服务，未开通投注服务则跳转到投注服务，最后判断心水是否已截至
  *
  *  @param object 心水对象
  */
- (void)createHeartLoveOrderWithObject:(DPHLObject *)object{
    if(object.userId == [[DPMemberManager sharedInstance].userId integerValue]){
        [[DPToast makeText:@"不能购买自己的心水"]show];
        return;
    }
    
    //创建订单block
    void (^orderBlock)() = ^{
        //判断是否开通投注服务
        @weakify(self);
        if (![DPMemberManager sharedInstance].betOpen) {
            @strongify(self);
            DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc]init];
            controller.openBetBlock = ^(){
                orderBlock();
            };
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
        
        NSDate *endDate = [NSDate dp_dateFromString:object.endDate withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
        if ([[NSDate dp_date] compare:endDate]>0) {
            [[DPToast makeText:@"当前心水已截至"]show];
            return;;
        }
        
        [self showHUD];
        PayWagesInput *param = [[PayWagesInput alloc]init];
        param.wagesId = self.wagesId;
        [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/CreateUnPayWages" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self dismissHUD];
            WagesUserInfo *userInfo = [WagesUserInfo parseFromData:responseObject error:nil];
            PBMCreateOrderResult *result = [[PBMCreateOrderResult alloc]init];
            result.orderId = self.wagesId;
            result.accountAmt = userInfo.amount;
            DPPayRedPacketViewController *controller = [[DPPayRedPacketViewController alloc]init];
            @weakify(self);
            controller.buyWagesSuccess = ^(){
                @strongify(self);
                [self requestDataFromServer];
                [[DPToast makeText:@"购买心水成功"]show];
            };
            controller.orderType = HeartLoveOrderType;
            controller.projectMoney = [object.buyBtnStr intValue];
            controller.wagesUserName =  object.userNameLabelStr;
            controller.dataBase = result;
            [self.navigationController pushViewController:controller animated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:[error dp_errorMessage]]show];
        }];
    };
    
    //判断是否登录
    if (![DPMemberManager sharedInstance].isLogin) {
        DPLogOnViewController *controller = [[DPLogOnViewController alloc]init];
        controller.finishBlock = ^(){
            //开通成功后->创建心水订单block
            orderBlock();
        };
        UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    orderBlock();
}
@end
