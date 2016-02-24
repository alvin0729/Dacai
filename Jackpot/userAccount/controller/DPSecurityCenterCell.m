//
//  DPSecurityCenterCell.m
//  Jackpot
//
//  Created by sxf on 15/8/19.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPImageLabel.h"
#import "DPSecurityCenterCell.h"

//手机认证
@interface DPSecurityCenterCell () {
@private
    UILabel *_titleLabel;
    UILabel *_infoLabel;
    UILabel *_changeLabel;
    
}

@property (nonatomic, strong, readonly) UILabel* titleLabel; //标题
@property (nonatomic, strong, readonly) UILabel* infoLabel; //简介
@property (nonatomic, strong, readonly) UILabel* changeLabel; //点击按钮--修改/绑定

@end

@implementation DPSecurityCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIView* contentView = self.contentView;
        contentView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:self.titleLabel];
        [contentView addSubview:self.infoLabel];
        [contentView addSubview:self.changeLabel];
        UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
        [contentView addSubview:line1];
        UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
        [contentView addSubview:line2];
        UIImageView* changeView = [[UIImageView alloc] init];
        changeView.backgroundColor = [UIColor clearColor];
        changeView.image = dp_AccountImage(@"rightArrow.png");
        [contentView addSubview:changeView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(15);
            make.right.equalTo(contentView).offset(60);
            make.top.equalTo(contentView).offset(10);
            make.height.equalTo(@25);
        }];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.titleLabel);
            make.right.equalTo(contentView);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.equalTo(@15);
        }];
        [changeView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.width.equalTo(@8);
            make.right.equalTo(contentView).offset(-10);
            make.height.equalTo(@15);
            make.centerY.equalTo(contentView);
        }];
        [self.changeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(changeView.mas_left).offset(-1);
            make.width.equalTo(@50);
            make.centerY.equalTo(changeView);
            make.height.equalTo(@25);
        }];
        [line1 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
        [line2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
        [contentView addGestureRecognizer:({
                         UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_changePhone)];
                         tapRecognizer;
                     })];
    }
    return self;
}
//标题设置(手机号码设置)
- (void)setTitleLabelText:(NSString*)text
{
    self.titleLabel.text = text;
}
//设置点击按钮
- (void)setChangeLabelShow:(BOOL)isShow
{
    self.changeLabel.hidden = !isShow;
    
}
//设置说明文字
- (void)setInfoLabelText:(NSString*)text
{
    self.infoLabel.text = text;
}
//修改银行卡
- (void)pvt_changePhone
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePhoneForCell:)]) {
        [self.delegate changePhoneForCell:self];
    }
}
#pragma mark - getter, setter

//标题
- (UILabel*)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x333248);
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}
//简介
- (UILabel*)infoLabel
{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = UIColorFromRGB(0x989898);
        _infoLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _infoLabel;
}
//点击按钮--修改/绑定
- (UILabel*)changeLabel
{
    if (_changeLabel == nil) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.backgroundColor = [UIColor clearColor];
        _changeLabel.textColor = UIColorFromRGB(0xccccc9);
        _changeLabel.font = [UIFont systemFontOfSize:14.0];
        _changeLabel.textAlignment = NSTextAlignmentRight;
        _changeLabel.text = @"修改";

    }
    return _changeLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//登录密码  支付密码
@implementation DPAredgeAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView* contentView = self.contentView;
        contentView.backgroundColor = [UIColor dp_flatWhiteColor];
        UIImageView* view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.image = dp_AccountImage(@"rightArrow.png");
        UIView* line = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
        [contentView addSubview:line];
        [contentView addSubview:view];
        [contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(15);
            make.right.equalTo(@200);
            make.top.equalTo(contentView);
            make.centerY.equalTo(contentView);
        }];
        [view mas_makeConstraints:^(MASConstraintMaker* make) {
            make.width.equalTo(@8);
            make.right.equalTo(contentView).offset(-10);
            make.height.equalTo(@15);
            make.centerY.equalTo(contentView);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
        [contentView addGestureRecognizer:({
                         UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_changePassWord)];
                         tapRecognizer;
                     })];
    }
    return self;
}
//修改密码
- (void)pvt_changePassWord
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePassWordForCell:)]) {
        [self.delegate changePassWordForCell:self];
    }
}
#pragma mark - getter, setter
- (UILabel*)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x333248);
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}
@end

