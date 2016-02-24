//
//  DPGameLiveViewController.h
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPGameLiveViewController : UIViewController

/**
 *  默认选择足球、篮球  0：足球   1：篮球
 */
@property (nonatomic, assign) NSInteger defaultIndex;
/**
 *  默认选择状态  0：未开始  1：已结束  2：关注
 */
@property (nonatomic, assign) NSInteger defaultItem;

@end
