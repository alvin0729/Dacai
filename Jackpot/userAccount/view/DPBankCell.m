//
//  DPBankCell.m
//  Jackpot
//
//  Created by mu on 15/9/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBankCell.h"

@implementation DPBankCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        UIView *indirectior = [[UIView alloc]init];
        indirectior.hidden = YES;
        indirectior.backgroundColor = UIColorFromRGB(0xdc4e4c);
        [self.contentView addSubview:indirectior];
        self.indirectorView = indirectior;
        [indirectior mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(5);
        }];
        
        self.bankIcon = [[UIImageView alloc]init];
        self.bankIcon.backgroundColor = [UIColor clearColor];
        self.bankIcon.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.bankIcon];
        [self.bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.mas_equalTo(90);
        }];
        
        self.bankNameLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:self.bankNameLabel];
        [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.bankIcon.mas_right).offset(15);
            make.height.mas_equalTo(17);
        }];
        
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPBankCell";
    DPBankCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPUAObject *)object{
    [super setObject:object];
    self.bankNameLabel.text = object.title;
    NSString *imageName = [NSString stringWithFormat:@"%@.png",object.title];
    self.bankIcon.image = dp_BankIconImage(imageName)?dp_BankIconImage(imageName):dp_BankIconImage(@"bankDefault.png");
    if (object.isSelect) {
        self.indirectorView.hidden = NO;
        self.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    }else{
        self.indirectorView.hidden = YES;
        self.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
}
@end
