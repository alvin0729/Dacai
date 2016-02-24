//
//  DPTicketViewController.h
//  Jackpot
//
//  Created by sxf on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTicketViewController : UIViewController

@property(nonatomic,assign)GameTypeId gameType;//彩种类型
@property(nonatomic,assign)long long projectId;//方案号
@property(nonatomic,copy)NSString *drawTime;//开奖时间
@end
