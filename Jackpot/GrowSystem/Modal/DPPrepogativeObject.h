//
//  DPPrepogativeObject.h
//  Jackpot
//
//  Created by mu on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    DPPrepogativeCurrentLevel,
    DPPrepogativeLastLevel,
    DPPrepogativeFutureLevel
}DPPrepogativeLevelState;

@interface DPPrepogativeObject : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *levelStr;
@property (nonatomic, strong) NSMutableArray *prepogativeArray;
@property (nonatomic, strong) NSMutableArray *prepogativeimageArray;
@property (nonatomic, assign) DPPrepogativeLevelState myLevel;
@end
