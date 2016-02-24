//
//  DPHLUserHeaderView.m
//  Jackpot
//
//  Created by mu on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLUserHeaderView.h"
#import "DPHLHeartLoveMark.h"
@interface DPHLUserHeaderView()
@property (nonatomic, strong) NSMutableArray *markViewArray;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation DPHLUserHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        self.userIcon = [[UIImageView alloc]initWithImage:dp_AccountImage(@"UAIconDefalt.png")];
        self.userIcon.layer.cornerRadius = 25;
        self.userIcon.layer.masksToBounds = YES;
        self.userIcon.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.userIcon];
        [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(11);
            make.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        self.userNameLabel  = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:17]];
        [self addSubview:self.userNameLabel];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userIcon.mas_top).offset(-1);
            make.left.equalTo(self.userIcon.mas_right).offset(12);
            make.height.mas_equalTo(17);
        }];
        
        self.userLVBgImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"level.png")];
        self.userLVBgImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.userLVBgImage];
        [self.userLVBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userNameLabel.mas_centerY);
            make.left.equalTo(self.userNameLabel.mas_right).offset(2);
            make.size.mas_equalTo(CGSizeMake(40, 14));
        }];
        
        self.userLVLabel = [UILabel dp_labelWithText:@"LV-" backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:7]];
        [self.userLVBgImage addSubview:self.userLVLabel];
        [self.userLVLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userLVBgImage.mas_centerY);
            make.right.mas_equalTo(-8);
        }];

        self.userfansLabel = [UILabel dp_labelWithText:@"粉丝数：--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:13]];
        [self addSubview:self.userfansLabel];
        
        self.userAwardRateLabel = [UILabel dp_labelWithText:@"总胜率：--  月盈率：--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:13]];
        [self addSubview:self.userAwardRateLabel];
        
        [self.userfansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameLabel.mas_bottom).offset(6);
            make.left.equalTo(self.userNameLabel.mas_left);
            make.height.mas_equalTo(13);
        }];
        
        [self.userAwardRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userfansLabel.mas_bottom).offset(6);
            make.left.equalTo(self.userNameLabel.mas_left);
            make.height.mas_equalTo(13);
        }];
        
        
        
        self.focusBtn = [UIButton dp_buttonWithTitle:@"关注" titleColor:UIColorFromRGB(0x669f49) backgroundColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:17]];
        self.focusBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        self.focusBtn.layer.cornerRadius = 5;
        self.focusBtn.layer.borderWidth = 1;
        self.focusBtn.layer.borderColor = UIColorFromRGB(0x669f49).CGColor;
        [self addSubview:self.focusBtn];
        [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userIcon.mas_top);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(30);
        }];
        
        self.lastWeekWinRateLabel = [UILabel dp_labelWithText:@"上周周胜率：--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:13]];
        self.lastWeekWinRateLabel.textAlignment = NSTextAlignmentCenter;
        self.lastWeekWinRateLabel.layer.borderColor = UIColorFromRGB(0xf0f0f0).CGColor;
        self.lastWeekWinRateLabel.layer.borderWidth = 0.5;
        [self addSubview:self.lastWeekWinRateLabel];
    
        self.lastWeekAwardRateLabel = [UILabel dp_labelWithText:@"上周胜率：--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:13]];
        self.lastWeekAwardRateLabel.textAlignment = NSTextAlignmentCenter;
        self.lastWeekAwardRateLabel.layer.borderColor = UIColorFromRGB(0xf0f0f0).CGColor;
        self.lastWeekAwardRateLabel.layer.borderWidth = 0.5;
        [self addSubview:self.lastWeekAwardRateLabel];
        
        [self.lastWeekWinRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userAwardRateLabel.mas_bottom).offset(12);
            make.left.mas_equalTo(16);
            make.height.mas_equalTo(27);
            make.right.equalTo(self.lastWeekAwardRateLabel.mas_left).offset(0.5);
            make.width.equalTo(self.lastWeekAwardRateLabel.mas_width);
        }];
        [self.lastWeekAwardRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastWeekWinRateLabel.mas_top);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(27);
        }];
        
        self.userDescribText = [[UITextField alloc]init];
        self.userDescribText.borderStyle = UITextBorderStyleNone;
        self.userDescribText.layer.cornerRadius =  14;
        self.userDescribText.backgroundColor = UIColorFromRGB(0xf0f0f0);
        self.userDescribText.placeholder = @"";
        self.userDescribText.textColor =UIColorFromRGB(0x999999);
        self.userDescribText.font = [UIFont systemFontOfSize:14];
        self.userDescribText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 27)];
        self.userDescribText.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.userDescribText];
        [self.userDescribText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-12);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(28);
        }];
        
        UILabel *titleLabel = [UILabel dp_labelWithText:@"个人简历" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xbdbdbd) font:[UIFont systemFontOfSize:11]];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.userDescribText.mas_top).offset(-9);
            make.left.mas_equalTo(16);
            make.height.mas_equalTo(11);
        }];
        
        UIImageView *penIcon = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLPen.png")];
        UIView *penView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 27)];
        [penView addSubview:penIcon];
        penIcon.userInteractionEnabled = YES;
        self.penImage = penIcon;
        [penIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(penView.mas_centerY);
            make.left.mas_equalTo(0);
        }];
        
        self.userDescribText.rightView = penView;
        self.userDescribText.enabled = NO;
        self.userDescribText.rightViewMode = UITextFieldViewModeNever;
        UITapGestureRecognizer *penTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(penIconTapped)];
        [penIcon addGestureRecognizer:penTapGesture];
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
        bottomLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [self addSubview:bottomLine];
        self.bottomLine = bottomLine;
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}
/**
 *  用户编辑图标点击
 */
