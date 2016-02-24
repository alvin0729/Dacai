//
//  DPHLUserCenterViewController.m
//  Jackpot
//
//  Created by mu on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLCreateHeartLoveViewController.h"
#import "DPHLExpertViewController.h"
#import "DPHLUserEditDescribViewController.h"
#import "DPHLFocusCell.h"
#import "DPHLHeartLoveDetailViewController.h"
#import "DPHLItemCell.h"
#import "DPHLOrderViewController.h"
#import "DPHLUserCenterViewController.h"
#import "DPHLUserHeaderView.h"
#import "DPHLUserHeartLoveCell.h"
#import "DPItemsScrollView.h"
#import "DPLogOnViewController.h"
#import "DPOpenBetServiceController.h"
#import "DPPayRedPacketViewController.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "DPOpenBetServiceController.h"
//data
#import "DPHLUserCenterViewModel.h"
#import "Order.pbobjc.h"
@interface DPHLUserCenterViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
/**
 *  表头
 */
@property (nonatomic, strong) DPHLUserHeaderView *headerView;
/**
 *  表内容
 */
@property (nonatomic, strong) DPItemsScrollView *contentView;
/**
 *  控制器viewModel
 */
@property (nonatomic, strong) DPHLUserCenterViewModel *viewModel;
/**
 *  请求我的心水和我的购买返回的数据对象
 */
@property (nonatomic, strong) MyWages *requestWages;
/**
 *  请求我的关注返回的数据对象
 */
@property (nonatomic, strong) MyFollow *requestFollows;
/**
 *  item切换：0我的心水，1我的购买，2我的关注
 */
@property (nonatomic, assign) NSInteger selectItem;
/**
 *  我的心水PageIndex
 */
@property (nonatomic, assign) NSInteger myHLPi;
/**
 *  我的购买PageIndex
 */
@property (nonatomic, assign) NSInteger myBuyHlPi;
/**
 *  我的购买PageIndex
 */
@property (nonatomic, assign) NSInteger myFollowPi;
/**
 *  数据请求PageIndex
 */
@property (nonatomic, assign) NSInteger pi;
/**
 *  无数据视图
 */
@property (nonatomic, strong) UIView *noDataView;
@end

