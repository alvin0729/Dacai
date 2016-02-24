//
//  DPHLCommentViewController.m
//  Jackpot
//
//  Created by mu on 15/12/24.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLCommentViewController.h"
#import "DPLogOnViewController.h"
#import "DPOpenBetServiceController.h"

#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "DPLiveCompetitionViews.h"
#import "DPHLCommentCell.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "Wages.pbobjc.h"
#import "FootballDataCenter.pbobjc.h"
#import "BasketballDataCenter.pbobjc.h"
@interface DPHLCommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
/**
 *  评论内容表单
 */
@property (nonatomic, strong)UITableView *contentTable;
/**
 *  发送评论View
 */
@property (nonatomic, strong)UIView *sendView;
/**
 *  评论输入框
 */
@property (nonatomic, strong)UITextField *sendTF;
/**
 *  评论发送按钮
 */
@property (nonatomic, strong)UIButton *sendBtn;
/**
 *  评论信息数组
 */
@property (nonatomic, strong)NSMutableArray *messageArray;
/**
 *  评论View到底部距离的约束条件
 */
@property (nonatomic, strong)MASConstraint *sendViewBottomCons;
/**
 *  比赛评论返回数据
 */
@property (nonatomic, strong)PBMFootComment *matchComments;
/**
 *  评论页数索引：pageIndex
 */
@property (nonatomic, assign)NSInteger pi;
/**
 *  评论id
 */
@property (nonatomic, copy)NSString *commentid;
/**
 *  评论次数
 */
@property (nonatomic, assign)NSTimeInterval lastTime;
/**
 *  键盘是否打开开关
 */
@property (nonatomic, assign) BOOL keyboardSwitch;
@end

