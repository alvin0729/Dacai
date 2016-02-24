//
//  DPTicketCell.m
//  Jackpot
//
//  Created by sxf on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPTicketCell.h"
@interface DPTicketCell () {
@private
    UILabel *_orderNumberLabel;
    UILabel *_copyTicketLabel;
    UILabel *_titleLabel;
    UILabel *_moneyLabel;
    UILabel *_infoLabel;
    UILabel *_winInfo;
    UIImageView *_winImageView;
}
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel; //出票序号
@property (nonatomic, strong, readonly) UILabel *copyTicketLabel; //复制票号查询
@property (nonatomic, strong, readonly) UILabel *titleLabel; //订单期号等信息
@property (nonatomic, strong, readonly) UILabel *moneyLabel; //单张票金额
@property (nonatomic, strong, readonly) UILabel *infoLabel; //票样详情
@property (nonatomic, strong, readonly) UILabel *winInfo; //中奖信息
@property (nonatomic, strong, readonly) UIImageView *winImageView; //中奖图片
@end
@implementation DPTicketCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIView* contentView = self.contentView;
        [contentView addSubview:self.orderNumberLabel];
        [contentView addSubview:self.copyTicketLabel];
        self.copyTicketLabel.hidden = YES;
        UILabel* titleNumber = [[UILabel alloc] init];
        titleNumber.backgroundColor = [UIColor clearColor];
        titleNumber.textColor = UIColorFromRGB(0x676767);
        titleNumber.textAlignment = NSTextAlignmentLeft;
        titleNumber.font = [UIFont systemFontOfSize:11.0];
        titleNumber.text = @"出票序号:";
        [contentView addSubview:titleNumber];
        [titleNumber mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(5);
            make.width.equalTo(@48);
            make.top.equalTo(contentView).offset(10);
            make.height.equalTo(@25);
        }];
        [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(titleNumber.mas_right).offset(5);
            make.right.equalTo(self.copyTicketLabel.mas_left);
            make.top.equalTo(contentView).offset(10);
            make.height.equalTo(@25);
        }];
        [self.copyTicketLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(contentView).offset(10);
            make.width.equalTo(@70);
            make.height.equalTo(@25);
        }];
        UIImageView* backView = [[UIImageView alloc] init];
        backView.backgroundColor = [UIColor clearColor];
        backView.image = [dp_RedPacketImage(@"orderInfo.png") resizableImageWithCapInsets:UIEdgeInsetsMake(35, 0, 10, 0) resizingMode:UIImageResizingModeStretch];
        UILabel* label = [[UILabel alloc] init];
        label.text = @"元";
        label.font = [UIFont systemFontOfSize:12.0];
        label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor clearColor];
        [contentView addSubview:backView];
        [backView addSubview:self.titleLabel];
        [backView addSubview:self.moneyLabel];
        [backView addSubview:self.infoLabel];
        [contentView addSubview:label];
        [backView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.orderNumberLabel.mas_bottom);
            make.bottom.equalTo(contentView);
            make.left.equalTo(contentView).offset(5);
            make.right.equalTo(contentView).offset(-5);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView).offset(10);
            make.top.equalTo(backView);
            make.height.equalTo(@27);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(backView).offset(-10);
            make.top.equalTo(self.titleLabel);
            make.bottom.equalTo(self.titleLabel);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(label.mas_left);
            make.top.equalTo(self.titleLabel);
            make.bottom.equalTo(self.titleLabel);
        }];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView).offset(10);
            make.right.equalTo(backView).offset(-10);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(backView).offset(-43);
        }];

        UILabel* winLabel = [[UILabel alloc] init];
        winLabel.backgroundColor = [UIColor clearColor];
        winLabel.text = @"中奖情况:";
        winLabel.adjustsFontSizeToFitWidth = YES;
        winLabel.textColor = UIColorFromRGB(0x969696);
        winLabel.font = [UIFont systemFontOfSize:12.0];
        winLabel.textAlignment = NSTextAlignmentLeft;
        [backView addSubview:winLabel];
        [backView addSubview:self.winInfo];
        [backView addSubview:self.winImageView];
        self.winImageView.hidden = YES;
        [winLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView).offset(10);
            make.top.equalTo(self.infoLabel.mas_bottom).offset(7);
            make.bottom.equalTo(backView).offset(-22);
        }];
        [self.winInfo mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(winLabel.mas_right).offset(5);
            make.top.equalTo(self.infoLabel.mas_bottom).offset(7);
            make.bottom.equalTo(backView).offset(-22);

        }];
        [self.winImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(backView).offset(-5);
            make.width.equalTo(@67);
            make.height.equalTo(@49);
            make.top.equalTo(self.winInfo).offset(-17);
        }];

        [self.copyTicketLabel addGestureRecognizer:({
                                  UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onCopy)];
                                  tapRecognizer;
                              })];
    }
    return self;
}

