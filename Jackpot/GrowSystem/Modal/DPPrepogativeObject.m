//
//  DPPrepogativeObject.m
//  Jackpot
//
//  Created by mu on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPPrepogativeObject.h"


@implementation DPPrepogativeObject
- (CGFloat)height{
    if (!_height) {
        NSInteger i = self.prepogativeArray.count%2;
        if (i==0) {
             _height = 80+70*(self.prepogativeArray.count/2);
        }else{
            _height = 80+70*(self.prepogativeArray.count/2+1);
        }
       
    }
    return _height;
}
@end
