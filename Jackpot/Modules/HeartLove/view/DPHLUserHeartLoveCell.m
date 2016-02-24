//
//  DPHLUserHeartLoveCell.m
//  Jackpot
//
//  Created by mu on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLUserHeartLoveCell.h"
#import "DPHLItemView.h"
@interface DPHLUserHeartLoveCell()
@property (nonatomic, strong) UIButton *freeIcon;
@property (nonatomic, strong) DPHLItemView *item;
@end

@implementation DPHLUserHeartLoveCell
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
        
        self.freeIcon = [UIButton dp_buttonWithTitle:@"" titleColor:[UIColor dp_flatRedColor] backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:11]];
        self.freeIcon.layer.borderWidth = 0.5;
        self.freeIcon.layer.borderColor = [UIColor dp_flatRedColor].CGColor;
        self.freeIcon.layer.cornerRadius = 3;
        self.freeIcon.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        [self.contentView addSubview:self.freeIcon];
        [self.freeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(11);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(16);
        }];
        
        self.item = [[DPHLItemView alloc]initWithFrame:CGRectZero];
        self.item.hlIconImage.hidden = YES;
        [self.contentView addSubview:self.item];
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.freeIcon.mas_bottom).offset(6);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
        }];
        
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPHLUserHeartLoveCell";
    DPHLUserHeartLoveCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPHLObject *)object{
    _object = object;
    [self.freeIcon setTitle:_object.isFree?@"免费":[NSString stringWithFormat:@"%@元",_object.buyBtnStr] forState:UIControlStateNormal];
    
    self.item.matchValueLab.text = _object.isFree?_object.matchValueLabStr:(_object.haveBuy==NO?@"***":_object.matchValueLabStr);
    self.item.matchTitleLab.text = _object.matchTitleLabStr;
    self.item.buyIcon.hidden = _object.isFree;
    NSMutableAttributedString *buyCountAttribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@人已买",_object.buyCountLabelStr]];
    [buyCountAttribute addAttributes:@{NSForegroundColorAttributeName:[UIColor dp_flatRedColor]} range:NSMakeRange(0,_object.buyCountLabelStr.length)];
    self.item.buyCountLabel.attributedText = _object.isFree?[[NSMutableAttributedString alloc]initWithString:@""]:buyCountAttribute;
    self.item.awardIcon.hidden = _object.isFree?NO:_object.haveBuy?NO:YES;
    self.item.awardValueLabel.text = _object.isFree?_object.awardValueLabelStr:_object.haveBuy?_object.awardValueLabelStr:@"";
    self.item.hlIconImage.hidden = _object.isFree||_object.haveBuy;
    
    self.item.awardValueLabel.text = _object.isFree?[NSString stringWithFormat:@"预计盈利%@",_object.awardValueLabelStr]:_object.haveBuy?[NSString stringWithFormat:@"预计盈利%@",_object.awardValueLabelStr]:@"";

    self.item.awardValueLabel.textColor = UIColorFromRGB(0xfd692b);
    [self.item.awardIcon setImage:dp_HeartLoveImage(@"HLAwardIcon.png")];

    
    self.item.awardValueLabel.text = _object.isFree?_object.awardValueLabelStr:_object.haveBuy?_object.awardValueLabelStr:@"";
    if(object.result.length>0&&object.isWin==NO){
        self.item.awardValueLabel.textColor = UIColorFromRGB(0x999999);
        [self.item.awardIcon setImage:dp_HeartLoveImage(@"HLUnAwardIcon.png")];
    }
}
@end
