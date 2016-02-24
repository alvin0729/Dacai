//
//  DPJczqTransferCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  竞彩足球中转单元格

#import <UIKit/UIKit.h>

@protocol DPJczqTransferCellDelegate;

@class DPJczqTransferCell;
typedef void (^ShowDetailBlock)(DPJczqTransferCell *curCell);
@interface DPJczqTransferCell : UITableViewCell

@property (nonatomic, assign) GameTypeId gameType;    //彩种类型
@property (nonatomic, weak) id<DPJczqTransferCellDelegate> delegate;
@property (nonatomic, strong, readonly) UILabel *homeNameLabel;       //主队名称
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;       //客队名称
@property (nonatomic, strong, readonly) UILabel *middleLabel;         //中间--vs（让球）
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel;    //序号
@property (nonatomic, strong, readonly) UIButton *markButton;         //胆拖按钮
@property (nonatomic, strong, readonly) UILabel *contentLabel;        //比分  总进球  半全场  选择记录

@property (nonatomic, strong, readonly) NSArray *betOptionSpf;    //胜平负（让球胜平负赔率）

@property (nonatomic, copy) ShowDetailBlock showDetail;
- (void)buildLayout;

@end

@protocol DPJczqTransferCellDelegate <NSObject>
@required

//胜平负-让球胜平负  修改选择概率
- (void)jczqTransferCell:(DPJczqTransferCell *)cell gameType:(GameTypeId)gameType index:(int)index selected:(BOOL)selected;
//设置胆拖
- (void)jczqTransferCell:(DPJczqTransferCell *)cell mark:(BOOL)selected;
- (BOOL)shouldMarkJczqTransferCell:(DPJczqTransferCell *)cell;
//删除本条赛事
- (void)deleteJczqTransferCell:(DPJczqTransferCell *)cell;
@end