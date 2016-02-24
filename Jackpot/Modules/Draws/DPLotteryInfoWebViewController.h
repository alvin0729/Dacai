//
//  DPLotteryInfoWebViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-10-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPWebViewController.h"
#import "NewsInfo.pbobjc.h"
@interface DPLotteryInfoWebViewController : DPWebViewController
/**
 *  第三方分享item
 */
@property (nonatomic, strong) PBMShareItem *shareItem;
- (instancetype)initWithGameType:(GameTypeId)gameType ;


 @end