@implementation DPHLUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
}
- (void)setupUI {
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    //表头
    self.headerView = [[DPHLUserHeaderView alloc] initWithFrame:CGRectZero];
    self.headerView.focusBtn.hidden = YES;
    self.headerView.userDescribText.delegate = self;
    self.headerView.userDescribText.enabled = YES;
    self.headerView.userDescribText.returnKeyType = UIReturnKeyDone;
    self.headerView.userDescribText.rightViewMode = UITextFieldViewModeAlways;
    self.headerView.userDescribText.placeholder = @"请输入用户简介";
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(177.5);
    }];

    //表内容
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark---------headerView
//text's delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    /**
     截取用户简介编辑，跳转到用户简介编辑页面，然后通过block回掉
     */
    DPHLUserEditDescribViewController *controller = [[DPHLUserEditDescribViewController alloc]init];
    controller.userDescrib = textField.text;
    @weakify(self);
    controller.editSuccessBlock = ^(){
        @strongify(self);
        [self requestMyHLOrMyBuysFromServer];
    };
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
}
#pragma mark---------contentView
//表内容
- (DPItemsScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[DPItemsScrollView alloc] initWithFrame:CGRectZero andItems:@[ @"我的心水", @"我的购买", @"我的关注" ]];
        //设置选择项属性
        _contentView.btnsView.backgroundColor = [UIColor dp_flatWhiteColor];//选择项背景颜色
        _contentView.btnViewHeight.mas_equalTo(45);//选择项高度
        _contentView.indirectorWidth = 77;//指示器宽度
        for (NSInteger i = 0; i < _contentView.btnArray.count; i++) {
            UIButton *btn = _contentView.btnArray[i];
            [btn setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
            [btn setTitleColor:UIColorFromRGB(0x7e6b5a) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            if (i == 0) {
                [_contentView btnTapped:btn];
            }
            if (i != _contentView.btnArray.count - 1) {
                UIView *verLiner = [[UIView alloc] init];
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
        
        @weakify(self);
        /**
         *  选择项点击
         */
        _contentView.itemTappedBlock = ^(UIButton *btn) {
            @strongify(self);
            self.selectItem = btn.tag - 100;
            //选择项对应的表数据为空时才请求数据，不然的话只是切换；
            if (self.selectItem == 0 && self.viewModel.myWagesArray.count == 0) {
                [self requestMyHLOrMyBuysFromServer];
            } else if (self.selectItem == 1 && self.viewModel.myBuysArray.count == 0) {
                [self requestMyHLOrMyBuysFromServer];
            } else if (self.selectItem == 2 && self.viewModel.myFocusArray.count == 0) {
                [self requestMyFollowsFromServer];
            }
            UITableView *table = [self.contentView.tablesView viewWithTag:300 + self.selectItem];
            [table reloadData];
        };

        /**
         *  向选择项对应的容器中添加表单，并绑定tag值，tag值为300+选择项索引
         */
        for (NSInteger i = 0; i < _contentView.viewArray.count; i++) {
            UIView *view = _contentView.viewArray[i];//选择项对应的容器
            UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.separatorColor = UIColorFromRGB(0xd0cfcd);
            table.emptyDataView = [self creatEmptyView];
            table.backgroundColor = [UIColor dp_flatBackgroundColor];
            table.sectionIndexBackgroundColor = [UIColor clearColor];
            table.tag = 300 + i;
            table.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
            table.tableFooterView = [[UIView alloc] init];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.showsInfiniteScrolling = NO;
            [view addSubview:table];
            [table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(i<2?-55:0);
            }];
            [table reloadData];
            //下拉刷新
            [table addPullToRefreshWithActionHandler:^{
                self.myBuyHlPi = 1;
                self.myHLPi = 1;
                self.myFollowPi = 1;
                if (self.selectItem < 2) {
                    [self requestMyHLOrMyBuysFromServer];
                } else {
                    [self requestMyFollowsFromServer];
                }
            }];
            //上拉加载
            [table addInfiniteScrollingWithActionHandler:^{
                if (self.selectItem < 2) {
                    if (self.selectItem == 0) {
                        self.myHLPi++;
                    } else {
                        self.myBuyHlPi++;
                    }
                    [self requestMyHLOrMyBuysFromServer];
                } else {
                    self.myFollowPi++;
                    [self requestMyFollowsFromServer];
                }
            }];
            //空页面
            @weakify(self);
            table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type) {
                @strongify(self);
                switch (type) {
                    case DZNEmptyDataViewTypeNoData: {
                        if (self.selectItem == 0 || self.selectItem == 1) {
                            [self requestMyHLOrMyBuysFromServer];
                        } else {
                            [self requestMyFollowsFromServer];
                        }
                    } break;
                    case DZNEmptyDataViewTypeFailure: {
                        if (self.selectItem == 0 || self.selectItem == 1) {
                            [self requestMyHLOrMyBuysFromServer];
                        } else {
                            [self requestMyFollowsFromServer];
                        }
                    } break;
                    case DZNEmptyDataViewTypeNoNetwork: {
                        [self.navigationController pushViewController:[DPWebViewController setNetWebController] animated:YES];
                    } break;
                    default:
                        break;
                }
            };

            //前两个表单底部添加个按钮
            if (i < 2) {
                UIView *bottomView = [[UIView alloc] init];
                bottomView.backgroundColor = [UIColor dp_flatWhiteColor];
                [view addSubview:bottomView];
                bottomView.layer.borderWidth = 0.5;
                bottomView.layer.borderColor = UIColorFromRGB(0xd0cfcd).CGColor;
                [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0.5);
                    make.left.mas_equalTo(-0.5);
                    make.right.mas_equalTo(0.5);
                    make.height.mas_equalTo(55);
                }];
                
                //发起心水按钮
                UIButton *postBtn = [UIButton dp_buttonWithTitle:@"发起心水" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont boldSystemFontOfSize:17]];
                postBtn.layer.cornerRadius = 8;
                @weakify(self);
                [[postBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
                    @strongify(self);

                    if ([[DPMemberManager sharedInstance] isLogin]) {
                        [self createLoveViewcontroller];
                    } else {
                        [self loginWithCallback:^{
                            // 从登录界面返回,自动执行下一步
                            [self createLoveViewcontroller];

                        }];
                    }

                }];
                [bottomView addSubview:postBtn];
                [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bottomView.mas_centerY);
                    make.left.mas_equalTo(16);
                    make.right.mas_equalTo(-16);
                    make.height.mas_equalTo(44);
                }];
            }
            
            table.showsInfiniteScrolling = NO;
            [table reloadData];
        }
    }
    return _contentView;
}

