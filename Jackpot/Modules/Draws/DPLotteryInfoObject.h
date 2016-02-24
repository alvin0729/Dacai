//
//  DPLotteryInfoObject.h
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPLotteryInfoObject : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *subValue;
@property (nonatomic, copy) NSString *iconImage;
@property (nonatomic, assign) BOOL isSubscrib;
@end
