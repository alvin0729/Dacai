//
//  DPLBNumberCells.h
//  DacaiProject
//
//  Created by jacknathan on 15-1-22.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  投注单元格集合

#import <Foundation/Foundation.h>
#import "DPLBNumberProtocol.h"

// cell的代理协议
@protocol DPLBCellDelegateProtocol <NSObject>
@required
- (void)buyCell:(UITableViewCell *)cell touchUp:(UIButton *)button;
@optional
- (void)tableViewScroll:(BOOL)stop;
- (void)buyCell:(UITableViewCell *)cell touchDown:(UIButton *)button;
@end

#define yilouSpace  20
#define noYilouSpace 7
#define ballHeight   35

@interface DPLBDigitalBallCell : UITableViewCell <DPLBCellDataModelProtocol>
@property(nonatomic,strong,readonly)UILabel *titleLabel;//提示信息
@property(nonatomic,assign)int ballstotal;//球的总数
@property(nonatomic,assign)int ballsColor;//球的颜色
@property(nonatomic,assign)int selectedMaxTotal;
@property(nonatomic,assign)id<DPLBCellDelegateProtocol>delegate;
@property(nonatomic,assign)int lotteryType;
@property(nonatomic,strong)UIView *ballView;

/**
 *  生成单元行
 *
 *  @param style           cell风格
 *  @param reuseIdentifier
 *  @param balltotal       选项个数
 *  @param ballColorIndex  选项颜色
 *  @param selectedTotal   最大能选中个数
 *  @param type            彩种玩法
 *
 *  @return <#return value description#>
 */
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          balltotal:(int)balltotal
          ballColor:(int)ballColorIndex
       ballSelected:(int)selectedTotal
        lotteryType:(int)type;

//遗漏值
-(void)openOrCloseYilouZhi:(BOOL)isOpen;
//改变Top距离
-(void)oneRowTitleRect:(float)height;
//改变高度
-(void)oneRowTitleHeight:(float)height;
@end


 