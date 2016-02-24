//
//  DPHLHotMatchDetailViewController.m
//  Jackpot
//
//  Created by mu on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

//controller
#import "DPHLHotMatchDetailViewController.h"
#import "DPFootballCenterCommentController.h"
#import "DPHLCommentViewController.h"
#import "DPHLHeartLoveDetailViewController.h"
#import "DPHLExpertViewController.h"
#import "DPHLOrderViewController.h"
#import "DPPayRedPacketViewController.h"
#import "DPLogOnViewController.h"
#import "DPOpenBetServiceController.h"
#import "DPHLUserCenterViewController.h"
//view
#import "DPItemsScrollView.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIImageView+DPExtension.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "DPHLItemCell.h"
//data
#import "Wages.pbobjc.h"
#import "Order.pbobjc.h"
#import "DPHLHotMatchDetailViewModel.h"
@interface DPHLMatchDetailHeader : UIView
/**
 *  比赛类型：eg.竞彩足球
 */
@property (nonatomic, strong) UILabel *matchTypelab;
/**
 *  主队名称
 */
@property (nonatomic, strong) UILabel *homeTeamNamelab;
/**
 *  可对名称
 */
@property (nonatomic, strong) UILabel *guestTeamNamelab;
/**
 *  截至时间
 */
@property (nonatomic, strong) UILabel *matchTimelab;
/**
 *  主队头像
 */
@property (nonatomic, strong) UIImageView *homeTeamIconImage;
/**
 *  可对头像
 */
@property (nonatomic, strong) UIImageView *guestTeamIconImage;
/**
 *  表头对应的数据对象
 */
@property (nonatomic, strong) DPHLObject *object;
@end

@implementation DPHLMatchDetailHeader


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        
        self.matchTypelab = [UILabel dp_labelWithText:@"竞彩足球" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:11]];
        NSMutableAttributedString *matchTypeStr = [[NSMutableAttributedString alloc]initWithString:@"竞彩足球 --"];
        [matchTypeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(matchTypeStr.length-2, 2)];
        self.matchTypelab.attributedText = matchTypeStr;
        [self addSubview:self.matchTypelab];
        [self.matchTypelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(26);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(12);
        }];
        
        UILabel *vsLabel = [UILabel dp_labelWithText:@"VS" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0X333333) font:[UIFont boldSystemFontOfSize:25]];
        vsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:vsLabel];
        [vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(46);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(25);
        }];
        
        self.matchTimelab = [UILabel dp_labelWithText:@"--:--截止" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:11]];
        [self addSubview:self.matchTimelab];
        [self.matchTimelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(vsLabel.mas_bottom).offset(2);
            make.centerX.equalTo(vsLabel.mas_centerX);
        }];
        
        self.homeTeamNamelab = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:17]];
        self.homeTeamNamelab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.homeTeamNamelab];
        
        self.guestTeamNamelab = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:17]];
        self.guestTeamNamelab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.guestTeamNamelab];
        
        self.homeTeamIconImage = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"defaultIcon.png")];
        self.homeTeamIconImage.layer.cornerRadius = 20;
        self.homeTeamIconImage.layer.masksToBounds = YES;
        self.homeTeamIconImage.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
        self.homeTeamIconImage.layer.borderWidth = 1.5;
        [self addSubview:self.homeTeamIconImage];

        
        self.guestTeamIconImage = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"defaultIcon.png")];
        self.guestTeamIconImage.layer.cornerRadius = 20;
        self.guestTeamIconImage.layer.masksToBounds = YES;
        self.guestTeamIconImage.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
        self.guestTeamIconImage.layer.borderWidth = 1.5;
        [self addSubview:self.guestTeamIconImage];
        
        [self.homeTeamIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.homeTeamNamelab.mas_centerY);
            make.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.guestTeamIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.guestTeamNamelab.mas_centerY);
            make.right.mas_equalTo(-16);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.homeTeamNamelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(vsLabel.mas_centerY);
            make.right.equalTo(vsLabel.mas_left);
            make.left.equalTo(self.homeTeamIconImage.mas_right);
        }];
        [self.guestTeamNamelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(vsLabel.mas_centerY);
            make.left.equalTo(vsLabel.mas_right);
            make.right.equalTo(self.guestTeamIconImage.mas_left);
        }];
    }
    return self;
}

