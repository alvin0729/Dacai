//
//  DPJcLqTransferCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//篮彩中转单元格

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DPJclqTransferCellEvent) {
    DPJclqTransferCellEventDelete,
    DPJclqTransferCellEventMark,
    DPJclqTransferCellEventOption,
};
@protocol DPJcLqTransferCellDelegate;

@class DPJcLqTransferCell;
typedef void (^ShowDetailBlock)(DPJcLqTransferCell *curCell);

@interface DPJcLqTransferCell : UITableViewCell
@property (nonatomic, assign) GameTypeId gameType;    //彩种类型
@property (nonatomic, weak) id<DPJcLqTransferCellDelegate> delegate;
@property (nonatomic, strong, readonly) UILabel *homeNameLabel;       //主队名称
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;       //客队名称
@property (nonatomic, strong, readonly) UILabel *middleLabel;         //中间--vs（让球）
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel;    //序号
@property (nonatomic, strong, readonly) UIButton *markButton;         //胆拖按钮
@property (nonatomic, strong, readonly) UILabel *contentLabel;        // 选择记录
@property (nonatomic, strong) UIButton *jclqtleftBtn, *jclqtRightBtn;

@property (nonatomic, copy) ShowDetailBlock showDetail;

- (void)buildLayout;
- (void)loadDragView;
- (void)loadRfDragView;

@end
@protocol DPJcLqTransferCellDelegate <NSObject>
@required
- (void)jclqTransferCell:(DPJcLqTransferCell *)cell event:(DPJclqTransferCellEvent)event;
//设置胆拖
- (BOOL)shouldMarkJclqTransferCell:(DPJcLqTransferCell *)cell;
//选择概率
- (void)jclqTranCell:(DPJcLqTransferCell *)cell selectedIndex:(int)selectedIndex isSelected:(int)isSelected;
@end