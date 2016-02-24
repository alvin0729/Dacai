//
//  DPPrepogativeCell.m
//  Jackpot
//
//  Created by mu on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPPrepogativeCell.h"
@interface DPPrepogativeCell()
/**
 *  vertical
 */
@property (nonatomic, strong) UIView *verticalLine;
/**
 *  progressLine
 */
@property (nonatomic, strong) UIView *progressLine;
/**
 *  icon
 */
@property (nonatomic, strong) UIButton *iconBtn;
/**
 *  prepogativeLab
 */
@property (nonatomic, strong) UILabel *prepogativeLab;
@end

@implementation DPPrepogativeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor dp_flatBackgroundColor];
        
        self.verticalLine = [[UIView alloc]init];
        self.verticalLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.verticalLine];
        
        self.progressLine = [[UIView alloc]init];
        self.progressLine.backgroundColor = [UIColor dp_flatRedColor];
        [self.verticalLine addSubview:self.progressLine];
        
        self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.iconBtn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.iconBtn];
        
        self.prepogativeLab = [[UILabel alloc]init];
        self.prepogativeLab.textColor = [UIColor lightGrayColor];
        self.prepogativeLab.textAlignment = NSTextAlignmentRight;
        self.prepogativeLab.font = [UIFont systemFontOfSize:12];
        self.prepogativeLab.text = @"hahah";
        self.prepogativeLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.prepogativeLab];
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context,UIColorFromRGB(0xd3ceca).CGColor);
    CGFloat lengths[] = {1,1};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 0, 30);
    CGContextAddLineToPoint(context, kScreenWidth,30);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}

#pragma mark---------data
- (void)setObject:(DPPrepogativeObject *)object{
    _object = object;
    self.prepogativeLab.text = _object.levelStr;
    for (NSInteger  i = 0; i<_object.prepogativeArray.count; i++) {
        UIImageView *prepogativeImage = [[UIImageView alloc]init];
        prepogativeImage.image = dp_GropSystemResizeImage(_object.prepogativeimageArray[i]);
        prepogativeImage.tag = 100+i;
        [self.contentView addSubview:prepogativeImage];
        [prepogativeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(60+60*(i/2));
            make.left.mas_equalTo(30+80*(i%2+1));
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];

        
        UILabel *prepogativeTitle = [[UILabel alloc]init];
        prepogativeTitle.textAlignment = NSTextAlignmentCenter;
        prepogativeTitle.font = [UIFont systemFontOfSize:12];
        prepogativeTitle.tag = 200+i;
        prepogativeTitle.text = _object.prepogativeArray[i];
        if (_object.myLevel == DPPrepogativeFutureLevel) {
            prepogativeTitle.textColor = [UIColor lightGrayColor];
        }else{
            prepogativeTitle.textColor = [UIColor blackColor];
        }
        [self.contentView addSubview:prepogativeTitle];
        [prepogativeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(prepogativeImage.mas_bottom).offset(12);
            make.centerX.mas_equalTo(prepogativeImage.mas_centerX);
            make.height.mas_equalTo(14);
        }];
    }
}


@end










