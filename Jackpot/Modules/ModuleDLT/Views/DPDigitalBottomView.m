//
//  DPDigitalBottomView.m
//  DacaiProject
//
//  Created by sxf on 15/1/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPDigitalBottomView.h"
#import "DPDigitalIssueControl.h"
@interface DPDigitalBottomView () {
 @private
    UIButton *_tbuyButton;
    UIButton *_confirmButton;
    UILabel  *_bottomLabel;
    NSInteger _gameType;
    
    UIButton *_addButton;
    UIButton*_introduceButton;
    UITextField *_addTimesTextField;
    UITextField *_addIssueTextField;
    
//    UIView *_midlleLine;
    UIView *_bottomLine;
    UILabel *_mulLabel;
    UILabel *_bonusLabel;
}
@property(nonatomic,strong,readonly)UIButton *tbuyButton;//清空选项
@property(nonatomic,strong,readonly)UIButton *confirmButton;//提交
@property(nonatomic,strong,readonly)UILabel *bottomLabel;//金额，倍数等

@property(nonatomic,strong,readonly)UIButton *addButton;//是否增加投注
@property(nonatomic,strong,readonly)UIButton*introduceButton;//增加投注说明
@property(nonatomic,strong,readonly)UITextField *addTimesTextField;//倍数
@property(nonatomic,strong,readonly)UITextField *addIssueTextField;//期数

@property(nonatomic,strong,readonly)UILabel *mulLabel;//倍数
@property(nonatomic,strong,readonly)UILabel *bonusLabel;//奖池
@end
@implementation DPDigitalBottomView


