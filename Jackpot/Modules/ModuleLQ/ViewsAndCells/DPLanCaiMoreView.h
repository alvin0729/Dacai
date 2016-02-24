//
//  DPLanCaiMoreView.h
//  DacaiProject
//
//  Created by sxf on 14-8-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//篮彩玩法详情页面

#import <UIKit/UIKit.h>
@class PBMJclqMatch;
typedef void (^ReloadBlock)(void);

@interface DPBasketMoreViewController : UIViewController
- (instancetype)initWithGameType:(GameTypeId)gameType match:(PBMJclqMatch *)match;
@property (nonatomic, copy) ReloadBlock reloadBlock;

@end
