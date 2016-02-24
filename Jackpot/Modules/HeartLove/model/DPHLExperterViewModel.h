//
//  DPHLExperterViewModel.h
//  Jackpot
//
//  Created by mu on 15/12/31.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPHLObject.h"
#import "Wages.pbobjc.h"
@interface DPHLExperterViewModel : NSObject
@property (nonatomic, strong) DPHLObject *headerObject;
@property (nonatomic, strong) ExpertWages *myWages;
@property (nonatomic, strong) ExpertWages *historyWages;
@property (nonatomic, strong) NSMutableArray *myWagesArray;
@property (nonatomic, strong) NSMutableArray *historyWagesArray;
@end
