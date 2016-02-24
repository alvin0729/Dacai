//
//  DPSuperPlayerCell.m
//  Jackpot
//
//  Created by mu on 15/8/3.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPSuperPlayerCell.h"
@interface playKind : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, assign) BOOL isFinished;
@end

@implementation playKind

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.titleLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:12]];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        self.iconImage  = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"forme.png")];
        self.iconImage.contentMode = UIViewContentModeCenter;
        [self addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
    }
    return self;
}

- (void)setIsFinished:(BOOL)isFinished{
    _isFinished = isFinished;
    self.iconImage.hidden = !_isFinished;
    if (_isFinished) {
        self.titleLabel.textColor = [UIColor dp_flatRedColor];
    }else{
        self.titleLabel.textColor = UIColorFromRGB(0x666666);
    }
}

@end


@interface DPSuperPlayerCell()
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rewardLabel;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) UIImageView *finishImage;
@property (nonatomic, strong) UIView *separatorLine;

@end

@implementation DPSuperPlayerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.contentView.backgroundColor = colorWithRGB(240,246,249);
        
        self.iconImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"superPlayer.png")];
        [self.contentView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(48, 48));
            make.left.mas_equalTo(8);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.equalTo(self.iconImage.mas_right).offset(10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(16);
        }];
        
        self.rewardLabel = [[UILabel alloc]init];
        self.rewardLabel.text = @"成长值：50  奖励：20";
        self.rewardLabel.font = [UIFont systemFontOfSize:10];
        self.rewardLabel.textColor = UIColorFromRGB(0x666666);
        [self.contentView addSubview:self.rewardLabel];
        [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-13);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
        
        self.arrowImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"arrow.png")];
        self.arrowImage.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.arrowImage];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-8);
            make.width.mas_equalTo(15);
        }];
        
        self.getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.getBtn.backgroundColor = UIColorFromRGB(0xfd6b6b);
        self.getBtn.layer.cornerRadius = 5;
        self.getBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.getBtn.userInteractionEnabled = NO;
        [self.getBtn setTitle:@"领取" forState:UIControlStateNormal];
        [self.getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.getBtn];
        [self.getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.mas_equalTo(-8);
            make.size.mas_equalTo(CGSizeMake(62, 30));
        }];
        
        self.finishImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"finishedIcon.png")];
        self.finishImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.finishImage];
        [self.finishImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.arrowImage.mas_left).offset(-8);
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
        
        self.separatorLine = [[UIView alloc]init];
        self.separatorLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.separatorLine];
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return  self;
}

- (void)setObject:(DPGSTaskObject *)object{
    _object = object;
    for (NSInteger i = 0 ; i<object.kindArray.count; i++) {
        DPPlayKind *kindObj = object.kindArray[i];
        playKind *kind = [[playKind alloc]init];
        kind.tag = 400+i;
        kind.titleLabel.text = kindObj.title;
        kind.isFinished = kindObj.isFinished;
        [self.contentView addSubview:kind];
        
        CGFloat x = 75*(i%3);
        CGFloat y = 8 + 18*(i/3);
        [kind mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(y);
            make.left.equalTo(self.titleLabel.mas_left).offset(x);
            make.width.mas_equalTo(75);
            make.height.mas_equalTo(12);
        }];
    }
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@（各种玩法中奖一次）",_object.titleLabelStr]];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0,_object.titleLabelStr.length)];
    self.titleLabel.attributedText = title;
    //奖励
    self.rewardLabel.text = _object.moneyLabStr;
    
    [self.iconImage setImageWithURL:[NSURL URLWithString:_object.iconImageURL] placeholderImage:dp_GropSystemResizeImage(@"taskDefault.png")];
    
    self.finishImage.hidden = YES;
    self.getBtn.hidden = YES;
    self.arrowImage.hidden = YES;
    //初始状态，可领取状态，完成状态
    if (_object.stata == DPTaskStateInitilizer) {
        self.arrowImage.hidden = NO;
    }else if (_object.stata == DPTaskStateCanGet) {
        self.getBtn.hidden = NO;
    }else if (_object.stata == DPTaskStateFinished) {
        self.finishImage.hidden = NO;
    }
}

@end