- (void)pvt_onCopy
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyTicketSearchForTicketCell:)]) {
        [self.delegate copyTicketSearchForTicketCell:self.orderNumberLabel.text];
    }
}
//序号
- (void)orderNumberLabelText:(NSString*)string
{
    self.orderNumberLabel.text = string;
}
//订单期号等信息
- (void)titleLabelText:(NSString*)string
{
    self.titleLabel.text = string;
}
//订单金额
- (void)moneyLabelText:(NSString*)string
{
    self.moneyLabel.text = string;
}
//订单详情
- (void)infoLabelText:(NSMutableAttributedString*)attributedText
{
    self.infoLabel.attributedText = attributedText;
}
//中奖信息
- (void)winInfoText:(NSAttributedString*)text
{
    self.winInfo.attributedText = text;
}
//是否出票
- (void)showCopyTicket:(BOOL)isTicket
{
    self.copyTicketLabel.hidden = !isTicket;
}
//是否中奖
- (void)isShowWinImageView:(BOOL)isWin
{
    self.winImageView.hidden = !isWin;
}
#pragma mark - getter, setter

//出票序号
- (UILabel*)orderNumberLabel
{
    if (_orderNumberLabel == nil) {
        _orderNumberLabel = [[UILabel alloc] init];
        _orderNumberLabel.backgroundColor = [UIColor clearColor];
        _orderNumberLabel.textColor = UIColorFromRGB(0x6d6c6c);
        _orderNumberLabel.textAlignment = NSTextAlignmentLeft;
        _orderNumberLabel.font = [UIFont systemFontOfSize:11.0];
        _orderNumberLabel.text = @"出票序号:";
    }
    return _orderNumberLabel;
}
//复制票号查询
- (UILabel*)copyTicketLabel
{
    if (_copyTicketLabel == nil) {
        _copyTicketLabel = [[UILabel alloc] init];
        _copyTicketLabel.backgroundColor = [UIColor clearColor];
        _copyTicketLabel.textColor = UIColorFromRGB(0x3181e8);
        _copyTicketLabel.textAlignment = NSTextAlignmentRight;
        _copyTicketLabel.font = [UIFont systemFontOfSize:11.0];
        _copyTicketLabel.text = @"复制票号查询";
        _copyTicketLabel.userInteractionEnabled = YES;
    }
    return _copyTicketLabel;
}
//订单期号等信息
- (UILabel*)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x979797);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}
//单张票金额
- (UILabel*)moneyLabel
{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.textColor = UIColorFromRGB(0xde514f);
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [UIFont systemFontOfSize:12.0];
        _moneyLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _moneyLabel;
}
//票样详情
- (UILabel*)infoLabel
{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = UIColorFromRGB(0x665736);
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [UIFont systemFontOfSize:14.0];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}
//中奖信息
- (UILabel*)winInfo
{
    if (_winInfo == nil) {
        _winInfo = [[UILabel alloc] init];
        _winInfo.backgroundColor = [UIColor clearColor];
        _winInfo.textColor = UIColorFromRGB(0x626262);
        _winInfo.textAlignment = NSTextAlignmentLeft;
        _winInfo.font = [UIFont systemFontOfSize:12.0];
        _winInfo.numberOfLines = 0;
    }
    return _winInfo;
}
//中奖图片
- (UIImageView*)winImageView
{
    if (_winImageView == nil) {
        _winImageView = [[UIImageView alloc] init];
        _winImageView.backgroundColor = [UIColor clearColor];
        _winImageView.image = dp_ProjectImage(@"win.png");
    }
    return _winImageView;
}

