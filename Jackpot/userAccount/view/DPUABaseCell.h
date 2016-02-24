//
//  DPUABaseCell.h
//  Jackpot
//
//  Created by mu on 15/8/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPUAObject.h"
@interface DPUABaseCell : UITableViewCell
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *firstLine;
@property (nonatomic, strong) UIView *lastLine;
@property (nonatomic, strong) DPUAObject *object;//数据源
@end
