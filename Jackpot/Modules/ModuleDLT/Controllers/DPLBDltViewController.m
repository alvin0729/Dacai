//
//  DPLBDltViewController.m
//  DacaiProject
//
//  Created by jacknathan on 15-1-20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPAlterViewController.h"
#import "DPDltDrawVC.h"
#import "DPHistoryTendencyCell.h"
#import "DPLBDltDataModel.h"
#import "DPLBDltViewController.h"
@implementation DPLBDltViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init {
    if (self = [super init]) {
        _gameType = GameTypeDlt;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    if (self.dataModel.gameIndex != ((DPNavigationMenu*)self.menu).selectedIndex  && [self respondsToSelector:@selector(reloadSelectTableView:)]) {
    if ([self respondsToSelector:@selector(reloadSelectTableView:)]) {
        [self reloadSelectTableView:(int)self.dataModel.gameIndex];
    }
    [(UITableView *)self.numberTable reloadData];
    [self calculateZhuShu];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
//- (void)clearAllSelectedData
//{
//#warning 可否重用，在父类实现？
//    [self.dataModel clearAllSelectedData];
//    [self calculateZhuShu];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.trendTableView) {
        DPHistoryTendencyCell *cell = [tableView dequeueReusableCellWithIdentifier:self.dataModel.trendCellClass];
        if (cell == nil) {
            cell = [[DPHistoryTendencyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:self.dataModel.trendCellClass
                                                    digitalType:self.dataModel.gameType];
        }

        [cell setDataModel:[self.dataModel trendCellModelForIndexPath:indexPath]];
        return cell;
    }

    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d%d", (int)indexPath.row, (int)self.dataModel.gameIndex];
    DPLBDigitalBallCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *ballTotal = [self.dataModel.ballUIDict objectForKey:@"total"];
        NSArray *ballColorAry = [self.dataModel.ballUIDict objectForKey:@"redColor"];
        NSArray *maxtotalAry = [self.dataModel.ballUIDict objectForKey:@"maxTotal"];
        int ballColorIndex = [[ballColorAry objectAtIndex:indexPath.row] intValue];
        int maxtotal = [[maxtotalAry objectAtIndex:indexPath.row] intValue];
        NSArray *titleAry = [self.dataModel.ballUIDict objectForKey:@"title"];
        cell = [[DPLBDigitalBallCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier
                                                balltotal:[[ballTotal objectAtIndex:indexPath.row] intValue]
                                                ballColor:ballColorIndex
                                             ballSelected:maxtotal
                                              lotteryType:self.dataModel.gameType];

        cell.backgroundColor = [UIColor dp_flatWhiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = [titleAry objectAtIndex:indexPath.row];
        cell.delegate = self;
        if ((indexPath.row == 0) && (self.dataModel.gameIndex == 1)) {
            [cell oneRowTitleHeight:21];
            [cell oneRowTitleRect:-22];
        }
    }
    [cell setDataModel:[self.dataModel numberCellModelForIndexPath:indexPath]];
    return cell;
}
- (void)timeSpaceNotify {
    self.deadlineTimeLab.attributedText = self.tranViewController.viewModel.countDownAttString;
    self.bonusLab.attributedText = self.tranViewController.viewModel.bonusMoney;
}
- (void)reloadSelectTableView:(int)titleIndex {
    [self.dataModel reloadGameIndex:titleIndex];
    self.titleButton.titleText = self.dataModel.titleArray[self.dataModel.gameIndex];
    [self calculateZhuShu];
    self.digitalRandomBtn.hidden = self.dataModel.gameIndex;
}

- (UIViewController *)getTrendVC {
    DPDltDrawVC *vcItem = [[DPDltDrawVC alloc] initWithTitles:[NSArray arrayWithObjects:@"常规", @"三区比", nil] withDocTitles:[NSArray arrayWithObjects:@"前区走势(红)", @"后区走势(蓝)", nil] titleSelectColor:[UIColor dp_flatRedColor] titleNormalColor:UIColorFromRGB(0x988B81) bottomImg:dp_AccountImage(@"selectedTop.png") redBall:((DPLBDltDataModel *)self.dataModel).redBallArray blueBall:((DPLBDltDataModel *)self.dataModel).blueBallArray];
    vcItem.modifyBalls = ^(int blue[16], int red[33]) {
        DPLBDltDataModel *model = self.dataModel;
        [model refreshBalls:blue redBalls:red];

    };

    return vcItem;
}
//提交
- (void)submitBtnClick {
    NSInteger normalRedCount = [self.dataModel numberOfSelectedBallsForRow:0 gameIndex:0];
    NSInteger normalBlueCount = [self.dataModel numberOfSelectedBallsForRow:1 gameIndex:0];
    NSInteger danRedCount = [self.dataModel numberOfSelectedBallsForRow:0 gameIndex:1];
    NSInteger tuoRedCount = [self.dataModel numberOfSelectedBallsForRow:1 gameIndex:1];
    NSInteger danBlueCount = [self.dataModel numberOfSelectedBallsForRow:2 gameIndex:1];
    NSInteger tuoBlueCount = [self.dataModel numberOfSelectedBallsForRow:3 gameIndex:1];

    if (self.dataModel.gameIndex == 0) {
        if (normalRedCount < 5) {
            [[DPToast makeText:@"至少选择5个前区"] show];
            return;
        }
        if (normalBlueCount < 2) {
            [[DPToast makeText:@"至少选择2个后区"] show];
            return;
        }
    } else if (self.dataModel.gameIndex == 1) {
        if (danRedCount < 1) {
            [[DPToast makeText:@"至少设置1个前区胆码"] show];
            return;
        }
        if (danRedCount + tuoRedCount < 6) {
            [[DPToast makeText:@"至少选择6个前区"] show];
            return;
        }

        if (tuoBlueCount < 2) {
            [[DPToast makeText:@"至少选择2个后区拖码"] show];
            return;
        }
    }
    int AddTargetReturn = [self.dataModel sendSubmitReq];
    if (AddTargetReturn >= 0) {
        [self.navigationController popViewControllerAnimated:YES];
        self.tranViewController.viewModel.gameIndex = self.dataModel.gameIndex;
        return;
    }
    [[DPToast makeText:@"提交失败"] show];
}
#pragma mark - DPDigitalBallCell delegate
- (void)tableViewScroll:(BOOL)stop {
    self.numberTable.scrollEnabled = stop;
}
//选中或者取消某个号码的时候
- (void)buyCell:(DPLBDigitalBallCell *)cell touchUp:(UIButton *)button {
    if ([self.numberTable isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.numberTable;
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        int index = button.tag & 0x0000FFFF;

        if (self.dataModel.gameIndex == 1 && indexPath.row == 0 && button.selected) {
            // 胆区最多五个球
            if ([self.dataModel numberOfSelectedBallsForRow:indexPath.row gameIndex:self.dataModel.gameIndex] >= 4) {
                [[DPToast makeText:@"至多4个前区胆码"] show];
            } else {
                [self.dataModel refreshBallSelected:button.selected index:index row:indexPath.row];
            }
        } else if (self.dataModel.gameIndex == 1 && indexPath.row == 2 && button.selected) {
            if ([self.dataModel numberOfSelectedBallsForRow:indexPath.row gameIndex:self.dataModel.gameIndex] >= 1) {
                [[DPToast makeText:@"至多1个后区胆码"] show];
            } else {
                 // 刷新选中状态
                [self.dataModel refreshBallSelected:button.selected index:index row:indexPath.row];
            }

        } else {
             // 刷新选中状态
            [self.dataModel refreshBallSelected:button.selected index:index row:indexPath.row];
        }
        [tableView reloadData];
        tableView.scrollEnabled = YES;
        [self calculateZhuShu];
    }
}

- (UIScrollView *)numberTable {
    if (_numberTable == nil) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _numberTable = tableView;
    }
    return _numberTable;
}

@end
