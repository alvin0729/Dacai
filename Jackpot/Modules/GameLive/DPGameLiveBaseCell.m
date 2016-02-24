//
//  DPGameLiveBaseCell.m
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveBaseCell.h"

@interface DPGameLiveStatusView : UIView
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;

- (instancetype)initWithLabel1:(UILabel *)label1 label2:(UILabel *)label2 label3:(UILabel *)label3;
@end

@implementation DPGameLiveStatusView

- (instancetype)initWithLabel1:(UILabel *)label1 label2:(UILabel *)label2 label3:(UILabel *)label3 {
    if (self = [super init]) {
        _label1 = label1;
        _label2 = label2;
        _label3 = label3;
    }
    return self;
}

//- (CGSize)intrinsicContentSize {
//    CGFloat height = 0;
//    if (_label1.text.length) {
//        height += _label1.intrinsicContentSize.height;
//    }
//    if (_label2.text.length) {
//        height += _label2.intrinsicContentSize.height;
//    }
//    if (_label3.text.length) {
//        height += _label3.intrinsicContentSize.height;
//    }
//    return CGSizeMake(0, height);
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    
//}

@end

@interface DPGameLiveInfoView ()
@property (nonatomic, strong) NSArray *matchStatusLabels;
@end

@implementation DPGameLiveInfoView

- (instancetype)init {
    if (self = [super init]) {
        [self setupProperty];
        [self setupConstraints];
    }
    return self;
}

- (void)setupProperty {
    _matchTitleLabel = [[UILabel alloc] init];
    _matchTitleLabel.font = [UIFont dp_systemFontOfSize:11];
    _matchTitleLabel.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
    
    _commentButton = [[UIButton alloc] init];
    _commentButton.titleLabel.font = [UIFont dp_systemFontOfSize:12];
    [_commentButton setTitleColor:[UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1] forState:UIControlStateNormal];
    [_commentButton setImage:dp_GameLiveImage(@"comment.png") forState:UIControlStateNormal];
    [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
    
    _homeNameLabel = [[UILabel alloc] init];
    _homeNameLabel.font = [UIFont dp_systemFontOfSize:13];
    _homeNameLabel.textColor = [UIColor dp_flatBlackColor];
    
    _awayNameLabel = [[UILabel alloc] init];
    _awayNameLabel.font = [UIFont dp_systemFontOfSize:13];
    _awayNameLabel.textColor = [UIColor dp_flatBlackColor];
    
    _homeRankLabel = [[UILabel alloc] init];
    _homeRankLabel.font = [UIFont dp_systemFontOfSize:10];
    _homeRankLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    
    _awayRankLabel = [[UILabel alloc] init];
    _awayRankLabel.font = [UIFont dp_systemFontOfSize:10];
    _awayRankLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    
    _matchStatusLabels = @[[[UILabel alloc] init], [[UILabel alloc] init], [[UILabel alloc] init]];
    
    _homeLogoView = [[UIImageView alloc] init];
    
    _awayLogoView = [[UIImageView alloc] init];
    
    _footballPulseLabel = [[UILabel alloc] init];
    _footballPulseLabel.text = @"'";
    _footballPulseLabel.textColor = [UIColor dp_flatBlackColor];
    _footballPulseLabel.font = [UIFont dp_systemFontOfSize:12];
    _footballPulseLabel.backgroundColor = [UIColor clearColor];
    _footballPulseLabel.hidden = YES;
    
    _basketballPulseLabel = [[UILabel alloc] init];
    _basketballPulseLabel.text = @"'";
    _basketballPulseLabel.textColor = [UIColor dp_flatBlackColor];
    _basketballPulseLabel.font = [UIFont dp_systemFontOfSize:12];
    _basketballPulseLabel.backgroundColor = [UIColor clearColor];
    _basketballPulseLabel.hidden = YES;
    
    _toggleButton = [[UIButton alloc] init];
    [_toggleButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    [_toggleButton setImage:dp_CommonImage(@"brown_smallarrow_down.png") forState:UIControlStateNormal];
    [_toggleButton setImage:dp_CommonImage(@"brown_smallarrow_up.png") forState:UIControlStateSelected];
    
    _startButton = [[UIButton alloc] init];
    [_startButton setImage:dp_GameLiveImage(@"guanzhunormal.png") forState:UIControlStateNormal];
    [_startButton setImage:dp_GameLiveImage(@"guanzhuselected.png") forState:UIControlStateSelected];
}

- (void)setupConstraints {
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:dp_CommonImage(@"下一步按钮.png")];
    UIView *matchStatusView = ({
        UILabel *vLabel1 = self.matchStatusLabels[0];
        UILabel *vLabel2 = self.matchStatusLabels[1];
        UILabel *vLabel3 = self.matchStatusLabels[2];
        UIView *view = [[UIView alloc] init];
        [view addSubview:vLabel1];
        [view addSubview:vLabel2];
        [view addSubview:vLabel3];
        [vLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view);
            make.centerX.equalTo(view);
        }];
        [vLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(vLabel1.mas_bottom);
            make.centerX.equalTo(view);
        }];
        [vLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(vLabel2.mas_bottom);
            make.centerX.equalTo(view);
            make.bottom.equalTo(view);
        }];
        view;
    });
    
    [self addSubview:self.matchTitleLabel];
    [self addSubview:self.commentButton];
    [self addSubview:self.homeNameLabel];
    [self addSubview:self.awayNameLabel];
    [self addSubview:self.homeRankLabel];
    [self addSubview:self.awayRankLabel];
    [self addSubview:self.homeLogoView];
    [self addSubview:self.awayLogoView];
    [self addSubview:self.toggleButton];
    [self addSubview:self.startButton];
    [self addSubview:self.footballPulseLabel];
    [self addSubview:self.basketballPulseLabel];
    [self addSubview:arrowImageView];
    [self addSubview:matchStatusView];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
    [self.matchTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(5);
        make.height.equalTo(@15);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.matchTitleLabel);
    }];
    [self.homeLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.matchTitleLabel.mas_bottom).offset(7.5);
        make.height.and.width.equalTo(@40);
    }];
    [self.awayLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.matchTitleLabel.mas_bottom).offset(7.5);
        make.height.and.width.equalTo(@40);
    }];
    [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.homeLogoView);
        make.top.equalTo(self.homeLogoView.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.awayLogoView);
        make.top.equalTo(self.awayLogoView.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    [self.homeRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.homeNameLabel);
        make.right.equalTo(self.homeNameLabel.mas_left).offset(-3);
    }];
    [self.awayRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.awayNameLabel);
        make.left.equalTo(self.awayNameLabel.mas_right).offset(3);
    }];
    [matchStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.homeLogoView.mas_right);
        make.right.equalTo(self.awayLogoView.mas_left);
        make.center.equalTo(self);
        make.width.equalTo(@120);
    }];
    [self.toggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@40);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@10);
        make.width.and.height.equalTo(@40);
    }];
    
    [self.footballPulseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.matchStatusLabels.firstObject);
        make.left.equalTo(((UILabel *)self.matchStatusLabels.firstObject).mas_right);
    }];
    [self.basketballPulseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.matchStatusLabels.lastObject);
        make.left.equalTo(((UILabel *)self.matchStatusLabels.lastObject).mas_right);
    }];
   
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setMatchStatusAttributedTexts:(NSArray *)attributedTexts {
    for (int i = 0; i < 3; i++) {
        UILabel *label = self.matchStatusLabels[i];
        label.attributedText = i < attributedTexts.count ? attributedTexts[i] : nil;
    }
}

