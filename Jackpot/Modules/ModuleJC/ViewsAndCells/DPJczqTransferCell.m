//
//  DPJczqTransferCell.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJczqTransferCell.h"
#import "DPDragView.h"
#import "DPBetToggleControl.h"

@interface DPJczqTransferCell () {
@private
    UILabel *_homeNameLabel;
    UILabel *_awayNameLabel;
    UILabel *_middleLabel;
    UILabel *_orderNumberLabel;
    UIButton *_markButton;
    UIButton *_deleteButton;
    
    UILabel *_contentLabel;
}

@property (nonatomic, strong, readonly) UIButton *deleteButton;

@end

@implementation DPJczqTransferCell
@dynamic homeNameLabel;
@dynamic awayNameLabel;
@dynamic middleLabel;
@dynamic orderNumberLabel;
@dynamic markButton;
@dynamic deleteButton;
@dynamic contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        self.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return self;
}

- (void)buildLayout {
    UIView *bottomLine = [UIView dp_viewWithColor:[UIColor colorWithRed:0.95 green:0.94 blue:0.93 alpha:1]];
    UIView *leftLine = [UIView dp_viewWithColor:[UIColor colorWithRed:0.86 green:0.83 blue:0.77 alpha:1]];
    UIView *rightLine = [UIView dp_viewWithColor:[UIColor colorWithRed:0.86 green:0.83 blue:0.77 alpha:1]];
    
    UIView *contentView = self.contentView;
    
    [contentView addSubview:bottomLine];
    [contentView addSubview:leftLine];
    [contentView addSubview:rightLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@0.5);
    }];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.right.equalTo(contentView);
        make.width.equalTo(@0.5);
    }]; 
    
    [contentView addSubview:self.orderNumberLabel];
    [contentView addSubview:self.homeNameLabel];
    [contentView addSubview:self.awayNameLabel];
    [contentView addSubview:self.middleLabel];
    [contentView addSubview:self.deleteButton];
    [contentView addSubview:self.markButton];
    
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(15);
        make.height.equalTo(@16);
        make.left.equalTo(contentView);
        make.width.equalTo(@50);
    }];
    [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-50);
        make.height.equalTo(@14);
         make.right.equalTo(self.middleLabel.mas_left).offset(-10);
    }];
    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-50);
        make.height.equalTo(@14);
         make.left.equalTo(self.middleLabel.mas_right).offset(10);
    }];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-50);
        make.height.equalTo(@14);
        make.centerX.equalTo(contentView);
     }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_left).offset(25);
        make.bottom.equalTo(contentView).offset(-12);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleLabel).offset(1);
        make.right.equalTo(contentView).offset(-15);
        make.height.equalTo(@25) ;
        make.width.equalTo(@25) ;
     }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    btn.backgroundColor = [UIColor clearColor] ;
    [btn addTarget:self action:@selector(pvt_onMark) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleLabel).offset(1);
        make.right.equalTo(contentView).offset(-5);
        make.height.equalTo(@30) ;
        make.width.equalTo(@50) ;
    }];
    
    
    switch (self.gameType) {
        case GameTypeJcDg:
        case GameTypeJcDgAll:
        case GameTypeJcHt:
        case GameTypeJcZjq:
        case GameTypeJcBf:
        case GameTypeJcBqc:
            [self dragBuildLayout];
            break;
        case GameTypeJcRqspf:
        case GameTypeJcSpf:
            [self spfBuildLayout];
            break;
        default:
            break;
    }
}
//滚动条
- (void)dragBuildLayout {
    UIView *contentView = self.contentView;
    DPDragView *dragLabel = [[DPDragView alloc] init];
    dragLabel.image = dp_CommonResizeImage(@"scroll_bg.png");
    dragLabel.customView = self.contentLabel;
    [contentView addSubview:dragLabel];
    
    [dragLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.bottom.equalTo(contentView).offset(-12);
        make.left.equalTo(self.deleteButton.mas_right).offset(5);
          make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [dragLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_showDetail:)]] ;
}

