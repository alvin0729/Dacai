//
//  DPShareView.m
//  DacaiProject
//
//  Created by jacknathan on 14-12-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPShareView.h"
#import "DPImageLabel.h"
#define KShareBtnTagBase 10
#define kShareBtnCommonH 78
#define kShareBtnCommonW 75 
#define kShareAnimationTime 0.3f
#define kShareContentHeight 284
@implementation DPShareView{
    UIView *_contentView;
    BOOL _showMoreFun;
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self dp_buildCommonUI];
//    }
//    return self;
//}
- (instancetype)initWithShowMoreFun:(BOOL)showMoreFun
{
    self = [super init];
    if (self) {
        _showMoreFun = showMoreFun;
        [self dp_buildCommonUI];
        [self addTapGesture];
    }
    return self;
}
- (void)addTapGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture:)];
    [self addGestureRecognizer:singleTap];
}
- (void)dp_buildCommonUI
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UIView *contentView = [[UIView alloc]init];
    _contentView = contentView;
    contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    UIImageView *headView = [[UIImageView alloc]initWithImage:dp_AccountImage(@"share_header.png")];
    UIImageView *headArrow = [[UIImageView alloc]initWithImage:dp_AccountImage(@"share_arrow.png")];
    
    UIButton *actionBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(moreFun:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"分享到";
        label.font = [UIFont dp_systemFontOfSize:17];
        label;
    });
    
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor dp_colorFromHexString:@"#C7C7C6"];
    
    
    NSString *circleImgName = @"朋友圈_03.png";
    NSString *friendsImgName = @"weixin_03.png";
    NSString *WBImgName = @"weibo_03.png";
    NSString *qqImgName = @"share_qq.png";
    BOOL wxEnabled = YES;
    BOOL wbEnabled = YES;
    BOOL qqEnabled = YES;
    if (![[DPThirdCallCenter sharedInstance] dp_isInstalledAPPType:kThirdShareTypeWXF]){
        circleImgName = @"Circle-of-Friends.png";
        friendsImgName = @"weichat.png";
        wxEnabled = NO;
    }
    if (![[DPThirdCallCenter sharedInstance] dp_isInstalledAPPType:kThirdShareTypeSinaWB]) {
        WBImgName = @"weibo.png";
        wbEnabled = NO;
    }
    if (![[DPThirdCallCenter sharedInstance] dp_isInstalledAPPType:kThirdShareTypeQQzone]) {
        qqImgName = @"share_qq_black.png";
        qqEnabled = NO;
    }
   
    UIButton *fCirclebtn = [self commonBtnWithTag:KShareBtnTagBase + 0 title:@"朋友圈" imgName:circleImgName enabled:wxEnabled];
    UIButton *friendsBtn = [self commonBtnWithTag:KShareBtnTagBase + 1 title:@"微信好友" imgName:friendsImgName enabled:wxEnabled];
    UIButton *weiboBtn = [self commonBtnWithTag:KShareBtnTagBase + 2 title:@"微博" imgName:WBImgName enabled:wbEnabled];
    UIButton *qqZoneBtn = [self commonBtnWithTag:KShareBtnTagBase + 3 title:@"QQ空间" imgName:@"kongjian_03.png" enabled:YES];
    UIButton *qqFriendBtn = [self commonBtnWithTag:KShareBtnTagBase + 4 title:@"QQ好友" imgName:qqImgName enabled:qqEnabled];
    
    
    [self addSubview:contentView];
    [contentView addSubview:titleLabel];
    [contentView addSubview:headView];
    [contentView addSubview:headArrow];
    [contentView addSubview:actionBtn];
    [contentView addSubview:topLine];
    
    [contentView addSubview:fCirclebtn];
    [contentView addSubview:friendsBtn];
    [contentView addSubview:weiboBtn];
    [contentView addSubview:qqZoneBtn];
    [contentView addSubview:qqFriendBtn];
    
    CGFloat contentHeight = _showMoreFun == YES ? kShareContentHeight : kShareContentHeight - 60;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@(contentHeight));
        make.bottom.equalTo(self);
        make.left.equalTo(self);
    }];
    
    if (_showMoreFun) {
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView);
            make.centerX.equalTo(contentView);
        }];
        [headArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_right);
            make.centerY.equalTo(headView);
        }];
        
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(contentView);
            make.bottom.equalTo(headView);
        }];
        
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.bottom.equalTo(headView);
            make.height.equalTo(@0.5);
        }];
    }else{
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.centerY.equalTo(contentView.mas_top).offset(20);
        }];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView).offset(40);
            make.height.equalTo(@0.5);
        }];
        
        [headView removeFromSuperview];
        [headArrow removeFromSuperview];
        [actionBtn removeFromSuperview];
        headView = headArrow = nil;
        actionBtn = nil;
    }
    
    [fCirclebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.mas_bottom).offset(10);
        make.left.equalTo(contentView).offset(10);
        make.width.equalTo(@kShareBtnCommonW);
        make.height.equalTo(@kShareBtnCommonH);
    }];
    [friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fCirclebtn);
        make.left.equalTo(fCirclebtn.mas_right).offset(1);
        make.width.equalTo(@kShareBtnCommonW);
        make.height.equalTo(@kShareBtnCommonH);
    }];
    [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fCirclebtn);
        make.left.equalTo(friendsBtn.mas_right).offset(1);
        make.width.equalTo(@kShareBtnCommonW);
        make.height.equalTo(@kShareBtnCommonH);
    }];
    [qqZoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fCirclebtn);
        make.left.equalTo(weiboBtn.mas_right).offset(1);
        make.width.equalTo(@kShareBtnCommonW);
        make.height.equalTo(@kShareBtnCommonH);
    }];
    [qqFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fCirclebtn);
        make.top.equalTo(fCirclebtn.mas_bottom);
        make.width.equalTo(@kShareBtnCommonW);
        make.height.equalTo(@kShareBtnCommonW);
    }];
}
- (UIButton *)commonBtnWithTag:(int)tag title:(NSString *)title imgName:(NSString *)imgName enabled:(BOOL)enabled
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_colorFromHexString:@"F5F5F5"]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:tag];
    button.userInteractionEnabled = enabled;
    
    DPImageLabel *imageLabel = [self imageLabelWithTitle:title imgName:imgName];
    [button addSubview:imageLabel];
    
    [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(button);
        make.width.equalTo(button);
        make.height.equalTo(button);
    }];
    
    return button;
}
- (void)moreFun:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(moreFunButtonClick)]) {
        [self.delegate moreFunButtonClick];
    }
    CGFloat moveY = _contentView.frame.size.height;
    CGRect newFame = CGRectMake(CGRectGetMinX(_contentView.frame), CGRectGetMinY(_contentView.frame) + moveY, CGRectGetWidth(_contentView.frame), moveY);
    [UIView animateWithDuration:kShareAnimationTime animations:^{
        //        DPLog(@"contentview transform = %@", NSStringFromCGAffineTransform(_contentView.transform));
        //        _contentView.transform = CGAffineTransformMakeTranslation(0, 50);
        _contentView.frame = newFame;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];}
