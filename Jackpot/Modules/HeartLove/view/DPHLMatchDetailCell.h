//
//  DPHLMatchDetailCell.h
//  Jackpot
//
//  Created by mu on 15/12/21.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBMJczqMatch ;
@class DPHLMatchDetailCell ;
@class DPBetToggleControl ;
/**
 *  赛事点击
 *
 *  @param currentCell 当前的cell
 *  @param control     点击的control
 *  @param gameType    点击的彩种
 *  @param index       点击的位置
 *  @param selected    是否选中
 */
typedef void(^DPControlSelected)(DPHLMatchDetailCell *currentCell ,DPBetToggleControl *control,GameTypeId gameType ,int index ,BOOL selected);

@interface DPHLMatchDetailCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *competitionLabel;   //赛事号 003
@property (nonatomic, strong, readonly) UILabel *orderNameLabel;     //赛事名字
@property (nonatomic, strong, readonly) UILabel *matchDateLabel;    // start time or end time 截止时间


@property (nonatomic, strong, readonly) UILabel *homeNameLabel;//主队名字
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;//客队名字
@property (nonatomic, strong, readonly) UILabel *homeRankLabel;//主队排名
@property (nonatomic, strong, readonly) UILabel *awayRankLabel;//客队排名
@property (nonatomic, strong, readonly) UILabel *middleLabel;//中间   VS  让球数
@property (nonatomic, strong, readonly) UILabel *rangQiuLabel;// 单关让球


@property (nonatomic, strong, readonly) UILabel *spfLabel;//胜平负让球数
@property (nonatomic, strong, readonly) UILabel *rqspfLabel;//让球胜平负让球数

@property (nonatomic, strong, readonly) UILabel *stopCellLabel; //停售
@property (nonatomic, strong, readonly) UILabel *stopCellspf; //停售

@property (nonatomic, strong, readonly) NSArray *optionButtonsRqspf;//让球胜平负
@property (nonatomic, strong, readonly) NSArray *optionButtonsSpf;//胜平负

@property(nonatomic,copy) DPControlSelected betControlSelected ;


@property (nonatomic, strong) PBMJczqMatch *match;

- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
