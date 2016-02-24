//
//  DPShareRootViewController.h
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface shareObject : NSObject
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, copy) NSString *shareUrl;
@end


@interface DPShareRootViewController : UIViewController
@property (nonatomic, strong) shareObject *object;
@end
