//
//  DPJczqOptimizeViewController.h
//  Jackpot
//
//  Created by Ray on 15/12/8.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPJczqOptimizeViewController : UIViewController

//@property (nonatomic, strong, readonly) UITextField *moneyTextField; //预算金额field
@property (nonatomic, strong, readonly) UILabel *passModeLabel; //过关方式
@property (nonatomic, strong, readonly) UITextField *multipleField;//倍数
/**
 *  彩种类型
 */
@property(nonatomic, assign)GameTypeId gameType ;
/**
 *  过关方式
 */
@property(nonatomic,strong) NSArray *passModeList ;
/**
 *  存储对象数组
 */
@property(nonatomic,strong) NSArray *optionList ;
/**
 *  赛事数组
 */
@property(nonatomic,strong) NSArray *matchList ;



@end
