//
//  DPShareView.h
//  DacaiProject
//
//  Created by jacknathan on 14-12-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  分享界面

#import <UIKit/UIKit.h>
#import "DPThirdCallCenter.h"
@protocol DPShareViewDelegate <NSObject>
@optional
- (void)shareWithThirdType:(kThirdShareType)type;
- (void)moreFunButtonClick;
@end

@interface DPShareView : UIView
@property (nonatomic, weak) id <DPShareViewDelegate> delegate;
- (instancetype)initWithShowMoreFun:(BOOL)showMoreFun;
- (void)showAnimation;
@end
