//
//  DPHistoryTendencyCell.h
//  DacaiProject
//
//  Created by sxf on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  历史走势

#import <UIKit/UIKit.h>
#import "DPLBNumberProtocol.h"
@interface DPHistoryTendencyCell : UITableViewCell <DPLBCellDataModelProtocol>

@property (nonatomic, strong, readonly) UILabel *gameNameLab;//期号
@property (nonatomic, strong, readonly) UIImageView *ballView;//连接符
@property (nonatomic, strong, readonly) UILabel *gameInfoLab;//开奖信息
@property (nonatomic, assign) NSInteger lotteryType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier digitalType:(int)digitalType;
@end
