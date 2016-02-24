//
//  DPAccountFunctionCell.m
//  Jackpot
//
//  Created by mu on 15/8/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPAccountFunctionCell.h"
@interface DPAccountFunctionCell ()
/**
 *  betBtn
 */
@property (nonatomic, strong) UIButton *betBtn;
/**
 *  cellStyle
 */
@property (nonatomic, assign) UITableViewCellStyle cellStyle;
/**
 *
 */
@property (nonatomic, strong) NSIndexPath *index;

@end

@implementation DPAccountFunctionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellStyle = style;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor dp_flatBackgroundColor];

        self.icon = [[UIImageView alloc] init];
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(16);
            make.width.mas_equalTo(18);
        }];

        self.titleLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.icon.mas_right).offset(16);
            make.height.mas_equalTo(14);
        }];

        self.subTitleLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xb3b3b3) font:[UIFont systemFontOfSize:14]];
        self.subTitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
            make.left.equalTo(self.titleLabel.mas_left);
            make.height.mas_equalTo(14);
        }];

        self.messageCountLab = [[UILabel alloc] init];
        self.messageCountLab.backgroundColor = UIColorFromRGB(0xdc4e4c);
        self.messageCountLab.layer.cornerRadius = 10;
        self.messageCountLab.layer.masksToBounds = YES;
        self.messageCountLab.font = [UIFont systemFontOfSize:10];
        self.messageCountLab.textAlignment = NSTextAlignmentCenter;
        self.messageCountLab.textColor = [UIColor dp_flatWhiteColor];
        [self.contentView addSubview:self.messageCountLab];
        [self.messageCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(8);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];

        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = UIColorFromRGB(0x333333);
        self.textLabel.font = [UIFont systemFontOfSize:14];

        self.separatorLine.backgroundColor = UIColorFromRGB(0xbbbbab);
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(100);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    DPAccountFunctionCell *cell = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    self.index = indexPath;
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPUAObject *)object {
    [super setObject:object];
    self.icon.image = dp_AccountImage(object.imageName);
    self.titleLabel.text = object.title;
    self.messageCountLab.text = [object.value integerValue] > 99 ? @"99+" : object.value;
    self.messageCountLab.hidden = ![object.value integerValue] > 0;
}

@end
