//
//  DPTimerCenter.h
//  Jackpot
//
//  Created by Ray on 15/8/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPTimerCenter : NSObject


+(instancetype)defaultCenter ;


-(void)startWithControllerName:(NSString*)controllerName ;
-(void)stopWithControllerName:(NSString*)controllerName ;
@end
