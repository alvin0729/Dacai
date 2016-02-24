//
//  DPResultListViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPResultListViewController : UIViewController

@property (nonatomic, assign) GameTypeId gameType;

@property(nonatomic,assign) BOOL isFromClickMore;

@property(nonatomic,copy)NSString  *gameTime;//选择的时间（竞彩足球，竞彩篮球）
@end
