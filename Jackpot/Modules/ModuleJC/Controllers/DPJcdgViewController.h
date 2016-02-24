//
//  DPJcdgViewController.h
//  DacaiProject
//
//  Created by jacknathan on 15-1-16.
//  Copyright (c) 2015年 dacai. All rights reserved.
// 

#import <UIKit/UIKit.h>

#import "DPJcdgTableCells.h"

typedef void(^CurrentType)(MyGameType type);

@interface DPJcdgViewController : UIViewController

/**
 *  记录退出时是篮球还是足球
 */
@property(nonatomic,copy)CurrentType CurrentType ;
/**
 *  进入时的位置
 *
 *  @param type 0 足球 1篮球
 *
 *  @return 
 */
- (instancetype)initWithGameType:(MyGameType)type ;


@end
