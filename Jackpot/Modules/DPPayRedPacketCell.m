//
//  DPPayRedPacketCell.m
//  Jackpot
//
//  Created by sxf on 15/8/27.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPPayRedPacketCell.h"
#import "DPRedPacketView.h"
#import "Order.pbobjc.h"
#define kPageWidth 85.0f
#define kPageHeight 122.0f


//使用红包
@interface DPPayRedPacketCell () {
@private
    UIImageView *_imageView;
    UILabel *_moneyLabel;
}
@property (nonatomic, strong, readonly) UIImageView *imageView;

@end
@implementation DPPayRedPacketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView* contentView = self.contentView;
        contentView.backgroundColor = [UIColor whiteColor];
        UILabel* yuanlabel = [[UILabel alloc] init];
        yuanlabel.backgroundColor = [UIColor clearColor];
        yuanlabel.textAlignment = NSTextAlignmentLeft;
        yuanlabel.font = [UIFont systemFontOfSize:12.0];
        yuanlabel.text = @"元";
        yuanlabel.textColor = [UIColor blackColor];

        UILabel* useLabel = [[UILabel alloc] init];
        useLabel.backgroundColor = [UIColor clearColor];
        useLabel.text = @"使用红包";
        useLabel.textAlignment = NSTextAlignmentLeft;
        useLabel.font = [UIFont systemFontOfSize:14.0];
        useLabel.textColor = UIColorFromRGB(0x666666);
        [contentView addSubview:yuanlabel];
        [contentView addSubview:useLabel];
        [contentView addSubview:self.imageView];
        [contentView addSubview:self.moneyLabel];

        [self.imageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
            make.centerY.equalTo(contentView);
        }];
        [useLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.imageView.mas_right).offset(5);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
            make.centerY.equalTo(contentView);
        }];
        [yuanlabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(contentView).offset(-10);
            make.width.equalTo(@25);
            make.height.equalTo(@30);
            make.centerY.equalTo(contentView);
        }];

        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(yuanlabel.mas_left);
            make.left.equalTo(useLabel.mas_right);
            make.height.equalTo(@30);
            make.centerY.equalTo(contentView);
        }];
        UIView* lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
        UIView* lineView2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
        [contentView addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
        [contentView addGestureRecognizer:({
                         UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_openRedPacket)];
                         tapRecognizer;
                     })];
    }
    return self;
}
//数据中心倒三角切换
- (void)analysisViewIsExpand:(BOOL)isExpand
{
    if (isExpand) {
        self.imageView.image = dp_CommonImage(@"brown_smallarrow_down.png");
    }
    else {
        self.imageView.image = dp_CommonImage(@"brown_smallarrow_up.png");
    }
}
//点开红包页面
- (void)pvt_openRedPacket
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRedpacketInfo:)]) {
        [self.delegate clickRedpacketInfo:self];
    }
}
#pragma mark - getter, setter
- (UIImageView*)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.image = dp_CommonImage(@"brown_smallarrow_down.png");
    }
    return _imageView;
}
- (UILabel*)moneyLabel
{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.textColor = UIColorFromRGB(0x007400);
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _moneyLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//钱不够充值列表
@interface DPChargePayForCell () {
@private
    UIImageView *_iconImageView;
    UILabel *_payTitle;
    UILabel *_payInfo;
    UIImageView *_selectedView;
}
@property (nonatomic, strong, readonly) UIImageView *iconImageView; //充值图标
@property (nonatomic, strong, readonly) UILabel *payTitle; //充值名称
@property (nonatomic, strong, readonly) UILabel *payInfo; //充值说明
@property (nonatomic, strong, readonly) UIImageView *selectedView; //选择按钮
@end
@implementation DPChargePayForCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView* contentView = self.contentView;
        contentView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:self.iconImageView];
        [contentView addSubview:self.payTitle];
        [contentView addSubview:self.payInfo];
        [contentView addSubview:self.selectedView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@48);
            make.height.equalTo(@48);
            make.centerY.equalTo(contentView);
        }];
        [self.selectedView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(contentView).offset(-10);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
            make.centerY.equalTo(contentView);
        }];
        [self.payTitle mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.right.equalTo(self.selectedView.mas_left);
            make.height.equalTo(@20);
            make.top.equalTo(self.iconImageView).offset(4);
        }];
        [self.payInfo mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.right.equalTo(self.selectedView.mas_left);
            make.height.equalTo(@20);
            make.bottom.equalTo(self.iconImageView).offset(-1);
        }];
        UIView* lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