@end

@interface DPJcTicketCell () {
@private

    UILabel *_infoLabel;
    UILabel *_infoTitleLabel;
    UILabel *_rqLabel;
}

@property (nonatomic, strong, readonly) UILabel *infoLabel; //订单详情
@property (nonatomic, strong, readonly) UILabel *infoTitleLabel; //订单详情分区标题
@property (nonatomic, strong, readonly) UILabel *rqLabel;//让球label
@end
@implementation DPJcTicketCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIView* backView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.contentView).offset(9.5);
            make.right.equalTo(self.contentView).offset(-9.5);
            make.top.equalTo(self.contentView);
            make.height.equalTo(self.contentView);
        }];
        [backView addSubview:self.infoTitleLabel];
        [backView addSubview:self.infoLabel];
        [backView addSubview:self.rqLabel];
        [self.rqLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView).offset(15);
            make.width.equalTo(@70);
            make.top.equalTo(backView).offset(13);
            make.height.equalTo(@14);
        }];
        [self.infoTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.rqLabel.mas_right).offset(5);
            make.right.equalTo(backView).offset(-15);
            make.top.equalTo(self.rqLabel);
            make.height.equalTo(@14);
        }];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.infoTitleLabel);
            make.right.equalTo(backView).offset(-15);
            make.top.equalTo(self.infoTitleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(backView).offset(-5);
        }];
        UIView* bottomLine = [UIView dp_viewWithColor:UIColorFromRGB(0xdbd5cc)];
        [backView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView).offset(15);
            make.right.equalTo(backView).offset(-15);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(backView);
        }];

        UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xdbd5cc)];
        UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdbd5cc)];
        [backView addSubview:line1];
        [backView addSubview:line2];
        [line1 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(backView);
            make.bottom.equalTo(backView);
            make.width.equalTo(@0.5);
            make.left.equalTo(backView);
        }];
        [line2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(backView);
            make.bottom.equalTo(backView);
            make.width.equalTo(@0.5);
            make.right.equalTo(backView);
        }];
    }
    return self;
}
//订单详情
- (void)infoLabelText:(NSMutableAttributedString*)attributedText
{
    self.infoLabel.attributedText = attributedText;
}
//订单详情标题
- (void)infoLabelTitleText:(NSString*)attributedText
{
    self.infoTitleLabel.text = attributedText;
}
//标示  如周一001
- (void)rqLableText:(NSString*)text
{
    self.rqLabel.text = text;
}
#pragma mark - getter, setter
//订单详情
- (UILabel*)rqLabel
{
    if (_rqLabel == nil) {
        _rqLabel = [[UILabel alloc] init];
        _rqLabel.backgroundColor = [UIColor clearColor];
        _rqLabel.textColor = UIColorFromRGB(0x665736);
        _rqLabel.textAlignment = NSTextAlignmentLeft;
        _rqLabel.font = [UIFont systemFontOfSize:14.0];
        _rqLabel.numberOfLines = 0;
    }
    return _rqLabel;
}
//订单详情分区标题
- (UILabel*)infoLabel
{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = UIColorFromRGB(0x665736);
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [UIFont systemFontOfSize:14.0];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}
//让球label
- (UILabel*)infoTitleLabel
{
    if (_infoTitleLabel == nil) {
        _infoTitleLabel = [[UILabel alloc] init];
        _infoTitleLabel.backgroundColor = [UIColor clearColor];
        _infoTitleLabel.textColor = UIColorFromRGB(0x665736);
        _infoTitleLabel.textAlignment = NSTextAlignmentLeft;
        _infoTitleLabel.font = [UIFont systemFontOfSize:14.0];
        _infoTitleLabel.numberOfLines = 0;
    }
    return _infoTitleLabel;
}

