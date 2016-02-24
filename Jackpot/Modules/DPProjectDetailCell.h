//
//  DPProjectDetailCell.h
//  Jackpot
//
//  Created by sxf on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  追号详情cell

#import <UIKit/UIKit.h>
@class DPJcProjectDetailCell;
@class DPJcOptimizeProjectDetailCell;
@class DPJcOptimizeView;
typedef void (^clickJcProjectDetailBlock)(DPJcProjectDetailCell *toggleCell ,BOOL isShow);
typedef void (^clickOptimizeBlock)(DPJcOptimizeProjectDetailCell *optimizeCell);
//大乐透方案详情
@interface DPProjectDetailCell : UITableViewCell
@property(nonatomic,strong,readonly)UILabel *infoLabel;//详情
@property(nonatomic,strong)UIImageView *lineView;
//类型和注数
-(void)titleLabelText:(NSString *)typeText;
//详情
-(void)infoLabelText:(NSMutableAttributedString *)hinString;
@end

//竞彩方案详情
@interface DPJcProjectDetailCell : UITableViewCell

@property(nonatomic,strong,readonly)UILabel *leftNameLabel;//左边队名称
@property(nonatomic,strong,readonly)UILabel *rightNameLabel;//右边对名称
@property(nonatomic,strong,readonly)UILabel *infoLabel;//彩种选项
@property(nonatomic,strong,readonly)UIImageView *danImageView;//是否设胆
@property (nonatomic, copy) clickJcProjectDetailBlock clickBlock;
//场次
-(void)orderNumberText:(NSString *)text;
//彩种信息
-(void)resultText:(NSString *)text;
-(void)imageSelectedView:(BOOL)isShow;
@end

//优化投注
@interface DPJcOptimizeProjectDetailCell : UITableViewCell

@property (nonatomic, copy) clickOptimizeBlock clickBlock;
//获取单注信息
-(void)setOptimizeInfoLabelText:(NSString *)text;
//获取注数
-(void)setZhuLabelText:(NSString *)text;
//获取理论奖金
-(void)setBonusLabelText:(NSString *)text;
-(void)analysisViewIsExpand:(BOOL)isExpand;//箭头变化
@end
//优化投注详情
@interface DPJcOptimizeListProjectDetailCell : UITableViewCell

@property(nonatomic,strong)NSMutableArray *viewArray;
-(void)bulidOutForRowCount:(NSInteger)rowCount;
@end

@interface DPProjectHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong,readonly)UILabel *ticketLabel;//票样
//获取当前需要显示的行数并渲染
-(void)bulidLayOutGameType:(GameTypeId)gameType;
//获取方案内容
-(void)projectInfoText:(NSString *)infoText;

//获取过关方式
-(void)passLabelText:(NSString *)passText;
//是否展示部分出票
-(void)isShowTicketImage:(BOOL)isShow;
@end

//优化详情头部
@interface DPOptimizeHeaderView : UITableViewHeaderFooterView

-(void)bulidLayOut;
@end

//优化详情每一行的视图
@interface DPJcOptimizeView : UIView
{
@private
    UILabel *_screeningLabel;
    UILabel *_homeNameLabel;
    UILabel *_awayNameLabel;
    UILabel *_optionLabel;
}
@property(nonatomic,strong,readonly)UILabel *screeningLabel;//场次
@property(nonatomic,strong,readonly)UILabel *homeNameLabel;//主队
@property(nonatomic,strong,readonly)UILabel *awayNameLabel;//客队
@property(nonatomic,strong,readonly)UILabel *optionLabel;//选项
@end
