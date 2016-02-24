//
//  DPHLHomeViewModel.h
//  Jackpot
//
//  Created by mu on 15/12/29.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPHLObject.h"
#import "Wages.pbobjc.h"
@interface DPHLHomeViewModel : NSObject
@property (nonatomic, strong) WagesHome *homeData;
@property (nonatomic, strong) DPHLObject *headerObject;
@property (nonatomic, strong) NSMutableArray *tableData;
@end
