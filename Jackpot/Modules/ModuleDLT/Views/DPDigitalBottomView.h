//
//  DPDigitalBottomView.h
//  DacaiProject
//
//  Created by sxf on 15/1/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPLTNumberProtocol.h"
@protocol DPLTNumberMutualDelegate;
@protocol DPLTNumberMutualDataSource;
@interface DPDigitalBottomView : UIView
<UITextFieldDelegate>
{
    UIImageView *_bottomView;
    UIImageView *_optionView;
    UIImageView *_mulAndIssueView;
    
}
@property(nonatomic,assign)id<DPLTNumberMutualDelegate>mdelegate;
@property(nonatomic,assign)id<DPLTNumberMutualDataSource>mdataSource;
@property(nonatomic,strong,readonly)UIImageView *bottomView;//底部条
@property(nonatomic,strong,readonly)UIImageView *optionView;//中间期数
@property(nonatomic,strong,readonly)UIImageView *mulAndIssueView;//倍数和期数
@property(nonatomic,assign)NSInteger mulTotal;//掏空奖池所需要的倍数
- (instancetype)initWithFrame:(CGRect)frame  lotteryType:(NSInteger)lotteryType;
// 刷新金额，注数，期数
- (void)dp_refreshMoneyContent;
//获取所选的倍数
-(int)dp_addSelectedBetTimes;
//期数
-(int)dp_addSelectedBetIssue;
- (void)dp_showMiddleContentWithHeight:(CGFloat)height lineHidden:(BOOL)hidden;

-(void)mulLabelText:(NSString *)text;//倍数
-(void)bonusLabel:(NSMutableAttributedString *)hinstring;//底部奖池
@end
