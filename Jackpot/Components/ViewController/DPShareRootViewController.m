//
//  DPShareRootViewController.m
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPShareRootViewController.h"
#import "DPShareThumbImageViewController.h"
#import "UMSocial.h"
#import "DPThirdCallCenter.h"

@implementation shareObject
- (void)setShareContent:(NSString *)shareContent{
    _shareContent =  shareContent;
    if (shareContent.length==0) {
        _shareContent = @"大彩";
    }
}
- (void)setShareTitle:(NSString *)shareTitle{
    _shareTitle = shareTitle;
    if (shareTitle.length==0) {
        _shareTitle = @"大彩";
    }
}
@end

@interface DPShareRootViewController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UMSocialUIDelegate>
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *shareIconArray;
@property (nonatomic, strong) NSArray *shareTitleArray;
@property (nonatomic, copy) NSString *shareType;
@end

@implementation DPShareRootViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (instancetype)init{
    if (self = [super init]) {
        self.object = [[shareObject alloc]init];
        UINavigationController *nav = [KTMHierarchySearcher topmostNonModalViewController].navigationController;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kScreenHeight), NO, 0.0);  //NO，YES 控制是否透明
        [nav.topViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.object.shareImage = image;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(182);
    }];
    
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.myCollectionView.mas_top);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    self.shareIconArray = @[@"朋友圈_03.png",@"weixin_03.png",@"weibo_03.png",@"kongjian_03.png",@"share_qq.png"];
    self.shareTitleArray = @[@"朋友圈",@"微信",@"微博",@"QQ空间",@"QQ好友"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_thirdShareFinish:) name:dp_ThirdShareFinishKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_thirdOuthFinish:) name:dp_ThirdLoginSuccess object:nil];
    
}
- (void)dp_thirdShareFinish:(NSNotification *)info
{
    [[DPToast makeText:[info.userInfo[dp_ThirdShareResultKey] boolValue]?@"分享成功":@"分享失败"] show];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark---------headerView
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor whiteColor];
        UIImageView *iconImage = [[UIImageView alloc]initWithImage:dp_AccountImage(@"share_header.png")];
        iconImage.userInteractionEnabled = YES;
        [_headerView addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView.mas_centerX);
            make.centerY.equalTo(_headerView.mas_centerY);
        }];
        
        UIImageView *arrowImage = [[UIImageView alloc]initWithImage:dp_AccountImage(@"share_arrow.png")];
        arrowImage.userInteractionEnabled = YES;
        [_headerView addSubview:arrowImage];
        [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView.mas_centerY);
            make.right.mas_equalTo(-16);
        }];
        
        UIView *seperatorLine = [[UIView alloc]init];
        seperatorLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [_headerView addSubview:seperatorLine];
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UITapGestureRecognizer *nextGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thumbImageShare)];
        [_headerView addGestureRecognizer:nextGesture];
    }
    return _headerView;
}
- (void)thumbImageShare{
   
    DPShareThumbImageViewController *controller = [[DPShareThumbImageViewController alloc]init];
    controller.object = self.object;
    UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark---------myCollectionView
- (UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.scrollEnabled = NO;
        _myCollectionView.backgroundColor = [UIColor dp_flatWhiteColor];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"shareItem"];
    }
    return _myCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth*0.25, 91);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"shareItem";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    UIImageView *iconImage = [[UIImageView alloc]initWithImage:dp_AccountImage(self.shareIconArray[indexPath.row])];
    [cell.contentView addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView.mas_centerX);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    
    UILabel *titleLabel =[UILabel dp_labelWithText:self.shareTitleArray[indexPath.row] backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font: [UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImage.mas_bottom).offset(4);
        make.centerX.equalTo(iconImage.mas_centerX);
    }];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *shareType = nil;
    switch (indexPath.row) {
        case 4:
        {
            shareType = UMShareToQQ;
            if (![QQApiInterface isQQInstalled]) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备没有装QQ客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                return;
            }
        }
            break;
        case 2:
        {
            shareType = UMShareToSina;
        
        }
            break;
        case 3:
        {
            shareType = UMShareToQzone;
            if (![QQApiInterface isQQInstalled]) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备没有装QQ客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                return;
            }
        }
            break;
        case 0:
        {
            shareType = UMShareToWechatTimeline;
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备没有装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                return;
            }
        }
            break;
        case 1:
        {
            shareType = UMShareToWechatSession;
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备没有装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                return;
            }
        }
            break;
        default:
            break;
    }
    
   
    self.shareType = shareType;
    if ([UMSocialAccountManager isOauthAndTokenNotExpired:shareType]) {
        [self shareWithType:shareType];
    }else{
        //进入授权页面
        [UMSocialSnsPlatformManager getSocialPlatformWithName:shareType].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            [self shareWithType:shareType];
        });
    }
}
- (void)dp_thirdOuthFinish:(UMSocialResponseEntity *)response {
     if (self == self.navigationController.topViewController) {
         [self shareWithType:self.shareType];
     }
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [[DPToast makeText:@"分享成功"] show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [[DPToast makeText:@"分享失败"] show];
    }
    
}
- (void)shareWithType:(NSString *)shareType{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.object.shareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.object.shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.object.shareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.object.shareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = dp_AccountImage(@"Icon.png");
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = dp_AccountImage(@"Icon.png");
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = self.object.shareContent;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = self.object.shareContent;
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeNone;
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeNone;
    //qq
    [UMSocialData defaultData].extConfig.qqData.url = self.object.shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = self.object.shareUrl;
    [UMSocialData defaultData].extConfig.qqData.title = self.object.shareTitle;
    [UMSocialData defaultData].extConfig.qzoneData.title = self.object.shareTitle;
    [UMSocialData defaultData].extConfig.qqData.shareText = self.object.shareContent;
    [UMSocialData defaultData].extConfig.qzoneData.shareText = self.object.shareContent;
    [UMSocialData defaultData].extConfig.qzoneData.shareImage = dp_AccountImage(@"Icon.png");
    [UMSocialData defaultData].extConfig.qqData.shareImage =dp_AccountImage(@"Icon.png");
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialWXMessageTypeNone;
    //sina
    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@%@",self.object.shareContent,self.object.shareUrl];
    [UMSocialData defaultData].extConfig.title = self.object.shareTitle;
    [UMSocialData defaultData].extConfig.sinaData.shareImage = dp_AccountImage(@"Icon.png");
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc]init];
    resource.url = self.object.shareUrl;
    
    if (shareType == UMShareToSina) {
        [[UMSocialControllerService defaultControllerService] setShareText: [NSString stringWithFormat:@"%@%@",self.object.shareContent,self.object.shareUrl] shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:self];
        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else{
        //获取微博用户名、uid、token等
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:shareType];
        NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
        //进入你的分享内容编辑页面
        @weakify(self);
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareType.length>0?shareType:@""] content:self.object.shareContent image:dp_AccountImage(@"Icon.png") location:nil urlResource:resource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            @strongify(self);
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                [[DPToast makeText:@"分享成功"] show];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [[DPToast makeText:@"分享失败"] show];
            }
        }];
    }
}
#pragma mark---------other
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (!CGRectContainsPoint(self.headerView.frame, point)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [super touchesBegan:touches withEvent:event];
    } 
}
@end
