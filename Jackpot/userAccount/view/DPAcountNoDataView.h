//
//  DPNoDataView.h
//  Jackpot
//
//  Created by mu on 15/10/27.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPAcountNoDataView : UIView
/**
 *  image
 */
@property (nonatomic, strong)UIImageView *iconImage;
/**
 *  title
 */
@property (nonatomic, strong)UILabel *titleLabel;
/**
 *  btn
 */
@property (nonatomic, strong)UIButton *btn;
/**
 *
 */
@property (nonatomic, copy)void (^btnTappedBlock)();

@end
