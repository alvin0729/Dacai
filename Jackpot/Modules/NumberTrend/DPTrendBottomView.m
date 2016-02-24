//
//  DPTrendBottomView.m
//  DacaiProject
//
//  Created by sxf on 15/2/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPTrendBottomView.h"
#define bottomviewlabelTag  2000
@interface DPTrendBottomView ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UILabel *_infoLabel;
    UIFont *_titleFont;

}
@property(nonatomic,strong,readonly)UILabel *infoLabel;
@property (nonatomic, strong, readonly) UIFont *titleFont;
@end
@implementation DPTrendBottomView


- (instancetype)init{
    if (self = [super init]) {
        self.ballsHeight=-1;
        [self bulidLayOut];
    }
    return self;
}
-(void)bulidLayOut{
    UIView *bottomView=[UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *sureView=[UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *ballView=[UIView dp_viewWithColor:[UIColor clearColor]];
//    UIView *topLine=[UIView dp_viewWithColor:UIColorFromRGB(0xcac1ba)];
//    UIView *midLine=[UIView dp_viewWithColor:UIColorFromRGB(0xcac1ba)];
    [self addSubview:bottomView];
    [bottomView addSubview:sureView];
    [bottomView addSubview:ballView];
    [bottomView addSubview:self.upHline];
    [bottomView addSubview:self.downHLine];
    [bottomView addSubview:self.leftSLine];
    [bottomView addSubview:self.rightSLine];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [sureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.equalTo(bottomView);
        make.width.equalTo(bottomView);
        make.bottom.equalTo(bottomView);
    }];
    [ballView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(1);
        make.left.equalTo(bottomView);
        make.width.equalTo(bottomView);
        make.bottom.equalTo(sureView.mas_top);
    }];
    
    [ballView addSubview: self.scrollView];
    
    UILabel *titleLabel=[[UILabel alloc] init];
    titleLabel.text=@"选号: ";
    titleLabel.tag=bottomviewlabelTag;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont dp_regularArialOfSize:12.0];
    [titleLabel setTextColor:UIColorFromRGB(0x5e5041)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [ballView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ballView);
        make.width.equalTo(@50);
        make.bottom.equalTo(ballView);
        make.left.equalTo(ballView);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right);
        make.right.equalTo(ballView);
        make.top.equalTo(ballView);
        make.bottom.equalTo(ballView);
    }];
    UILabel *bottomLabel=[[UILabel alloc] init];
    bottomLabel.text=@"已选: ";
    bottomLabel.tag=bottomviewlabelTag+1;
    bottomLabel.backgroundColor=[UIColor clearColor];
    bottomLabel.font=[UIFont dp_regularArialOfSize:12.0];
    [bottomLabel setTextColor:UIColorFromRGB(0x5e5041)];
    bottomLabel.textAlignment=NSTextAlignmentRight;
    [sureView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureView);
        make.bottom.equalTo(sureView);
        make.left.equalTo(sureView).offset(10);
        make.width.equalTo(@30);
    }];
    UIButton *button=[[UIButton alloc] init];
    button.backgroundColor=[UIColor dp_flatRedColor];
    button.layer.cornerRadius=2.0;
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setImage:dp_CommonImage(@"sumit001_24.png") forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(finishedSelectedBallClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font=[UIFont dp_regularArialOfSize:15.0];
    self.finishButton=button;
    [sureView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureView).offset(5);
        make.bottom.equalTo(sureView).offset(-5);
        make.right.equalTo(sureView).offset(-10);
        make.width.equalTo(@75);
    }];
    
    
    [sureView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureView);
        make.bottom.equalTo(sureView);
        make.left.equalTo(bottomLabel.mas_right).offset(2);
        make.right.equalTo(button.mas_left).offset(-5);
    }];
    [self.upHline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);
        make.height.equalTo(@1);
    }];
    [self.downHLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLabel);
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);
        make.height.equalTo(@0.5);
    }];
    [self.leftSLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel).offset(1);
        make.left.equalTo(titleLabel.mas_right).offset(-1);
        make.width.equalTo(@1);
        make.bottom.equalTo(titleLabel);
    }];
    [self.rightSLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(1);
        make.left.equalTo(bottomView).offset(320);
        make.width.equalTo(@1);
        make.bottom.equalTo(bottomView);
    }];
    self.leftSLine.hidden=YES;
    self.rightSLine.hidden=YES;

    
}
-(void)createTrendBottomBallView:(NSArray *)redballArray//前区文字
           blueArray:(NSArray *)blueBallArray//后区文字(如果只有一种情况，则传为空)
            rowWidth:(float)rowWidth//每一列宽度//每一列宽度
 normalBallTextColor:(UIColor *)normalColor//字体颜色
 selectBallTextColor:(UIColor *)selectextColor//选中字体颜色
     normalbackImage:(UIImage *)normalBackImage//单元格背景颜色
  selectRedBackImage:(UIImage *)selectRedBackImage//前区选中单元格背景颜色
 selectBlueBackImage:(UIImage *)selectBlueBackImage//后区选中单元格背景颜色
             redBall:(int *)redBall
            blueBall:(int *)blueBall

