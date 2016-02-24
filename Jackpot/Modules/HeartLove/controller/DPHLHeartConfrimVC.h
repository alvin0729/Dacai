//
//  DPHLHeartConfrimVC.h
//  Jackpot
//
//  Created by Ray on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPJczqDataModel.h"

@class WagesUserInfo ;
@interface DPHLHeartConfrimVC : UIViewController

/**
 *  选中的赛事
 */
@property (nonatomic, strong) PBMJczqMatch *match ;
/**
 *  彩种选中的位置角标
 */
@property  (nonatomic ,assign) NSInteger selectedIndex  ;

/**
 *  选择的比赛类型
 */
@property  (nonatomic ,assign) GameTypeId gameType  ;

/**
 *  用户信息
 */
@property (nonatomic ,assign) WagesUserInfo *userInfo ;//用户信息


@end