//账户信息->实名认证->提款信息
@interface DPAcountInfoCell () {
@private
    UILabel *_userName;
    UILabel *_cardId;
    UILabel *_bankInfo;
    UILabel *_address;
}
@property (nonatomic, strong, readonly) UILabel *userName; //用户姓名
@property (nonatomic, strong, readonly) UILabel *cardId; //用户身份证
@property (nonatomic, strong, readonly) UILabel *bankInfo; //提款银行
@property (nonatomic, strong, readonly) UILabel *address; //提款银行归属地
@end

@implementation DPAcountInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView* contentView = self.contentView;
        contentView.backgroundColor = [UIColor clearColor];
        UILabel* oneTitle = [self createLabel:@"实名信息" textColor:UIColorFromRGB(0x464644) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14.0]];
        UILabel* twoTitle = [self createLabel:@"提款银行卡" textColor:UIColorFromRGB(0x464644) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14.0]];
        UIView* aceView = [UIView dp_viewWithColor:[UIColor whiteColor]];
        UIView* bankView = [UIView dp_viewWithColor:[UIColor whiteColor]];
        //
        [contentView addSubview:oneTitle];
        [contentView addSubview:twoTitle];
        [contentView addSubview:aceView];
        [contentView addSubview:bankView];
        [oneTitle mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(16);
            make.right.equalTo(contentView).offset(-16);
            make.top.equalTo(contentView).offset(25);
            make.height.equalTo(@14);
        }];
        [aceView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.top.equalTo(oneTitle.mas_bottom).offset(12);
            make.height.equalTo(@88);
        }];
        [twoTitle mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(16);
            make.right.equalTo(contentView).offset(-16);
            make.top.equalTo(aceView.mas_bottom).offset(25);
            make.height.equalTo(@14);
        }];

        [bankView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.top.equalTo(twoTitle.mas_bottom).offset(12);
            make.height.equalTo(@60);
        }];

        //实名信息
        UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
        UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
        UIView* line3 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
        [aceView addSubview:line1];
        [aceView addSubview:line2];
        [aceView addSubview:line3];
        [aceView addSubview:self.userName];
        [aceView addSubview:self.cardId];
        UILabel* aceName = [self createLabel:@"姓   名:" textColor:UIColorFromRGB(0x686868) textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:16.0]];
        UILabel* cardText = [self createLabel:@"身份证:" textColor:UIColorFromRGB(0x686868) textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:16.0]];
        [aceView addSubview:aceName];
        [aceView addSubview:cardText];
        [aceName mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(aceView).offset(16);
            make.width.equalTo(@53);
            make.top.equalTo(aceView);
            make.height.equalTo(@44);
        }];
        [cardText mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(aceName);
            make.right.equalTo(aceName);
            make.top.equalTo(aceName.mas_bottom);
            make.height.equalTo(@44);
        }];
        [self.userName mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(aceName.mas_right).offset(5);
            make.right.equalTo(aceView).offset(-16);
            make.top.equalTo(aceView);
            make.height.equalTo(@44);
        }];
        [self.cardId mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.userName);
            make.right.equalTo(self.userName);
            make.top.equalTo(self.userName.mas_bottom);
            make.height.equalTo(@44);
        }];
        [line1 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(aceView);
            make.right.equalTo(aceView);
            make.top.equalTo(aceView);
            make.height.equalTo(@0.5);
        }];
        [line2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(aceView).offset(16);
            make.right.equalTo(aceView);
            make.top.equalTo(self.userName.mas_bottom);
            make.height.equalTo(@0.5);
        }];
        [line3 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(aceView);
            make.right.equalTo(aceView);
            make.bottom.equalTo(self.cardId);
            make.height.equalTo(@0.5);
        }];

        //提款银行卡
        DPImageLabel* imageLabel = [[DPImageLabel alloc] init];
        imageLabel.spacing = 1;
        imageLabel.imagePosition = DPImagePositionRight;
        imageLabel.backgroundColor = [UIColor clearColor];
        imageLabel.font = [UIFont dp_systemFontOfSize:14];
        imageLabel.image = dp_AccountImage(@"rightArrow.png");
        imageLabel.text = @"修改";
        imageLabel.textColor = UIColorFromRGB(0xccccc9);
        UIView* line21 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
        UIView* line22 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
        [bankView addSubview:line21];
        [bankView addSubview:line22];
        [bankView addSubview:self.bankInfo];
        [bankView addSubview:self.address];
        [bankView addSubview:imageLabel];
        [imageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(bankView);
            make.right.equalTo(bankView).offset(-12);
            make.width.equalTo(@30);
            make.height.equalTo(@35);
        }];
        [self.bankInfo mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(bankView).offset(15);
            make.right.equalTo(imageLabel.mas_left);
            make.top.equalTo(bankView).offset(10);
            make.height.equalTo(@20);
        }];
        [self.address mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.bankInfo);
            make.right.equalTo(self.bankInfo);
            make.top.equalTo(self.bankInfo.mas_bottom);
            make.height.equalTo(@20);
        }];
        [line21 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(bankView);
            make.right.equalTo(bankView);
            make.top.equalTo(bankView);
            make.height.equalTo(@0.5);
        }];
        [line22 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(bankView);
            make.right.equalTo(bankView);
            make.bottom.equalTo(bankView);
            make.height.equalTo(@0.5);
        }];
        [bankView addGestureRecognizer:({
                      UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_changebank)];
                      tapRecognizer;
                  })];
    }
    return self;
}

