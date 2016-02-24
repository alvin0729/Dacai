//
//  DPJcLqBuyCelll.m
//  DacaiProject
//
//  Created by sxf on 14-8-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJcLqBuyCelll.h"
#import "DPBetToggleControl.h"


@interface DPJcLqBuyCelll () {
@private
    UIView *_infoView;
    UIView *_titleView;
    UIView *_optionView;
    
    UILabel *_competitionLabel;
    UILabel *_orderNameLabel;
    UILabel *_matchDateLabel;
    UIImageView *_analysisView;
    UILabel *_homeNameLabel;
    UILabel *_awayNameLabel;
    UILabel *_homeRankLabel;
    UILabel *_awayRankLabel;
    UILabel *_middleLabel;
    
    UIButton *_moreButton;
    UILabel *_rangfenLabel;
    UILabel *_dxfLabel;
    
    UILabel* _rfTitleLabel ;
    UILabel* _dxfTitleLabel ;
    UIImageView *_htSpfDGView;
    UIImageView *_htRqDGView;
    UIImageView *_otherDGView;
    
    UILabel *_rfNoDataLabel ;//让分
    UILabel *_dxfNoDataLabel ;//比分

}

@property (nonatomic, strong, readonly) UIView *infoView;//左边视图
@property (nonatomic, strong, readonly) UIView *titleView;//对阵视图
@property (nonatomic, strong, readonly) UIView *optionView;//赔率视图


- (void)infoBuildLayout;
- (void)titleBuildLayoutWithOffset:(CGFloat)off;
- (void)optionBuildLayout;

@end
@implementation DPJcLqBuyCelll
@dynamic infoView;
@dynamic titleView;
@dynamic optionView;
@dynamic competitionLabel;
@dynamic orderNameLabel;
@dynamic matchDateLabel;
@dynamic homeNameLabel;
@dynamic awayNameLabel;
@dynamic homeRankLabel;
@dynamic awayRankLabel;
@dynamic middleLabel;

@dynamic moreButton;
@dynamic rangfenLabel;
@dynamic dxfLabel;
@dynamic dxfTitleLabel ;
@dynamic rfTitleLabel ;
@dynamic rfNoDataLabel ;
@dynamic dxfNoDataLabel ;

- (void)buildLayout {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = self.contentView;
    UIView *line = [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.88 alpha:1]];
    
    [contentView addSubview:self.infoView];
    [contentView addSubview:self.titleView];
    [contentView addSubview:self.optionView];
    [contentView addSubview:line];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@(self.frame.size.width*0.2));
    }];
    if(self.gameType!=GameTypeLcHt){
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView.mas_right);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView).offset(13);
            make.height.equalTo(@15);
        }];
    }else{
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView.mas_right);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
            make.height.equalTo(@23);
        }];
    }

    [self.optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView.mas_right);
        make.right.equalTo(contentView);
        make.top.equalTo(self.titleView.mas_bottom).offset(1);
        make.bottom.equalTo(contentView).offset(-3);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self infoBuildLayout];
    
    CGFloat off= -5 ;
    switch (self.gameType) {
        case GameTypeLcHt:
            [self optionBuildLayout];
            off = -17.5 ;
            break;
        case GameTypeLcSf:
            [self optionSfBuildLayout];
            break;
        case GameTypeLcRfsf:
            [self optionRfsfBuildLayout];
            break;
        case GameTypeLcDxf:
            [self optionDxfBuildLayout];
            break;
        case GameTypeLcSfc:
            [self optionSfcBuildLayout];
            break;
        default:
            break;
    }
    
    [self titleBuildLayoutWithOffset:off];

    [self.infoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onMatchInfo)]];
}
/**
 *  左侧视图
 */
