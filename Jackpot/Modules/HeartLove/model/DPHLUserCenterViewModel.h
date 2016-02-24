//
//  DPHLUserCenterViewModel.h
//  Jackpot
//
//  Created by mu on 15/12/30.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPHLObject.h"
#import "Wages.pbobjc.h"
@interface DPHLUserCenterViewModel : NSObject
@property (nonatomic, strong) DPHLObject *headerObject;
@property (nonatomic, strong) MyWages *myWages;
@property (nonatomic, strong) MyWages *myBuys;
@property (nonatomic, strong) MyFollow *myFollows;
@property (nonatomic, strong) NSMutableArray *myWagesArray;
@property (nonatomic, strong) NSMutableArray *myBuysArray;
@property (nonatomic, strong) NSMutableArray *myFocusArray;
@end
