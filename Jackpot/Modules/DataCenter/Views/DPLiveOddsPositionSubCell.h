//
//  DPLiveOddsPositionSubCell.h
//  Jackpot
//
//  Created by wufan on 15/9/12.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPLiveDataCenterViews.h"

@interface DPLiveOddsPositionSubCell : UITableViewCell
@property(nonatomic,strong)UIImageView* noDataImgLabel ;
@property(nonatomic,strong)DPLiveOddsHeaderView *itemView ;
/**
 *  初始化
 *
 *  @param widArray        宽度数组
 *  @param reuseIdentifier reuseIdentifier
 *  @param height          高度
 *
 *  @return DPLiveOddsPositionSubCell
 */
-(instancetype)initWithWidArray:(NSArray*)widArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height ;

@end