@end

@interface DPHeaderViewForJcTicket () {
@private
    UILabel *_orderNumberLabel;
    UILabel *_copyTicketLabel;
    UILabel *_titleLabel;
    UILabel *_moneyLabel;
}
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel; //序号
@property (nonatomic, strong, readonly) UILabel *copyTicketLabel; //复制票号查询
@property (nonatomic, strong, readonly) UILabel *titleLabel; //订单期号等信息
@property (nonatomic, strong, readonly) UILabel *moneyLabel; //单张票金额
@end

@implementation DPHeaderViewForJcTicket

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        UIView* backView = [UIView dp_viewWithColor:[UIColor clearColor]];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self).offset(7.5);
            make.right.equalTo(self).offset(-7.5);
            make.top.equalTo(self);
            make.height.equalTo(self);
        }];

        [backView addSubview:self.orderNumberLabel];
        [backView addSubview:self.copyTicketLabel];
        self.copyTicketLabel.hidden = YES;
        UILabel* titleNumber = [[UILabel alloc] init];
        titleNumber.backgroundColor = [UIColor clearColor];
        titleNumber.textColor = UIColorFromRGB(0x6d6c6c);
        titleNumber.textAlignment = NSTextAlignmentLeft;
        titleNumber.font = [UIFont systemFontOfSize:11.0];
        titleNumber.text = @"出票序号:";
        //        titleNumber.adjustsFontSizeToFitWidth=YES;
        [backView addSubview:titleNumber];
        [titleNumber mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView).offset(5);
            make.width.equalTo(@48);
            make.top.equalTo(backView).offset(16);
            make.height.equalTo(@11);
        }];
        [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(titleNumber.mas_right).offset(5);
            make.right.equalTo(self.copyTicketLabel.mas_left);
            make.top.equalTo(backView).offset(16);
            make.height.equalTo(@11);
        }];
        [self.copyTicketLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(backView).offset(-10);
            make.top.equalTo(titleNumber);
            make.width.equalTo(@70);
            make.bottom.equalTo(titleNumber);
        }];

        UIImageView* lineView = [[UIImageView alloc] init];
        lineView.backgroundColor = [UIColor clearColor];
        //        lineView.image=dp_ProjectImage(@"topLine.png");
        lineView.image = [dp_ProjectImage(@"topLine.png") resizableImageWithCapInsets:UIEdgeInsetsMake(3, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [backView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView);
            make.right.equalTo(backView);
            make.top.equalTo(self.orderNumberLabel.mas_bottom).offset(8);
            make.bottom.equalTo(backView);
        }];

        UILabel* label = [[UILabel alloc] init];
        label.text = @"元";
        label.font = [UIFont systemFontOfSize:12.0];
        label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor clearColor];
        [lineView addSubview:self.titleLabel];
        [lineView addSubview:self.moneyLabel];
        [lineView addSubview:label];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(lineView).offset(16);
            make.top.equalTo(lineView).offset(2);
            make.bottom.equalTo(lineView);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(lineView).offset(-16);
            make.top.equalTo(self.titleLabel);
            make.bottom.equalTo(self.titleLabel);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(label.mas_left);
            make.top.equalTo(self.titleLabel);
            make.bottom.equalTo(self.titleLabel);
        }];

        UIImageView* bottomLine = [[UIImageView alloc] init];
        bottomLine.backgroundColor = [UIColor clearColor];
        bottomLine.image = dp_ProjectImage(@"imaginaryline.png");
        [backView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView).offset(2);
            make.right.equalTo(backView).offset(-2);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(backView);
        }];
        [self.copyTicketLabel addGestureRecognizer:({
                                  UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onCopy)];
                                  tapRecognizer;
                              })];
    }

    return self;
}
//序号
- (void)orderNumberLabelText:(NSString*)string
{
    self.orderNumberLabel.text = string;
}
//订单期号等信息
- (void)titleLabelText:(NSString*)string
{
    self.titleLabel.text = string;
}
//订单金额
- (void)moneyLabelText:(NSString*)string
{
    self.moneyLabel.text = string;
}
//票跳转是否隐藏
- (void)showCopyTicket:(BOOL)isTicket
{
    self.copyTicketLabel.hidden = !isTicket;
}
//跳转去查询票
- (void)pvt_onCopy
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyTicketSearchForTicketCell:)]) {
        [self.delegate copyTicketSearchForTicketCell:self.orderNumberLabel.text];
    }
}

