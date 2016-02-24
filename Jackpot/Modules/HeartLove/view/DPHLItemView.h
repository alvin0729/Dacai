//
//  DPHLItemView.h
//  Jackpot
//
//  Created by mu on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPHLItemView : UIView
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *hlIconImage;
@property (nonatomic, strong) UILabel *matchTitleLab;
@property (nonatomic, strong) UILabel *matchValueLab;
@property (nonatomic, strong) UILabel *buyCountLabel;
@property (nonatomic, strong) UILabel *awardValueLabel;
@property (nonatomic, strong) UIImageView *buyIcon;
@property (nonatomic, strong) UIImageView *awardIcon;
@end
