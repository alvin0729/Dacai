//
//  DPRedPacketView.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DPRedPacketView : UIView

@property (nonatomic, strong, readonly) UILabel *surplusLabel;
@property (nonatomic, strong, readonly) UILabel *limitLabel;
@property (nonatomic, strong, readonly) UILabel *validityLabel;
@property (nonatomic, strong, readonly) UILabel *signLabel;
@property (nonatomic, strong, readonly) UILabel *nameLabel;

@property (nonatomic, assign) int identifier;
@property (nonatomic, assign) int currentAmt;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

@end