//
//  DPChaseNumberInfoCell.h
//  Jackpot
//
//  Created by sxf on 15/12/10.
//  Copyright © 2015年 ；. All rights reserved.
//

#import <UIKit/UIKit.h>

//追号内容
@interface DPChaseNumberInfoCell : UITableViewCell
/**
 *  期号
 *
 *  @param text
 */
-(void)setIssueLabelText:(NSString *)text;
/**
 *  状态
 *
 *  @param text
 */
-(void)setStateLabel:(NSString *)text;
/**
 *  开奖号码
 *
 *  @param text
 */
-(void)setDrawLabelText:(NSMutableAttributedString *)text;
/**
 *  中奖情况
 *
 *  @param text
 */
-(void)setWinLabelText:(NSString *)text;
@end

//方案内容

@interface DPChaseNumberProjectHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong)UILabel *projectInfo;
@property(nonatomic,strong)UIView *lineView;
-(void)bulidLayOut;
@end
//追号内容
@interface DPChaseNumberContentHeaderView : UITableViewHeaderFooterView
-(void)bulidLayOut;
@end

