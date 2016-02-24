// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: security.proto

#import "GPBProtocolBuffers.h"

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30000
#error This file was generated by a different version of protoc-gen-objc which is incompatible with your Protocol Buffer sources.
#endif

// @@protoc_insertion_point(imports)

CF_EXTERN_C_BEGIN

@class PBMSecurityHome_BankInfoItem;
@class PBMSecurityHome_RealNameItem;


#pragma mark - PBMSecurityRoot

@interface PBMSecurityRoot : GPBRootObject

// The base class provides:
//   + (GPBExtensionRegistry *)extensionRegistry;
// which is an GPBExtensionRegistry that includes all the extensions defined by
// this file and all files that it depends on.

@end

#pragma mark - PBMSecurityHome

typedef GPB_ENUM(PBMSecurityHome_FieldNumber) {
  PBMSecurityHome_FieldNumber_NameItem = 1,
  PBMSecurityHome_FieldNumber_BankItem = 2,
  PBMSecurityHome_FieldNumber_ShowAccount = 3,
  PBMSecurityHome_FieldNumber_ShowPhone = 4,
  PBMSecurityHome_FieldNumber_ShowLoginPassword = 5,
  PBMSecurityHome_FieldNumber_ShowPayPassword = 6,
  PBMSecurityHome_FieldNumber_PhoneNumber = 7,
};

// 实名认证首页
@interface PBMSecurityHome : GPBMessage

// 实名认证列表
@property(nonatomic, readwrite) BOOL hasNameItem;
@property(nonatomic, readwrite, strong) PBMSecurityHome_RealNameItem *nameItem;

// 银行卡信息列表
@property(nonatomic, readwrite) BOOL hasBankItem;
@property(nonatomic, readwrite, strong) PBMSecurityHome_BankInfoItem *bankItem;

// 开通账户
@property(nonatomic, readwrite) BOOL hasShowAccount;
@property(nonatomic, readwrite) BOOL showAccount;

// 手机认证
@property(nonatomic, readwrite) BOOL hasShowPhone;
@property(nonatomic, readwrite) BOOL showPhone;

// 登录密码（设置 修改）
@property(nonatomic, readwrite) BOOL hasShowLoginPassword;
@property(nonatomic, readwrite) BOOL showLoginPassword;

// 支付密码（设置 修改）
@property(nonatomic, readwrite) BOOL hasShowPayPassword;
@property(nonatomic, readwrite) BOOL showPayPassword;

// 手机号码（带*号，没认证则不显示）
@property(nonatomic, readwrite) BOOL hasPhoneNumber;
@property(nonatomic, readwrite, copy) NSString *phoneNumber;

@end

#pragma mark - PBMSecurityHome_RealNameItem

typedef GPB_ENUM(PBMSecurityHome_RealNameItem_FieldNumber) {
  PBMSecurityHome_RealNameItem_FieldNumber_RealName = 1,
  PBMSecurityHome_RealNameItem_FieldNumber_CardId = 2,
};

@interface PBMSecurityHome_RealNameItem : GPBMessage

// 姓名
@property(nonatomic, readwrite) BOOL hasRealName;
@property(nonatomic, readwrite, copy) NSString *realName;

// 身份证
@property(nonatomic, readwrite) BOOL hasCardId;
@property(nonatomic, readwrite, copy) NSString *cardId;

@end

#pragma mark - PBMSecurityHome_BankInfoItem

typedef GPB_ENUM(PBMSecurityHome_BankInfoItem_FieldNumber) {
  PBMSecurityHome_BankInfoItem_FieldNumber_BankName = 1,
  PBMSecurityHome_BankInfoItem_FieldNumber_BankNumber = 2,
  PBMSecurityHome_BankInfoItem_FieldNumber_BankAddress = 3,
};

@interface PBMSecurityHome_BankInfoItem : GPBMessage

// 姓名
@property(nonatomic, readwrite) BOOL hasBankName;
@property(nonatomic, readwrite, copy) NSString *bankName;

// 卡号后四位
@property(nonatomic, readwrite) BOOL hasBankNumber;
@property(nonatomic, readwrite, copy) NSString *bankNumber;

// 归属地
@property(nonatomic, readwrite) BOOL hasBankAddress;
@property(nonatomic, readwrite, copy) NSString *bankAddress;

@end

#pragma mark - PBMPhoneVerCodeRes

typedef GPB_ENUM(PBMPhoneVerCodeRes_FieldNumber) {
  PBMPhoneVerCodeRes_FieldNumber_PhoneNumber = 1,
};

// 获取验证码请求(验证旧手机,找回登录密码)
@interface PBMPhoneVerCodeRes : GPBMessage

// 手机号码
@property(nonatomic, readwrite) BOOL hasPhoneNumber;
@property(nonatomic, readwrite, copy) NSString *phoneNumber;

@end

#pragma mark - PBMPhoneBindingRes

