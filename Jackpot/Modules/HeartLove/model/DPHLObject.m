//
//  DPHLObject.m
//  Jackpot
//
//  Created by mu on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLObject.h"

@implementation DPHLObject
- (void)setMarksArray:(NSMutableArray *)marksArray{
    _marksArray = marksArray;
    for (NSInteger i = 0; i < marksArray.count; i++) {
        NSString *title = marksArray[i];
        if (title.length==0) {
            [marksArray removeObject:title];
        }
    }
}

@end
