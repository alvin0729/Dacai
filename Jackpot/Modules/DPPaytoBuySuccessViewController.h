//
//  DPPaytoBuySuccessViewController.h
//  DacaiProject
//
//  Created by sxf on 14/11/17.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  未支付成功页面

#import <UIKit/UIKit.h>

@interface DPPaytoBuySuccessViewController : UIViewController


@property(nonatomic,assign)long long projectId;//方案/追号id
@property(nonatomic,assign)GameTypeId gameType;//彩种id
@property(nonatomic,copy)NSString *drawTime;//开奖时间
@property(nonatomic,assign)BOOL isChase;//是否追号
@end