@implementation DPHLCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化UI
    [self initilizerUI];
    //初始化数据
    [self initilizerData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.keyboardSwitch = YES;
}
#pragma mark---------ui
- (void)initilizerUI {//初始化UI
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
        
    [self.view addSubview:self.contentTable];
    [self.view addSubview:self.sendView];
    [self layoutUI];
}
- (void)layoutUI{
    [self.contentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-44);
    }];
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.sendViewBottomCons = make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
}
//初始化内容表单
- (UITableView *)contentTable{
    if (!_contentTable) {
        _contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
        _contentTable.dataSource = self;
        _contentTable.delegate = self;
        _contentTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _contentTable.separatorStyle = UITableViewCellSelectionStyleNone;
        _contentTable.contentInset = UIEdgeInsetsMake(20, 0, 64, 0);
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
        [_contentTable addGestureRecognizer:gesture];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
        @weakify(self);
        [_contentTable addInfiniteScrollingWithActionHandler:^{
            @strongify(self);
            if (self.messageArray.count>0) {
                DPHLObject *object = self.messageArray[self.messageArray.count-1];
                self.commentid = object.objectId;
                [self requestDataFromServer];
            }
        }];
        
        [_contentTable addPullToRefreshWithActionHandler:^{
            @strongify(self);
            self.commentid = @"";
            [self requestDataFromServer];
        }];
        _contentTable.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
            @strongify(self);
            switch (type) {
                case DZNEmptyDataViewTypeNoData:
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
        
    }
    return _contentTable;
}
#pragma mark---------contentView
//emptyView
- (DZNEmptyDataView *)creatEmptyView{
    DZNEmptyDataView * emptyView = [DZNEmptyDataView emptyDataView];
    emptyView.showButtonForNoData = NO;
    emptyView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
    emptyView.textForNoData = @"暂无数据";
    return emptyView;
}

- (void)keyboardChanged:(NSNotification *)notice{
    NSDictionary *info = notice.userInfo;
    NSValue *keyBoardValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardRect = [keyBoardValue CGRectValue];
    CGFloat bottom = - (kScreenHeight - keyBoardRect.origin.y);
    if (self.keyboardSwitch) {
        self.sendViewBottomCons.mas_equalTo(bottom);
    }
}
- (void)closeKeyboard:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}
//初始化发送评论View
- (UIView *)sendView{
    if (!_sendView) {
        _sendView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentTable.frame), kScreenWidth, 44)];
        _sendView.backgroundColor = [UIColor dp_flatWhiteColor];
        [_sendView addSubview:self.sendBtn];
        [_sendView addSubview:self.sendTF];
        
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(44);
        }];
        
        [self.sendTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.equalTo(self.sendBtn.mas_left);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _sendView;
}
- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = [UIColor dp_flatWhiteColor];
        _sendBtn.imageView.contentMode = UIViewContentModeCenter;
        [_sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setImage:dp_FeedbackResizeImage(@"messageFly.png") forState:UIControlStateNormal];
    }
    return _sendBtn;
}
//发送评论
- (void)sendMessage:(UIButton *)btn{
    if (![DPMemberManager sharedInstance].isLogin) {
        [self.view endEditing:YES];
        self.keyboardSwitch = NO;
        if (self.loginBlock) {
            self.loginBlock();
        }
        return;
    }
    
    if ([[NSDate dp_date] timeIntervalSince1970] - _lastTime <= 5) {
        [[DPToast makeText:@"评论过于频繁,稍后再发"] show];
        return;
    }
    if (self.sendTF.text.length > 140) {
        [[DPToast makeText:@"最多只能发布140个字"] show];
        return;
    }
    if (self.sendTF.text.length <= 0) {
        [[DPToast makeText:@"请输入评论内容"] show];
        return;
    }
    if (self.sendTF.text.length <= 1) {
        [[DPToast makeText:@"至少输入1个字以上"] show];
        return;
    }
    
    PBMCommentData *commData = [PBMCommentData message];
    commData.matchId = (long)self.matchId;
    commData.gametype = 2;
    commData.text = self.sendTF.text;
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager] POST:@"/datacenter/SubmitComment"
                                       parameters:commData
                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                              @strongify(self);
                                              self.lastTime = [[NSDate dp_date] timeIntervalSince1970];
                                              [[DPToast makeText:@"评论成功"] show];
                                              self.sendTF.text = @"" ;
                                              [self.view endEditing:YES];
                                              [self requestDataFromServer];
                                          }
                                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                                              [[DPToast makeText:@"评论失败"] show];
                                              [self requestDataFromServer];
                                          }];
}
//sendTF
- (UITextField *)sendTF{
    if (!_sendTF) {
        _sendTF = [[UITextField alloc]init];
        _sendTF.delegate = self;
        _sendTF.placeholder = @"我想说点什么...";
        _sendTF.backgroundColor =[UIColor dp_flatWhiteColor];
    }
    return _sendTF;
}
#pragma mark---------data
//初始化数据
- (void)initilizerData{
    self.pi = 1;
    self.keyboardSwitch = YES;
    self.commentid = @"";
    self.messageArray = [NSMutableArray array];
    [self requestDataFromServer];
   
}
//请求评论数据
- (void)requestDataFromServer{
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager]GET:[NSString stringWithFormat:@"/datacenter/GetMatchComments?matchid=%zd&type=2&commendId=%@",self.matchId,self.commentid] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        self.matchComments = [PBMFootComment parseFromData:responseObject error:nil];
        if (self.commentid.length == 0) {//如果评论ID不存在，则清除所有的对象
            [self.messageArray removeAllObjects];
        }
        
        for (NSInteger i = 0; i < self.matchComments.commentArray.count; i++) {
            //将评论内容转化为评论cell对应的对象
            DPHLObject *object = [self transfromCommentToObject:self.matchComments.commentArray[i]];
            [self.messageArray addObject:object];
        }
        
        NSString *commentCount = [NSString stringWithFormat:@"[%zd]",self.matchComments.totalNum];
        NSMutableAttributedString *matchTypeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"评论%@",commentCount]];
        [matchTypeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)} range:NSMakeRange(2,commentCount.length)];
        if (self.getCommentCountBlock) {
            self.getCommentCountBlock(matchTypeStr);
        }
        [self.contentTable.pullToRefreshView stopAnimating];
        [self.contentTable.infiniteScrollingView stopAnimating];
        self.contentTable.emptyDataView.requestSuccess = YES;
        self.contentTable.infiniteScrollingView.enabled = self.messageArray.count<self.matchComments.totalNum;
        [self.contentTable reloadData];
        self.contentTable.showsInfiniteScrolling = self.contentTable.contentSize.height>self.contentTable.frame.size.height;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]]show];
        self.contentTable.emptyDataView.requestSuccess = NO;
        [self.contentTable.pullToRefreshView stopAnimating];
        [self.contentTable.infiniteScrollingView stopAnimating];
        self.contentTable.infiniteScrollingView.enabled = self.messageArray.count<self.matchComments.totalNum;
        self.contentTable.showsInfiniteScrolling = self.contentTable.contentSize.height>self.contentTable.frame.size.height;
        [self.contentTable reloadData];
    }];
}
#pragma mark---------function
//table's delegate and datasourse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPHLObject *object = self.messageArray[indexPath.row];
    NSString *contentStr = object.value.length>60?(object.isHiddle?[object.value substringToIndex:60]:object.value):object.value;
    CGSize commendContentSize = [NSString dpsizeWithSting:contentStr andFont:[UIFont systemFontOfSize:12] andMaxSize:CGSizeMake(kScreenWidth-84, MAXFLOAT)];
    return commendContentSize.height+67;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPHLCommentCell *cell = [[DPHLCommentCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    cell.object = self.messageArray[indexPath.row];
    cell.upLine.hidden = !indexPath.row ==0;
    cell.backgroundColor = [UIColor dp_flatBackgroundColor];
    @weakify(self);
    cell.contentTappedBlock = ^( DPHLObject *object){//展示全文与不展示全文切换
        @strongify(self); 
        object.isHiddle = !object.isHiddle;
        [self.contentTable reloadData];
    };
    cell.likeBtnTappedBlock = ^(DPHLObject *object){//评论点赞
        @strongify(self);
        if (object.isSelect) {
            return ;
        }
        
        if (![DPMemberManager sharedInstance].isLogin) {
            [self.view endEditing:YES];
            self.keyboardSwitch = NO;
            if (self.loginBlock) {
                self.loginBlock();
            }
            return;
        }
       
        //点赞请求
        PBMSupport *supportData = [PBMSupport message];
        supportData.matchId = (long)self.matchId;
        supportData.commentId = object.objectId;
        supportData.gametype = 2;
        [[AFHTTPSessionManager dp_sharedManager] POST:@"/datacenter/SupportComment"
                                           parameters:supportData
                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                  [self requestDataFromServer];
                                              }
                                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                  [self requestDataFromServer];
                                              }];
    };
    //cell整行点击 
    cell.cellTappedBlock = ^(){
        @strongify(self);
        [self.view endEditing:YES];
    };
    return cell;
}
//将每一条评论内容转化为评论cell对应的对象
- (DPHLObject *)transfromCommentToObject:(PBMComment *)comment{
    DPHLObject *object = [[DPHLObject alloc]init];
    object.iconName = comment.userAvatar;
    object.title = comment.username;
    object.subTitle = comment.time;
    object.objectId = comment.commentId;
    object.value = comment.content;
    object.isSelect = comment.isSupported;
    object.subValue = [NSString stringWithFormat:@"%zd", comment.supportCount];
    object.isHiddle = YES;
    object.objectId = comment.commentId;
    return object;
}
//textField's delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