- (void)infoBuildLayout {
    UIView *contentView = self.infoView;
    [contentView addSubview:self.competitionLabel];
    [contentView addSubview:self.orderNameLabel];
    [contentView addSubview:self.matchDateLabel];
      [contentView addSubview:self.analysisView];
    [self.orderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(contentView.mas_centerY).offset(-2);
        make.centerY.equalTo(contentView) ;
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    [self.competitionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.orderNameLabel.mas_top).offset(-3);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    if (self.gameType!=GameTypeLcHt) {
        [self.matchDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderNameLabel.mas_bottom);
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
        }];
        [self.analysisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.top.equalTo(self.matchDateLabel.mas_bottom).offset(4);
        }];

    }else{
    
        [self.matchDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNameLabel.mas_bottom).offset(3);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
        [self.analysisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.top.equalTo(self.matchDateLabel.mas_bottom).offset(5);
        }];
    }
   
   
}

/**
 *  顶部视图
 */
- (void)titleBuildLayoutWithOffset:(CGFloat)off {
    UIView *contentView = self.titleView;
    
    [contentView addSubview:self.middleLabel];
    [contentView addSubview:self.homeNameLabel];
    [contentView addSubview:self.awayNameLabel];
    [contentView addSubview:self.homeRankLabel];
    [contentView addSubview:self.awayRankLabel];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView).offset(off);
        make.bottom.equalTo(contentView);
    }];
    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.middleLabel.mas_left).offset(-15);
        make.bottom.equalTo(contentView);
    }];
    [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleLabel.mas_right).offset(15);
        make.bottom.equalTo(contentView);
    }];
    [self.homeRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.homeNameLabel.mas_right);
        make.bottom.equalTo(contentView);
    }];
    [self.awayRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.awayNameLabel.mas_left);
        make.bottom.equalTo(contentView);
    }];
    
    if (self.gameType!=GameTypeLcHt) {
        [contentView addSubview:self.otherDGView];
        [self.otherDGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@18.5);
            make.height.equalTo(@18.5);
            make.left.equalTo(self.infoView.mas_right).offset(-3);
            make.centerY.equalTo(self.homeNameLabel);
            
        }];
        self.otherDGView.hidden=YES;
    }
}
/**
 *  投注视图
 */