//设置充值图标
- (void)iconImageViewImage:(UIImage*)image
{
    self.iconImageView.image = image;
}
//设置充值名称
- (void)payTitleString:(NSString*)payString
{
    self.payTitle.text = payString;
}
//设置充值说明
- (void)payInfoString:(NSString*)payString
{
    self.payInfo.text = payString;
}
//设置当前是否被选中
- (void)paySelectedView:(BOOL)isSelected
{
    if (isSelected) {
        self.selectedView.image = dp_RedPacketImage(@"selectedCharge.png");
    }
    else {
        self.selectedView.image = dp_RedPacketImage(@"normalCharge.png");
    }
}
#pragma mark - getter, setter
//充值图标
- (UIImageView*)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor clearColor];
    }
    return _iconImageView;
}
//充值名称
- (UILabel*)payTitle
{
    if (_payTitle == nil) {
        _payTitle = [[UILabel alloc] init];
        _payTitle.backgroundColor = [UIColor clearColor];
        _payTitle.textColor = UIColorFromRGB(0x333333);
        _payTitle.textAlignment = NSTextAlignmentLeft;
        _payTitle.font = [UIFont systemFontOfSize:17.0];
    }
    return _payTitle;
}
//充值说明
- (UILabel*)payInfo
{
    if (_payInfo == nil) {
        _payInfo = [[UILabel alloc] init];
        _payInfo.backgroundColor = [UIColor clearColor];
        _payInfo.textColor = UIColorFromRGB(0x656565);
        _payInfo.textAlignment = NSTextAlignmentLeft;
        _payInfo.font = [UIFont systemFontOfSize:13.0];
    }
    return _payInfo;
}
//选择按钮
- (UIImageView*)selectedView
{
    if (_selectedView == nil) {
        _selectedView = [[UIImageView alloc] init];
        _selectedView.backgroundColor = [UIColor clearColor];
    }
    return _selectedView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


//彩种信息
@implementation DPPayLotteryTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView* contentView = self.contentView;
        contentView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:self.iconView];
        [contentView addSubview:self.titleLabel];
        [contentView addSubview:self.issueLabel];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
            make.centerY.equalTo(contentView);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.height.equalTo(@30);
            make.centerY.equalTo(contentView);
        }];
        [self.issueLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
            make.height.equalTo(@20);
            make.top.equalTo(self.titleLabel).offset(6);
        }];
        UIView* lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

#pragma mark - getter, setter
//彩种图标
- (UIImageView*)iconView
{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = [UIColor clearColor];
    }
    return _iconView;
}
//彩种名称
- (UILabel*)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}
//彩种期号
- (UILabel*)issueLabel
{
    if (_issueLabel == nil) {
        _issueLabel = [[UILabel alloc] init];
        _issueLabel.backgroundColor = [UIColor clearColor];
        _issueLabel.textColor = UIColorFromRGB(0xb5b5b5);
        _issueLabel.textAlignment = NSTextAlignmentLeft;
        _issueLabel.font = [UIFont systemFontOfSize:13.0];
        _issueLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _issueLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//方案金额，账户余额通用cell
@implementation DPPayNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView* contentView = self.contentView;
        contentView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:self.normalTitleLabel];
        [contentView addSubview:self.moneyLabel];
        UILabel* label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.0];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"元";
        label.textColor = [UIColor blackColor];
        [contentView addSubview:label];
        [self.normalTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@60);
            make.height.equalTo(@30);
            make.centerY.equalTo(contentView);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(contentView).offset(-10);
            make.width.equalTo(@25);
            make.height.equalTo(@30);
            make.centerY.equalTo(contentView);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(label.mas_left);
            make.left.equalTo(self.normalTitleLabel.mas_right);
            make.height.equalTo(@30);
            make.centerY.equalTo(label).offset(-2);
        }];
        UIView* lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
        self.line = lineView;
        self.line.hidden = YES;
    }
    return self;
}

