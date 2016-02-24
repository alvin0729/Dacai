//
//  DPHLCommentViewController.h
//  Jackpot
//
//  Created by mu on 15/12/24.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPHLCommentViewController : UIViewController
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, copy) void(^getCommentCountBlock) (NSMutableAttributedString *commentCountAttribute);
@property (nonatomic, copy) void(^loginBlock)();
- (void)requestDataFromServer;
@end
