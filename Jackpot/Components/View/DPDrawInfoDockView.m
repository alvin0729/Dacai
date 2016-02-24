//
//  DPDrawInfoDockView.m
//  DacaiProject
//
//  Created by Ray on 15/2/12.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDrawInfoDockView.h"

@implementation DPDrawInfoDockView{
    
    UIImage *_bottomImage ;
    UIColor *_selectColor ;
    UIColor *_normalColor ;
    
}



-(void)setTitleArray:(NSArray *)titleArray{
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    _titleArray = titleArray ;
    [self createUIWithTitles:titleArray];
    
}

-(void)setSelectBGImg:(UIImage *)selectBGImg{

    if (_selectBGImg == selectBGImg) {
        return ;
    }
    
    _selectBGImg =selectBGImg ;
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)obj ;
            [btn setBackgroundImage:selectBGImg forState:UIControlStateSelected];
        }
    }];
    
}

-(void)setNormalBGImg:(UIImage *)normalBGImg{

    if (_normalBGImg == normalBGImg) {
        return ;
    }
    
    _normalBGImg = normalBGImg ;
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)obj ;
            [btn setBackgroundImage:normalBGImg forState:UIControlStateNormal];
        }
    }];

}

-(void)setMiddleLineColor:(UIColor *)middleLineColor{

    if (_middleLineColor == middleLineColor) {
        return ;
    }
    _middleLineColor = middleLineColor ;
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)obj ;
            UIView* sepView = [btn viewWithTag:888] ;
            sepView.backgroundColor = middleLineColor ;
            
            UIView *rightView = [btn viewWithTag:889] ;
            rightView.backgroundColor = middleLineColor ;

        }
    }];

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithTitles:(NSArray*)titleArray bottomImg:(UIImage*)botomImg selectColor:(UIColor*)selectColor normalColor:(UIColor*)normalColor 
{
    self = [super init];
    if (self) {
        
        _bottomImage = botomImg ;
        _selectColor =selectColor ;
        _normalColor = normalColor ;
        self.backgroundColor = [UIColor clearColor] ;
//        self.layer.borderColor = UIColorFromRGB(0xdad5cc).CGColor ;
//        self.layer.borderWidth = 1 ;
        _titleArray = titleArray ;
        [self createUIWithTitles:titleArray ];
        
    }
    return self;
}

-(void)createUIWithTitles:(NSArray*)titles {
    
    UIImageView *imgView ;
    for (int i=0; i<titles.count; i++) {
        UIButton *btn = [self dockItemWithTitle:[titles objectAtIndex:i] tag:(DrawTag+i) target:self action:@selector(pvt_changeIndex :) seperatorLine:(i==titles.count-1)];
        [self addSubview:btn];
        imgView = (UIImageView*)[btn viewWithTag:777] ;
        
        
        if (i == 0) {
            btn.selected = imgView.highlighted=  YES ;
        }else{
            btn.selected =imgView.highlighted=  NO ;
        }
        
    }
    
    
}




-(void)layoutSubviews{

    int btnWidth = CGRectGetWidth(self.frame)/self.titleArray.count ;

    for (int i=0; i<self.titleArray.count ; i++) {

         UIButton *btn = (UIButton*)[self viewWithTag:DrawTag+i];
        btn.frame = CGRectMake(i*btnWidth, 0, btnWidth, CGRectGetHeight(self.frame)) ;

    }
}

-(void)pvt_changeIndex:(UIButton*)sender{
    
    UIButton *btn = (UIButton*)[self viewWithTag:sender.tag] ;
    self.currentDocIndex = btn.tag -DrawTag ;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeDocIndex:)]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeDocIndex:) object:nil];
        [self.delegate changeDocIndex:btn.tag -DrawTag];
    }
    
    
}

-(void)setCurrentDocIndex:(NSInteger)currentDocIndex{
    if (_currentDocIndex == currentDocIndex) {
        return ;
    }
    _currentDocIndex = currentDocIndex ;
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:([ UIButton class])]) {
            UIButton * curbtn = (UIButton*)obj ;
            curbtn.selected = NO ;
            
            UIImageView *imgView = (UIImageView*)[curbtn viewWithTag:777] ;
            imgView.highlighted = NO ;
        }
    }];
    UIButton *btn = (UIButton*)[self viewWithTag:currentDocIndex+DrawTag] ;
    btn.selected = YES ;
    
    UIImageView *imgView = (UIImageView*)[btn viewWithTag:777] ;
    imgView.highlighted = YES ;

}

#pragma mark - 初始化dockButton按钮方法
- (UIButton *)dockItemWithTitle:(NSString *)title tag:(int)tag target:(id)target action:(SEL)action seperatorLine:(BOOL)seperatorLine{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor] ;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:_normalColor forState:UIControlStateNormal];
    [btn setTitleColor:_selectColor forState:UIControlStateSelected];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:kTextFont];
    btn.tag = tag;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView * bottomLine = ({
        
        UIImageView* imgView ;
        if (_titleArray.count <2) {
            imgView = [[UIImageView alloc]initWithImage:nil highlightedImage:nil];
        }else{
        
            imgView = [[UIImageView alloc]initWithImage:nil highlightedImage:_bottomImage];
        }
        imgView.tag = 777;
        imgView.backgroundColor = [UIColor clearColor] ;
        imgView;
    } );
    
    [btn addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn) ;
        make.left.equalTo(btn) ;
        make.right.equalTo(btn) ;
    }];
    
    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor =  UIColorFromRGB(0xdad5cc);
    [btn addSubview:rightLine];
    rightLine.tag = 888 ;
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn);
        make.left.equalTo(btn.mas_left);
        make.bottom.equalTo(btn.mas_bottom);
        make.width.equalTo(@0.5);
    }];

    
    if (seperatorLine) {
        
        UIView *seperatorLine = [[UIView alloc]init];
        seperatorLine.backgroundColor =  UIColorFromRGB(0xdad5cc);
        [btn addSubview:seperatorLine];
        seperatorLine.tag = 889 ;
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn);
            make.right.equalTo(btn.mas_right);
            make.bottom.equalTo(btn.mas_bottom);
            make.width.equalTo(@0.5);
        }];
    }
    return btn;
}


@end

