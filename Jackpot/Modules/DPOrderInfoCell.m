//
//  DPOrderInfoCell.m
//  Jackpot
//
//  Created by sxf on 15/8/28.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPOrderInfoCell.h"

//数字彩内容
@interface DPOrderInfoCell () {
@private
    UILabel *_orderNumberLabel;
    UILabel *_titleLabel;
    UILabel *_moneyLabel;
    UILabel *_infoLabel;
}
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel;//序号
@property (nonatomic, strong, readonly) UILabel *titleLabel;//期号等信息
@property (nonatomic, strong, readonly) UILabel *moneyLabel;//金额
@property (nonatomic, strong, readonly) UILabel *infoLabel;//内容
@end
@implementation DPOrderInfoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIView* contentView = self.contentView;
        [contentView addSubview:self.orderNumberLabel];
        [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(5);
            make.right.equalTo(contentView).offset(-5);
            make.top.equalTo(contentView).offset(10);
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
            make.left.equalTo(backView).offset(15);
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
            make.left.equalTo(backView).offset(15);
            make.right.equalTo(backView).offset(-15);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(backView).offset(-10);
        }];
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
//订单详情
- (void)infoLabelText:(NSMutableAttributedString*)attributedText
{
    self.infoLabel.attributedText = attributedText;
}

#pragma mark - getter, setter
//序号
- (UILabel*)orderNumberLabel
{
    if (_orderNumberLabel == nil) {
        _orderNumberLabel = [[UILabel alloc] init];
        _orderNumberLabel.backgroundColor = [UIColor clearColor];
        _orderNumberLabel.textColor = UIColorFromRGB(0xb6b6b4);
        _orderNumberLabel.textAlignment = NSTextAlignmentLeft;
        _orderNumberLabel.font = [UIFont systemFontOfSize:12.0];
        _orderNumberLabel.text = @"序号:";
    }
    return _orderNumberLabel;
}
//期号等信息
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
//金额
- (UILabel*)moneyLabel
{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.textColor = UIColorFromRGB(0xde514f);
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [UIFont systemFontOfSize:14.0];
        _moneyLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _moneyLabel;
}
//内容
- (UILabel*)infoLabel
{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [UIFont systemFontOfSize:14.0];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

@end

@interface DPJcOrderInfoCell () {
@private
    UILabel *_infoLabel;
    UILabel *_infoTitleLabel;
    UILabel *_rqLabel;
}

@property (nonatomic, strong, readonly) UILabel *infoLabel; //订单详情
@property (nonatomic, strong, readonly) UILabel *infoTitleLabel; //订单详情分区标题
@property (nonatomic, strong, readonly) UILabel *rqLabel;//标示  如周一001
@end
@implementation DPJcOrderInfoCell

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

        [backView addSubview:self.infoLabel];
        [backView addSubview:self.infoTitleLabel];
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
- (UILabel*)infoLabel
{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = UIColorFromRGB(0xde514f);
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [UIFont systemFontOfSize:12.0];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}
//订单详情标题
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
//标示  如周一001
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

//竞彩区头
@interface DPHeaderViewForJcOrder () {
@private
    UILabel *_orderNumberLabel;
    UILabel *_titleLabel;
    UILabel *_moneyLabel;
}
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel; //序号
@property (nonatomic, strong, readonly) UILabel *titleLabel; //订单期号等信息
@property (nonatomic, strong, readonly) UILabel *moneyLabel; //单张票金额
@end

@implementation DPHeaderViewForJcOrder

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
        [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(backView).offset(15);
            make.right.equalTo(backView).offset(-15);
            make.top.equalTo(backView).offset(10);
            make.height.equalTo(@25);
        }];

        UIImageView* lineView = [[UIImageView alloc] init];
        lineView.backgroundColor = [UIColor clearColor];
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
- (void)showCopyTicket:(BOOL)isTicket
{
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
        _orderNumberLabel.text = @"序号:";
    }
    return _orderNumberLabel;
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
//订单金额
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

