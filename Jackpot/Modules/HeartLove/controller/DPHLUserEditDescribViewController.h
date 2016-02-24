//
//  DPHLUserEditDescribViewController.h
//  Jackpot
//
//  Created by mu on 16/1/15.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPHLUserEditDescribViewController : UIViewController
/**
 *  用户简介
 */
@property (nonatomic, copy) NSString *userDescrib;
/**
 *  用户编辑成功block
 */
@property (nonatomic, copy) void (^editSuccessBlock)();
@end
