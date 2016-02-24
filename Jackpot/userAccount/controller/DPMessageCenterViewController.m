//
//  DPMessageCenterViewController.m
//  Jackpot
//
//  Created by mu on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPMessageCenterViewController.h"
//view
#import "DPMessageCenterContentView.h"
#import "SVPullToRefresh.h"
#import "DPMessageCenterCell.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
//data
#import "DPUARequestData.h"
typedef enum{
    topRefreshType,//下拉刷新
    downRefreshType,//上拉加载
}refreshType;

@interface DPMessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) refreshType refresh;
@property (nonatomic, strong) DPMessageCenterContentView *contentView;
@property (nonatomic, strong) UIView *editView;//编辑视图
@property (nonatomic, strong) UITableView *personMessageTable;//个人列表
@property (nonatomic, strong) UITableView *commonMessageTable;//公告列表
@property (nonatomic, weak) MASConstraint *editViewY;
@property (nonatomic, assign) BOOL isEdit;//编辑状态
@property (nonatomic, assign) BOOL isSelect;//编辑状态下，全选/全不选的切换
@property (nonatomic, strong) NSMutableArray *tabelData;//列表数据
@property (nonatomic, strong) NSMutableArray *tabelArray;
@property (nonatomic, strong) NSString *type;//当前类型（个人/公告）
@property (nonatomic, strong) NSString *pi;//请求第几页
@property (nonatomic, strong) NSString *ps;//当前页请求数据
@property (nonatomic, strong) NSMutableArray *selfResult;//个人列表数据
@property (nonatomic, strong) NSMutableArray *publicResult;//公告列表数据
@property (nonatomic, strong) NSMutableArray *deleteArray;//选中需要被删除的对象
@property (nonatomic, strong) UIButton *delectBtn;//编辑下删除按钮
@property (nonatomic, strong) UIButton *allSelectBtn;//编辑下的全选按钮
@end

@implementation DPMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息中心";
    self.isEdit = NO;
    self.isSelect = NO;
    self.pi = @"0";
    self.ps = @"20";
    
    self.deleteArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = UIColorFromRGB(0xFCFBFA) ;
    [self.view addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.editViewY = make.bottom.mas_equalTo(45);
        make.left.mas_equalTo(-1);
        make.right.mas_equalTo(1);
        make.height.mas_equalTo(46);
    }];
    
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.editView.mas_top);
    }];
    [self requestData];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithTitle:@"编辑" target:self action:@selector(editItemTapped)];
}
- (void)editItemTapped{
    if (self.editViewY) {
        [self edit:0 andIsEdit:YES andIsSelect:NO];
    }
}

#pragma mark---------data
- (void)requestData{
    [self showHUD];
    @weakify(self) ;
    //获取消息记录
    [DPUARequestData getMessagesWithParam:@{@"type":self.type?self.type:@"0",@"pageIndex":self.pi?self.pi:@"0",@"pageSize":self.ps} Success:^(PBMMsgListResult *result) {
         @strongify(self) ;
        [self dismissHUD];
        UITableView *table = (UITableView *)[self.contentView viewWithTag:300+[self.type integerValue]];
        table.emptyDataView.requestSuccess = YES;
        
        if (self.refresh == topRefreshType)//下拉刷新
        {
            self.tabelArray = [self transformResultToArray:result.msgItemArray];
        }else//上拉更新
        {
            NSMutableArray *moreMsg = [self transformResultToArray:result.msgItemArray];
            [self.tabelArray addObjectsFromArray:moreMsg];
        }
        
        if ([self.type integerValue]==0) {
            self.selfResult = self.tabelArray;
        }else{
            self.publicResult = self.tabelArray;
        }
        table.infiniteScrollingView.enabled = result.count>self.tabelData.count;
        table.showsInfiniteScrolling = table.contentSize.height>=table.frame.size.height;
        table.emptyDataView.requestSuccess = YES;
        [table.pullToRefreshView stopAnimating ];
        [table.infiniteScrollingView stopAnimating ];
        [table reloadData];
        [self resetDeleteData];
        self.navigationItem.rightBarButtonItem.enabled = self.tabelData.count ;
    } andFail:^(NSString *failMessage) {
        @strongify(self) ;
         [self dismissHUD];
        UITableView *table = (UITableView *)[self.contentView viewWithTag:300+[self.type integerValue]];
        [table.infiniteScrollingView stopAnimating];
        [table.pullToRefreshView stopAnimating];
        table.emptyDataView.requestSuccess = NO;
        table.showsInfiniteScrolling = NO;
        [table reloadData];
    }];
}

