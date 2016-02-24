//
//  DPLiveOddsPositionSubCell.m
//  Jackpot
//
//  Created by wufan on 15/9/12.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPLiveOddsPositionSubCell.h"


@implementation DPLiveOddsPositionSubCell

-(instancetype)initWithWidArray:(NSArray*)widArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] ;
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor] ;
        self.backgroundColor = [UIColor clearColor] ;
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        self.itemView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO bottomLayer:NO withHigh:height  withWidth:kScreenWidth-10];
        self.itemView.numberOfLabLines = 2 ;
        self.itemView.titleFont = [UIFont dp_systemFontOfSize:11] ;
        self.itemView.textColors = UIColorFromRGB(0x535353) ;
        [self.itemView createHeaderWithWidthArray:widArray whithHigh:height withSeg:NO] ;

 
        [self.contentView addSubview:self.itemView];
        
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
        }] ;
        
        
        UIImageView* imgView = [[UIImageView alloc]init];
        imgView.image = dp_ResultImage(@"arrow_right.png") ;
        [self.itemView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@5);
            make.height.equalTo(@12);
            
            make.centerY.equalTo(self.itemView);
            make.right.equalTo(self.itemView.mas_right).offset(-2);
        }] ;
        
        _noDataImgLabel  = [[UIImageView alloc]init];
        _noDataImgLabel.contentMode = UIViewContentModeCenter ;
        _noDataImgLabel.layer.borderWidth = 0.5 ;
        _noDataImgLabel.layer.borderColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1].CGColor ;
        _noDataImgLabel.hidden = YES ;
         _noDataImgLabel.image = dp_SportLiveImage(@"foot_down.png") ;
         _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        [self.contentView addSubview:_noDataImgLabel];
        [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(-0.5, 5, 0, 5)) ;
        }] ;

         
        
    }
    
    return self ;
}

@end