- (void)setObject:(DPHLObject *)object{
    _object = object;
    NSMutableAttributedString *matchTypeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"竞彩足球 %@",_object.title]];
    [matchTypeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(matchTypeStr.length-_object.title.length, _object.title.length)];
    self.matchTypelab.attributedText = matchTypeStr;
    [self.homeTeamIconImage dp_setImageWithURL:_object.value andPlaceholderImage:dp_SportLotteryImage(@"default.png")];
    self.homeTeamNamelab.text = _object.subValue;
    [self.guestTeamIconImage dp_setImageWithURL:_object.detail andPlaceholderImage:dp_SportLotteryImage(@"default.png")];
    self.guestTeamNamelab.text = _object.subDetail;
    self.matchTimelab.text = _object.matchTime;
}
@end

@interface DPHLHotMatchDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) DPHLMatchDetailHeader *headerView;//表头
@property (nonatomic, strong) DPItemsScrollView *contentView;//多表容器
@property (nonatomic, strong) DPHLCommentViewController *commentController;//评论视图控制器
@property (nonatomic, strong) UITableView *heartView;//心水表单
@property (nonatomic, strong) UIButton *xinShuiBtn;//心水选择项Btn
@property (nonatomic, strong) UIButton *commentBtn;//评论选择项Btn
@property (nonatomic, strong) DPHLHotMatchDetailViewModel *viewModel;//比赛详情viewModel
@property (nonatomic, assign) NSInteger pi;//pageIndex
@property (nonatomic, assign) NSInteger selectItem;//选择项索引
@property (nonatomic, strong) NSMutableAttributedString *commentStr;//评论选择项属性：是从评论视图控制器传出来的
@end

@implementation DPHLHotMatchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
}
- (void)setupUI{
    self.title = @"赛事";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    //表头
    self.headerView = [[DPHLMatchDetailHeader alloc]init];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(106);
    }];
    //多表容器
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark---------contentView
- (DPItemsScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[DPItemsScrollView alloc]initWithFrame:CGRectZero andItems:@[@"",@""]];
        _contentView.btnsView.backgroundColor = [UIColor dp_flatWhiteColor];
        _contentView.btnViewHeight.mas_equalTo(45);
        _contentView.indirectorWidth = 77;
        
        @weakify(self);
        _contentView.itemTappedBlock = ^(UIButton *btn){//选择项点击
            @strongify(self);
            //设置心水选择项
            self.xinShuiBtn.titleLabel.textColor = btn.tag-100==0?[UIColor dp_flatRedColor]:UIColorFromRGB(0x7e6b5a);
            NSString *wagesCount = [NSString stringWithFormat:@"[%zd]",self.viewModel.matchWages.wagesCount];
            NSMutableAttributedString *matchTypeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"心水%@",wagesCount]];
            [matchTypeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)} range:NSMakeRange(2,wagesCount.length)];
            [self.xinShuiBtn setAttributedTitle:matchTypeStr forState:UIControlStateNormal];
