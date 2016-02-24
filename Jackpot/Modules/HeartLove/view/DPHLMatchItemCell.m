//
//  DPHLMatchItemCell.m
//  Jackpot
//
//  Created by mu on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLMatchItemCell.h"
#import "UIImageView+DPExtension.h"
@interface DPHLMatchItemCell()
@property (nonatomic, strong) UILabel *matchTypelab;
@property (nonatomic, strong) UILabel *Eventslab;
@property (nonatomic, strong) UILabel *heartlab;
@property (nonatomic, strong) UILabel *homeTeamNamelab;
@property (nonatomic, strong) UILabel *guestTeamNamelab;
@property (nonatomic, strong) UILabel *matchTimelab;
@property (nonatomic, strong) UIImageView *homeTeamIconImage;
@property (nonatomic, strong) UIImageView *guestTeamIconImage;
@property (nonatomic, strong) UIImageView *arrowImage;
@end

@implementation DPHLMatchItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.matchTypelab = [UILabel dp_labelWithText:@"●竞彩足球" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:11]];
        [self.contentView addSubview:self.matchTypelab];
        [self.matchTypelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(16);
        }];
        
        self.Eventslab = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.Eventslab];
        [self.Eventslab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.matchTypelab.mas_bottom);
            make.left.equalTo(self.matchTypelab.mas_right).offset(4);
        }];
        
        self.heartlab = [UILabel dp_labelWithText:@"心水:--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:11]];
        [self.contentView addSubview:self.heartlab];
        [self.heartlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.matchTypelab.mas_bottom);
            make.right.mas_equalTo(-16);
        }];
        
        self.hotMatchIconlab = [UILabel dp_labelWithText:@"hot" backgroundColor:[UIColor dp_flatRedColor] textColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:10]];
        self.hotMatchIconlab.textAlignment = NSTextAlignmentCenter;
        self.hotMatchIconlab.layer.cornerRadius = 3;
        self.hotMatchIconlab.layer.masksToBounds = YES;
        [self.contentView addSubview:self.hotMatchIconlab];
        [self.hotMatchIconlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.heartlab.mas_centerY);
            make.right.equalTo(self.heartlab.mas_left).offset(-2);
            make.size.mas_equalTo(CGSizeMake(22, 11));
        }];
        
        UILabel *vsLabel = [UILabel dp_labelWithText:@"VS" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0X333333) font:[UIFont boldSystemFontOfSize:24]];
        vsLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:vsLabel];
        [vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(39);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.mas_equalTo(49);
        }];
        
        self.matchTimelab = [UILabel dp_labelWithText:@"--:--截至" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:11]];
        [self.contentView addSubview:self.matchTimelab];
        [self.matchTimelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(vsLabel.mas_bottom).offset(2);
            make.centerX.equalTo(vsLabel.mas_centerX);
        }];
        
        self.homeTeamIconImage = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"default.png")];
        self.homeTeamIconImage.layer.cornerRadius = 20;
        self.homeTeamIconImage.layer.masksToBounds = YES;
        self.homeTeamIconImage.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
        self.homeTeamIconImage.layer.borderWidth = 1.5;
        [self.contentView addSubview:self.homeTeamIconImage];
        [self.homeTeamIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(vsLabel.mas_centerY);
            make.right.equalTo(vsLabel.mas_left).offset(-27);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        self.guestTeamIconImage = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"default.png")];
        self.guestTeamIconImage.layer.cornerRadius = 20;
        self.guestTeamIconImage.layer.masksToBounds = YES;
        self.guestTeamIconImage.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
        self.guestTeamIconImage.layer.borderWidth = 1.5;
        [self.contentView addSubview:self.guestTeamIconImage];
        [self.guestTeamIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(vsLabel.mas_centerY);
            make.left.equalTo(vsLabel.mas_right).offset(27);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        self.homeTeamNamelab = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.homeTeamNamelab];
        [self.homeTeamNamelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.homeTeamIconImage.mas_bottom).offset(2);
            make.centerX.equalTo(self.homeTeamIconImage.mas_centerX);
        }];
        
        self.guestTeamNamelab = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.guestTeamNamelab];
        [self.guestTeamNamelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.guestTeamIconImage.mas_bottom).offset(2);
            make.centerX.equalTo(self.guestTeamIconImage.mas_centerX);
        }];
            
        self.arrowImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"arrow.png")];
        [self.contentView addSubview:self.arrowImage];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-16);
        }];
        
        
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPHLMatchItemCell";
    DPHLMatchItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    self.upLine.hidden = indexPath.row!=0;
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPHLObject *)object{
    _object = object;
    self.Eventslab.text = object.title;
    self.heartlab.text = [NSString stringWithFormat:@"心水:%@",_object.subTitle];
    [self.homeTeamIconImage dp_setImageWithURL:_object.value andPlaceholderImage:dp_SportLotteryImage(@"default.png")];
    self.homeTeamNamelab.text = _object.subValue;
    [self.guestTeamIconImage dp_setImageWithURL:_object.detail andPlaceholderImage:dp_SportLotteryImage(@"default.png")];
    self.guestTeamNamelab.text = _object.subDetail;
    self.matchTimelab.text = _object.matchTime;
    
}

@end
