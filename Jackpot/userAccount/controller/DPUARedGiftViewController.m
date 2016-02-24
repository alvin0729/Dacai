//
//  DPUARedGiftViewController.m
//  Jackpot
//
//  Created by mu on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUARedGiftViewController.h"
//view
#import "DPUAItemsScrollView.h"
#import "SVPullToRefresh.h"
#import "DPUARedGiftCell.h"
//data
#import "DPUARequestData.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"

@interface DPUARedGiftViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) DPUAItemsScrollView *contentView;
@property (nonatomic, assign) DPRedGiftState giftState;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) PBMRedGiftInfo *redGiftInfo;
@property (nonatomic, strong) NSMutableArray *useableGiftArray;
@property (nonatomic, strong) NSMutableArray *commingGiftArray;
@property (nonatomic, strong) NSMutableArray *unUseableGiftArray;
@end

@implementation DPUARedGiftViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"红包";
    self.param = [NSMutableDictionary dictionary];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    
    [self initilizer];
    [self requestData];
}

#pragma mark---------data
//获取红包数据
- (void)requestData{
    [DPUARequestData getRedGiftInfoWithParam:self.param Success:^(PBMRedGiftInfo *giftInfo) {
        self.redGiftInfo = giftInfo;
        
//        self.useableGiftArray = [self tranformToCellObjectWithRedArray:giftInfo.useableGiftListArray];
//        self.commingGiftArray = [self tranformToCellObjectWithRedArray:giftInfo.commingGiftListArray];
//        self.unUseableGiftArray = [self tranformToCellObjectWithRedArray:giftInfo.unUseableGiftListArray];
        
    } andFail:^(NSString *failMessage) {
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
}
- (NSMutableArray *)tranformToCellObjectWithRedArray:(NSMutableArray *)redArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < redArray.count; i++) {
        PBMRedGiftInfo_RedGiftItem *giftItem = redArray[i];
        DPUAObject *object = [[DPUAObject alloc]init];
        object.imageName = giftItem.giftIcon;
        object.title = giftItem.giftName;
        object.subTitle = giftItem.giftType;
        object.redGiftTime = giftItem.giftTime;
        object.value = giftItem.giftValue;
//        object.subValue = giftItem.giftUnUseableResonal;
        [array addObject:object];
    }
    return array;
}
#pragma mark---------contentView
- (DPUAItemsScrollView *)contentView{
    if (!_contentView) {
        _contentView  = [[DPUAItemsScrollView alloc]initWithFrame:CGRectZero andItems:@[@"可使用",@"派发中",@"已用完/过期"]];
        _contentView.btnsView.backgroundColor = UIColorFromRGB(0xffffff);
        _contentView.btnsView.layer.borderColor = UIColorFromRGB(0xb5b5b5).CGColor;
        for (NSInteger i = 0; i < _contentView.btnArray.count; i++) {
            UIButton *btn = (UIButton *)_contentView.btnArray[i];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        }
        for (NSInteger i = 0; i < self.contentView.viewArray.count; i++) {
            
            UIView *view = self.contentView.viewArray[i];
            UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.backgroundColor = [UIColor dp_flatBackgroundColor];
            table.delegate = self;
            table.dataSource = self;
            table.tag = 300+i;
            table.emptyDataView = [DZNEmptyDataView emptyDataView];
            @weakify(self);
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
            }];
            
        }
        
    }
    return _contentView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0 ;
    switch (tableView.tag) {
        case 300:
        {
            rowCount = self.useableGiftArray.count;
        }
            break;
        case 301:
        {
            rowCount = self.commingGiftArray.count;
        }
            break;
        case 302:
        {
            rowCount = self.unUseableGiftArray.count;
        }
            break;
        default:
            break;
    }
    return rowCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPUARedGiftCell *cell = [[DPUARedGiftCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    switch (tableView.tag) {
        case 300:
        {
            DPUAObject *object = self.useableGiftArray[indexPath.row];
            object.giftState = DPRedGiftUseableState;
            cell.object = object;
        }
            break;
        case 301:
        {
            DPUAObject *object = self.commingGiftArray[indexPath.row];
            object.giftState = DPRedGiftComingState;
            cell.object = object;
        }
            break;
        case 302:
        {
            DPUAObject *object = self.unUseableGiftArray[indexPath.row];
            object.giftState = DPRedGiftUnUsedState;
            cell.object = object;
        }
            break;
        default:
            break;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark---------function
- (void)initilizer{
    UIBarButtonItem *helpItem = [UIBarButtonItem dp_itemWithTitle:@"帮助" target:self action:@selector(helpItemTapped)];
    self.navigationItem.rightBarButtonItem = helpItem;
}
- (void)helpItemTapped{
}
@end
