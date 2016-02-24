//
//  DPSecurityCenterCell.h
//  Jackpot
//
//  Created by sxf on 15/8/19.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPSecurityCenterCellDelegate;
//手机认证
@interface DPSecurityCenterCell : UITableViewCell

@property(nonatomic,assign)id<DPSecurityCenterCellDelegate>delegate;
//标题设置(手机号码设置)
-(void)setTitleLabelText:(NSString *)text;
//设置点击按钮
-(void)setChangeLabelShow:(BOOL)isShow;
//设置说明文字
-(void)setInfoLabelText:(NSString *)text;
@end

//登录密码  支付密码
@interface DPAredgeAccountCell : UITableViewCell
{
  UILabel *_titleLabel;
}
@property(nonatomic,strong,readonly)UILabel *titleLabel;//简介
@property(nonatomic,assign)id<DPSecurityCenterCellDelegate>delegate;
@end


//账户信息->实名认证->提款信息
@interface DPAcountInfoCell : UITableViewCell

@property(nonatomic,assign)id<DPSecurityCenterCellDelegate>delegate;
//用户姓名
-(void)setUsernameText:(NSString *)text;
//身份证信息
-(void)setCardIdText:(NSString *)text;
//银行卡信息
-(void)setBankInfoText:(NSString *)text;
//归属地信息
-(void)setAddressText:(NSString *)text;
@end

@protocol DPSecurityCenterCellDelegate <NSObject>
@optional
//修改手机号
-(void)changePhoneForCell:(DPSecurityCenterCell *)cell;
//修改提款银行卡
-(void)changeDrawBankForCell:(DPAcountInfoCell *)cell;
//修改密码
-(void)changePassWordForCell:(DPAredgeAccountCell *)cell;

@end
