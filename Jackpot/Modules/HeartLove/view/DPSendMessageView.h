//
//  DPSendMessageView.h
//  Jackpot
//
//  Created by mu on 16/1/7.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPSendMessageView : UIView
@property (nonatomic, copy) void (^sendMessageBlock)(NSString *message);
@end