//用户姓名
- (void)setUsernameText:(NSString*)text
{
    self.userName.text = text;
}
//身份证信息
- (void)setCardIdText:(NSString*)text
{
    self.cardId.text = text;
}
//银行卡信息
- (void)setBankInfoText:(NSString*)text
{
    self.bankInfo.text = text;
}
//归属地信息
- (void)setAddressText:(NSString*)text
{
    self.address.text = text;
}
//修改银行卡信息
- (void)pvt_changebank
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeDrawBankForCell:)]) {
        [self.delegate changeDrawBankForCell:self];
    }
}
#pragma mark - getter, setter

//用户姓名
- (UILabel*)userName
{
    if (_userName == nil) {
        _userName = [[UILabel alloc] init];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textColor = [UIColor dp_flatBlackColor];
        _userName.font = [UIFont systemFontOfSize:16.0];
        //        _userName.text=@"姓名: ";
    }
    return _userName;
}
//用户身份证
- (UILabel*)cardId
{
    if (_cardId == nil) {
        _cardId = [[UILabel alloc] init];
        _cardId.backgroundColor = [UIColor clearColor];
        _cardId.textColor = [UIColor dp_flatBlackColor];
        _cardId.font = [UIFont systemFontOfSize:16.0];
        //        _cardId.text=@"身份证: ";
    }
    return _cardId;
}
//提款银行
- (UILabel*)bankInfo
{
    if (_bankInfo == nil) {
        _bankInfo = [[UILabel alloc] init];
        _bankInfo.backgroundColor = [UIColor clearColor];
        _bankInfo.textColor = [UIColor dp_flatBlackColor];
        _bankInfo.font = [UIFont systemFontOfSize:16.0];
    }
    return _bankInfo;
}
//提款银行归属地
- (UILabel*)address
{
    if (_address == nil) {
        _address = [[UILabel alloc] init];
        _address.backgroundColor = [UIColor clearColor];
        _address.textColor = UIColorFromRGB(0x969696);
        _address.font = [UIFont systemFontOfSize:12.0];
        _address.text = @"归属地:";
    }
    return _address;
}
- (UILabel*)createLabel:(NSString*)text textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont*)font
{
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.font = font;
    return label;
}
@end
