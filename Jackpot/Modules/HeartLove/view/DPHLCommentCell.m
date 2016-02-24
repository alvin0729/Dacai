//
//  DPHLCommentCell.m
//  Jackpot
//
//  Created by mu on 16/1/7.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import "DPHLCommentCell.h"
#import "DPImageLabel.h"
@interface DPHLCommentCell()
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *timeIcon;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) NSIndexPath *index;
@end

@implementation DPHLCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        

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
        
        self.iconImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.iconImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        self.titleLabel = [UILabel dp_labelWithText:@"XXX" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_top);
            make.left.equalTo(self.iconImage.mas_right).offset(12);
            make.height.mas_equalTo(14);
        }];
        
        self.timeIcon = [[UIImageView alloc]initWithImage:dp_SportLiveImage(@"clock.png")];
        [self.contentView addSubview:self.timeIcon];
        [self.timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.left.equalTo(self.titleLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        self.timeLabel = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.timeIcon.mas_centerY);
            make.left.equalTo(self.timeIcon.mas_right).offset(4);
        }];
        
        self.contentLabel =  [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:12]];
        self.contentLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *contentGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTapped:)];
        [self.contentView addGestureRecognizer:contentGesture];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeIcon.mas_bottom).offset(4);
            make.left.equalTo(self.timeIcon.mas_left);
            make.right.mas_equalTo(-16);
            make.bottom.mas_equalTo(-10);
        }];
        
        self.likeLabel = [UILabel dp_labelWithText:@"-" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.likeLabel];
        
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likeBtn setImage:dp_SportLiveImage(@"agree_normal.png") forState:UIControlStateNormal];
        [self.likeBtn setImage:dp_SportLiveImage(@"agree_select.png") forState:UIControlStateSelected];
        self.likeBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.likeBtn];
        
        [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.likeBtn.mas_centerY);
            make.right.mas_equalTo(-16);
        }];
        [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_top);
            make.right.equalTo(self.likeLabel.mas_left).offset(-2);
        }];
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPHLCommentCell";
    DPHLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    self.index = indexPath;
    return cell;
}

#pragma mark---------data
- (void)setObject:(DPHLObject *)object{
    _object = object;
    
    [self.iconImage setImageWithURL:[NSURL URLWithString:object.iconName] placeholderImage:dp_AccountImage(@"UAIconDefalt.png")];
    self.titleLabel.text = _object.title;
    self.timeLabel.text = object.subTitle;
    if (object.value.length>60) {
        if (object.isHiddle==NO) {
            self.contentLabel.numberOfLines = 0;
            NSString *contentStr = [NSString stringWithFormat:@"%@  全文ʌ",object.value];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
            [attributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dp_flatBlueColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(contentStr.length-3, 3)];
            self.contentLabel.attributedText = attributeStr;
        }else{
            self.contentLabel.numberOfLines = 3;
            NSString *contentStr = [NSString stringWithFormat:@"%@...  全文v",[object.value substringToIndex:60]];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
            [attributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dp_flatBlueColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(contentStr.length-3, 3)];
            self.contentLabel.attributedText = attributeStr;
        }
       
    }else{
        self.contentLabel.text = _object.value;
    }
    
    self.likeBtn.selected = object.isSelect;
    self.likeLabel.text = object.subValue;
}
- (void)contentTapped:(UITapGestureRecognizer *)gesture{
    CGPoint touchPoint = [gesture locationInView:self.contentView];
    if (CGRectContainsPoint(self.contentLabel.frame, touchPoint)) {
        if (self.contentTappedBlock) {
            self.contentTappedBlock(self.object);
        }
    }
    
    if (touchPoint.x>self.likeBtn.frame.origin.x) {
        if (self.likeBtnTappedBlock) {
            self.likeBtnTappedBlock(self.object);
        }
    }
    
    if (self.cellTappedBlock) {
        self.cellTappedBlock();
    }
}
@end
