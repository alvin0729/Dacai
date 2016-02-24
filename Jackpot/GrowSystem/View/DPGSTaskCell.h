//
//  DPGSTaskCell.h
//  Jackpot
//
//  Created by mu on 15/7/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGSTaskObject.h"
#import <UIKit/UIKit.h>
typedef void (^btnTapBlock)(UIButton *btn);
@interface DPGSTaskCell : UITableViewCell
/**
 *  object
 */
@property (nonatomic, strong) DPGSTaskObject *object;
/**
 *  getBtnBlock
 */
@property (nonatomic, copy) btnTapBlock getBlock;
/**
 *  sellBtnBlock
 */
@property (nonatomic, copy) btnTapBlock sellBlock;

@end
