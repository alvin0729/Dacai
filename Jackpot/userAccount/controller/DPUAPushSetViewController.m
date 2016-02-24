//
//  DPUAPushSetViewController.m
//  Jackpot
//
//  Created by mu on 15/8/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPUAPushSetViewController.h"
#import "DPUANoTroubleController.h"

#import "DPAccountFunctionCell.h"
#import "DPUASwitchCell.h"

@interface DPUAPushSetViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *functionTable;
@property (nonatomic, strong) UIView *headerView;//头部
@property (nonatomic, strong) UIView *footerView;//底部
@end

@implementation DPUAPushSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self.view addSubview:self.functionTable];
    [self.functionTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self setUpNavigationBar];
}

#pragma mark---------设置导航栏
- (void)setUpNavigationBar{
    self.title = @"推送";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(didBackTapped)];
}
//推送返回
- (void)didBackTapped{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    /**
     * 保存推送设置信息
     */

    self.pushItem.pushDevice = [KTMUtilities pushDeviceToken];
    [DPUARequestData savePushSetWithParam:self.pushItem Success:^{
    } andFail:^(NSString *failMessage) {
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
}
#pragma mark---------functionTable
- (UITableView *)functionTable{
    if (!_functionTable) {
        _functionTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _functionTable.delegate = self;
        _functionTable.dataSource = self;
        _functionTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _functionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _functionTable.tableHeaderView = self.headerView;
        _functionTable.tableFooterView = self.footerView;
    }
    return _functionTable;
}
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 11)];
        _headerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor =UIColorFromRGB(0xc7c8cc);
        [_headerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return _headerView;
}
-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]init];
        _footerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = UIColorFromRGB(0xc7c8cc);
        [_footerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _footerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPAccountFunctionCell";
    DPUABaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[DPUABaseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        //前两行加入开关
        if (indexPath.row<2) {
            UISwitch *cellSwitch = [[UISwitch alloc]init];
            cellSwitch.tag = indexPath.row;
            cellSwitch.onTintColor = [UIColor dp_flatRedColor];
            [cellSwitch addTarget:self action:@selector(cellSwitchTapped:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:cellSwitch];
            [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.mas_equalTo(-20);
            }];
            if (indexPath.row == 0) {
                cellSwitch.on = self.pushItem.winningPush;
            }else{
                cellSwitch.on = NO;
                NSArray *gameTypeArray = [self.pushItem.gametypeId componentsSeparatedByString:@","];
                for (NSString *gameTypeId  in gameTypeArray) {
                    if ([gameTypeId integerValue] == GameTypeDlt) {
                        cellSwitch.on =  YES;
                    }
                }
            }
        }else if(indexPath.row == 2 ){
            UILabel *describerLabel = [[UILabel alloc]init];
            describerLabel.text = @"设置";
            describerLabel.textColor = ycolorWithRGB(0.73, 0.73, 0.74);
            describerLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:describerLabel];
            [describerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.mas_equalTo(5);
            }];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    NSArray *titles = @[@"中奖提醒",@"大乐透开奖推送",@"关注比赛推送"];
    NSArray *subTitles = @[@"购买的彩票中奖后，第一时间通知",@"每周一，三，六20:30开奖",@"关注比赛的重要信息实时推送"];
    NSArray *imageNames = @[@"giftRemind.png",@"soHappyPush.png",@"forcusMatchPush.png"];
    cell.textLabel.text = titles[indexPath.row];
    cell.detailTextLabel.text = subTitles[indexPath.row];
    cell.detailTextLabel.textColor = ycolorWithRGB(0.73, 0.73, 0.74);
    cell.imageView.image = dp_AccountImage(imageNames[indexPath.row]);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        DPUANoTroubleController *controller = [[DPUANoTroubleController alloc]init];
        controller.noTrouble = self.pushItem.notroble;
        @weakify(self);
        controller.notroubleBlock = ^(BOOL notrouble){
            @strongify(self);
            self.pushItem.notroble = notrouble;
        };
        [self.navigationController pushViewController:controller animated:YES];
    }
}
//开光状态变化
- (void)cellSwitchTapped:(UISwitch *)sender{
    if (sender.tag==0) {
        self.pushItem.winningPush = sender.on;
    }else{
        self.pushItem.gametypeId = sender.on?[NSString stringWithFormat:@"%zd",GameTypeDlt]:@"";
    }
}
@end