- (void)dp_singleBtnClick:(UIButton *)sender
{
    kThirdShareType type = kThirdShareTypeUnknown;
    switch (sender.tag - KShareBtnTagBase) {
        case 0:
            type = kThirdShareTypeWXC;
            break;
        case 1:
            type = kThirdShareTypeWXF;
            break;
        case 2:
            type = kThirdShareTypeSinaWB;
            break;
        case 3:
            type = kThirdShareTypeQQzone;
            break;
        case 4:
            type = kThirdShareTypeQQfriend;
            break;
        default:
            break;
    }
    if (type == kThirdShareTypeUnknown) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(shareWithThirdType:)]) {
        [self.delegate shareWithThirdType:type];
    }
    [self removeFromSuperview];
}
- (void)singleTapGesture:(UIGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self];
    if (CGRectContainsPoint(_contentView.frame, location)) {
        return;
    }else{
        [self pvt_removeAnimation];
    }
}
- (void)pvt_removeAnimation
{
//    CGFloat moveH = _showMoreFun == YES ? kShareContentHeight : kShareContentHeight - 60;
    _contentView.transform = CGAffineTransformIdentity;
    
    CGFloat moveY = _contentView.frame.size.height;
    CGRect newFame = CGRectMake(CGRectGetMinX(_contentView.frame), CGRectGetMinY(_contentView.frame) + moveY, CGRectGetWidth(_contentView.frame), moveY);
    [UIView animateWithDuration:kShareAnimationTime animations:^{
        _contentView.frame = newFame;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (DPImageLabel *)imageLabelWithTitle:(NSString *)title imgName:(NSString *)imgName
{
    DPImageLabel *imgLabel = [[DPImageLabel alloc]init];
    imgLabel.imagePosition = DPImagePositionTop;
    imgLabel.image = dp_AccountImage(imgName);
    imgLabel.text = title;
    imgLabel.textColor = [UIColor dp_colorFromHexString:@"#6D6D67"];
    imgLabel.font = [UIFont dp_systemFontOfSize:14];
    imgLabel.userInteractionEnabled = NO;
    return imgLabel;
}
- (void)showAnimation
{
    CGFloat moveH = _showMoreFun == YES ? kShareContentHeight : kShareContentHeight - 60;
    _contentView.transform = CGAffineTransformMakeTranslation(0, moveH);
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:kShareAnimationTime animations:^{
        _contentView.transform = CGAffineTransformIdentity;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
}
@end