- (void)loginWithCallback:(void (^)(void))block {
    DPLogOnViewController *viewController = [[DPLogOnViewController alloc] init];
    viewController.finishBlock = block;
    //    [self.viewController.navigationController pushViewController:viewController animated:YES];
    [self presentViewController:[UINavigationController dp_controllerWithRootViewController:viewController] animated:YES completion:nil];
}

#pragma mark - 开通投注服务

- (void)openService {
    DPOpenBetServiceController *vc = [[DPOpenBetServiceController alloc] init];
    @weakify(vc, self);
    vc.openBetBlock = ^{
        @strongify(vc, self);
        
         [self createLoveViewcontroller];
//        [vc.navigationController dp_popViewControllerAnimated:YES completion:^{
//           
//        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 创建心水订单页面
- (void)createLoveViewcontroller {
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager] GET:@"wages/UserInfo" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];

        WagesUserInfo *userInfo = [WagesUserInfo parseFromData:responseObject error:nil];

        if (!userInfo.isOpenBetAccount) {
//            [[DPToast makeText:@"未开通购彩账户"] show];
            [self openService];
        } else if (!userInfo.isCanCreateWages) {
            [[DPToast makeText:@"今天的发起心水数已满"] show];
        } else {
            DPHLCreateHeartLoveViewController *controller = [[DPHLCreateHeartLoveViewController alloc] init];
            controller.userInfo = userInfo;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];

        }];
}
//emptyView
- (DZNEmptyDataView *)creatEmptyView {
    DZNEmptyDataView *emptyView = [DZNEmptyDataView emptyDataView];
    emptyView.imageForNoData = nil;
    emptyView.imageForFailure = nil;
    emptyView.imageForNoNetwork = nil;
    emptyView.textForNoData = @"暂无数据";
    emptyView.buttonToTextMarginForNoData = 8;
    UIImage *noDataImage = [dp_LoadingImage(@"retry.png") dp_resizedImageToFitInSize:CGSizeMake(74, 36) scaleIfSmaller:YES];
    emptyView.buttonBgImageForNoData = noDataImage;
    emptyView.buttonTitleForNoData = @"重试";
    emptyView.buttonTextColorForNoData = UIColorFromRGB(0xa0a0a0a0);
    return emptyView;
}
//nodataView
- (UIView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 72)];
        _noDataView.backgroundColor = [UIColor dp_flatBackgroundColor];
        UILabel *titleLabel = [UILabel dp_labelWithText:@"咱无数据" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xa0a0a0) font:[UIFont systemFontOfSize:15]];
        [_noDataView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_noDataView.mas_centerY).offset(-11.5);
            make.centerX.equalTo(_noDataView.mas_centerX);
            make.height.mas_equalTo(15);
        }];
        
        UIButton *btn = [UIButton dp_buttonWithTitle:@"重试" titleColor:UIColorFromRGB(0xa0a0a0) backgroundColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:15]];
        [_noDataView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(8);
            make.centerX.equalTo(_noDataView.mas_centerX);
            make.width.mas_equalTo(74);
            make.height.mas_equalTo(36);
        }];
    }
    return _noDataView;
}
//表单对应的数据源和协议方法：根据selectItem通过三元运算符来赋值
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.selectItem == 0 ? self.viewModel.myWagesArray.count : (self.selectItem == 1 ? self.viewModel.myBuysArray.count : self.viewModel.myFocusArray.count);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 16;
    } else {
        return self.selectItem == 0 ? 0 : (self.selectItem == 1 ? 11 : 0);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.selectItem == 0 ? 98 : (self.selectItem == 1 ? 134 : 85);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    return sectionHeaderView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     *  @param self.viewModel.myWagesArray 我的心水数组
     *  @param self.viewModel.myBuysArray 我的购买数组
     *  @param self.viewModel.myFocusArray 我的关注数组
     */
 
    if (self.selectItem == 0) {
        DPHLObject *object = self.viewModel.myWagesArray[indexPath.section];
        object.haveBuy = YES;
        DPHLUserHeartLoveCell *cell = [[DPHLUserHeartLoveCell alloc] initWithTableView:tableView atIndexPath:indexPath];
        cell.object = object;
        cell.upLine.hidden = indexPath.section != 0;
        return cell;
    }

    if (self.selectItem == 2) {
        DPHLObject *object = self.viewModel.myFocusArray[indexPath.section];
        DPHLFocusCell *cell = [[DPHLFocusCell alloc] initWithTableView:tableView andMarkTitles:[NSMutableArray arrayWithArray:object.marksArray] atIndexPath:indexPath];
        cell.object = object;
        cell.upLine.hidden = indexPath.section != 0;
        /**
         *  关注与取消关注
         */
        @weakify(self);
        cell.focusBtnTapped = ^(DPHLObject *object) {
            @strongify(self);
            [self showHUD];
            if (![DPMemberManager sharedInstance].isLogin) {//判断是否登录
                UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:[[DPLogOnViewController alloc]init]];
                [self presentViewController:nav animated:YES completion:nil];
                return;
            }
            if (!object.isSelect) {
                @weakify(self);
                EditAttention *param = [[EditAttention alloc]init];
                param.userId = object.userId;
                [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/CancelAttention" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
                    @strongify(self);
                    [[DPToast makeText:@"取消关注成功"]show];
                    [self dismissHUD];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    @strongify(self);
                    [self dismissHUD];
                    [[DPToast makeText:[error dp_errorMessage]]show];
                }];
            }else{
                @weakify(self);
                EditAttention *param = [[EditAttention alloc]init];
                param.userId = object.userId;
                [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/SetAttention" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
                    @strongify(self);
                    [[DPToast makeText:@"关注成功"]show];
                    [self dismissHUD];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    @strongify(self);
                    [self dismissHUD];
                    [[DPToast makeText:[error dp_errorMessage]]show];
                }];
            }

        };
        
        //cell点击方法
        cell.cellTapped = ^(NSIndexPath *indexPath){
            @strongify(self);
            UITableView *table = [self.contentView.tablesView viewWithTag:300 + self.selectItem];
            [self tableView:table didSelectRowAtIndexPath:indexPath];
        };
        return cell;
    }
    
    DPHLItemCell *cell = [[DPHLItemCell alloc] initWithTableView:tableView atIndexPath:indexPath];
    DPHLObject *object = self.viewModel.myBuysArray[indexPath.section];
    //跳转到专家详情
    @weakify(self);
    cell.iconBtnTappedBlock = ^(DPHLObject *object) {
        @strongify(self);
        DPHLExpertViewController *controller = [[DPHLExpertViewController alloc] init];
        controller.uid = object.userId;
        [self.navigationController pushViewController:controller animated:YES];
    };
    //创建心水
    cell.heartLoveOrderBlock = ^(DPHLObject *object) {
        @strongify(self);
        [self createHeartLoveOrderWithObject:object];
    };
    cell.object = object;
    cell.buyHlIconHiddle = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPHLObject *object = self.selectItem == 0 ? self.viewModel.myWagesArray[indexPath.section] : (self.selectItem == 1 ? self.viewModel.myBuysArray[indexPath.section] : self.viewModel.myFocusArray[indexPath.section]);
    if (self.selectItem < 2) {
        //跳转到心水详情
        DPHLHeartLoveDetailViewController *controller = [[DPHLHeartLoveDetailViewController alloc] init];
        controller.wagesId = object.wagesId;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        //跳转到专家详情
        DPHLExpertViewController *controller = [[DPHLExpertViewController alloc] init];
        controller.uid = object.userId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark---------data
- (void)setupData {
    self.pi = 1;
    self.viewModel = [[DPHLUserCenterViewModel alloc] init];
    [self requestMyHLOrMyBuysFromServer];
}

- (NSInteger)pi {
    switch (self.selectItem) {
        case 0:
            return self.myHLPi;
            break;
        case 1:
            return self.myBuyHlPi;
            break;
        case 2:
            return self.myFollowPi;
            break;
        default:
            return 0;
            break; 
    }
}
/**
 *  请求我的心水和我的购买
 */
- (void)requestMyHLOrMyBuysFromServer {
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager] GET:[NSString stringWithFormat:@"/wages/mywages?type=%zd&pi=%zd&ps=20", self.selectItem, self.pi] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        self.requestWages  = [MyWages parseFromData:responseObject error:nil];
        UITableView *table = [self.contentView.tablesView viewWithTag:300 + self.selectItem];//根据selectItem获取对应的表单
        if (self.selectItem == 0) {//我的心水
            if (self.pi == 1) {
                [self.viewModel.myWagesArray removeAllObjects];
            }
            self.viewModel.myWages = self.requestWages;
            table.infiniteScrollingView.enabled = self.viewModel.myWagesArray.count < self.requestWages.wagesCount;
        } else {//我的购买
            if (self.pi == 1) {
                [self.viewModel.myBuysArray removeAllObjects];
            }
            self.viewModel.myBuys = [MyWages parseFromData:responseObject error:nil];
            table.infiniteScrollingView.enabled = self.viewModel.myBuysArray.count < self.requestWages.wagesCount;
        }
        self.headerView.object = self.viewModel.headerObject;
        [table.pullToRefreshView stopAnimating];
        [table.infiniteScrollingView stopAnimating];
        table.emptyDataView.requestSuccess = YES;
        [table reloadData];
        table.showsInfiniteScrolling = table.contentSize.height > table.frame.size.height;
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]] show];
        UITableView *table = [self.contentView.tablesView viewWithTag:300 + self.selectItem];
        [table.pullToRefreshView stopAnimating];
        table.showsInfiniteScrolling = table.contentSize.height > table.frame.size.height;
        table.infiniteScrollingView.enabled = self.viewModel.myBuysArray.count < self.requestWages.wagesCount;
        [table.infiniteScrollingView stopAnimating];
        table.emptyDataView.requestSuccess = NO;
        [table reloadData];
        
    }];
}
/**
 *  请求我的关注数据
 */
