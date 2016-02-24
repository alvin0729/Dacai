//
//  DPShareThumbImageViewController.m
//  Jackpot
//
//  Created by mu on 15/12/10.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPShareThumbImageViewController.h"
#import "DPThirdCallCenter.h"
@interface DPShareThumbImageViewController ()<UITextFieldDelegate,UMSocialDataDelegate,UMSocialUIDelegate>
@property (nonatomic, strong) UIImageView *shareImage;
@property (nonatomic, strong) UIImageView *princessImage;
@property (nonatomic, strong) UIImageView *textBgImage;
@property (nonatomic, strong) UIImageView *likeImage;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) UITextField *describText;
@property (nonatomic, strong) UILabel *describLabel;
@property (nonatomic, strong) MASConstraint *checkIconRight;
@end

@implementation DPShareThumbImageViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png") target:self action:@selector(didShareTapped)];
    [self initilizerUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(didBackTapped)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_thirdShareFinish:) name:dp_ThirdShareFinishKey object:nil];
}
- (void)dp_thirdShareFinish:(NSNotification *)info
{
    [[DPToast makeText:[info.userInfo[dp_ThirdShareResultKey] boolValue]?@"分享成功":@"分享失败"] show];
    [self didBackTapped];
}
- (void)didBackTapped{
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)didShareTapped{
    UIGraphicsBeginImageContextWithOptions(self.princessImage.frame.size, NO, 0.0);  //NO，YES 控制是否透明
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //wx
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"";
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = image;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = @"";
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
    //wechat
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = @"";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"";
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = image;
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeImage;
    //qq
    [UMSocialData defaultData].extConfig.qqData.url = @"";
    [UMSocialData defaultData].extConfig.qqData.title = @"";
    [UMSocialData defaultData].extConfig.qqData.shareImage = image;
    [UMSocialData defaultData].extConfig.qqData.shareText = @"";
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    //qzoneData
    [UMSocialData defaultData].extConfig.qzoneData.url = self.object.shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.title = self.object.shareTitle;
    [UMSocialData defaultData].extConfig.qzoneData.shareImage = image;
    [UMSocialData defaultData].extConfig.qzoneData.shareText = self.object.shareContent;
    //sina
    [UMSocialData defaultData].extConfig.sinaData.shareText =@"";
    [UMSocialData defaultData].extConfig.sinaData.shareImage = image;
    [UMSocialData defaultData].extConfig.title = @"";
    //share
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:dp_UM_appID
                                      shareText:self.object.shareContent
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatTimeline, UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToSina]
                                       delegate:self];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [[DPToast makeText:@"分享成功"] show];
        [self didBackTapped];
    }else{
        [[DPToast makeText:@"分享失败"] show];
    }
    
}
- (void)keyboardChanged:(NSNotification *)notice{
    NSDictionary *info = notice.userInfo;
    NSValue *keyBoardValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardRect = [keyBoardValue CGRectValue];

    CGFloat describTextY = keyBoardRect.origin.y==kScreenHeight?kScreenHeight:keyBoardRect.origin.y-94;
    [UIView animateWithDuration:0.25 animations:^{
        self.describText.frame = CGRectMake(0,describTextY, kScreenWidth, 30);
    }];
    
}
- (void)initilizerUI{
    self.view.backgroundColor = [UIColor dp_flatWhiteColor];
    [self.view addSubview:self.bottomView];
    
    self.shareImage = [[UIImageView alloc]initWithImage:self.object.shareImage];
    [self.view addSubview:self.shareImage];
    
    self.textBgImage = [[UIImageView alloc]initWithImage:dp_AccountImage(@"share_textBg.png")];
    [self.view addSubview:self.textBgImage];
    
    self.describLabel = [UILabel dp_labelWithText:@"中奖就土豪哦" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight lineBreakMode:NSLineBreakByWordWrapping textColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:14]];
    UITapGestureRecognizer *describLabelGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(describLabelTaped)];
    [self.describLabel addGestureRecognizer:describLabelGesture];
    self.describLabel.userInteractionEnabled = YES;
    [self.view addSubview:self.describLabel];
    
    self.princessImage = [[UIImageView alloc]initWithImage:dp_AccountImage(@"princess.png")];
    [self.view addSubview:self.princessImage];
    
    UILabel *stationLabel = [UILabel dp_labelWithText:@"大彩网-网上彩票投注站" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter lineBreakMode:NSLineBreakByWordWrapping textColor:UIColorFromRGB(0xffe36b) font:[UIFont systemFontOfSize:17]];
    [self.princessImage addSubview:stationLabel];
    [stationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    
    self.likeImage = [[UIImageView alloc]initWithImage:dp_AccountImage(@"shareBar_04.png")];
    [self.view addSubview:self.likeImage];
    
    self.describText= [[UITextField alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 30)];
    self.describText.delegate = self;
    self.describText.text = @"有钱，任性";
    self.describText.borderStyle = UITextBorderStyleRoundedRect;
    self.describText.backgroundColor = [UIColor dp_flatBackgroundColor];
    [[self.describText rac_textSignal]subscribeNext:^(NSString *discrib) {
        self.describLabel.text = [NSString stringWithFormat:@"%@  ",discrib];
    }];
    [self.view addSubview:self.describText];
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(71);
    }];
    
    [self.princessImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.shareImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.princessImage.mas_centerX);
        make.top.equalTo(self.princessImage.mas_top).offset(80);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-80, kScreenHeight-170));
    }];
    
    [self.textBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.princessImage.mas_bottom).offset(-50);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    [self.describLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textBgImage.mas_centerY);
        make.right.equalTo(self.textBgImage.mas_right).offset(-12);
        make.width.mas_equalTo(142);
    }];
    
    [self.likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textBgImage.mas_bottom);
        make.left.equalTo(self.textBgImage.mas_left);
    }];
}