- (instancetype)initWithFrame:(CGRect)frame  lotteryType:(NSInteger)lotteryType
{
    if (self = [super initWithFrame:frame]) {
        _gameType=lotteryType;
        [self bulidLayout];
       
    }
    return self;
}
-(void)bulidLayout{
    
    [self addSubview: self.optionView];
    [self addSubview:self.mulAndIssueView];
    [self addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@44);
    }];
    [self.optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.height.equalTo(@0);
    }];
    [self.mulAndIssueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
 
    [self pvt_buildConfigLayout];
    [self pvt_buildBottomLayout];
    [self pvt_bulidOption];
    
   
}
//倍数期数
-(void)pvt_buildConfigLayout{
    UIColor *titleColor=[UIColor dp_flatBlackColor];
    
    UIView *midLine = ({
        [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    });
    UIView *rightLine = ({
        [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    });
     UIView *topLine = ({
        [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    });
    UIView *bottomLine = ({
        UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
        line.hidden = YES;
        line;
    });
    
    [self.mulAndIssueView addSubview:topLine];
    [self.mulAndIssueView addSubview:bottomLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mulAndIssueView);
        make.right.equalTo(self.mulAndIssueView);
        make.top.equalTo(self.mulAndIssueView);
        make.height.equalTo(@0.5);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mulAndIssueView);
        make.right.equalTo(self.mulAndIssueView);
        make.bottom.equalTo(self.mulAndIssueView);
        make.height.equalTo(@0.5);
    }];
    _bottomLine = bottomLine;
    
    UILabel *label1=[self labelWithText:@"投" font:[UIFont dp_systemFontOfSize:12.0] titleColor:titleColor textAlignment:NSTextAlignmentCenter];
   
    UILabel *label2=[self labelWithText:@"倍" font:[UIFont dp_systemFontOfSize:12.0] titleColor:titleColor textAlignment:NSTextAlignmentCenter];
    
    label1.adjustsFontSizeToFitWidth=YES;
    label2.adjustsFontSizeToFitWidth=YES;
    UILabel *label3=[self labelWithText:@"追" font:[UIFont dp_systemFontOfSize:12.0] titleColor:titleColor textAlignment:NSTextAlignmentCenter];
    
    UILabel *label4=[self labelWithText:@"期" font:[UIFont dp_systemFontOfSize:12.0] titleColor:titleColor textAlignment:NSTextAlignmentCenter];
    

    if (_gameType== GameTypeDlt) {
        UIView *leftView=[UIView dp_viewWithColor:[UIColor clearColor]];
        UIView *rightView=[UIView dp_viewWithColor:[UIColor clearColor]];
        UIView *midView=[UIView dp_viewWithColor:[UIColor clearColor]];
        [self.mulAndIssueView addSubview:leftView];
        [self.mulAndIssueView addSubview:midView];
        [self.mulAndIssueView addSubview:rightView];
        [midView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView);
            make.bottom.equalTo(self.mulAndIssueView);
            make.centerX.equalTo(self.mulAndIssueView);
            make.width.equalTo(@(kScreenWidth*0.33));
        }];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView);
            make.bottom.equalTo(self.mulAndIssueView);
            make.left.equalTo(self.mulAndIssueView);
            make.right.equalTo(midView.mas_left);
        }];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView);
            make.bottom.equalTo(self.mulAndIssueView);
            make.right.equalTo(self.mulAndIssueView);
            make.left.equalTo(midView.mas_right);
        }];
        
        [leftView addSubview:label1];
        [leftView addSubview:label2];
        [leftView addSubview:self.addTimesTextField];
        [midView addSubview:label3];
        [midView addSubview:label4];
        [midView addSubview:midLine];
        [midView addSubview:self.addIssueTextField];
        [rightView addSubview:rightLine];
        [rightView addSubview:self.addButton];
        [rightView addSubview:self.introduceButton];
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView);
            make.bottom.equalTo(self.mulAndIssueView);
            make.left.equalTo(midView);
            make.width.equalTo(@0.5);
        }];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView);
            make.bottom.equalTo(self.mulAndIssueView);
            make.left.equalTo(rightView);
            make.width.equalTo(@0.5);
        }];
       
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftView).offset(6);
            make.bottom.equalTo(leftView).offset(-6);
            make.left.equalTo(leftView).offset(10);
            make.width.equalTo(@(kScreenWidth*0.05));
        }];
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftView).offset(6);
            make.bottom.equalTo(leftView).offset(-6);
            make.right.equalTo(leftView).offset(-10);
            make.width.equalTo(@(kScreenWidth*0.05));
        }];
        [self.addTimesTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView).offset(6);
            make.bottom.equalTo(self.mulAndIssueView).offset(-6);
            make.left.equalTo(label1.mas_right).offset(5);
            make.right.equalTo(label2.mas_left).offset(-5);
        }];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(midView).offset(6);
            make.bottom.equalTo(midView).offset(-6);
            make.left.equalTo(midView).offset(10);
            make.width.equalTo(@(kScreenWidth*0.05));
        }];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(midView).offset(6);
            make.bottom.equalTo(midView).offset(-6);
            make.right.equalTo(midView).offset(-10);
            make.width.equalTo(@(kScreenWidth*0.05));
        }];
        [self.addIssueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView).offset(6);
            make.bottom.equalTo(self.mulAndIssueView).offset(-6);
            make.left.equalTo(label3.mas_right).offset(5);
            make.right.equalTo(label4.mas_left).offset(-5);

        }];
       

        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rightView).offset(-10);
            make.top.equalTo(rightView);
            make.centerY.equalTo(rightView);
            make.width.equalTo(@70);
        }];
       
        [_introduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightView);
            make.width.equalTo(@30);
            make.top.equalTo(rightView);
            make.centerY.equalTo(_addButton) ;
        }];
        
        
        return;
    }
    //todo 加彩种需要再做处理

}
//底部投注提交
-(void)pvt_buildBottomLayout{
    [self.bottomView addSubview:self.tbuyButton];
    [self.tbuyButton addTarget:self action:@selector(pvt_togetherBuy) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.confirmButton];
    [self.tbuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(5);
        make.bottom.equalTo(self.bottomView).offset(-5);
        make.left.equalTo(self.bottomView).offset(5);
        make.width.equalTo(@40);
    }];
    
        UIImageView *confirmView = [[UIImageView alloc] init];
        confirmView.image =dp_CommonImage(@"sumit001_24.png") ;
         UIView *lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
         self.confirmButton.backgroundColor = UIColorFromRGB(0xd94f4d);
     [self.confirmButton addTarget:self action:@selector(pvt_submit) forControlEvents:UIControlEventTouchUpInside];
        [self.confirmButton addSubview:self.bottomLabel];
        [self.confirmButton addSubview:confirmView];
        [self.bottomView addSubview:lineView];
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView);
            make.bottom.equalTo(self.bottomView);
            make.left.equalTo(self.tbuyButton.mas_right).offset(5);
            make.right.equalTo(self.bottomView);
        }];
        
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.confirmButton).offset(10);
            make.right.equalTo(self.bottomView).offset(-40);
            make.centerY.equalTo(self.confirmButton);
            make.top.equalTo(self.bottomView);
        }];
        [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.confirmButton).offset(-20);
            make.centerY.equalTo(self.confirmButton);
            make.width.equalTo(@23.5);
            make.height.equalTo(@23);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView);
            make.left.equalTo(self.bottomView);
            make.right.equalTo(self.bottomView);
            make.height.equalTo(@0.5);
        }];

}