//重置编辑时的ui
-(void)resetDeleteData{

    [self.deleteArray removeAllObjects];
    self.isSelect = NO;
    [self.delectBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];


}
//保存请求来的数据
- (NSMutableArray *)transformResultToArray:(NSMutableArray *)array{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < array.count; i++) {
        PBMMsgListResult_MsgItem *item = array[i];
        DPUAObject *object = [[DPUAObject alloc]init];
        object.ID = [NSString stringWithFormat:@"%zd",item.id_p];
        object.title = item.title;
        object.subTitle = item.time;
        object.value = item.desc;
        object.isRead = item.isRead;
        object.isEdit = self.isEdit;
        object.isSelect = NO;
        object.action = item.action;
        [arr addObject:object];
    }
    return arr;
}

- (NSMutableArray *)tabelData{
    switch ([self.type integerValue]) {
        case 0:
        {
            _tabelData = self.selfResult;
        }
            break;
        case 1:
        {
            _tabelData = self.publicResult;
        }
            break;
        default:
            break;
    }
    return _tabelData;
}
#pragma mark---------contentView
- (DPMessageCenterContentView *)contentView{
    if (!_contentView) {
        _contentView  = [[DPMessageCenterContentView alloc]initWithFrame:CGRectZero andItems:@[@"个人",@"公告"]];
        for (NSInteger i = 0; i < self.contentView.viewArray.count; i++) {
            UIView *view = self.contentView.viewArray[i];
            UITableView *table = [[UITableView alloc]initWithFrame:view.bounds style:UITableViewStylePlain];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.backgroundColor = [UIColor dp_flatBackgroundColor];
            table.delegate = self;
            table.dataSource = self;
            table.tag = 300+i;
            table.emptyDataView = [self creatEmptyView];
           
            @weakify(self);
            //无数据时的处理
            table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
                @strongify(self);
                switch (type) {
                    case DZNEmptyDataViewTypeNoData:
                    {
                        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
                        [tabbar setSelectedViewController:tabbar.viewControllers.firstObject];
                    }
                        break;
                    case DZNEmptyDataViewTypeFailure:
                    {
                        [self requestData];
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
            [view addSubview:table];
            [table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.centerX.equalTo(view.mas_centerX);
            }];
            
            
            [table addPullToRefreshWithActionHandler:^{
                @strongify(self);
                self.refresh = topRefreshType;
                self.pi = @"0";
                [self requestData];
            }];
            
            
            [table addInfiniteScrollingWithActionHandler:^{
                @strongify(self);
                self.refresh = downRefreshType;
                self.pi = [NSString stringWithFormat:@"%zd",[self.pi integerValue]+1];
                [self requestData];
            }];
            
             table.showsInfiniteScrolling = NO;
        }
        @weakify(self);
        _contentView.itemTappedBlock = ^(UIButton *btn){
            @strongify(self);
            self.type = [NSString stringWithFormat:@"%zd",btn.tag - 100];
            [self requestData];
        };
    }
    return _contentView;
}
//emptyView 无数据
- (DZNEmptyDataView *)creatEmptyView{
    DZNEmptyDataView * emptyView = [DZNEmptyDataView emptyDataView];
    emptyView.showButtonForNoData = NO;
    emptyView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
    emptyView.textForNoData = @"暂无数据";
    return emptyView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tabelData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat maxWidth = self.isEdit?kScreenWidth-60:kScreenWidth-24;//编辑状态列表的改变
    DPUAObject *obj = self.tabelData[indexPath.row];
    CGFloat contentHeight =  [NSString dpsizeWithSting:obj.value andFont:[UIFont systemFontOfSize:12] andMaxWidth:maxWidth].height;
    return 46+contentHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    DPMessageCenterCell *cell = [[DPMessageCenterCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    DPUAObject *obj = self.tabelData[indexPath.row];
    cell.object = obj;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isEdit) {
        __block DPUAObject *object = self.tabelData[indexPath.row];
        if (!object.isRead)//是否已读(未编辑状态下)
        {
            PBMDeleteMsgRequest *request = [[PBMDeleteMsgRequest alloc]init];
            [request.idArray addValue:[object.ID integerValue]];
            //已读消息
            [DPUARequestData readMessageWithParam:request Success:^(PBMMsgStatusResult *result) {
                object.isSelect = !object.isSelect;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } andFail:^(NSString *failMessage) {
                [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
            }];
        }
        
        if (object.action.length>0) {
            [DPAppURLRoutes handleURL:[NSURL URLWithString:object.action]];
        }
    }else//编辑状态下点击
    {
        DPUAObject *object = self.tabelData[indexPath.row];
        object.isSelect = !object.isSelect;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (object.isSelect) {
            [self.deleteArray addObject:object];
        }else{
            [self.deleteArray removeObject:object];
        }
        
    }
    
     if (self.deleteArray.count>0) {
        [self.delectBtn setTitle:[NSString stringWithFormat:@"删除（%zd）",self.deleteArray.count] forState:UIControlStateNormal];
    }else{
        [self.delectBtn setTitle:@"删除" forState:UIControlStateNormal];
    }

    if (self.deleteArray.count == self.tabelData.count) {
        self.isSelect = YES;
        [self.allSelectBtn setTitle:@"全不选" forState:UIControlStateNormal];
    }else{
        self.isSelect = NO;
        [self.allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
}
#pragma mark---------editView
//编辑视图
- (UIView *)editView{
    if (!_editView) {
        _editView = [[UIView alloc]init];
        _editView.backgroundColor = [UIColor clearColor];
        _editView.layer.borderColor = UIColorFromRGB(0xd7d4c6).CGColor;
        _editView.layer.borderWidth = 1;
 
        UIButton *allSelectBtn = [UIButton dp_buttonWithTitle:@"全选" titleColor:UIColorFromRGB(0x2855e5) backgroundColor:nil font:[UIFont systemFontOfSize:14]];
        allSelectBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [allSelectBtn addTarget:self action:@selector(allSelectBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:allSelectBtn];
        self.allSelectBtn = allSelectBtn;
        [allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(0);
        }];
        
        UIButton *delectBtn = [UIButton dp_buttonWithTitle:@"删除" titleColor:UIColorFromRGB(0x2855e5) backgroundColor:nil font:[UIFont systemFontOfSize:14]];
        [delectBtn addTarget:self action:@selector(delectBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:delectBtn];
        self.delectBtn = delectBtn;
        [delectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(_editView.mas_centerX);
        }];
        
        UIButton *cancelBtn = [UIButton dp_buttonWithTitle:@"取消" titleColor:UIColorFromRGB(0x2855e5) backgroundColor:nil font:[UIFont systemFontOfSize:14]];        cancelBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [cancelBtn addTarget:self action:@selector(cancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-20);
        }];
        
    }
    return _editView;
}
//点击全选全不选时
- (void)allSelectBtnTapped:(UIButton *)btn{
    self.isSelect = !self.isSelect;
   [self edit:0 andIsEdit:YES andIsSelect:self.isSelect];
    if(self.isSelect){
        [self.delectBtn setTitle:[NSString stringWithFormat:@"删除（%zd）",self.tabelData.count] forState:UIControlStateNormal];
    }else{
         [self.delectBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    self.isSelect?[btn setTitle:@"全不选" forState:UIControlStateNormal]:[btn setTitle:@"全选" forState:UIControlStateNormal];
}
//删除
- (void)delectBtnTapped:(UIButton*)btn{
    
    if (!self.deleteArray.count) {
        return ;
    }
     PBMDeleteMsgRequest *param = [[PBMDeleteMsgRequest alloc]init];
   
    for (DPUAObject *object in self.deleteArray) {
        [param.idArray addValue:[object.ID integerValue]];
     }
    
    @weakify(self) ;
    [DPUARequestData deleteMessagesWithParam:param Success:^(PBMMsgStatusResult *result) {
        @strongify(self) ;
        [self.tabelData removeObjectsInArray:self.deleteArray];
        [self.personMessageTable reloadData];
        [self.commonMessageTable reloadData];
        [self.delectBtn setTitle:@"删除" forState:UIControlStateNormal];
    } andFail:^(NSString *failMessage) {
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
    
   
}
//取消
- (void)cancelBtnTapped{
    [self edit:45 andIsEdit:NO andIsSelect:NO];
    [self resetDeleteData];
}
#pragma mark---------function

/**
 *  点击编辑按钮
 *
 *  @param editY    改变的y轴
 *  @param isEdit    是否编辑状态
 *  @param isSelect 当前是全选还是全部选
 */
- (void)edit:(CGFloat)editY andIsEdit:(BOOL)isEdit andIsSelect:(BOOL)isSelect{
    self.editViewY.mas_equalTo(editY);
    for (DPUAObject *object in self.tabelData) {
        object.isEdit = isEdit;
        object.isSelect = isSelect;
    }
    self.isEdit = isEdit;
    self.navigationItem.rightBarButtonItem.enabled = !self.isEdit && self.tabelData.count ;
    self.contentView.tablesView.scrollEnabled = !self.isEdit;
    for (UIButton *btn in self.contentView.btnsView.subviews) {
        btn.enabled = !self.isEdit;
    }
    UITableView *table = (UITableView *)[self.contentView viewWithTag:300+[self.type integerValue]];
    [table reloadData];
}


@end
