//
//  DPPrepogativeHeaderView.h
//  Jackpot
//
//  Created by mu on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DPPrepogativeHeaderViewBlock)(id sender);

@interface DPPrepogativeHeaderView : UIView
/**
 *  level
 */
@property (nonatomic, strong) UIImageView *levelIcon;
/**
 *  icon
 */
@property (nonatomic, strong) UIImageView *iconImage;
/**
 *  name
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 *  level
 */
@property (nonatomic, strong) UILabel *levelLabel;
/**
 *  growNum
 */
@property (nonatomic, strong) UILabel *growNumLabel;
/**
 *  upBlock
 */
@property (nonatomic, copy) DPPrepogativeHeaderViewBlock upBlock;
@end