- (void)optionBuildLayout {
    UIView *contentView = self.optionView;
//    _rfTitleLabel=[self creatTitleLabel];
//    _rfTitleLabel.text=@"让\n分";
//    _dxfTitleLabel=[self creatTitleLabel];
//    _dxfTitleLabel.text=@"大\n小\n分";
    [contentView addSubview:self.moreButton];
    [contentView addSubview:self.rfTitleLabel];
    [contentView addSubview:self.dxfTitleLabel];
   
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@37);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(3);
        make.bottom.equalTo(contentView).offset(-3);
    }];
    [self.rfTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.width.equalTo(@12);
        make.top.equalTo(self.moreButton);
        make.bottom.equalTo(self.moreButton.mas_centerY).offset(-1);
    }];
    [self.dxfTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.width.equalTo(@12);
        make.top.equalTo(self.moreButton.mas_centerY).offset(0.5);
        make.bottom.equalTo(self.moreButton);
    }];
    
    // 辅助view
    UIView *assistedView1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *assistedView2 = [UIView dp_viewWithColor:[UIColor clearColor]];
    
    [contentView addSubview:assistedView1];
    [contentView addSubview:assistedView2];
    [assistedView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rfTitleLabel.mas_right).offset(3);
        make.right.equalTo(self.moreButton.mas_left).offset(-3);
        make.top.equalTo(self.moreButton);
        make.bottom.equalTo(self.moreButton.mas_centerY).offset(-1);
    }];
    [assistedView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(assistedView1);
        make.right.equalTo(assistedView1);
        make.top.equalTo(self.moreButton.mas_centerY).offset(0.5);
        make.bottom.equalTo(self.moreButton);
        
    }];
    
    // 布局选项
    NSArray *title132 = [NSArray arrayWithObjects:@"主负", @"主胜", nil];
    NSArray *option132 = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControlForBasket]];
    [option132 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:obj];
        [obj setShowBorderWhenSelected:YES];
        [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    for (int i = 0; i < option132.count; i++) {
        DPBetToggleControl *obj = option132[i];
        obj.titleFont = [UIFont dp_systemFontOfSize:14] ;
        obj.oddsFont = [UIFont dp_systemFontOfSize:11] ;
        obj.tag = (GameTypeLcRfsf << 16) | i;
        obj.titleText = [title132 objectAtIndex:i];
        [obj addTarget:self action:@selector(pvt_singleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@((self.frame.size.width*0.8-47-13)/2));
            make.width.equalTo(assistedView1).valueOffset(@-0.25).dividedBy(2);

            make.top.equalTo(assistedView1);
            make.bottom.equalTo(assistedView1);
        }];
        
        if (i >= option132.count - 1) {
            continue;
        }
        
        DPBetToggleControl *obj1 = option132[i];
        DPBetToggleControl *obj2 = option132[i + 1];
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(assistedView1);
        }];
         [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(obj2.mas_left).offset(0.5);
        }];
        

    }
    
    NSArray *title134 = [NSArray arrayWithObjects:@"大分", @"小分", nil];
    NSArray *option134 = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControlForBasket]];
    [option134 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:obj];
        [obj setShowBorderWhenSelected:YES];
         [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    for (int i = 0; i < option134.count; i++) {
        DPBetToggleControl *obj = option134[i];
        obj.titleFont = [UIFont dp_systemFontOfSize:14] ;
        obj.oddsFont = [UIFont dp_systemFontOfSize:11] ;
        obj.tag = (GameTypeLcDxf << 16) | i;
        obj.titleText = [title134 objectAtIndex:i];
        [obj addTarget:self action:@selector(pvt_singleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(assistedView1).valueOffset(@-0.25).dividedBy(2);
            make.top.equalTo(assistedView2);
            make.bottom.equalTo(assistedView2);
            }];
        
        if (i >= option134.count - 1) {
            continue;
        }
        
        DPBetToggleControl *obj1 = option134[i];
        DPBetToggleControl *obj2 = option134[i + 1];
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(assistedView1);
        }];
        [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(obj2.mas_left).offset(0.5);
        }];
    }
    
    _options132 = option132;
    _options134 = option134;
    
    [contentView addSubview:self.rangfenLabel];
    self.rangfenLabel.text=@"-1.45";
    [contentView addSubview:self.dxfLabel];
    self.dxfLabel.text=@"140.5";
    [self.rangfenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(assistedView1.mas_centerX);
        make.width.equalTo(@35);
        make.centerY.equalTo(assistedView1.mas_centerY);
        make.height.equalTo(@15);
    }];
    [self.dxfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(assistedView2.mas_centerX);
        make.width.equalTo(@35);
        make.centerY.equalTo(assistedView2.mas_centerY);
        make.height.equalTo(@15);
    }];
    
    //未开售
    [contentView addSubview:self.rfNoDataLabel];
    [contentView addSubview:self.dxfNoDataLabel];
    [self.rfNoDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.and.top.equalTo(assistedView1) ;
    }];
    
    [self.dxfNoDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.and.top.equalTo(assistedView2) ;

    }];

    
    // 单关标志
    [contentView addSubview:self.htSpfDGView];
    [contentView addSubview:self.htRqDGView];
    self.htRqDGView.hidden=YES;
    self.htSpfDGView.hidden=YES;
    
    [self.htSpfDGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30.5);
        make.height.equalTo(@14);
        make.left.equalTo(self.rfTitleLabel).offset(7);
        make.top.equalTo(self.rfTitleLabel);
    }];
    [self.htRqDGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30.5);
        make.height.equalTo(@14);
        make.left.equalTo(self.dxfTitleLabel).offset(7);
        make.top.equalTo(self.dxfTitleLabel);
        
    }];
    
    
    
}
- (void)optionSfBuildLayout {
    UIView *contentView = self.optionView;
    // 辅助view
    UIView *assistedView1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:assistedView1];
    
    [assistedView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(9.5);
        make.height.equalTo(@32);
    }];
    
    NSArray *title131 = [NSArray arrayWithObjects:@"主负", @"主胜", nil];
    NSArray *option131 = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
    [option131 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:obj];
        [obj setShowBorderWhenSelected:YES];
         [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    for (int i = 0; i < option131.count; i++) {
        DPBetToggleControl *obj = option131[i];
        obj.tag = (GameTypeLcSf << 16) | i;
        obj.titleFont = [UIFont dp_systemFontOfSize:14] ;
        obj.oddsFont = [UIFont dp_systemFontOfSize:11] ;
        obj.titleText = [title131 objectAtIndex:i];
        [obj addTarget:self action:@selector(pvt_singleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(assistedView1).multipliedBy(0.5);
            make.top.equalTo(assistedView1);
            make.bottom.equalTo(assistedView1);
        }];
        
        if (i >= option131.count - 1) {
            continue;
        }
        
        DPBetToggleControl *obj1 = option131[i];
        DPBetToggleControl *obj2 = option131[i + 1];
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(assistedView1).offset(-1);
        }];
        [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(obj2.mas_left).offset(1);
        }];
        
        
    }
     _options131 = option131;

}
- (void)optionRfsfBuildLayout {
    UIView *contentView = self.optionView;
    // 辅助view
    UIView *assistedView1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:assistedView1];
    
    [assistedView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(9.5);
        make.height.equalTo(@32);
    }];
    
    NSArray *title132 = [NSArray arrayWithObjects:@"主负", @"主胜", nil];
    NSArray *option132 = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
    [option132 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:obj];
        [obj setShowBorderWhenSelected:YES];
         [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    for (int i = 0; i < option132.count; i++) {
        DPBetToggleControl *obj = option132[i];
        obj.tag = (GameTypeLcRfsf << 16) | i;
        obj.titleFont = [UIFont dp_systemFontOfSize:14] ;
        obj.oddsFont = [UIFont dp_systemFontOfSize:11] ;
        obj.titleText = [title132 objectAtIndex:i];
        [obj addTarget:self action:@selector(pvt_singleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(assistedView1).multipliedBy(0.5);
            make.top.equalTo(assistedView1);
            make.bottom.equalTo(assistedView1);
        }];
        
        if (i >= option132.count - 1) {
            continue;
        }
        
        DPBetToggleControl *obj1 = option132[i];
        DPBetToggleControl *obj2 = option132[i + 1];
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(assistedView1).offset(-1);
        }];
        [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(obj2.mas_left).offset(1);
        }];
        
        
    }
     _options132 = option132;

}
- (void)optionDxfBuildLayout {
    UIView *contentView = self.optionView;
    // 辅助view
    UIView *assistedView1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:assistedView1];
    
    [assistedView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(9.5);
        make.height.equalTo(@32);
    }];
    
    NSArray *title134 = [NSArray arrayWithObjects:@"大分", @"小分", nil];
    NSArray *option134 = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
    [option134 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:obj];
        [obj setShowBorderWhenSelected:YES];
         [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    for (int i = 0; i < option134.count; i++) {
        DPBetToggleControl *obj = option134[i];
        obj.tag = (GameTypeLcDxf << 16) | i;
        obj.titleFont = [UIFont dp_systemFontOfSize:14] ;
        obj.oddsFont = [UIFont dp_systemFontOfSize:11] ;
        obj.titleText = [title134 objectAtIndex:i];
        [obj addTarget:self action:@selector(pvt_singleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(assistedView1).multipliedBy(0.5);
            make.top.equalTo(assistedView1);
            make.bottom.equalTo(assistedView1);
        }];
        
        if (i >= option134.count - 1) {
            continue;
        }
        
        DPBetToggleControl *obj1 = option134[i];
        DPBetToggleControl *obj2 = option134[i + 1];
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(assistedView1).offset(-1);
        }];
        [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(obj2.mas_left).offset(1);
        }];
        
        
    }
     _options134 = option134;

}
- (void)optionSfcBuildLayout {
    UIView *contentView = self.optionView;
    // 辅助view
    UIView *assistedView1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:assistedView1];
    assistedView1.backgroundColor=[UIColor clearColor];
    [assistedView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(9.5);
        make.height.equalTo(@32);
    }];
    
    NSArray *option133 = @[[self createButton]];
    [option133 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [assistedView1 addSubview:obj];
    }];
    for (int i=0; i<option133.count; i++) {
        UIButton *obj=option133[i];
        obj.tag = (GameTypeLcSfc << 16) | i;
        [obj setTitle:@"胜分差投注" forState:UIControlStateNormal];
        [obj addTarget:self action:@selector(pvt_onMore) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(assistedView1);
            make.right.equalTo(assistedView1);
            make.top.equalTo(assistedView1);
            make.height.equalTo(@32);
        }];
    }
    _options133 = option133;
}
-(void)pvt_onSelected:(DPBetToggleControl *)betToggle{
    betToggle.selected=!betToggle.selected;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - getter

- (void)pvt_onMore{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jcLqBuyCell:event:info:)]) {
        [self.delegate jcLqBuyCell:self event:DPJcLqBuyCellEventMore info:nil];
    }
}
-(void)pvt_singleButtonClick:(DPBetToggleControl *)betButton{
    NSDictionary *dic=[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:betButton.tag] forKey:@"tag"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(jcLqBuyCell:event:info:)]) {
        [self.delegate jcLqBuyCell:self event:DPJCLqBuyCellEventOption info:dic];
    }
}
- (void)pvt_onMatchInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jcLqBuyCellInfo:)]) {
        [self.delegate jcLqBuyCellInfo:self];
    }
}
-(void)analysisViewIsExpand:(BOOL)isExpand{
    if (isExpand) {
        self.analysisView.highlighted = NO ;;
    }else{
        self.analysisView.highlighted = YES ;
        
    }
}

