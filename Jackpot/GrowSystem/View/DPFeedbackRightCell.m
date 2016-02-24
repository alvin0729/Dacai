//
//  DPFeedbackRightCell.m
//  Jackpot
//
//  Created by mu on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPFeedbackRightCell.h"
@interface DPFeedbackRightCell()
/**
 *  contentBtn
 */
@property (nonatomic, strong)UIButton *contentBtn;
/**
 *  icon
 */
@property (nonatomic, strong)UIImageView *iconImage;
/**
 *  date
 */
@property (nonatomic, strong)UILabel *dateLab;
/**
 *  time
 */
@property (nonatomic, strong)UILabel *timeLab;
/**
 *
 */
@property (nonatomic, strong)MASConstraint *contentBtnSizeCons;
@end

@implementation DPFeedbackRightCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor dp_flatBackgroundColor];
        self.userInteractionEnabled = NO;
        
        self.contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.contentBtn.titleLabel.numberOfLines = 0;
        self.contentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.contentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        self.contentBtn.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.contentBtn];
        
        self.iconImage = [[UIImageView alloc]initWithImage:dp_FeedbackResizeImage(@"timeIcon.png")];
        self.iconImage.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.iconImage];
        
        self.dateLab = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x898e91) font:[UIFont systemFontOfSize:8]];
        [self.contentView addSubview:self.dateLab];
        
        self.timeLab = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x898e91) font:[UIFont systemFontOfSize:8]];
        [self.contentView addSubview:self.timeLab];
        
        [self.contentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            self.contentBtnSizeCons = make.size.mas_equalTo(CGSizeZero);
        }];
        
        [self.dateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentBtn.mas_centerY).offset(-2);
            make.right.equalTo(self.contentBtn.mas_left).offset(-12);
            make.height.mas_equalTo(8);
        }];
        
        [self.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateLab.mas_bottom).offset(4);
            make.right.equalTo(self.dateLab.mas_right);
            make.left.equalTo(self.dateLab.mas_left);
            make.height.mas_equalTo(8);
        }];
        
        [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLab.mas_centerY);
            make.right.equalTo(self.dateLab.mas_left);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPFeedbackRightCell";
    DPFeedbackRightCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPUAObject *)object{
    [super setObject:object];
    CGSize contentSize = [NSString dpsizeWithSting:object.value andFont:[UIFont systemFontOfSize:14] andMaxWidth:kScreenWidth*0.5];
    self.contentBtnSizeCons.mas_equalTo(CGSizeMake(contentSize.width+30, contentSize.height+20));
    
    self.dateLab.text = object.date;
    self.timeLab.text = object.time;
    UIImage *image = [dp_FeedbackResizeImage(@"yourMessage.png") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 50, 50) resizingMode:UIImageResizingModeStretch];
    [self.contentBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.contentBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.contentBtn setTitle:object.value forState:UIControlStateNormal];
}
@end
