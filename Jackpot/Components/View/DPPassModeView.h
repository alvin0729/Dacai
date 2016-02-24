//
//  DPPassModeView.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  选择过关方式

#import <UIKit/UIKit.h>

@protocol DPPassModeViewDelegate;

@interface DPPassModeView : UICollectionView

@property (nonatomic, weak) id<DPPassModeViewDelegate> passModeDelegate;
@property (nonatomic, strong) NSArray *freedoms;
@property (nonatomic, strong) NSArray *combines;

@end

@protocol DPPassModeViewDelegate <NSObject>
@required

//点击多串过关
- (void)passModeView:(DPPassModeView *)passModeView expand:(BOOL)expand;
//选择过关方式
- (void)passModeView:(DPPassModeView *)passModeView toggle:(NSInteger)passModeTag;
//获取过关信息
- (BOOL)passModeView:(DPPassModeView *)passModeView isSelectedModel:(NSInteger)passModeTag;
@end