#pragma mark - getter, setter
//序号
- (UILabel*)orderNumberLabel
{
    if (_orderNumberLabel == nil) {
        _orderNumberLabel = [[UILabel alloc] init];
        _orderNumberLabel.backgroundColor = [UIColor clearColor];
        _orderNumberLabel.textColor = UIColorFromRGB(0xbebebe);
        _orderNumberLabel.textAlignment = NSTextAlignmentLeft;
        _orderNumberLabel.font = [UIFont systemFontOfSize:11.0];
        _orderNumberLabel.text = @"出票序号:";
    }
    return _orderNumberLabel;
}
//复制票号查询
- (UILabel*)copyTicketLabel
{
    if (_copyTicketLabel == nil) {
        _copyTicketLabel = [[UILabel alloc] init];
        _copyTicketLabel.backgroundColor = [UIColor clearColor];
        _copyTicketLabel.textColor = UIColorFromRGB(0x2a77e6);
        _copyTicketLabel.textAlignment = NSTextAlignmentRight;
        _copyTicketLabel.font = [UIFont systemFontOfSize:11.0];
        _copyTicketLabel.text = @"复制票号查询";
        _copyTicketLabel.userInteractionEnabled = YES;
    }
    return _copyTicketLabel;
}
//订单期号等信息
- (UILabel*)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x666666);
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}
//单张票金额
- (UILabel*)moneyLabel
{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.textColor = UIColorFromRGB(0xde514f);
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [UIFont systemFontOfSize:12.0];
        _moneyLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _moneyLabel;
}

@end

@interface DPFooterViewForJcTicket () {
@private
    UILabel *_winInfo;
    UIImageView *_winImageView;
    UILabel *_infoLabel;
    UILabel *_infoTitleLabel;
    UILabel *_rqLabel;
}
@property (nonatomic, strong, readonly) UILabel *winInfo; //中奖信息
@property (nonatomic, strong, readonly) UIImageView *winImageView; //中奖图片
@property (nonatomic, strong, readonly) UILabel *infoLabel; //订单详情
@property (nonatomic, strong, readonly) UILabel *infoTitleLabel; //订单详情分区标题
@property (nonatomic, strong, readonly) UILabel *rqLabel;//让球，让分信息
@end

