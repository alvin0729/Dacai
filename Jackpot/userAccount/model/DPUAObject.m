//
//  DPUAObject.m
//  Jackpot
//
//  Created by mu on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUAObject.h"

@implementation DPUAObject
- (NSString *)fundIconName{
    if (!_fundIconName) {
           switch (self.fundType) {
            case TopUp:
                _fundIconName = @"UAFundRechange.png";
                break;
            case Drawing:
                _fundIconName = @"UAFundDraw.png";
                break;
            case Buy:
                _fundIconName = @"UABuyTicket.png";
                break;
            case Awarded:
                _fundIconName = @"UAFundReward.png";
                break;
            case SysPresent:
                _fundIconName = @"UAFundRechange.png";
                break;
            case SysTopUp:
                _fundIconName = @"UAFundRechange.png";
                break;
            case SysDrawing:
                _fundIconName = @"UAFundCut.png";
                break;
            case SysrRefund:
                _fundIconName = @"UAFundCut.png";
                break;
            default:
                break;
        }
    }
    return _fundIconName;
}


@end