//竞彩区尾
@interface DPFooterViewForJcOrder () {
@private
    UILabel* _infoLabel;
    UILabel* _infoTitleLabel;
    UILabel* _rqLabel;
}

@property (nonatomic, strong, readonly) UILabel* infoLabel; //订单详情
@property (nonatomic, strong, readonly) UILabel* infoTitleLabel; //订单详情分区标题
@property (nonatomic, strong, readonly) UILabel* rqLabel;//标示  如周一001
@end

@implementation DPFooterViewForJcOrder

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

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
//订单详情标题
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
//标示  如周一001
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

//第一分区的区头
@implementation DPHeaderViewForOrderFirstView

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
    UIView* linebottom = [UIView dp_viewWithColor:UIColorFromRGB(0xcccccc)];
    [topView addSubview:linebottom];
    [topView addSubview:self.ticketLabel];
    [topView addSubview:self.moneyLabel];
    [topView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@53);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(topView);
        make.width.equalTo(@0.5);
        make.height.equalTo(@40);
    }];
    [linebottom mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(topView);
        make.left.equalTo(topView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(topView);
    }];

    [self.ticketLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(topView);
        make.right.equalTo(topView.mas_centerX);
        make.top.equalTo(topView);
        make.bottom.equalTo(topView); //有问题？
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(topView);
        make.left.equalTo(topView.mas_centerX);
        make.height.equalTo(@40);
        make.centerY.equalTo(topView);
    }];
    if (IsGameTypeJc(gameType) || IsGameTypeLc(gameType)) {
        //        headerView.frame=CGRectMake(0, 0, kScreenWidth, 115);
        UIView* bottomView = [UIView dp_viewWithColor:[UIColor clearColor]];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.top.equalTo(topView.mas_bottom);
        }];
        UIImageView* titleImageView = [[UIImageView alloc] init];
        titleImageView.backgroundColor = [UIColor clearColor];
        titleImageView.image = dp_AccountImage(@"newreminder.png");
        [bottomView addSubview:titleImageView];
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont dp_systemFontOfSize:12.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = UIColorFromRGB(0xfa9796);
        titleLabel.numberOfLines = 2;
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:@"本页面的赔率等信息均为方案发起时的即时数据，实际数据以最终的出票票样为准"];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5]; //调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
        titleLabel.attributedText = attributedString;
        [bottomView addSubview:titleLabel];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(bottomView).offset(10);
            make.width.equalTo(@16);
            make.top.equalTo(bottomView).offset(25);
            make.height.equalTo(@16);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(titleImageView.mas_right).offset(5);
            make.width.equalTo(@(kScreenWidth - 61));
            make.centerY.equalTo(titleImageView);
            make.height.equalTo(@40);
        }];
        UIImageView* lineView = [[UIImageView alloc] init];
        lineView.backgroundColor = [UIColor clearColor];
        lineView.image = dp_ProjectImage(@"imaginaryline.png");
        [bottomView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(bottomView).offset(10);
            make.right.equalTo(bottomView).offset(-10);
            make.bottom.equalTo(bottomView);
            make.height.equalTo(@0.5);
        }];
    }

    self.isBulid = YES;
}

#pragma mark - getter, setter

//总票数
- (UILabel*)ticketLabel
{
    if (_ticketLabel == nil) {
        _ticketLabel = [[UILabel alloc] init];
        _ticketLabel.backgroundColor = [UIColor clearColor];
        _ticketLabel.text = @"总票数:";
        _ticketLabel.textColor = UIColorFromRGB(0x666666);
        _ticketLabel.textAlignment = NSTextAlignmentCenter;
        _ticketLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _ticketLabel;
}
//总金额
- (UILabel*)moneyLabel
{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.text = @"金额:";
        _moneyLabel.textColor = UIColorFromRGB(0x666666);
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _moneyLabel;
}
@end