@implementation DPFooterViewForJcTicket

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //         self.contentView.backgroundColor=[UIColor clearColor];
        UIImageView* backView = [[UIImageView alloc] init];
        backView.backgroundColor = [UIColor clearColor];
        backView.image = [dp_ProjectImage(@"bottomLine.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 8, 0) resizingMode:UIImageResizingModeStretch];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self).offset(7.5);
            make.right.equalTo(self).offset(-7.5);
            make.bottom.equalTo(self);
            make.top.equalTo(self);
        }];
        UIView* topView = [UIView dp_viewWithColor:[UIColor clearColor]];
        UIView* bottomView = [UIView dp_viewWithColor:[UIColor clearColor]];
        [self addSubview:topView];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView);
            make.right.equalTo(backView);
            make.bottom.equalTo(backView);
            make.height.equalTo(@40);
        }];
        [topView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView);
            make.right.equalTo(backView);
            make.bottom.equalTo(bottomView.mas_top);
            make.top.equalTo(backView);
        }];
        [topView addSubview:self.infoTitleLabel];
        [topView addSubview:self.infoLabel];
        [topView addSubview:self.rqLabel];
        [self.rqLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(topView).offset(15);
            make.width.equalTo(@70);
            make.top.equalTo(topView).offset(13);
            make.height.equalTo(@14);
        }];
        [self.infoTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.rqLabel.mas_right).offset(5);
            make.right.equalTo(topView).offset(-15);
            make.top.equalTo(self.rqLabel);
            make.height.equalTo(@14);
        }];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.infoTitleLabel);
            make.right.equalTo(backView).offset(-15);
            make.top.equalTo(self.infoTitleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(topView).offset(-5);
        }];

        UILabel* winLabel = [[UILabel alloc] init];
        winLabel.backgroundColor = [UIColor clearColor];
        winLabel.text = @"中奖情况:";
        winLabel.adjustsFontSizeToFitWidth = YES;
        winLabel.textColor = UIColorFromRGB(0x9e9e9e);
        winLabel.font = [UIFont systemFontOfSize:12.0];
        winLabel.textAlignment = NSTextAlignmentLeft;
        [bottomView addSubview:winLabel];
        [bottomView addSubview:self.winInfo];
        [bottomView addSubview:self.winImageView];
        self.winImageView.hidden = YES;
        [winLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(bottomView).offset(15);
            make.top.equalTo(bottomView).offset(11);
            make.height.equalTo(@14);
        }];
        [self.winInfo mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(winLabel.mas_right).offset(5);
            make.top.equalTo(winLabel);
            make.bottom.equalTo(winLabel);
        }];
        [self.winImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(bottomView).offset(-5);
            make.width.equalTo(@67);
            make.height.equalTo(@49);
            make.top.equalTo(self.winInfo).offset(-20);
        }];

        UIImageView* bottomLine = [[UIImageView alloc] init];
        bottomLine.backgroundColor = [UIColor clearColor];
        bottomLine.image = dp_ProjectImage(@"imaginaryline.png");
        [bottomView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(bottomView).offset(2);
            make.right.equalTo(bottomView).offset(-2);
            make.height.equalTo(@0.5);
            make.top.equalTo(bottomView);
        }];
    }

    return self;
}
//订单详情
- (void)infoLabelText:(NSMutableAttributedString*)attributedText
{
    self.infoLabel.attributedText = attributedText;
}
//订单详情标题
- (void)infoLabelTitleText:(NSString*)attributedText
{
    self.infoTitleLabel.text = attributedText;
}
//标示  如周一001
- (void)rqLableText:(NSString*)text
{
    self.rqLabel.text = text;
}
//中奖信息
- (void)winInfoText:(NSAttributedString*)text
{
    self.winInfo.attributedText = text;
}

//是否中奖
- (void)isShowWinImageView:(BOOL)isWin
{
    self.winImageView.hidden = !isWin;
}

#pragma mark - getter, setter
//中奖信息
- (UILabel*)winInfo
{
    if (_winInfo == nil) {
        _winInfo = [[UILabel alloc] init];
        _winInfo.backgroundColor = [UIColor clearColor];
        _winInfo.textColor = UIColorFromRGB(0x626262);
        _winInfo.textAlignment = NSTextAlignmentLeft;
        _winInfo.font = [UIFont systemFontOfSize:12.0];
    }
    return _winInfo;
}
//中奖图片
- (UIImageView*)winImageView
{
    if (_winImageView == nil) {
        _winImageView = [[UIImageView alloc] init];
        _winImageView.backgroundColor = [UIColor clearColor];
        _winImageView.image = dp_ProjectImage(@"win.png");
    }
    return _winImageView;
}
//订单详情
- (UILabel*)infoLabel
{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = UIColorFromRGB(0x665736);
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [UIFont systemFontOfSize:14.0];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}
//订单详情分区标题
- (UILabel*)infoTitleLabel
{
    if (_infoTitleLabel == nil) {
        _infoTitleLabel = [[UILabel alloc] init];
        _infoTitleLabel.backgroundColor = [UIColor clearColor];
        _infoTitleLabel.textColor = UIColorFromRGB(0x665736);
        _infoTitleLabel.textAlignment = NSTextAlignmentLeft;
        _infoTitleLabel.font = [UIFont systemFontOfSize:14.0];
        _infoTitleLabel.numberOfLines = 0;
    }
    return _infoTitleLabel;
}
//让球，让分信息
- (UILabel*)rqLabel
{
    if (_rqLabel == nil) {
        _rqLabel = [[UILabel alloc] init];
        _rqLabel.backgroundColor = [UIColor clearColor];
        _rqLabel.textColor = UIColorFromRGB(0x665736);
        _rqLabel.textAlignment = NSTextAlignmentLeft;
        _rqLabel.font = [UIFont systemFontOfSize:14.0];
        _rqLabel.numberOfLines = 0;
    }
    return _rqLabel;
}