#pragma mark - getter

- (UIButton *)moreButton {
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setTitle:@"更多\n玩法" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatWhiteColor]] forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
        [_moreButton setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatRedColor]] forState:UIControlStateSelected];
        [_moreButton.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [_moreButton.titleLabel setNumberOfLines:0];
        [_moreButton.layer setBorderColor:[UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor];
        [_moreButton.layer setBorderWidth:0.5];
        [_moreButton addTarget:self action:@selector(pvt_onMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

-(UILabel*)dxfTitleLabel
{

    if (_dxfTitleLabel == nil) {
        _dxfTitleLabel = [self creatTitleLabel] ;
        _dxfTitleLabel.text=@"大\n小\n分";

    }
    
    return _dxfTitleLabel ;
}

-(UILabel*)rfTitleLabel
{
    if (_rfTitleLabel == nil) {
        _rfTitleLabel = [self creatTitleLabel] ;
        _rfTitleLabel.text=@"让\n分";

    }
    
    return _rfTitleLabel ;
    
}
-(UILabel*)rfNoDataLabel{

    if (_rfNoDataLabel == nil) {
        _rfNoDataLabel = [[UILabel alloc]init] ;
        _rfNoDataLabel.text=@"未开售";
        _rfNoDataLabel.textColor = UIColorFromRGB(0xc3b9a5) ;
        _rfNoDataLabel.textAlignment = NSTextAlignmentCenter ;
        _rfNoDataLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
        _rfNoDataLabel.font = [UIFont dp_systemFontOfSize:14] ;
        _rfNoDataLabel.hidden = YES ;
        _rfNoDataLabel.layer.borderWidth = 0.5 ;
        _rfNoDataLabel.layer.borderColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor;
        
    }
    
    return _rfNoDataLabel ;

}

-(UILabel*)dxfNoDataLabel{
    
    if (_dxfNoDataLabel == nil) {
        _dxfNoDataLabel = [[UILabel alloc]init] ;
        _dxfNoDataLabel.text=@"未开售";
        _dxfNoDataLabel.textColor = UIColorFromRGB(0xc3b9a5) ;
        _dxfNoDataLabel.textAlignment = NSTextAlignmentCenter ;
        _dxfNoDataLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
        _dxfNoDataLabel.font = [UIFont dp_systemFontOfSize:14] ;
        _dxfNoDataLabel.hidden = YES ;
        _dxfNoDataLabel.layer.borderWidth = 0.5 ;
        _dxfNoDataLabel.layer.borderColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor;
        
    }
    
    return _dxfNoDataLabel ;
    
}


- (UILabel *)rangfenLabel {
    if (_rangfenLabel == nil) {
        _rangfenLabel = [[UILabel alloc] init];
        _rangfenLabel.backgroundColor =[UIColor dp_flatWhiteColor];
        _rangfenLabel.textColor = [UIColor dp_flatBlueColor];
        _rangfenLabel.layer.borderColor=[UIColor colorWithRed:0.86 green:0.85 blue:0.78 alpha:1.0].CGColor;
        _rangfenLabel.layer.borderWidth=0.5;
         _rangfenLabel.textAlignment = NSTextAlignmentCenter;
        _rangfenLabel.font = [UIFont dp_systemFontOfSize:10];
    }
    return _rangfenLabel;
}


- (UILabel *)dxfLabel {
    if (_dxfLabel == nil) {
        _dxfLabel = [[UILabel alloc] init];
        _dxfLabel.backgroundColor =[UIColor dp_flatWhiteColor];
        _dxfLabel.textColor = [UIColor dp_flatRedColor];
        _dxfLabel.layer.borderColor=[UIColor colorWithRed:0.86 green:0.85 blue:0.78 alpha:1.0].CGColor;
        _dxfLabel.layer.borderWidth=0.5;
        _dxfLabel.textAlignment = NSTextAlignmentCenter;
        _dxfLabel.font = [UIFont dp_systemFontOfSize:10];;
    }
    return _dxfLabel;
}


#pragma mark - getter
-(UIImageView *)htSpfDGView{
    if (_htSpfDGView==nil) {
        _htSpfDGView=[[UIImageView alloc] init];
        _htSpfDGView.backgroundColor=[UIColor clearColor];
        [_htSpfDGView setImage:dp_SportLotteryImage(@"htdanguan.png")];
    }
    return _htSpfDGView;
    
}
-(UIImageView *)htRqDGView{
    if (_htRqDGView==nil) {
        _htRqDGView=[[UIImageView alloc] init];
        _htRqDGView.backgroundColor=[UIColor clearColor];
        [_htRqDGView setImage:dp_SportLotteryImage(@"htdanguan.png")];
    }
    return _htRqDGView;
    
}
-(UIImageView *)otherDGView{
    if (_otherDGView==nil) {
        _otherDGView=[[UIImageView alloc] init];
        _otherDGView.backgroundColor=[UIColor clearColor];
        [_otherDGView setImage:dp_SportLotteryImage(@"dan.png")];
    }
    return _otherDGView;
    
}
- (UIView *)infoView {
    if (_infoView == nil) {
        _infoView = [[UIView alloc] init];
        _infoView.backgroundColor = [UIColor clearColor];
    }
    return _infoView;
}

- (UIView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    return _titleView;
}

- (UIView *)optionView {
    if (_optionView == nil) {
        _optionView = [[UIView alloc] init];
        _optionView.backgroundColor = [UIColor clearColor];
    }
    return _optionView;
}

- (UILabel *)competitionLabel {
    if (_competitionLabel == nil) {
        _competitionLabel = [[UILabel alloc] init];
        _competitionLabel.backgroundColor = [UIColor clearColor];
        _competitionLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _competitionLabel.textAlignment = NSTextAlignmentCenter;
        _competitionLabel.font = [UIFont dp_systemFontOfSize:11];
    }
    return _competitionLabel;
}

- (UILabel *)orderNameLabel {
    if (_orderNameLabel == nil) {
        _orderNameLabel = [[UILabel alloc] init];
        _orderNameLabel.backgroundColor = [UIColor clearColor];
        _orderNameLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _orderNameLabel.textAlignment = NSTextAlignmentCenter;
        _orderNameLabel.font = [UIFont dp_systemFontOfSize:11];
    }
    return _orderNameLabel;
}

- (UILabel *)matchDateLabel {
    if (_matchDateLabel == nil) {
        _matchDateLabel = [[UILabel alloc] init];
        _matchDateLabel.backgroundColor = [UIColor clearColor];
        _matchDateLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _matchDateLabel.textAlignment = NSTextAlignmentCenter;
        _matchDateLabel.font = [UIFont dp_systemFontOfSize:10];
    }
    return _matchDateLabel;
}

- (UIImageView *)analysisView {
    if (_analysisView == nil) {
        _analysisView = [[UIImageView alloc] init];
        _analysisView.image = dp_CommonImage(@"brown_smallarrow_down.png");
        _analysisView.highlightedImage = dp_CommonImage(@"brown_smallarrow_up.png");
    }
    return _analysisView;
}
- (UILabel *)homeNameLabel {
    if (_homeNameLabel == nil) {
        _homeNameLabel = [[UILabel alloc] init];
        _homeNameLabel.backgroundColor = [UIColor clearColor];
        _homeNameLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        _homeNameLabel.textAlignment = NSTextAlignmentCenter;
        _homeNameLabel.font = [UIFont dp_systemFontOfSize:13];
    }
    return _homeNameLabel;
}

- (UILabel *)awayNameLabel {
    if (_awayNameLabel == nil) {
        _awayNameLabel = [[UILabel alloc] init];
        _awayNameLabel.backgroundColor = [UIColor clearColor];
        _awayNameLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        _awayNameLabel.textAlignment = NSTextAlignmentCenter;
        _awayNameLabel.font = [UIFont dp_systemFontOfSize:13];
    }
    return _awayNameLabel;
}

- (UILabel *)homeRankLabel {
    if (_homeRankLabel == nil) {
        _homeRankLabel = [[UILabel alloc] init];
        _homeRankLabel.backgroundColor = [UIColor clearColor];
        _homeRankLabel.textColor = [UIColor colorWithRed:0.58 green:0.55 blue:0.48 alpha:1];
        _homeRankLabel.textAlignment = NSTextAlignmentCenter;
        _homeRankLabel.font = [UIFont dp_systemFontOfSize:9];
    }
    return _homeRankLabel;
}

- (UILabel *)awayRankLabel {
    if (_awayRankLabel == nil) {
        _awayRankLabel = [[UILabel alloc] init];
        _awayRankLabel.backgroundColor = [UIColor clearColor];
        _awayRankLabel.textColor = [UIColor colorWithRed:0.58 green:0.55 blue:0.48 alpha:1];
        _awayRankLabel.textAlignment = NSTextAlignmentCenter;
        _awayRankLabel.font = [UIFont dp_systemFontOfSize:9];
    }
    return _awayRankLabel;
}

- (UILabel *)middleLabel {
    if (_middleLabel == nil) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.backgroundColor = [UIColor clearColor];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.font = [UIFont dp_systemFontOfSize:13];
    }
    return _middleLabel;
}
-(UILabel *)creatTitleLabel{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines=0;
    label.backgroundColor=[UIColor colorWithRed:0.18 green:0.53 blue:0.53 alpha:1.0];
    label.textColor=[UIColor dp_flatWhiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont dp_systemFontOfSize:10.0];
    return label;
}
-(UIButton *)createButton{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatWhiteColor]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatRedColor]] forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont dp_systemFontOfSize:13]];
    [button.layer setBorderColor:[UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor];
    [button.layer setBorderWidth:0.5];
    return button;
}
@end