//            //设置评论选择项
            self.commentBtn.titleLabel.textColor = btn.tag-100==1?[UIColor dp_flatRedColor]:UIColorFromRGB(0x7e6b5a);
            [self.commentBtn setAttributedTitle:self.commentStr forState:UIControlStateNormal];
        };
        
        for (NSInteger i = 0; i < _contentView.btnArray.count; i++) {//设置选择项
            UIButton *btn = _contentView.btnArray[i];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            btn.titleLabel.textColor = UIColorFromRGB(0x7e6b5a);
            if (i==0) {
                [_contentView btnTapped:btn];
                btn.titleLabel.textColor = [UIColor dp_flatRedColor];
                NSString *wagesCount = [NSString stringWithFormat:@"[%zd]",self.viewModel.matchWages.wagesCount];
                NSMutableAttributedString *matchTypeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"心水%@",wagesCount]];
                [matchTypeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)} range:NSMakeRange(2,wagesCount.length)];
                [btn setAttributedTitle:matchTypeStr forState:UIControlStateNormal];
                self.xinShuiBtn = btn;
            }else{
                NSString *commentCount = [NSString stringWithFormat:@"[%zd]",0];
                NSMutableAttributedString *matchTypeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"评价%@",commentCount]];
                [matchTypeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)} range:NSMakeRange(2,commentCount.length)];
                [btn setAttributedTitle:matchTypeStr forState:UIControlStateNormal];
                self.commentBtn = btn;
            }
            
            if (i != _contentView.btnArray.count-1) {
                UIView *verLiner = [[UIView alloc]init];
                verLiner.backgroundColor = UIColorFromRGB(0xd0cfcd);
                [_contentView.btnsView addSubview:verLiner];
                [verLiner mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(6);
                    make.left.equalTo(btn.mas_right);
                    make.bottom.mas_equalTo(-6);
                    make.width.mas_equalTo(0.5);
                }];
            }
        }
        
        for (NSInteger i = 0; i < _contentView.viewArray.count; i++) {
            UIView *view = _contentView.viewArray[i];//选择项对应的容器
            if (i==0) {
                //添加比赛心水表单
                UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
                table.delegate = self;
                table.dataSource = self;
                table.separatorColor = UIColorFromRGB(0xd0cfcd);
                table.emptyDataView = [self creatEmptyView];
                table.backgroundColor = [UIColor dp_flatBackgroundColor];
                table.sectionIndexBackgroundColor = [UIColor clearColor];
                table.tag = 300+i;
                table.separatorStyle = UITableViewCellSeparatorStyleNone;
                [view addSubview:table];
                self.heartView = table;
                [table mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(0);
                }];
                //下拉刷新
                @weakify(self);
                [table addPullToRefreshWithActionHandler:^{
                    @strongify(self);
                    self.pi = 1;
                    [self requestDataFromServer];
                }];
                //上拉加载
                [table addInfiniteScrollingWithActionHandler:^{
                    @strongify(self);
                    self.pi ++;
                    [self requestDataFromServer];
                }];
                //空页面
                table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
                    @strongify(self);
                    switch (type) {
                        case DZNEmptyDataViewTypeNoData:
                        {
                            [self requestDataFromServer];
                        }
                            break;
                        case DZNEmptyDataViewTypeFailure:
                        {
                            [self requestDataFromServer];
                        }
                            break;
                        case DZNEmptyDataViewTypeNoNetwork:
                        {
                            [self.navigationController pushViewController:[DPWebViewController setNetWebController] animated:YES];
                        }
                            break;
                        default:
                            break;
                    }
                };
            }else{
                //添加比赛评论表单
                view.backgroundColor = [UIColor dp_flatBackgroundColor];
                self.commentController = [[DPHLCommentViewController alloc]init];
                self.commentController.matchId = self.matchId;
                //获取比赛评论条数Block-》设置对应的评论选择项
                @weakify(self);
                self.commentController.getCommentCountBlock = ^(NSMutableAttributedString *attributeStr){
                    @strongify(self);
                    [self.commentBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
                    self.commentStr = attributeStr;
                };
                //比赛评论登录block
                self.commentController.loginBlock = ^(){
                    @strongify(self);
                    DPLogOnViewController *controller = [[DPLogOnViewController alloc]init];
                    @weakify(self);
                    controller.finishBlock = ^(){
                        @strongify(self);
                        [self.commentController requestDataFromServer];
                    };
                    UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:controller];
                    [self presentViewController:nav animated:YES completion:nil];
    
                };
                [view addSubview:self.commentController.view];
                [self.commentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
            }
        }
        
    }
    return _contentView;
}

