//
//  DPHLItemCell.m
//  Jackpot
//
//  Created by mu on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLItemCell.h"
#import "DPHLItemView.h"


@interface DPHLItemHeaderView : UIView
@property (nonatomic, strong) UIButton *userIcon;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *userLVBgImage;
@property (nonatomic, strong) UIImageView *buyHlIcon;
@property (nonatomic, strong) UILabel *userLVLabel;
@property (nonatomic, strong) UILabel *userAwardRateLabel;
@property (nonatomic, strong) UIButton *buyBtn;
@end

@implementation DPHLItemHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor clearColor];
        
        self.userIcon = [UIButton dp_buttonWithTitle:nil titleColor:nil backgroundImage:dp_HeartLoveImage(@"HLUserIconBack.png") font:nil];
        self.userIcon.layer.cornerRadius = 15;
        self.userIcon.layer.masksToBounds = YES;
        [self addSubview:self.userIcon];
        [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.userNameLabel  = [UILabel dp_labelWithText:@"---" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:14]];
        [self addSubview:self.userNameLabel];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userIcon.mas_top);
            make.left.equalTo(self.userIcon.mas_right).offset(4);
        }];
        
        self.userLVBgImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"level.png")];
        self.userLVBgImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.userLVBgImage];
        [self.userLVBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userNameLabel.mas_centerY);
            make.left.equalTo(self.userNameLabel.mas_right).offset(4);
            make.size.mas_equalTo(CGSizeMake(44, 14));
        }];
        
        self.userLVLabel = [UILabel dp_labelWithText:@"LV-" backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:7]];
        [self.userLVBgImage addSubview:self.userLVLabel];
        [self.userLVLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userLVBgImage.mas_centerY);
            make.right.mas_equalTo(-8);
        }];
        
        self.userAwardRateLabel = [UILabel dp_labelWithText:@"近十场胜率：--" backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:11]];
        [self addSubview:self.userAwardRateLabel];
        [self.userAwardRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.userIcon.mas_bottom);
            make.left.equalTo(self.userNameLabel.mas_left);
        }];
        
        self.buyBtn = [UIButton dp_buttonWithTitle:@"心水价格 -元" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:15]];
        self.buyBtn.layer.cornerRadius = 5;
        self.buyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        [self addSubview:self.buyBtn];
        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(30);
        }];
        
        self.buyHlIcon =  [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLBuyIcon.png")];
        [self addSubview:self.buyHlIcon];
        [self.buyHlIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userIcon.mas_centerY);
            make.right.mas_equalTo(-8);
        }];
    }
    return self;
}

@end


@interface DPHLItemCell()
@property (nonatomic, strong) DPHLItemView *itemView;
@property (nonatomic, strong) DPHLItemHeaderView *headerView;
@property (nonatomic, strong) UIView *firstLine;
@property (nonatomic, strong) UIView *lastLine;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation DPHLItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headerView = [[DPHLItemHeaderView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.headerView];
        @weakify(self);
        [[self.headerView.userIcon rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
            @strongify(self);
            if (self.iconBtnTappedBlock) {
                self.iconBtnTappedBlock(self.object);
            }
        }];
        
        UITapGestureRecognizer *DPHLItemGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DPHLItemTapped)];
        [self.headerView addGestureRecognizer:DPHLItemGesture];
        [[self.headerView.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
            if (self.heartLoveOrderBlock) {
                self.heartLoveOrderBlock(self.object);
            }
        }];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(65);
        }];
        
        self.itemView = [[DPHLItemView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
        }];
        
        self.firstLine = [[UIView alloc]init];
        self.firstLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [self.contentView addSubview:self.firstLine];
        [self.firstLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.lastLine = [[UIView alloc]init];
        self.lastLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [self.contentView addSubview:self.lastLine];
        [self.lastLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"";
    self.indexPath = indexPath;
    DPHLItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPHLObject *)object{
    _object = object;
    self.headerView.buyHlIcon.hidden = _object.isFree?YES:(_object.haveBuy?NO:YES);
    self.headerView.buyBtn.hidden = _object.isFree?YES:(_object.haveBuy?YES:NO);
    self.headerView.userNameLabel.text = object.userNameLabelStr.length>10?[object.userNameLabelStr substringToIndex:10]:object.userNameLabelStr;
    self.headerView.userLVLabel.text = object.userLVLabelStr;
    self.headerView.userAwardRateLabel.text = [NSString stringWithFormat:@"近十场胜率:%@",object.userAwardRateLabelStr];
    [self.headerView.buyBtn setTitle:[NSString stringWithFormat:@"心水价格 %@元",object.buyBtnStr] forState:UIControlStateNormal];
    [self.headerView.userIcon setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:_object.userIconStr] placeholderImage:dp_AccountImage(@"UAIconDefalt.png")];
    
    self.itemView.matchValueLab.text = _object.isFree?_object.matchValueLabStr:(_object.haveBuy==NO?@"***":_object.matchValueLabStr);
    self.itemView.matchTitleLab.text = _object.matchTitleLabStr;
    self.itemView.buyIcon.hidden = _object.isFree;
    NSMutableAttributedString *buyCountAttribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@人已买",_object.buyCountLabelStr]];
    [buyCountAttribute addAttributes:@{NSForegroundColorAttributeName:[UIColor dp_flatRedColor]} range:NSMakeRange(0,_object.buyCountLabelStr.length)];
    self.itemView.buyCountLabel.attributedText = _object.isFree?[[NSMutableAttributedString alloc]initWithString:@""]:buyCountAttribute;
    self.itemView.awardIcon.hidden = _object.isFree?NO:_object.haveBuy?NO:YES;
    self.itemView.awardValueLabel.text = _object.isFree?[NSString stringWithFormat:@"预计盈利%@",_object.awardValueLabelStr]:_object.haveBuy?[NSString stringWithFormat:@"预计盈利%@",_object.awardValueLabelStr]:@"";
    self.itemView.hlIconImage.hidden = _object.isFree||_object.haveBuy;
    
    if ([_object.awardValueLabelStr floatValue]<0) {
        self.itemView.awardValueLabel.textColor = UIColorFromRGB(0x999999);
        [self.itemView.awardIcon setImage:dp_HeartLoveImage(@"HLUnAwardIcon.png")];
    }else{
        self.itemView.awardValueLabel.textColor = UIColorFromRGB(0xfd692b);
        [self.itemView.awardIcon setImage:dp_HeartLoveImage(@"HLAwardIcon.png")];
    }
    
    self.itemView.awardValueLabel.text = _object.isFree?_object.awardValueLabelStr:_object.haveBuy?_object.awardValueLabelStr:@"";
    if(object.result.length>0&&object.isWin==NO){
        self.itemView.awardValueLabel.textColor = UIColorFromRGB(0x999999);
        [self.itemView.awardIcon setImage:dp_HeartLoveImage(@"HLUnAwardIcon.png")];
    }
}
- (void)setBuyHlIconHiddle:(BOOL)buyHlIconHiddle{
    _buyHlIconHiddle = buyHlIconHiddle;
    self.headerView.buyHlIcon.hidden = buyHlIconHiddle;
}
#pragma mark---------function
- (void)DPHLItemTapped{
    @weakify(self);
    if(self.iconBtnTappedBlock){
        @strongify(self);
        self.iconBtnTappedBlock(self.object);
    }
}
@end
