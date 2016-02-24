//
//  DPGameLiveBaseCell.h
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPGameLiveBaseCell;
@protocol DPGameLiveCellDelegate <NSObject>
@required
- (void)didTappedCell:(DPGameLiveBaseCell *)cell;
- (void)didToggleCell:(DPGameLiveBaseCell *)cell;
- (void)gameLiveCell:(DPGameLiveBaseCell *)cell attention:(BOOL)attention;
@end

@interface DPGameLiveInfoView : UIView
@property (nonatomic, strong) UILabel *matchTitleLabel;
@property (nonatomic, strong) UILabel *homeNameLabel;
@property (nonatomic, strong) UILabel *awayNameLabel;
@property (nonatomic, strong) UILabel *homeRankLabel;
@property (nonatomic, strong) UILabel *awayRankLabel;
@property (nonatomic, strong) UIImageView *homeLogoView;
@property (nonatomic, strong) UIImageView *awayLogoView;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *footballPulseLabel;
@property (nonatomic, strong) UILabel *basketballPulseLabel;

- (void)setMatchStatusAttributedTexts:(NSArray *)attributedTexts;
@end

@interface DPGameLiveBaseCell : UITableViewCell
@property (nonatomic, weak) id<DPGameLiveCellDelegate> delegate;
@property (nonatomic, strong) DPGameLiveInfoView *infoView;
@property (nonatomic, strong) id unfoldView;
@property (nonatomic, weak) UITableView *ownerTable;

+ (CGFloat)infoViewHeight;

@end