-(void)pvt_bulidOption{
    
    UILabel *label=[[UILabel alloc] init];
    label.backgroundColor=[UIColor clearColor];
    label.text=@"投注";
    label.clipsToBounds=YES;
    label.textColor=UIColorFromRGB(0x828260);
    label.font=[UIFont systemFontOfSize:14.0];
    [self.optionView addSubview:label];
    [self.optionView addSubview:self.mulLabel];
    [self.optionView addSubview:self.bonusLabel];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.optionView).offset(40);
        make.top.equalTo(self.optionView);
        make.bottom.equalTo(self.optionView);
    }];
    [self.mulLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(label.mas_right).offset(5);
        make.width.equalTo(@68);
        make.centerY.equalTo(self.optionView);
        make.height.equalTo(@25);
    }];
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.mulLabel.mas_right).offset(5);
        make.top.equalTo(self.optionView);
        make.bottom.equalTo(self.optionView);
    }];
    [self.optionView addGestureRecognizer:({
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_optionView)];
        tapRecognizer.view.tag=5;
        tapRecognizer;
    })];
   
    
    
    
}
-(void)pvt_optionView{
    self.addTimesTextField.text=[NSString stringWithFormat:@"%d",(int)self.mulTotal];
     [self dp_refreshMoneyContent];
}
//增加投注倍数
-(void)pvt_addMul:(UIButton *)button{
    button.selected=!button.selected;
    [self dp_refreshMoneyContent];
    if (self.mdelegate&&[self.mdelegate respondsToSelector:@selector(onBtnaddition:)]) {
        [self.mdelegate onBtnaddition:button.selected];
    }
}
//投注倍数介绍
-(void)pvt_introduce{
    if (self.mdelegate&&[self.mdelegate respondsToSelector:@selector(onBtnIntroduce)]) {
        [self.mdelegate onBtnIntroduce];
    }
}
////中奖后停止
//-(void)pvt_afterWinStop:(UIButton *)button{
//
//    button.selected=!button.selected;
//    self.mdataSource.stopAfterWin = button.selected;
//     [self dp_refreshMoneyContent];
//
//}
//选择期号
-(void)pvt_singleButtonClick:(id)sender{

}
//提交按钮
-(void)pvt_submit{
    if (self.mdelegate&&[self.mdelegate respondsToSelector:@selector(onBtnGoPay)]) {
        [self.mdelegate onBtnGoPay];
    }

}
//合买按钮
-(void)pvt_togetherBuy{
    if (self.mdelegate&&[self.mdelegate respondsToSelector:@selector(onBTnDeleteAllData)]) {
        [self.mdelegate onBTnDeleteAllData];
    }
    
}
//生成标签
- (UILabel *)labelWithText:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = color;
    label.textAlignment = alignment;
    label.text = title;
    return label;
}
//生成按钮
-(UIButton *)createIssueButton{
    UIButton *button=[[UIButton alloc]init];
           [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
       [button setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
       [button setImage:nil forState:UIControlStateNormal];
       [button setImage:dp_DigitLotteryImage(@"selectedIssue001_11.png") forState:UIControlStateSelected];
     return button;
}
//倍数期数
-(UIImageView *)mulAndIssueView{
    if (_mulAndIssueView==nil) {
        _mulAndIssueView=[[UIImageView alloc]init];
        _mulAndIssueView.backgroundColor=[UIColor whiteColor];
         _mulAndIssueView.userInteractionEnabled=YES;
    }
    return _mulAndIssueView;
}
-(UIImageView *)optionView{
    if (_optionView==nil) {
        _optionView=[[UIImageView alloc]init];
        _optionView.backgroundColor=[UIColor dp_flatBackgroundColor];
        _optionView.userInteractionEnabled = YES;
    }
    return _optionView;
}
//投注提交
- (UIImageView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIImageView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.userInteractionEnabled=YES;
    }
    return _bottomView;
}
//清空选项
-(UIButton *)tbuyButton{
    if (_tbuyButton==nil) {
        _tbuyButton=[[UIButton alloc] init];
        _tbuyButton.backgroundColor=[UIColor clearColor];
        [_tbuyButton setImage:dp_CommonImage(@"delete001_21.png") forState:UIControlStateNormal];
       
    }
    return _tbuyButton;
}
//提交
-(UIButton *)confirmButton{
    if (_confirmButton==nil) {
        _confirmButton=[[UIButton alloc] init];
        _confirmButton.backgroundColor=[UIColor clearColor];
        
    }
    return _confirmButton;
}
//金额，倍数等
-(UILabel *)bottomLabel{
    if (_bottomLabel==nil) {
        _bottomLabel=[[UILabel alloc] init];
        _bottomLabel.backgroundColor=[UIColor clearColor];
        _bottomLabel.textColor=[UIColor dp_flatWhiteColor];
        _bottomLabel.font=[UIFont dp_regularArialOfSize:14.0];
        _bottomLabel.textAlignment=NSTextAlignmentLeft;
        _bottomLabel.numberOfLines=2;
    }
    return _bottomLabel;

}
-(UIButton *)addButton{
    if (_addButton==nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.backgroundColor = [UIColor clearColor];
        _addButton.tag = 1000;
        [_addButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"uncheck.png")] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"check.png")] forState:UIControlStateSelected];
        [_addButton setTitle:@" 追加投注" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _addButton.selected = NO;
        [_addButton addTarget:self action:@selector(pvt_addMul:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;

}
//是否增加投注
-(UIButton *)introduceButton{

    if(_introduceButton==nil){
        _introduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _introduceButton.backgroundColor = [UIColor clearColor];
        [_introduceButton setImage:[dp_AccountImage(@"drawingMoney.png") dp_imageWithTintColor:UIColorFromRGB(0x0b76d4)] forState:UIControlStateNormal];
        [_introduceButton addTarget:self action:@selector(pvt_introduce) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _introduceButton;

}
//倍数
-(UILabel *)mulLabel{
    if (_mulLabel==nil) {
        _mulLabel =[[UILabel alloc] init];
        _mulLabel.backgroundColor=UIColorFromRGB(0xda4f4d);
//        _mulLabel.text=@"    200倍    ";
        _mulLabel.clipsToBounds=YES;
//        _mulLabel.adjustsFontSizeToFitWidth=YES;
        _mulLabel.layer.cornerRadius=3;
        _mulLabel.textAlignment=NSTextAlignmentCenter;
        _mulLabel.textColor=[UIColor whiteColor];
        _mulLabel.font=[UIFont systemFontOfSize:13.0];
    }
    return _mulLabel;
}
//奖池
-(UILabel *)bonusLabel{
    if (_bonusLabel==nil) {
        _bonusLabel =[[UILabel alloc] init];
        _bonusLabel.backgroundColor=[UIColor clearColor];
//        _bonusLabel.text=@"可掏空12.43亿的奖池";
        _bonusLabel.clipsToBounds=YES;
        _bonusLabel.adjustsFontSizeToFitWidth=YES;
        _bonusLabel.textColor=UIColorFromRGB(0x828260);
        _bonusLabel.font=[UIFont systemFontOfSize:13.0];
    }
    return _bonusLabel;
}
//倍数
-(UITextField *)addTimesTextField{

    if (_addTimesTextField==nil) {
       _addTimesTextField= [[UITextField alloc] init];
       _addTimesTextField.backgroundColor = [UIColor whiteColor];
        _addTimesTextField.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0].CGColor;
        _addTimesTextField.layer.borderWidth = 0.5;
       _addTimesTextField.layer.cornerRadius = 5;
        _addTimesTextField.textAlignment = NSTextAlignmentCenter;
       _addTimesTextField.delegate = self;
        _addTimesTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _addTimesTextField.font = [UIFont dp_systemFontOfSize:14];
        _addTimesTextField.keyboardType = UIKeyboardTypeNumberPad;
        _addTimesTextField.textColor = [UIColor dp_flatBlackColor];
        _addTimesTextField.text = @"1";
        _addTimesTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter ;
        
        _addTimesTextField.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);
            line;
        });
    }
    return _addTimesTextField;
}
//期数
-(UITextField *)addIssueTextField{
    if (_addIssueTextField==nil) {
        _addIssueTextField = [[UITextField alloc] init];
        _addIssueTextField.backgroundColor = [UIColor whiteColor];
        _addIssueTextField.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0].CGColor;
        _addIssueTextField.layer.borderWidth = 0.5;
        _addIssueTextField.layer.cornerRadius = 5;
        _addIssueTextField.textAlignment = NSTextAlignmentCenter;
        _addIssueTextField.delegate = self;
        _addIssueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _addIssueTextField.font = [UIFont boldSystemFontOfSize:14];
        _addIssueTextField.keyboardType = UIKeyboardTypeNumberPad;
        _addIssueTextField.textColor = [UIColor dp_flatBlackColor];
        _addIssueTextField.text = @"1";
        _addIssueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter ;
        _addIssueTextField.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);
            line;
        });
    }
    return _addIssueTextField;
    
}