@end

@implementation DPGameLiveBaseCell
@dynamic unfoldView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self setupProperty];
        [self setupConstraints];
    }
    return self;
}

- (void)setupProperty {
    _infoView = [[DPGameLiveInfoView alloc] init];
    
    [self.infoView.toggleButton addTarget:self action:@selector(didExpand) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView.startButton addTarget:self action:@selector(didAttention) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConstraints {
    if ([self respondsToSelector:@selector(unfoldView)]) {
        [self.contentView addSubview:self.infoView];
        [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.equalTo(self.contentView);
            make.height.equalTo(@([DPGameLiveBaseCell infoViewHeight]));
        }];
        [self.contentView addSubview:self.unfoldView];
        [self.unfoldView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoView.mas_bottom);
            make.left.and.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
    } else {
        [self.contentView addSubview:self.infoView];
        [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}

- (void)didExpand {
    if ([self.delegate respondsToSelector:@selector(didToggleCell:)]) {
        [self.delegate didToggleCell:self];
    }
}

- (void)didAttention {
    self.infoView.startButton.selected = !self.infoView.startButton.selected;
    if ([self.delegate respondsToSelector:@selector(gameLiveCell:attention:)]) {
        [self.delegate gameLiveCell:self attention:self.infoView.startButton.selected];
    }
}

+ (CGFloat)infoViewHeight {
    return 5 + 15 + 5 + 40 + 5 + 20 + 5 + 5;
}

@end