#pragma mark - getter, setter

- (UILabel*)normalTitleLabel
{
    if (_normalTitleLabel == nil) {
        _normalTitleLabel = [[UILabel alloc] init];
        _normalTitleLabel.backgroundColor = [UIColor clearColor];
        _normalTitleLabel.textColor = UIColorFromRGB(0x666666);
        _normalTitleLabel.textAlignment = NSTextAlignmentLeft;
        _normalTitleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _normalTitleLabel;
}
- (UILabel*)moneyLabel
{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.textColor = UIColorFromRGB(0xd80600);
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _moneyLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//钱不够订单时的提示信息
@implementation NoPayInfocell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView* contentView = self.contentView;
        contentView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:self.payMoney];
        UILabel* label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"由于充值渠道的金额限制，我们将对您的充值金额做进位取整，支付后多余的钱返还到您的大彩账户中。";
        label.textColor = UIColorFromRGB(0xafafaf);

        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        self.payIntrouceLabel = label;
        [contentView addSubview:label];
        [self.payMoney mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(contentView).offset(-10);
            make.height.equalTo(@20);
            make.top.equalTo(contentView).offset(10);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(contentView).offset(-10);
            make.left.equalTo(contentView).offset(10);
            make.bottom.equalTo(contentView).offset(-10);
            make.top.equalTo(self.payMoney.mas_bottom);
        }];
        UIView* lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

