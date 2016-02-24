//
//  DPShareThumbImageViewController.h
//  Jackpot
//
//  Created by mu on 15/12/10.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPShareRootViewController.h"

@interface DPShareThumbImageViewController : UIViewController
@property (nonatomic, strong) shareObject *object;
@property (nonatomic, copy) void (^dismissBlock)();
@end
