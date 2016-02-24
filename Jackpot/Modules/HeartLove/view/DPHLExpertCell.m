//
//  DPHLExpertCell.m
//  Jackpot
//
//  Created by mu on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLExpertCell.h"
#import "DPHLItemView.h"
@interface DPHLExpertCell()
@property (nonatomic, strong) DPHLItemView *item;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIImageView *buyHlIcon;
@end


@implementation DPHLExpertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *upLine = [[UIView alloc]init];
        upLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [self.contentView addSubview:upLine];
        self.upLine = upLine;
        [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UIView *downLine = [[UIView alloc]init];
        downLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [self.contentView addSubview:downLine];
        self.downLine = downLine;
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.buyBtn = [UIButton dp_buttonWithTitle:@"心水价格 10元" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:15]];
        self.buyBtn.layer.cornerRadius = 5;
        self.buyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        @weakify(self);
        [[self.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
            @strongify(self);
            if (self.heartLoveOrderBlock) {
                self.heartLoveOrderBlock(self.object);
            }
        }];
        [self addSubview:self.buyBtn];
        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(30);
        }];
        
        self.item = [[DPHLItemView alloc]initWithFrame:CGRectZero];
        self.item.hlIconImage.hidden = YES;
        [self.contentView addSubview:self.item];
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buyBtn.mas_bottom).offset(8);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
        }];
        
        self.buyHlIcon =  [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLBuyIcon.png")];
        [self addSubview:self.buyHlIcon];
        [self.buyHlIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.item.mas_top);
            make.right.mas_equalTo(-16);
        }];
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPHLExpertCell";
    DPHLExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPHLObject *)object{
    _object = object;
    
    [self.buyBtn setTitle:[NSString stringWithFormat:@"心水价格 %@元",object.buyBtnStr] forState:UIControlStateNormal];
    self.item.matchValueLab.text = _object.isFree?_object.matchValueLabStr:(_object.haveBuy==NO?@"***":_object.matchValueLabStr);
    self.item.matchTitleLab.text = _object.matchTitleLabStr;
    self.item.buyIcon.hidden = _object.isFree;
    NSMutableAttributedString *buyCountAttribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@人已买",_object.buyCountLabelStr]];
    [buyCountAttribute addAttributes:@{NSForegroundColorAttributeName:[UIColor dp_flatRedColor]} range:NSMakeRange(0,_object.buyCountLabelStr.length)];
    self.item.buyCountLabel.attributedText = _object.isFree?[[NSMutableAttributedString alloc]initWithString:@""]:buyCountAttribute;
    self.item.awardIcon.hidden = _object.isFree?NO:_object.haveBuy?NO:YES;
    self.item.awardValueLabel.text = _object.isFree?[NSString stringWithFormat:@"预计盈利%@",_object.awardValueLabelStr]:_object.haveBuy?[NSString stringWithFormat:@"预计盈利%@",_object.awardValueLabelStr]:@"";
    self.item.hlIconImage.hidden = _object.isFree||_object.haveBuy;
    self.buyHlIcon.hidden = _object.isFree?YES:(_object.haveBuy?NO:YES);
    self.buyBtn.hidden = _object.isFree?YES:(_object.haveBuy?YES:NO);
    
    if ([_object.awardValueLabelStr floatValue]<0) {
        self.item.awardValueLabel.textColor = UIColorFromRGB(0x999999);
        [self.item.awardIcon setImage:dp_HeartLoveImage(@"HLUnAwardIcon.png")];
    }else{
        self.item.awardValueLabel.textColor = UIColorFromRGB(0xfd692b);
        [self.item.awardIcon setImage:dp_HeartLoveImage(@"HLAwardIcon.png")];
    }
    
    self.item.awardValueLabel.text = _object.isFree?_object.awardValueLabelStr:_object.haveBuy?_object.awardValueLabelStr:@"";
    if(object.result.length>0&&object.isWin==NO){
        self.item.awardValueLabel.textColor = UIColorFromRGB(0x999999);
        [self.item.awardIcon setImage:dp_HeartLoveImage(@"HLUnAwardIcon.png")];
    }
}
@end