#pragma mark - getter, setter
//还需支付多少钱
- (UILabel*)payMoney
{
    if (_payMoney == nil) {
        _payMoney = [[UILabel alloc] init];
        _payMoney.backgroundColor = [UIColor clearColor];
        _payMoney.textColor = UIColorFromRGB(0x323232);
        _payMoney.textAlignment = NSTextAlignmentLeft;
        _payMoney.font = [UIFont systemFontOfSize:14.0];
    }
    return _payMoney;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//红包详情
@interface RedPacketInfocell () <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIButton *leftArrowButton; //左箭头
@property (nonatomic, strong, readonly) UIButton *rightArrowButton; //右箭头
@property (nonatomic, strong) NSArray *redElpViews; //红包view
@property (nonatomic, strong) NSArray *redArray;
@end
@implementation RedPacketInfocell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIView* line = [UIView dp_viewWithColor:UIColorFromRGB(0xdadad9)];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (void)bulidLayOut:(NSArray*)array
{
    self.redArray = array;
    UIView* contentView = self.contentView;
    self.backgroundColor = [UIColor clearColor];
    contentView.backgroundColor = [UIColor whiteColor];
    ;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.delegate = self;
    _leftArrowButton = [[UIButton alloc] init];
    [_leftArrowButton setImage:dp_RedPacketImage(@"left.png") forState:UIControlStateNormal];
    [_leftArrowButton setAdjustsImageWhenHighlighted:NO];
    _rightArrowButton = [[UIButton alloc] init];
    [_rightArrowButton setImage:dp_RedPacketImage(@"right.png") forState:UIControlStateNormal];
    [_rightArrowButton setAdjustsImageWhenHighlighted:NO];

    [_leftArrowButton addTarget:self action:@selector(pvt_onTap:) forControlEvents:UIControlEventTouchUpInside];
    [_rightArrowButton addTarget:self action:@selector(pvt_onTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.scrollView];
    [contentView addSubview:self.leftArrowButton];
    [contentView addSubview:self.rightArrowButton];
    NSMutableArray* views = [NSMutableArray arrayWithCapacity:10];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.width.equalTo(@(3 * kPageWidth));
        make.height.equalTo(@(kPageHeight));
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
    }];
    [self.leftArrowButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@40);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.scrollView.mas_left);
    }];
    [self.rightArrowButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@40);
        make.left.equalTo(self.scrollView.mas_right);
        make.right.equalTo(self.contentView);
    }];
    for (int i = 0; i < array.count; i++) {
        PBMCreateOrderResult_RedPacket* redpacketItem = [array objectAtIndex:i];
        DPRedPacketView* view = [[DPRedPacketView alloc] init];
        view.surplusLabel.text = [NSString stringWithFormat:@"剩余%d元", redpacketItem.curAmt];
        view.limitLabel.text = redpacketItem.useDesc;
        view.validityLabel.text = redpacketItem.endDate;
        view.identifier = (int)redpacketItem.id_p;
        view.currentAmt = redpacketItem.curAmt;
        view.tag = i;
        if (view.identifier == 0) {
            view.signLabel.text = @"";
            view.nameLabel.text = @"   大彩币";
        }
        else {
            view.nameLabel.text = [NSString stringWithFormat:@"%d", redpacketItem.origAmt];
        }
        [self.scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker* make) {
            make.width.equalTo(@(kPageWidth));
            make.height.equalTo(@(kPageHeight));
            make.top.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView);
        }];
        [views addObject:view];

        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onSelected:)]];
    }
    [[views firstObject] setSelected:YES];
    [[views firstObject] mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.scrollView);
    }];
    [views dp_enumeratePairsUsingBlock:^(UIView* obj1, NSUInteger idx1, UIView* obj2, NSUInteger idx2, BOOL* stop) {
        [obj2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(obj1.mas_right);
        }];
    }];
    [[views lastObject] mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.scrollView);
    }];
    self.redElpViews = views;
}
- (void)pvt_onSelected:(UITapGestureRecognizer*)tap
{
    NSInteger index = tap.view.tag;

    if ([self.redElpViews[index] isSelected]) {
        [self.redElpViews[index] setSelected:NO];

        DPRedPacketView* view = [self.redElpViews firstObject];
        if ([view identifier] == 0) {
            [view setSelected:YES];
            [self.scrollView scrollRectToVisible:view.frame animated:YES];

            index = 0;
        }
        else {
            index = -1;
        }
    }
    else {
        [self.redElpViews enumerateObjectsUsingBlock:^(DPRedPacketView* obj, NSUInteger idx, BOOL* stop) {
            obj.selected = idx == index;
        }];

        [self.scrollView scrollRectToVisible:[self.redElpViews[index] frame] animated:YES];
    }

    int redPayAmount = 0;
    if (index >= 0) {
        DPRedPacketView* view = self.redElpViews[index];
        redPayAmount = MIN(self.projectAmount, view.currentAmt);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRedPacketIndex:)]) {
        [self.delegate selectedRedPacketIndex:index];
    }
    //    self.redPacketAmtLabel.text = [NSString stringWithFormat:@"-%d", redPayAmount];
    //    self.realPayAmtLabel.text = [NSString stringWithFormat:@"%d", self.projectAmount - redPayAmount];
}

- (void)pvt_onTap:(UIButton*)button
{
    if (button == _leftArrowButton) {
        for (int i = (int)self.redElpViews.count - 1; i >= 0; i--) {
            UIView* view = self.redElpViews[i];
            if (CGRectGetMinX(view.frame) < self.scrollView.contentOffset.x) {
                [self.scrollView scrollRectToVisible:view.frame animated:YES];
                break;
            }
        }
    }
    else {
        for (int i = 0; i < self.redElpViews.count; i++) {
            UIView* view = self.redElpViews[i];
            if (CGRectGetMaxX(view.frame) > self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds)) {
                [self.scrollView scrollRectToVisible:view.frame animated:YES];
                break;
            }
        }
    }
}
- (void)viewDidLayoutSubviews
{
    [self scrollViewDidScroll:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    self.leftArrowButton.hidden = scrollView.contentOffset.x <= 0;
    self.rightArrowButton.hidden = scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.bounds.size.width);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
