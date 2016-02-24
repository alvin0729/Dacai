//
//  DPPayRedPacketCell.h
//  Jackpot
//
//  Created by sxf on 15/8/27.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DPPayChargeCellDelegate;

//使用红包
@interface DPPayRedPacketCell : UITableViewCell
@property(nonatomic,strong,readonly)UILabel  *moneyLabel;
@property(nonatomic,assign)id<DPPayChargeCellDelegate>delegate;
//是否展开红包选项
-(void)analysisViewIsExpand:(BOOL)isExpand;

@end

//钱不够充值列表
@interface DPChargePayForCell : UITableViewCell
//设置充值图标
-(void)iconImageViewImage:(UIImage *)image;
//设置充值名称
-(void)payTitleString:(NSString *)payString;
//设置充值说明
-(void)payInfoString:(NSString *)payString;
//设置当前是否被选中
-(void)paySelectedView:(BOOL)isSelected;
@end

//彩种信息
@interface DPPayLotteryTitleCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconView;//彩种图标
@property(nonatomic,strong)UILabel *titleLabel;//彩种名称
@property(nonatomic,strong)UILabel *issueLabel;//彩种期号
@end

//方案金额，账户余额通用cell
@interface DPPayNormalCell : UITableViewCell

@property(nonatomic,strong)UILabel *normalTitleLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UIView *line;
@end

//钱不够订单时的提示信息
@interface NoPayInfocell : UITableViewCell

@property(nonatomic,strong)UILabel *payMoney;//还需支付多少钱
@property(nonatomic,strong)UILabel *payIntrouceLabel;
@end

//红包详情
@interface RedPacketInfocell : UITableViewCell
@property(nonatomic,assign)id<DPPayChargeCellDelegate>delegate;
@property(nonatomic,assign)int projectAmount;//方案金额
-(void)bulidLayOut:(NSArray *)array;//获取红包数据
@end

@protocol DPPayChargeCellDelegate <NSObject>

@optional
//点开红包页面
-(void)clickRedpacketInfo:(DPPayRedPacketCell *)cell;
//选择红包
-(void)selectedRedPacketIndex:(NSInteger)index;
@end

