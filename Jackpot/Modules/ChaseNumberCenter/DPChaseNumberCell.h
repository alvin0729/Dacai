//
//  DPChaseNumberCell.h
//  Jackpot
//
//  Created by sxf on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//  追号中心cell

#import <UIKit/UIKit.h>

@interface DPChaseNumberCell : UITableViewCell

@property(nonatomic,strong,readonly)UIImageView *iconImageView;

/**
 *  彩种名称
 *
 *  @param text
 */
-(void)lotteryNameLabelText:(NSString *)text;
/**
 *  追号时间
 *
 *  @param text
 */
-(void)orderTimeLabelText:(NSString *)text;
/**
 *  追号信息
 *
 *  @param text
 */
-(void)chaseInfoLabeltext:(NSString *)text;
@end
