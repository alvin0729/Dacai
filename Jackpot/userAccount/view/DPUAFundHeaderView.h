//
//  DPUAFundHeaderView.h
//  Jackpot
//
//  Created by mu on 15/8/31.
//  Copyright (c) 2015年 dacai. All rights reserved.
//



@interface DPUAFundHeaderView : UIView

@property (nonatomic, strong) UILabel *fundValueLabel;//账户金额

@property (nonatomic, strong) UILabel *fundTitleLabel;//账户总金额标示

@property (nonatomic, strong) UILabel *useableValueLabel;//可用余额

@property (nonatomic, strong) UILabel *useableTitleLabel;//可用余额标示

@property (nonatomic, strong) UILabel *frozenValueLabel;//冻结金额

@property (nonatomic, strong) UILabel *frozenTitleLabel;//冻结金额标示

@property (nonatomic, strong) UIView *upHonLine;//上分割线

@property (nonatomic, strong) UIView *downVerLine;//下分割线

@property (nonatomic, strong) UIImageView *fundIcon;//金钱标示符
@end
