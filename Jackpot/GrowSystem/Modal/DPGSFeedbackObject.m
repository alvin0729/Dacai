//
//  DPGSFeedbackObject.m
//  Jackpot
//
//  Created by mu on 15/7/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGSFeedbackObject.h"

@implementation DPGSFeedbackObject
- (CGFloat)cellHeight{
    if (!_cellHeight) {
        CGSize contentSize = [NSString dpsizeWithSting:self.contentStr andFont:[UIFont systemFontOfSize:14] andMaxWidth:[UIScreen mainScreen].bounds.size.width*0.6];
        _cellHeight = contentSize.height+50;
        if (_cellHeight<44) {
            _cellHeight = 44;
        }
    }
    return _cellHeight;
}
@end