#pragma mark---------bottomView
- (UIImageView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc]initWithImage:dp_AccountImage(@"shareBar_red_bg.png")];
        _bottomView.userInteractionEnabled = YES;
        for (NSInteger i = 0; i < 4; i++) {
            NSString *btnName = [NSString stringWithFormat:@"shareBar_0%zd.png",i+1];
            UIButton *btn = [UIButton dp_buttonWithTitle:nil titleColor:nil image:dp_AccountImage(btnName) font:nil];
            btn.tag = i+1;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
                self.likeImage.image = btn.imageView.image;
                self.checkIconRight.mas_equalTo( CGRectGetMaxX(btn.frame)-kScreenWidth-6);
                switch (btn.tag) {
                    case 1:
                        self.describLabel.text = @"随手一注，就中奖啦";
                        self.describText.text =  @"随手一注，就中奖啦";
                        break;
                    case 2:
                        self.describLabel.text = @"笑着把钱赚";
                        self.describText.text = @"笑着把钱赚";
                        break;
                    case 3:
                        self.describLabel.text = @"一看即会、一玩即中";
                        self.describText.text = @"一看即会、一玩即中";
                        break;
                    case 4:
                        self.describLabel.text = @"有钱，任性";
                        self.describText.text = @"有钱，任性";
                        break;
                    default:
                        break;
                }
            }];
            [_bottomView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(kScreenWidth*0.25*i);
                make.width.mas_equalTo(kScreenWidth*0.25);
                make.bottom.mas_equalTo(0);
            }];
        }
        
        UIImageView *checkImage = [[UIImageView alloc]initWithImage:dp_AccountImage(@"checked.png")];
        [_bottomView addSubview:checkImage];
        [checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-6);
            self.checkIconRight = make.right.mas_equalTo(-6);
        }];
    }
    return _bottomView;
}
#pragma mark---------describText
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length>20) {
        [[DPToast makeText:@"字数达到上限"] show];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
- (void)describLabelTaped{
    [self.describText becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
@end