//emptyView
- (DZNEmptyDataView *)creatEmptyView{
    DZNEmptyDataView * emptyView = [DZNEmptyDataView emptyDataView];
    emptyView.showButtonForNoData = NO;
    emptyView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
    emptyView.textForNoData = @"暂无数据";
    return emptyView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.matchWagesArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?16:11;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 134;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPHLItemCell *cell = [[DPHLItemCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    @weakify(self);
    cell.iconBtnTappedBlock = ^(DPHLObject *object){
        @strongify(self);
        if(object.userId == [[DPMemberManager sharedInstance].userId integerValue]){
            if ([DPMemberManager sharedInstance].isLogin) {
                [self.navigationController pushViewController:[[DPHLUserCenterViewController alloc]init] animated:YES];
                return;
            }
            DPLogOnViewController *controller = [[DPLogOnViewController alloc]init];
            @weakify(self);
            controller.finishBlock = ^{
                @strongify(self);
                [self.navigationController pushViewController:[[DPHLUserCenterViewController alloc]init] animated:YES];
            };
            UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
        DPHLExpertViewController *controller = [[DPHLExpertViewController alloc]init];
        controller.uid = object.userId;
        [self.navigationController pushViewController:controller animated:YES];
    };
    cell.heartLoveOrderBlock = ^(DPHLObject *object){
        @strongify(self);
       [self createHeartLoveOrderWithObject:object];
    };
    DPHLObject *object = self.viewModel.matchWagesArray[indexPath.section];
    cell.object = object;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DPHLObject *object = self.viewModel.matchWagesArray[indexPath.section];
    DPHLHeartLoveDetailViewController *controller = [[DPHLHeartLoveDetailViewController alloc]init];
    controller.wagesId = object.wagesId;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark---------data
- (void)setupData{
    self.pi = 1;
    self.viewModel = [[DPHLHotMatchDetailViewModel alloc]init];
    [self requestDataFromServer];
}
/**
 *  请求比赛心水
 */
- (void)requestDataFromServer{
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager]GET:[NSString stringWithFormat:@"/wages/MatchWages?matchid=%zd&pi=%zd&ps=20&gameTypeId=%zd",self.matchId,self.pi,self.gameTypeId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        MatchWages *matchWages = [MatchWages parseFromData:responseObject error:nil];
        if (self.pi == 1) {
            [self.viewModel.matchWagesArray removeAllObjects];
        }
        self.viewModel.matchWages = matchWages;
        self.headerView.object = self.viewModel.headerObject;//设置表头数据
        //设置比赛心水选择
        NSString *wagesCount = [NSString stringWithFormat:@"[%zd]",self.viewModel.matchWages.wagesCount];
        NSMutableAttributedString *matchTypeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"心水%@",wagesCount]];
        [matchTypeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)} range:NSMakeRange(2,wagesCount.length)];
        [self.xinShuiBtn setAttributedTitle:matchTypeStr forState:UIControlStateNormal];
        
        self.heartView.emptyDataView.requestSuccess = YES;
        [self.heartView.pullToRefreshView stopAnimating];
        [self.heartView.infiniteScrollingView stopAnimating];
        self.heartView.infiniteScrollingView.enabled = self.viewModel.matchWagesArray.count<matchWages.wagesCount;
        self.heartView.showsInfiniteScrolling = self.heartView.contentSize.height>self.heartView.frame.size.height;
        [self.heartView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]]show];
        self.heartView.emptyDataView.requestSuccess = NO;
        [self.heartView.pullToRefreshView stopAnimating];
        [self.heartView.infiniteScrollingView stopAnimating];
        [self.heartView reloadData];
    }];
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
        param.wagesId = object.wagesId;
        [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/CreateUnPayWages" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self dismissHUD];
            WagesUserInfo *userInfo = [WagesUserInfo parseFromData:responseObject error:nil];
            PBMCreateOrderResult *result = [[PBMCreateOrderResult alloc]init];
            result.orderId = object.wagesId;
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