typedef GPB_ENUM(PBMPhoneBindingRes_FieldNumber) {
  PBMPhoneBindingRes_FieldNumber_PhoneNumber = 1,
  PBMPhoneBindingRes_FieldNumber_VerCode = 2,
  PBMPhoneBindingRes_FieldNumber_Token = 3,
  PBMPhoneBindingRes_FieldNumber_ThirdLoginItem = 4,
};

// 验证手机请求(验证旧手机，绑定新手机,找回登录密码)
@interface PBMPhoneBindingRes : GPBMessage

// 手机号码
@property(nonatomic, readwrite) BOOL hasPhoneNumber;
@property(nonatomic, readwrite, copy) NSString *phoneNumber;

// 验证码
@property(nonatomic, readwrite) BOOL hasVerCode;
@property(nonatomic, readwrite, copy) NSString *verCode;

// 验证旧手机缺省token
@property(nonatomic, readwrite) BOOL hasToken;
@property(nonatomic, readwrite, copy) NSString *token;

// 第三方注册元素
@property(nonatomic, readwrite) BOOL hasThirdLoginItem;
@property(nonatomic, readwrite, copy) NSString *thirdLoginItem;

@end

#pragma mark - PBMPhoneBindingRes_ThirdLogOnParam

typedef GPB_ENUM(PBMPhoneBindingRes_ThirdLogOnParam_FieldNumber) {
  PBMPhoneBindingRes_ThirdLogOnParam_FieldNumber_Appid = 1,
  PBMPhoneBindingRes_ThirdLogOnParam_FieldNumber_AccessToken = 2,
  PBMPhoneBindingRes_ThirdLogOnParam_FieldNumber_Openid = 3,
  PBMPhoneBindingRes_ThirdLogOnParam_FieldNumber_Type = 4,
};

@interface PBMPhoneBindingRes_ThirdLogOnParam : GPBMessage

// 用户id
@property(nonatomic, readwrite) BOOL hasAppid;
@property(nonatomic, readwrite, copy) NSString *appid;

// token
@property(nonatomic, readwrite) BOOL hasAccessToken;
@property(nonatomic, readwrite, copy) NSString *accessToken;

@property(nonatomic, readwrite) BOOL hasOpenid;
@property(nonatomic, readwrite, copy) NSString *openid;

//第三方类别
@property(nonatomic, readwrite) BOOL hasType;
@property(nonatomic, readwrite) int32_t type;

@end

#pragma mark - PBMGetTokenRes

typedef GPB_ENUM(PBMGetTokenRes_FieldNumber) {
  PBMGetTokenRes_FieldNumber_Token = 1,
};

// 验证旧手机响应,验证个人信息(手机号码已丢失),找回登录密码/找回支付密码
@interface PBMGetTokenRes : GPBMessage

// 获取token
@property(nonatomic, readwrite) BOOL hasToken;
@property(nonatomic, readwrite, copy) NSString *token;

@end

#pragma mark - PBMNewPhoneVerCodeRes

typedef GPB_ENUM(PBMNewPhoneVerCodeRes_FieldNumber) {
  PBMNewPhoneVerCodeRes_FieldNumber_PhoneNumber = 1,
  PBMNewPhoneVerCodeRes_FieldNumber_Token = 2,
};

// 获取新手机验证码请求
@interface PBMNewPhoneVerCodeRes : GPBMessage

// 手机号码
@property(nonatomic, readwrite) BOOL hasPhoneNumber;
@property(nonatomic, readwrite, copy) NSString *phoneNumber;

// token
@property(nonatomic, readwrite) BOOL hasToken;
@property(nonatomic, readwrite, copy) NSString *token;

@end

#pragma mark - PBMPhoneLoseRes

typedef GPB_ENUM(PBMPhoneLoseRes_FieldNumber) {
  PBMPhoneLoseRes_FieldNumber_AceName = 1,
  PBMPhoneLoseRes_FieldNumber_CardNumber = 2,
  PBMPhoneLoseRes_FieldNumber_BankNumber = 3,
};

// 号码已丢失验证
@interface PBMPhoneLoseRes : GPBMessage

// 实名
@property(nonatomic, readwrite) BOOL hasAceName;
@property(nonatomic, readwrite, copy) NSString *aceName;

// 身份证
@property(nonatomic, readwrite) BOOL hasCardNumber;
@property(nonatomic, readwrite, copy) NSString *cardNumber;

// 银行卡
@property(nonatomic, readwrite) BOOL hasBankNumber;
@property(nonatomic, readwrite, copy) NSString *bankNumber;

@end

#pragma mark - PBMChangePassWordRes

typedef GPB_ENUM(PBMChangePassWordRes_FieldNumber) {
  PBMChangePassWordRes_FieldNumber_OldPassword = 1,
  PBMChangePassWordRes_FieldNumber_NewPassword = 2,
};

// 修改登录密码/修改支付密码
@interface PBMChangePassWordRes : GPBMessage

// 原密码
@property(nonatomic, readwrite) BOOL hasOldPassword;
@property(nonatomic, readwrite, copy) NSString *oldPassword;