//创建胜平负（让球胜平负）
- (void)spfBuildLayout {
    UIView *contentView = self.contentView;
    UIView *assistView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    
    [self.contentView addSubview:assistView];
    
    [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deleteButton.mas_right).offset(10);
//        make.right.equalTo(self.markButton.mas_left).offset(-10);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    DPBetToggleControl *winControl = [DPBetToggleControl horizontalControl2];
    [winControl setTitleText:@"胜 "];
    [winControl setTag:self.gameType << 16 | 0];
    [winControl setNormalImage:({
        UIImage *image = dp_SportLotteryImage(@"transferLeftNormal.png") ;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0) resizingMode:UIImageResizingModeStretch];
        image;
    })];
    [winControl setSelectedImage:({
        UIImage *image = [dp_SportLotteryImage(@"transferLeftSel.png")dp_imageWithTintColor:[UIColor dp_flatRedColor]];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0) resizingMode:UIImageResizingModeStretch];
        image;
    })];
    [winControl addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    
    DPBetToggleControl *tieControl = [DPBetToggleControl horizontalControl];
    [tieControl setTitleText:@"平"];
    [tieControl setTag:self.gameType << 16 | 1];
    [tieControl addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    [tieControl setNormalBgColor:UIColorFromRGB(0xfaf9f2)];//[UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1]];
    
    DPBetToggleControl *loseControl = [DPBetToggleControl horizontalControl2];
    [loseControl setTitleText:@"负 "];
    [loseControl setTag:self.gameType << 16 | 2];
    [loseControl setNormalImage:({
        UIImage *image = dp_SportLotteryImage(@"transferRightNormal.png");
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 15) resizingMode:UIImageResizingModeStretch];
        image;
    })];
    [loseControl setSelectedImage:({
        UIImage *image = [dp_SportLotteryImage(@"transferRightSel.png") dp_imageWithTintColor:[UIColor dp_flatRedColor]];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 15) resizingMode:UIImageResizingModeStretch];
        image;
    })];
    [loseControl addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:winControl];
    [contentView addSubview:tieControl];
    [contentView addSubview:loseControl];
    
    [tieControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(assistView).multipliedBy(0.33);
        make.centerX.equalTo(assistView);
        make.centerY.equalTo(self.deleteButton);
    }];
    [winControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(tieControl);
        make.centerY.equalTo(self.deleteButton);
        make.right.equalTo(tieControl.mas_left);
    }];
    [loseControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(tieControl);
        make.centerY.equalTo(self.deleteButton);
        make.left.equalTo(tieControl.mas_right);
    }];
    
    UIView *line1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1];
        view;
    });
    UIView *line2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1];
        view;
    });
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tieControl);
        make.bottom.equalTo(tieControl);
        make.left.equalTo(tieControl);
        make.width.equalTo(@1);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tieControl);
        make.bottom.equalTo(tieControl);
        make.right.equalTo(tieControl);
        make.width.equalTo(@1);
    }];
    
    _betOptionSpf = @[winControl, tieControl, loseControl];
}

#pragma mark - private

-(void)pvt_showDetail:(UIGestureRecognizer*)gester{

    if (self.showDetail) {
        self.showDetail(self) ;
    }

}

//删除本条赛事
- (void)pvt_onDelete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteJczqTransferCell:)]) {
        [self.delegate deleteJczqTransferCell:self];
    }
}

//设置胆拖
- (void)pvt_onMark {
    if(!self.markButton.enabled)
        return ;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldMarkJczqTransferCell:)] && [self.delegate respondsToSelector:@selector(jczqTransferCell:mark:)]) {
        if ([self.delegate shouldMarkJczqTransferCell:self]) {
             [self.delegate jczqTransferCell:self mark:!self.markButton.isSelected];
        }
    }
}

//胜平负-让球胜平负  修改选择概率
- (void)pvt_onBet:(DPBetToggleControl *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jczqTransferCell:gameType:index:selected:)]) {
        [self.delegate jczqTransferCell:self gameType:(sender.tag & 0xFFFF0000) >> 16 index:sender.tag & 0x0000FFFF selected:sender.isSelected];
    }
}

#pragma mark - getter, setter
//比分  总进球  半全场  选择记录
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont dp_systemFontOfSize:12];
        _contentLabel.textColor = [UIColor dp_flatRedColor];
    }
    return _contentLabel;
}
//主队名称
- (UILabel *)homeNameLabel {
    if (_homeNameLabel == nil) {
        _homeNameLabel = [[UILabel alloc] init];
        _homeNameLabel.backgroundColor = [UIColor clearColor];
        _homeNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _homeNameLabel.textColor = [UIColor dp_flatBlackColor];
        _homeNameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _homeNameLabel;
}
//客队名称
- (UILabel *)awayNameLabel {
    if (_awayNameLabel == nil) {
        _awayNameLabel = [[UILabel alloc] init];
        _awayNameLabel.backgroundColor = [UIColor clearColor];
        _awayNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _awayNameLabel.textColor = [UIColor dp_flatBlackColor];
        _awayNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _awayNameLabel;
}
//中间--vs（让球）
- (UILabel *)middleLabel {
    if (_middleLabel == nil) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.backgroundColor = [UIColor clearColor];
        _middleLabel.font = [UIFont dp_systemFontOfSize:13];
        _middleLabel.textColor = [UIColor colorWithRed:0.79 green:0.74 blue:0.62 alpha:1];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _middleLabel;
}
//序号
- (UILabel *)orderNumberLabel {
    if (_orderNumberLabel == nil) {
        _orderNumberLabel = [[UILabel alloc] init];
        _orderNumberLabel.backgroundColor = [UIColor clearColor];
        _orderNumberLabel.font = [UIFont dp_systemFontOfSize:11];
        _orderNumberLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _orderNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _orderNumberLabel;
}

//胆拖
- (UIButton *)markButton {
    if (_markButton == nil) {
        _markButton = [[UIButton alloc] init];
        _markButton.backgroundColor = [UIColor clearColor] ;
        [_markButton setImage:dp_SportLotteryImage(@"normalDan.png") forState:UIControlStateNormal];
        [_markButton setImage:dp_SportLotteryImage(@"selectDan.png") forState:UIControlStateSelected];
        [_markButton setImage:dp_SportLotteryImage(@"disableDan.png") forState:UIControlStateDisabled];
//        [_markButton setImageEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];

        [_markButton addTarget:self action:@selector(pvt_onMark) forControlEvents:UIControlEventTouchUpInside];
    }
    return _markButton;
}

//删除按钮
- (UIButton *)deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:dp_SportLotteryImage(@"close.png") forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(pvt_onDelete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
