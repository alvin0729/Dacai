//
//  DPLiveOddsPositionDetailVC.h
//  DacaiProject
//
//  Created by Ray on 14/12/16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPLiveOddsPositionDetailVC : UIViewController
 /**
 *  初始化
 *
 *  @param gameType    彩种
 *  @param index       选中的位置
 *  @param companyIndx 公司在数组中的角标
 *  @param matchid     matchId
 *
 *  @return self
 */
- (instancetype)initWIthGameType:(GameTypeId)gameType withSelectIndex:(int)index companyIndx:(int)companyIndx withMatchId:(NSInteger)matchid;

/**
 *  公司数组
 */
@property(nonatomic,strong)NSArray *companyNames ;
 

@end


//详情页面左侧tableViewCell
@interface OddsPositionDetailCell : UITableViewCell
/**
 *  公司名
 */
@property(nonatomic,strong)UILabel* nameLabel ;

@end