- (void)requestMyFollowsFromServer {
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager] GET:[NSString stringWithFormat:@"/wages/FollowUsers?pi=%zd&ps=20", self.pi] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        MyFollow *follow = [MyFollow parseFromData:responseObject error:nil];
        self.requestFollows = follow;
        if (self.pi == 1) {
            [self.viewModel.myFocusArray removeAllObjects];
        }
        UITableView *table = [self.contentView.tablesView viewWithTag:300 + self.selectItem];
        self.viewModel.myFollows = follow;
        self.headerView.object = self.viewModel.headerObject;
        [table.pullToRefreshView stopAnimating];
        [table.infiniteScrollingView stopAnimating];
        table.infiniteScrollingView.enabled = self.viewModel.myFocusArray.count < follow.followUserCount;
        table.emptyDataView.requestSuccess = YES;
        [table reloadData];
        table.showsInfiniteScrolling = table.contentSize.height > table.frame.size.height;
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]] show];
        UITableView *table = [self.contentView.tablesView viewWithTag:300 + self.selectItem];
        [table.pullToRefreshView stopAnimating];
        [table.infiniteScrollingView stopAnimating];
        table.emptyDataView.requestSuccess = NO;
        table.infiniteScrollingView.enabled = self.viewModel.myFocusArray.count < self.requestFollows.followUserCount;
        table.showsInfiniteScrolling = table.contentSize.height > table.frame.size.height;
        [table reloadData];
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
                [self requestMyHLOrMyBuysFromServer];
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