// 新密码
@property(nonatomic, readwrite) BOOL hasNewPassword;
@property(nonatomic, readwrite, copy) NSString *newPassword NS_RETURNS_NOT_RETAINED;

@end

#pragma mark - PBMFindPassWordRes

typedef GPB_ENUM(PBMFindPassWordRes_FieldNumber) {
  PBMFindPassWordRes_FieldNumber_AceName = 1,
  PBMFindPassWordRes_FieldNumber_CardId = 2,
  PBMFindPassWordRes_FieldNumber_PhoneNumber = 3,
  PBMFindPassWordRes_FieldNumber_VerCode = 4,
};

// 找回登录密码/找回支付密码
@interface PBMFindPassWordRes : GPBMessage

// 姓名
@property(nonatomic, readwrite) BOOL hasAceName;
@property(nonatomic, readwrite, copy) NSString *aceName;

// 身份证号
@property(nonatomic, readwrite) BOOL hasCardId;
@property(nonatomic, readwrite, copy) NSString *cardId;

// 手机号码
@property(nonatomic, readwrite) BOOL hasPhoneNumber;
@property(nonatomic, readwrite, copy) NSString *phoneNumber;

// 验证码
@property(nonatomic, readwrite) BOOL hasVerCode;
@property(nonatomic, readwrite, copy) NSString *verCode;

@end

#pragma mark - PBMSetPassWordRes

typedef GPB_ENUM(PBMSetPassWordRes_FieldNumber) {
  PBMSetPassWordRes_FieldNumber_Password = 1,
};

//设置支付密码/登录密码
@interface PBMSetPassWordRes : GPBMessage

// 设置支付密码
@property(nonatomic, readwrite) BOOL hasPassword;
@property(nonatomic, readwrite, copy) NSString *password;

@end

#pragma mark - PBMFindToSetPassWordRes

typedef GPB_ENUM(PBMFindToSetPassWordRes_FieldNumber) {
  PBMFindToSetPassWordRes_FieldNumber_Password = 1,
  PBMFindToSetPassWordRes_FieldNumber_PhoneNumber = 2,
  PBMFindToSetPassWordRes_FieldNumber_Token = 3,
};

//找回支付密码/登录密码(设置)
@interface PBMFindToSetPassWordRes : GPBMessage

// 设置支付密码
@property(nonatomic, readwrite) BOOL hasPassword;
@property(nonatomic, readwrite, copy) NSString *password;

// 手机号码
@property(nonatomic, readwrite) BOOL hasPhoneNumber;
@property(nonatomic, readwrite, copy) NSString *phoneNumber;

// token
@property(nonatomic, readwrite) BOOL hasToken;
@property(nonatomic, readwrite, copy) NSString *token;

@end

#pragma mark - PBMLoginOutAcoount

typedef GPB_ENUM(PBMLoginOutAcoount_FieldNumber) {
  PBMLoginOutAcoount_FieldNumber_NoBetTotal = 1,
  PBMLoginOutAcoount_FieldNumber_UserMoney = 2,
};

// 注销投注账户获取未结信息
@interface PBMLoginOutAcoount : GPBMessage

// 未结投注个数
@property(nonatomic, readwrite) BOOL hasNoBetTotal;
@property(nonatomic, readwrite, copy) NSString *noBetTotal;

// 用户余额
@property(nonatomic, readwrite) BOOL hasUserMoney;
@property(nonatomic, readwrite, copy) NSString *userMoney;

@end

#pragma mark - PBMModifyDrawingCard

typedef GPB_ENUM(PBMModifyDrawingCard_FieldNumber) {
  PBMModifyDrawingCard_FieldNumber_BankNo = 1,
  PBMModifyDrawingCard_FieldNumber_BankName = 2,
  PBMModifyDrawingCard_FieldNumber_BankId = 3,
  PBMModifyDrawingCard_FieldNumber_BlongToCity = 4,
  PBMModifyDrawingCard_FieldNumber_Token = 5,
  PBMModifyDrawingCard_FieldNumber_AttributionDesc = 6,
};

// 修改提款银行卡
@interface PBMModifyDrawingCard : GPBMessage

// 银行卡号
@property(nonatomic, readwrite) BOOL hasBankNo;
@property(nonatomic, readwrite, copy) NSString *bankNo;

// 银行名称
@property(nonatomic, readwrite) BOOL hasBankName;
@property(nonatomic, readwrite, copy) NSString *bankName;

// 银行id
@property(nonatomic, readwrite) BOOL hasBankId;
@property(nonatomic, readwrite, copy) NSString *bankId;

// 归属地编码
@property(nonatomic, readwrite) BOOL hasBlongToCity;
@property(nonatomic, readwrite) int64_t blongToCity;

// token
@property(nonatomic, readwrite) BOOL hasToken;
@property(nonatomic, readwrite, copy) NSString *token;

//归属地描述
@property(nonatomic, readwrite) BOOL hasAttributionDesc;
@property(nonatomic, readwrite, copy) NSString *attributionDesc;

@end

CF_EXTERN_C_END

// @@protoc_insertion_point(global_scope)