-(void)mulLabelText:(NSString *)text{
    [self.mulLabel setText:text];
}
-(void)bonusLabel:(NSMutableAttributedString *)hinstring{
    self.bonusLabel.attributedText=hinstring;
}
#pragma mark -UITextDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    float height = 0.0;
//    self.optionView.hidden = YES;
//    float alp = 0;
//    self.tag = 0;
//    if (textField == self.addTimesTextField) {
//        height = 30;
//        self.optionView.hidden = NO;
//        alp = 1.0f;
//        self.tag = 1;
//    }
//    if ([[DPKeyboardCenter defaultCenter] isKeyboardAppear]) {
//        // 键盘已经出来
//        CGFloat height = 0;
//        BOOL hidden = YES;
//        if (self.tag == 1) {
//            height = 30;
//            hidden = NO;
//        }
//        [self dp_showMiddleContentWithHeight:height lineHidden:hidden];
//        [self setNeedsLayout];
//        [self setNeedsUpdateConstraints];
//        
//        DPLog(@"1.%@", [NSDate date]);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            DPLog(@"2.%@", [NSDate date]);
//            [UIView animateWithDuration:0.2f animations:^{
//                [self layoutIfNeeded];
//            }];
//        });
    
        
//    }
    return YES;
}
- (void)dp_showMiddleContentWithHeight:(CGFloat)height lineHidden:(BOOL)hidden
{
    [self pvt_adaptPassModeHeight:height];
//    if (_midlleLine) {
//        _midlleLine.hidden = hidden;
//        
//    }
    if (_bottomLine) {
        _bottomLine.hidden = hidden;
    }

    
    self.optionView.hidden = (height == 0 )? YES : NO;

}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField selectAll:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];
        });
    });
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (![DPVerifyUtilities isNumber:string]) {
//        return NO;
//    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int aString = [newString intValue];
//    if (textField == self.addTimesTextField) {
//        if (aString > 1000) {
//            textField.text = @"1000";
//           [self dp_refreshMoneyContent];
//            return NO;
//        }
//    }
    if (newString.length == 0) {
        textField.text = @"";
       [self dp_refreshMoneyContent];
        return NO;
    }
    if (aString <= 0) {
        textField.text = @"1";
       [self dp_refreshMoneyContent];
        return NO;
    }
    newString = [NSString stringWithFormat:@"%d", aString];
    if ([textField.text isEqualToString:newString]) {
        textField.text = nil;   // fix iOS8
    }
    textField.text = newString;
    if (textField==self.addTimesTextField) {
        self.mdataSource.multiple=[newString integerValue];
         self.addTimesTextField.text=textField.text;
    }
     [self dp_refreshMoneyContent];
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length==0) {
        textField.text=@"1";
    }
    if (textField==self.addIssueTextField) {
        if ([textField.text integerValue]>99) {
            textField.text=@"99";
        }
    }
   [self dp_refreshMoneyContent];
    
}
- (void)pvt_adaptPassModeHeight:(float)height {
    [self invalidateIntrinsicContentSize];
    [self.optionView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == self.optionView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = height;
            *stop = YES;
        }
    }];
}
- (CGSize)intrinsicContentSize {
    CGFloat height=79;
    if (self.optionView.hidden==NO&&self.addTimesTextField.editing) {
        height= 114;
    }
    return CGSizeMake(320, height);
}

- (void)dp_refreshMoneyContent
{
    NSInteger zhushu = self.mdataSource.note; // 注数
    NSInteger addTimesAndMoney= self.addButton.selected?3:2;
    NSMutableAttributedString *hinstring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld元\n  %ld注  %d倍",zhushu*addTimesAndMoney*[self dp_addSelectedBetTimes]*[self dp_addSelectedBetIssue],zhushu,[self dp_addSelectedBetTimes]]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:4];//调整行间距
    [hinstring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [hinstring length])];
    self.bottomLabel.attributedText=hinstring;;
}
//倍数
-(int)dp_addSelectedBetTimes{
    int times=1;
    if ([self.addTimesTextField.text integerValue]>1) {
        times=[self.addTimesTextField.text intValue];
    }
    return times;
}
//期数
-(int)dp_addSelectedBetIssue{
    int issue=1;
    if ([self.addIssueTextField.text integerValue]>1) {
        issue=[self.addIssueTextField.text intValue];
    }
    return issue;
}
@end