@end

@implementation DPHeaderViewForFirstView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.isBulid = NO;
    }

    return self;
}
- (void)bulidLayOut:(GameTypeId)gameType
{

    UIView* topView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [self addSubview:topView];
    UIView* line = [UIView dp_viewWithColor:UIColorFromRGB(0xcccccc)];
    [topView addSubview:line];
    [topView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [line mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(topView);
        make.left.equalTo(topView);
        make.bottom.equalTo(topView);
        make.height.equalTo(@0.5);
    }];

    if (IsGameTypeJc(gameType) || IsGameTypeLc(gameType)) {
        UIImageView* titleImageView = [[UIImageView alloc] init];
        titleImageView.backgroundColor = [UIColor clearColor];
        if (IsGameTypeJc(gameType)) {
            titleImageView.image = dp_AppRootImage(@"jczq.png");
        }
        else {
            titleImageView.image = dp_AppRootImage(@"jclq.png");
        }

        [topView addSubview:titleImageView];
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont dp_systemFontOfSize:18.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = UIColorFromRGB(0x000000);
        titleLabel.text = dp_GameTypeFirstName(gameType);
        [topView addSubview:titleLabel];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(topView).offset(10);
            make.width.equalTo(@35);
            make.centerY.equalTo(topView);
            make.height.equalTo(@35);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(titleImageView.mas_right).offset(5);
            make.width.equalTo(@(kScreenWidth - 61));
            make.centerY.equalTo(titleImageView);
            make.height.equalTo(@40);
        }];
    }
    else if (gameType == GameTypeDlt) {
        [topView addSubview:self.issueLabel];
        [self.issueLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(topView);
            make.right.equalTo(topView);
            make.top.equalTo(topView).offset(13);
            make.height.equalTo(@14);
        }];
        for (int i = 0; i < 7; i++) {
            UILabel* label = [[UILabel alloc] init];
            label.backgroundColor = (i > 4) ? UIColorFromRGB(0x1d67e2) : UIColorFromRGB(0xd34c4b);
            label.layer.cornerRadius = 12;
            label.clipsToBounds = YES;
            label.textColor = [UIColor whiteColor];
            label.tag = 100 + i;
            label.font = [UIFont systemFontOfSize:14.0];
            label.textAlignment = NSTextAlignmentCenter;
            [topView addSubview:label];
            label.hidden = YES;
            [label mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.equalTo(topView).offset(55 + 30 * i);
                make.width.equalTo(@25);
                make.bottom.equalTo(topView).offset(-12);
                make.height.equalTo(@25);
            }];
        }
        [topView addSubview:self.winLabel];
        [self.winLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(topView);
            make.right.equalTo(topView);
            make.bottom.equalTo(topView).offset(-12);
            make.height.equalTo(@25);
        }];
    }
    self.isBulid = YES;
}

#pragma mark - getter, setter
//开奖结果
- (UILabel*)issueLabel
{
    if (_issueLabel == nil) {
        _issueLabel = [[UILabel alloc] init];
        _issueLabel.backgroundColor = [UIColor clearColor];
        _issueLabel.textColor = UIColorFromRGB(0x666666);
        _issueLabel.textAlignment = NSTextAlignmentCenter;
        _issueLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _issueLabel;
}
//开奖状态
- (UILabel*)winLabel
{
    if (_winLabel == nil) {
        _winLabel = [[UILabel alloc] init];
        _winLabel.backgroundColor = [UIColor clearColor];
        _winLabel.textColor = UIColorFromRGB(0x666666);
        _winLabel.textAlignment = NSTextAlignmentCenter;
        _winLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _winLabel;
}

@end