{
    
    UIView *tempView=(UIView *)[self viewWithTag:1201];
    if (tempView) {
        [tempView removeFromSuperview];
    }
    NSInteger  ballTotal=redballArray.count+(blueBallArray?blueBallArray.count:0);
    UIView *backView = [UIView dp_viewWithColor:[UIColor clearColor]];
    backView.tag=1201;
    [self.scrollView addSubview:backView];
    float rowTotalWidth=0;
    if (rowWidth<=0) {
        for (int i=0; i<self.rowWidthArray.count; i++) {
            rowTotalWidth=rowTotalWidth+[[self.rowWidthArray objectAtIndex:i] floatValue];
        }
    }else{
        rowTotalWidth=rowWidth*ballTotal;
    }
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
      //        make.edges.insets(UIEdgeInsetsZero);
      make.left.equalTo(self.scrollView);
      make.width.equalTo(@(rowTotalWidth));
      make.top.equalTo(self).offset(1);
      make.bottom.equalTo(self.infoLabel.mas_top);
    }];
    float totalWidth = 0;
    for (int i = 0; i < ballTotal; i++) {
        UIButton *button = [[UIButton alloc] init];
        //        button.backgroundColor=[UIColor clearColor];
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        [button setTitleColor:selectextColor forState:UIControlStateSelected];
        [button setBackgroundImage:normalBackImage forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        //        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(ballBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i < redballArray.count) {
            [button setBackgroundImage:selectRedBackImage forState:UIControlStateSelected];
            [button setTitle:[redballArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[redballArray objectAtIndex:i] forState:UIControlStateSelected];
            if (redBall) {
                button.selected = redBall[i];
            }

        } else {
            [button setBackgroundImage:selectBlueBackImage forState:UIControlStateSelected];
            [button setTitle:[blueBallArray objectAtIndex:i - redballArray.count] forState:UIControlStateNormal];
            [button setTitle:[blueBallArray objectAtIndex:i - redballArray.count] forState:UIControlStateSelected];
            if (blueBall) {
                button.selected = blueBall[i - redballArray.count];
            }
        }
        [backView addSubview:button];
        float width=rowWidth;
        if (rowWidth<=0) {
             width=[[self.rowWidthArray objectAtIndex:i] floatValue];
            totalWidth=totalWidth+(i>0?[[self.rowWidthArray objectAtIndex:i-1] floatValue]:0);
        }else{
            totalWidth=width*i;
        }
        if (self.ballsHeight<0) {
        
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width-3));
                make.centerY.equalTo(backView);
                make.left.equalTo(backView).offset(width *i+1.5);
                make.height.equalTo(@(width-3));
            }];
        }else{ 
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width-3));
                make.centerY.equalTo(backView);
                make.left.equalTo(backView).offset(totalWidth+1.5);
                make.height.equalTo(@(self.ballsHeight));
            }];
        }
        
        [button setTag:UIbuttonTagIndex+i];
        [button setUserInteractionEnabled:YES];
       [button.titleLabel setFont:self.titleFont];
    
    }


}
-(UIScrollView*)scrollView{
    if (_scrollView==nil) {
       _scrollView= [[UIScrollView alloc] init];
        _scrollView.backgroundColor=[UIColor clearColor];
       _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
       _scrollView.delegate=self;
       _scrollView.bounces = NO;
    }
    return _scrollView;
}
-(UILabel *)infoLabel{
    if (_infoLabel==nil) {
        _infoLabel=[[UILabel alloc] init];
        _infoLabel.backgroundColor=[UIColor clearColor];
        _infoLabel.font=[UIFont dp_regularArialOfSize:12.0];
        [_infoLabel setTextColor:UIColorFromRGB(0xe20000)];
        _infoLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _infoLabel;

}
- (UIFont *)titleFont
{
    if (_titleFont == nil) {
        _titleFont = [UIFont dp_systemFontOfSize:12];
    }
    return _titleFont;
}
-(UIView *)upHline{

    if (_upHline==nil) {
        _upHline=[UIView dp_viewWithColor:UIColorFromRGB(0xcac1ba)];
    }
    return _upHline;
}
-(UIView *)downHLine{
    
    if (_downHLine==nil) {
        _downHLine=[UIView dp_viewWithColor:UIColorFromRGB(0xcac1ba)];
    }
    return _downHLine;
}
-(UIView *)leftSLine{
    
    if (_leftSLine==nil) {
        _leftSLine=[UIView dp_viewWithColor:UIColorFromRGB(0x250b05)];
    }
    return _leftSLine;
}
-(UIView *)rightSLine{
    
    if (_rightSLine==nil) {
        _rightSLine=[UIView dp_viewWithColor:UIColorFromRGB(0x250b05)];
    }
    return _rightSLine;
}

-(void)selectedballInfoLabelText:(NSMutableAttributedString *)infoString{
    self.infoLabel.attributedText=infoString;
}
-(void)ballBtnClick:(UIButton *)button{
    button.selected=!button.selected;
    NSInteger index=button.tag-UIbuttonTagIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveSelectedBallForBottomView: isSelected:)]) {
        [self.delegate saveSelectedBallForBottomView:index isSelected:button.selected];
    }

    
}
//获取title的宽度
-(void)gainLayOutWidthForTitlelabel:(float)width{
    UILabel *label=(UILabel *)[self viewWithTag:bottomviewlabelTag];
    [label.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == label && obj.firstAttribute == NSLayoutAttributeWidth) {
            obj.constant = width;
            [self setNeedsUpdateConstraints];
            [self setNeedsLayout];
             [self layoutIfNeeded];
        }
        }];

}
//选号颜色
-(void)optionstitleColor:(UIColor *)color{
    UILabel *label=(UILabel *)[self viewWithTag:bottomviewlabelTag];
    label.textColor=color;
}
//已选颜色
-(void)optionsSelectedTitleColor:(UIColor *)color{
    UILabel *label=(UILabel *)[self viewWithTag:bottomviewlabelTag+1];
    label.textColor=color;
}
-(void)finishedSelectedBallClick{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(finishedSelectedBallForBottomView)]) {
        [self.delegate finishedSelectedBallForBottomView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating) {
        return;
    }

        if (self.delegate && [self.delegate respondsToSelector:@selector(trendBottomView:offset:)]) {
            [self.delegate trendBottomView:self offset:scrollView.contentOffset];
    }

}

@end
