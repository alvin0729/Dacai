//
//  DPGSHomeHeaderView.m
//  Jackpot
//
//  Created by mu on 15/7/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGSHomeHeaderView.h"
@interface DPGSHomeHeaderView()
@property (nonatomic, strong)UIImageView *bgImage;
@property (nonatomic, strong)UIImageView *levelIcon;
@property (nonatomic, strong)UILabel *levelLabel;
@property (nonatomic, strong)UILabel *jifenLabel;
@property (nonatomic, strong)UILabel *growValueLabel;
@property (nonatomic, strong)UIButton *shopBtn;
@property (nonatomic, strong)UIButton *rankingBtn;
@property (nonatomic, strong)UIView *transparencyView;
@property (nonatomic, strong)UIView *lineView;
@end


#define kMargin 15
#define kFont 14
#define shopBtnTag 1000
#define rankingBtnTag 1001

@implementation DPGSHomeHeaderView

- (instancetype)init{
    if (self = [super init]) {
//        self.backgroundColor = [UIColor colorWithPatternImage:dp_GropSystemResizeImage(@"headerBg.jpg")];
        self.bgImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"headerBg.jpg")];
        [self addSubview:self.bgImage];
        [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        
        self.iconImage = [[UIImageView alloc]initWithImage:dp_AccountImage(@"UAIconDefalt.png")];
        self.iconImage.layer.cornerRadius = 30;
        self.iconImage.layer.masksToBounds = YES;
        [self addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.text = [DPMemberManager sharedInstance].nickName;
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_bottom).offset(12);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        self.levelIcon = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"level.png")];
        [self addSubview:self.levelIcon];
        [self.levelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImage.mas_right).offset(-24);
            make.top.equalTo(self.iconImage.mas_top);
        }];
        
        self.levelLabel = [[UILabel alloc]init];
        self.levelLabel.textColor = [UIColor dp_flatRedColor];
        self.levelLabel.font = [UIFont systemFontOfSize:12];
        self.levelLabel.backgroundColor = [UIColor clearColor];
        self.levelLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(levelLabelTapped)];
        [self.levelLabel addGestureRecognizer:tapGesture];
        [self addSubview:self.levelLabel];
        [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.levelIcon.mas_centerX).offset(12);
            make.centerY.equalTo(self.levelIcon.mas_centerY);
            make.height.mas_equalTo(24);
        }];
        
        self.transparencyView = [[UIView alloc]init];
        self.transparencyView.backgroundColor = [UIColor colorWithPatternImage:dp_GropSystemResizeImage(@"headerBottom.png")];
        [self addSubview:self.transparencyView];
        [self.transparencyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(55);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.transparencyView.mas_top).offset(8);
            make.width.mas_equalTo(1);
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(-8);
        }];
        
        self.shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shopBtn.tag = shopBtnTag;
        self.shopBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.shopBtn.titleLabel.numberOfLines = 0;
        [self.shopBtn addTarget:self action:@selector(didTapp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.shopBtn];
        [self.shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.transparencyView.mas_top);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth*0.5);
            make.bottom.mas_equalTo(0);
        }];
       
        self.rankingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rankingBtn.tag = rankingBtnTag;
        self.rankingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.rankingBtn.titleLabel.numberOfLines = 0;
        [self.rankingBtn addTarget:self action:@selector(didTapp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rankingBtn];
        [self.rankingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.transparencyView.mas_top);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth*0.5);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}

- (void)setObject:(DPGSHomeHeaderObject *)object{
    _object = object;
    self.levelLabel.text = _object.levelLabelName;
    
    NSString *shopTitle = [NSString stringWithFormat:@"积分 %@\n商城 >",_object.jifenLabelName?_object.jifenLabelName:@"--"];
    [self.shopBtn setAttributedTitle:[self attributedStringWithString:shopTitle andChangeLength:_object.jifenLabelName.length] forState:UIControlStateNormal];
    
    NSString *rankingTitle = [NSString stringWithFormat:@"成长 %@\n排行 >",_object.growValueLabelName?_object.growValueLabelName:@"--"];
    [self.rankingBtn setAttributedTitle:[self attributedStringWithString:rankingTitle andChangeLength:_object.growValueLabelName.length] forState:UIControlStateNormal];

    if (_object.iconImageName.length>0) {
         [self.iconImage setImageWithURL:[NSURL URLWithString:_object.iconImageName] placeholderImage:dp_AccountImage(@"UAIconDefalt.png")];
    }
}
- (NSMutableAttributedString *)attributedStringWithString:(NSString *)str andChangeLength:(NSInteger)length{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 4;
    NSMutableAttributedString *shopChangeTitle = [[NSMutableAttributedString alloc]initWithString:str];
    [shopChangeTitle addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(3, length)];
    [shopChangeTitle addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatWhiteColor] range:NSMakeRange(0, shopChangeTitle.length)];
    [shopChangeTitle addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, shopChangeTitle.length)];
    return shopChangeTitle;
}


#pragma mark---------function
- (void)didTapp:(UIButton *)btn{
    if (self.tapBlock) {
        self.tapBlock(btn);
    }
}
- (void)levelLabelTapped{
    if (self.levelTappedBlock) {
        self.levelTappedBlock(nil);
    }
    
}
@end
