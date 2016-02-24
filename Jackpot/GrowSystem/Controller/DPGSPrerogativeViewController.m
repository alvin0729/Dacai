//
//  DPGSPrerogativeViewController.m
//  Jackpot
//
//  Created by mu on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGSPrerogativeViewController.h"
#import "DPPrepogativeHeaderView.h"
#import "DPPrerogativeLVView.h"
#import "DPPrepogativeCell.h"
#import "DPWebViewController.h"

@interface DPGSPrerogativeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)DPPrepogativeHeaderView *headerView;
@property (nonatomic, strong)UITableView *myTable;
@property (nonatomic, strong)NSMutableArray *tableData;
@property (nonatomic, strong)DPPrerogativeLVView *LVView;
@end

@implementation DPGSPrerogativeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"用户特权";

    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(122);
    }];
    [self.view addSubview:self.myTable];
    [self.myTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.myTable addSubview:self.LVView];
}

#pragma mark---------headerView
//headerView
-(DPPrepogativeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[DPPrepogativeHeaderView alloc]init];
        [_headerView.iconImage setImageWithURL:[NSURL URLWithString:[DPMemberManager sharedInstance].iconImageURL] placeholderImage:dp_AccountImage(@"UAIconDefalt.png")];
        _headerView.nameLabel.text = [DPMemberManager sharedInstance].nickName;
        _headerView.levelLabel.text = [NSString stringWithFormat:@"LV%d",self.useInfo.level];
        NSMutableAttributedString *atrributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d\n成长值",self.useInfo.growup]];
        [atrributedStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x8e8e8e),NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(atrributedStr.length-3, 3)];
        _headerView.growNumLabel.attributedText =atrributedStr;
        @weakify(self);
        _headerView.upBlock = ^(id sender){
            @strongify(self);
            DPWebViewController *controller = [[DPWebViewController alloc]init];
            controller.title = @"帮助";
            NSString *url = [NSString stringWithFormat:@"%@%@",kServerBaseURL,@"/web/help/userlevel"];
            controller.requset = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
            [self.navigationController pushViewController:controller animated:YES];
        };
        [_headerView.iconImage setImageWithURL:[NSURL URLWithString:self.useInfo.iconURL] placeholderImage:nil];
    }
    return _headerView;
}
#pragma mark---------myTable
- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _myTable.contentInset = UIEdgeInsetsMake(0, 0, 186, 0);
    }
    return _myTable;
}
- (DPPrerogativeLVView *)LVView{
    if (!_LVView) {
         CGFloat height = 0;
        NSMutableArray *LVHeightArray = [NSMutableArray array];
        for (DPPrepogativeObject *object in self.tableData) {
            [LVHeightArray addObject:[NSNumber numberWithFloat:124]];
            height +=object.height;
        }
       
        _LVView = [[DPPrerogativeLVView alloc]initWithFrame:CGRectMake(0, 0, 90, height)];
      
        _LVView.currentLV = self.useInfo.level;
        _LVView.currentJifen = self.useInfo.growup;
        _LVView.LVHeightArray = LVHeightArray;
        _LVView.LVCount = 7;
    }
    return _LVView;
}
//data
- (NSMutableArray *)tableData{
    if (!_tableData) {
        _tableData = [NSMutableArray array];
        for (NSInteger i = 0; i<7; i++) {
            DPPrepogativeObject *object = [[DPPrepogativeObject alloc]init];
            if (i<self.useInfo.level) {
                object.myLevel = DPPrepogativeLastLevel;
            }else if (i==self.useInfo.level){
                object.myLevel = DPPrepogativeCurrentLevel;
            }else{
                object.myLevel = DPPrepogativeFutureLevel;
            }
            object.levelStr = [NSString stringWithFormat:@"LV%zd",i];
            NSArray *titleArray = @[@[@"免手续费登录"],
                                    @[@"极速提款",@"一对一客服"],
                                    @[@"生日大礼包"],
                                    @[@"论坛会宾区",@"短信提醒"],
                                    @[@"发帖免审核"],
                                    @[@"充值折扣",@"公益支持"],
                                    @[@"特权升级中"]];
            
            NSArray *imageArray=@[@[@"freeProcedure.png"],
                                  @[@"topGet.png",@"justYourESQ.png"],
                                  @[@"birthdayGift.png"],
                                  @[@"barVIP.png",@"smsRemind.png"],
                                  @[@"superPosts.png"],
                                  @[@"payDiscount.png",@"publicBenefit.png"],
                                  @[@"provativeUp.png"]];
            
             NSArray *redImageArray =@[@[@"freeProcedure_red.png"],
                                       @[@"topGet_red.png",@"justYourESQ_red.png"],
                                       @[@"birthdayGift_red.png"],
                                       @[@"barVIP_red.png",@"smsRemind_red.png"],
                                       @[@"superPosts_red.png"],
                                       @[@"payDiscount_red.png",@"publicBenefit_red.png"],
                                       @[@"provativeUp_red.png"]];
            
            object.prepogativeArray = [NSMutableArray arrayWithArray:titleArray[i]];
            if (object.myLevel==DPPrepogativeFutureLevel) {
                object.prepogativeimageArray = [NSMutableArray arrayWithArray:imageArray[i]];
            }else {
                 object.prepogativeimageArray = [NSMutableArray arrayWithArray:redImageArray[i]];
            }
            [_tableData addObject:object];
        }
      
    }
    return _tableData;
}
//myTable's delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPPrepogativeCell *cell = [[DPPrepogativeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.object = self.tableData[indexPath.row];
    return cell;
}
@end