- (void)penIconTapped{
    [self.userDescribText becomeFirstResponder];
}

/**
 *  设置用户标签：如果标签都存在，就将其删除，然后遍历标签数组，添加标签
 *
 *  @param markTitleArray 用户标签数组
 */
- (void)setMarkTitleArray:(NSMutableArray *)markTitleArray{
    _markTitleArray = markTitleArray;
    if (self.markViewArray.count>0) {
        for (NSInteger i = 0; i < self.markViewArray.count; i++) {
            DPHLHeartLoveMark *markView = self.markViewArray[i];
            [markView removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i < markTitleArray.count; i++) {
        DPHLHeartLoveMark *markView = [[DPHLHeartLoveMark alloc]init];
        markView.markImage.image = dp_HeartLoveImage(@"HLSuperBg.png");
        markView.markTitleLable.text = markTitleArray[i];
        markView.markTitleLable.font = [UIFont systemFontOfSize:10];
        [self addSubview:markView];
        [markView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.left.equalTo(self.titleLabel.mas_right).offset(4+36*i);
            make.size.mas_equalTo(CGSizeMake(32, 15));
        }];
        [self.markViewArray addObject:markView];
    }
    
}
/**
 *  重写表头对象的set方法，以此给表头各个控件赋值
 *
 *  @param object 表头对象模型
 */
- (void)setObject:(DPHLObject *)object{
    _object = object;
    [self.userIcon setImageWithURL:[NSURL URLWithString:_object.userIconStr] placeholderImage:dp_AccountImage(@"UAIconDefalt.png")];
    self.userNameLabel.text = _object.userNameLabelStr.length>10?[_object.userNameLabelStr substringToIndex:10]: _object.userNameLabelStr;
    self.userLVLabel.text = _object.userLVLabelStr;
    self.userfansLabel.text = [NSString stringWithFormat:@"粉丝：%@",_object.subTitle];
    self.userAwardRateLabel.text = [NSString stringWithFormat:@"总胜率:%@    近30天盈利:%@",_object.value,_object.subValue];
    NSMutableAttributedString *winAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"近7天胜率：%@",_object.detail]];
    [winAttributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dp_flatRedColor]} range:NSMakeRange(6, _object.detail.length)];
    NSMutableAttributedString *awardAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"近7天盈利：%@",_object.subDetail]];
    [awardAttributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dp_flatRedColor]} range:NSMakeRange(6, _object.detail.length)];
    self.lastWeekWinRateLabel.attributedText = winAttributeStr;
    self.lastWeekAwardRateLabel.attributedText = awardAttributeStr;
    self.userDescribText.text = _object.title.length>0?object.title:@"虽然我很懒，但我有方案！";
    self.markTitleArray = _object.marksArray;
    
    
    [self.focusBtn setTitle:_object.isSelect?@"已关注":@"关注" forState:UIControlStateNormal];
    [self.focusBtn setTitleColor:_object.isSelect?UIColorFromRGB(0x999999):UIColorFromRGB(0x669f49) forState:UIControlStateNormal];
    self.focusBtn.layer.borderColor = _object.isSelect?UIColorFromRGB(0x999999).CGColor:UIColorFromRGB(0x669f49).CGColor;
}
@end
