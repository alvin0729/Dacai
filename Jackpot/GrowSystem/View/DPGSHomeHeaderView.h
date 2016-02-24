//
//  DPGSHomeHeaderView.h
//  Jackpot
//
//  Created by mu on 15/7/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPGSHomeHeaderObject.h"

typedef void (^btnTappBlock)(UIButton *btn);
typedef void (^DPGSHomeHeaderViewBlock)(id sender);

@interface DPGSHomeHeaderView : UIView
/**
 *  object
 */
@property (nonatomic, strong)DPGSHomeHeaderObject *object;
/**
 *  block
 */
@property (nonatomic, copy)btnTappBlock tapBlock;
/**
 *  levelTapped
 */
@property (nonatomic, copy)btnTappBlock levelTappedBlock;
/**
 *  icon
 */
@property (nonatomic, strong)UIImageView *iconImage;
/**
 *  name
 */
@property (nonatomic, strong)UILabel *nameLabel;


@end
