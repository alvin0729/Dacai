//
//  DPLotteryInfoWebViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-10-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJczqBuyViewController.h"
#import "DPJclqBuyViewController.h"
#import "DPLotteryInfoWebViewController.h"
#import "DPShareView.h"
 #import "DPLTDltViewController.h"
#import "UMSocial.h"
#import "DPDltBetData.h"
#import "DZNEmptyDataView.h"
#import "DPThirdCallCenter.h"
#import "DPShareRootViewController.h"
@interface DPLotteryInfoWebViewController () <UIWebViewDelegate, DPShareViewDelegate, UMSocialUIDelegate> {
    UIView *_bottomView;
    GameTypeId _gameType;
    NSMutableArray *_ballsArray;

    // TODO
    int _normalRed[35];
    int _normalBlue[12];
}

@property(nonatomic,strong)DZNEmptyDataView *noDataView ;
@end
@implementation DPLotteryInfoWebViewController

- (instancetype)initWithGameType:(GameTypeId)gameType {
    self = [super init];
    if (self) {
        _gameType = gameType;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (UIButton *)createButtonWithBackImage:(UIImage *)image {
    UIButton *button = [[UIButton alloc] init];

    [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.contentMode = UIViewContentModeScaleAspectFit;
    [button setUserInteractionEnabled:NO];
    [button.titleLabel setFont:[UIFont dp_systemFontOfSize:13]];

    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ballsArray = [[NSMutableArray alloc] initWithCapacity:7];

    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor dp_flatWhiteColor];
    bottomView.hidden = YES;
    _bottomView = bottomView;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        //        make.height.equalTo(@44);
        make.top.equalTo(self.webView.mas_bottom);
    }];

    UIButton *goTouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goTouBtn setTitle:@"去投注" forState:UIControlStateNormal];
    [goTouBtn setBackgroundColor:[UIColor dp_flatRedColor]];
    [goTouBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [goTouBtn addTarget:self action:@selector(touzhuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:goTouBtn];

    switch (_gameType) {
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcGJ:
        case GameTypeJcGYJ:
        case GameTypeJcHt:
        case GameTypeJcSpf:
        case GameTypeJcNone:{
        
            [goTouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bottomView).offset(8);
                make.right.equalTo(bottomView).offset(-8);
                make.centerY.equalTo(bottomView);
                make.height.equalTo(@44);
            }];
            goTouBtn.dp_eventId = DPAnalyticsTypeLotteryDetailJczq ;
        }break ;
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
        case GameTypeLcNone: {
            [goTouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bottomView).offset(8);
                make.right.equalTo(bottomView).offset(-8);
                make.centerY.equalTo(bottomView);
                make.height.equalTo(@44);
            }];
  
            goTouBtn.dp_eventId = DPAnalyticsTypeLotteryDetailJclq ;

        }

        break;
        case GameTypeDlt: {
            UIView *lastBaseView = bottomView;
            for (int i = 0; i < 8; i++) {
                UIButton *btn = [self createButtonWithBackImage:(i < 5 ? dp_DigitLotteryImage(@"ballSelectedRed001_07.png") : i < 7 ? dp_DigitLotteryImage(@"ballSelectedBlue001_14.png") : dp_ResultImage(@"dlt_new.png"))];
                [bottomView addSubview:btn];
                if (i < 7) {
                    [_ballsArray addObject:btn];
                } else {
                    btn.userInteractionEnabled = YES;
                    [btn addTarget:self action:@selector(pvt_getRandom:) forControlEvents:UIControlEventTouchUpInside];
                }

                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bottomView);
                    make.width.equalTo(@22);
                    make.height.equalTo(@22);
                    if (i == 0) {
                        make.left.equalTo(bottomView.mas_left).offset(10);
                    } else
                        make.left.equalTo(lastBaseView.mas_right).offset(5);

                }];
                lastBaseView = btn;
            }

            goTouBtn.layer.cornerRadius = 5;
            goTouBtn.clipsToBounds = YES;
            goTouBtn.dp_eventId = DPAnalyticsTypeLotteryDetailDlt ;

            [goTouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBaseView.mas_right).offset(10);
                make.right.equalTo(bottomView).offset(-10);
                make.centerY.equalTo(bottomView);
                make.height.equalTo(@28);
            }];

            [self pvt_getRandom:nil];

        } break;

        default:
            break;
    }

    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [UIColor dp_colorFromHexString:@"#dad5cc"];

    [bottomView addSubview:sepLine];

    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);
        make.top.equalTo(bottomView);
        make.height.equalTo(@0.5);
    }];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png") target:self action:@selector(navRightItemClick)];
    [self.view addSubview:self.noDataView];
    self.noDataView.hidden = YES ;
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view) ;
        
     }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_ThirdShareFinishKey object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[DPToast sharedToast] dismiss];
}
- (void)navRightItemClick{
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *content = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    if (content.length > 200) {
        content = [content substringToIndex:200];
    }
    DPLog(@"title =%@, body =%@", title, content);
    //    NSString *title = @"资讯标题";
    //    NSString *content = @"资讯内容------测试";
    NSString *urlstr = self.requset.URL.absoluteString;
    DPLog(@"lotteryinfo ----------- url =%@", urlstr);
    if (urlstr.length == 0 || urlstr == nil) {
        urlstr = @"http://m.dacai.com/";
    }
    
    DPShareRootViewController *shareController = [[DPShareRootViewController alloc]init];
    shareController.object.shareTitle = title;
    shareController.object.shareContent = content;
    shareController.object.shareUrl = urlstr;
    [self dp_showViewController:shareController animatorType:DPTransitionAnimatorTypeAlert completion:nil];
    
}

- (void)random {
    memset(_normalRed, 0, sizeof(_normalRed));
    memset(_normalBlue, 0, sizeof(_normalBlue));

    NSMutableSet *redSet = [[NSMutableSet alloc] initWithCapacity:4];

    do {
        int x = arc4random() % 35 + 1;
        [redSet addObject:[NSNumber numberWithInt:x]];
    } while (redSet.count < 5);

    NSArray *arr = [redSet allObjects];
    arr = [arr sortedArrayUsingSelector:@selector(compare:)];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [_ballsArray objectAtIndex:i];

        int number = [arr[i] intValue];
        [btn setTitle:[NSString stringWithFormat:@"%02d", number] forState:UIControlStateNormal];
        _normalRed[number - 1] = 1;
    }

    [redSet removeAllObjects];

    do {
        int x = arc4random() % 12 + 1;
        [redSet addObject:[NSNumber numberWithInt:x]];
    } while (redSet.count < 2);

    arr = [redSet allObjects];
    arr = [arr sortedArrayUsingSelector:@selector(compare:)];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [_ballsArray objectAtIndex:i + 5];
        int number = [arr[i] intValue];

        [btn setTitle:[NSString stringWithFormat:@"%02d", [arr[i] intValue]] forState:UIControlStateNormal];
        _normalBlue[number - 1] = 1;
    }
}

//换一注
- (void)pvt_getRandom:(UIButton *)sender {
    DPLog(@"换一注");
    //    35、12

 
    if (!sender) {
        [self random];

        return;
    }

    for (int i = 0; i < _ballsArray.count; i++) {
        UIButton *btn = [_ballsArray objectAtIndex:i];

        NSString *key_str = [NSString stringWithFormat:@"Roation%d", i];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"] ;
         animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:(M_PI * 6 + 2 * M_PI * i)];
        animation.duration = 1.5 + 0.15 * i;
        animation.repeatCount = 1;

 
        if (btn) {
            
            [btn.layer addAnimation:animation forKey:key_str];
         }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self random];

    });

     CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"] ;
     animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 8];
    animation.duration = 1.5 + 0.15 * 6;
    animation.repeatCount = 1;

        if (sender) {
        [sender.layer addAnimation:animation forKey:@"Rotation"];
    }
}
#pragma mark - share view delegate
- (void)shareWithThirdType:(kThirdShareType)type {
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *content = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    if (content.length > 200) {
        content = [content substringToIndex:200];
    }
    DPLog(@"title =%@, body =%@", title, content);
    //    NSString *title = @"资讯标题";
    //    NSString *content = @"资讯内容------测试";
    NSString *urlstr = self.requset.URL.absoluteString;
    DPLog(@"lotteryinfo ----------- url =%@", urlstr);
    if (urlstr.length == 0 || urlstr == nil) {
        urlstr = @"http://m.dacai.com/";
    }

    DPShareRootViewController *shareController = [[DPShareRootViewController alloc]init];
    shareController.object.shareTitle = self.shareItem.shareTitle;
    shareController.object.shareContent = self.shareItem.shareContent;
    shareController.object.shareUrl = self.shareItem.shareURL;
    [self dp_showViewController:shareController animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}

- (void)touzhuBtnClick {
    switch (_gameType) {
        case GameTypeDlt: {
            // TODO:
//            CSuperLotto *_CSLInstance  = CFrameWork::GetInstance()->GetSuperLotto() ;
//            
//            _CSLInstance->AddTarget(_normalBlue, _normalRed);
            
            DPDltBetData *dltData = [[DPDltBetData alloc]init];
            for (int i= 0; i<35; i++) {
                [ dltData.red addObject:[NSNumber numberWithInt:_normalRed[i]]];
            }
            for (int i=0; i<12; i++) {
                [ dltData.blue addObject:[NSNumber numberWithInt:_normalBlue[i]]];
            }
            dltData.mark = NO ;
            dltData.note =[ NSNumber numberWithInt:1] ;

            DPLTDltViewController *vc = [[DPLTDltViewController alloc] init];
            
            [vc.viewModel.infoArray addObject:dltData];
            
             [self.navigationController pushViewController:vc animated:YES];
        } break;

        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcGJ:
        case GameTypeJcGYJ:
        case GameTypeJcHt:
        case GameTypeJcSpf:
        case GameTypeJcNone: {
            [self.navigationController pushViewController:[[DPJczqBuyViewController alloc] init] animated:YES];
        } break;
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
        case GameTypeLcNone: {
            [self.navigationController pushViewController:[[DPJclqBuyViewController alloc] init] animated:YES];
        } break;

        default:
            break;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.noDataView.hidden = YES ;

    if (DPWebViewLoadingTypeHUD == self.type) {
        [self dismissHUD];
    }

    if (self.shouldFitWidth) {
        [webView dp_fitWidth];
    }
    if (!self.canHighlight) {
        [webView dp_removeTapCSS];
    }

    switch (_gameType) {
        //        case GameTypeSd:
        //        case GameTypeSsq:
        //        case GameTypeQlc:
        //        case GameTypePs:
        //        case GameTypePw:
        //        case GameTypeQxc:
        //        case GameTypeJxsyxw:
        //        case GameTypeNmgks:
        //        case GameTypeSdpks:

        case GameTypeDlt:

        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcGJ:
        case GameTypeJcGYJ:
        case GameTypeJcHt:
        case GameTypeJcDgAll:
        case GameTypeJcDg:
        case GameTypeJcSpf:
        case GameTypeJcNone:

        //        case GameTypeBdRqspf:
        //        case GameTypeBdSxds:
        //        case GameTypeBdZjq:
        //        case GameTypeBdBf:
        //        case GameTypeBdBqc:
        //        case GameTypeBdSf:
        //        case GameTypeBdNone:

        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
        case GameTypeLcNone:

            //        case GameTypeZc14:
            //        case GameTypeZc9:
            //        case GameTypeZcNone:
            {
                _bottomView.hidden = NO;
                [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 54, 0));
                }];
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            }
            break;
        default:
            _bottomView.hidden = YES;
            break;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [super webView:webView didFailLoadWithError:error];
 
    self.noDataView.hidden = NO ;
    self.noDataView.requestSuccess = NO ;
  
 }

-(DZNEmptyDataView *)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DZNEmptyDataView alloc]init];
         _noDataView.textForNoData = @"暂无数据" ;
        _noDataView.imageForNoData = dp_LoadingImage(@"noMatch.png") ;
         _noDataView.backgroundColor = [UIColor dp_flatBackgroundColor] ;
        _noDataView.showButtonForNoData = NO ;
        
        @weakify(self) ;
        _noDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
            @strongify(self) ;
            switch (type) {
                case DZNEmptyDataViewTypeFailure:
                    [self.webView loadRequest:self.requset];
                    break;
                case  DZNEmptyDataViewTypeNoNetwork:{
                     [self.navigationController pushViewController:[DPWebViewController setNetWebController] animated:YES];

                }
                    break ;
                 default:
                    break;
            }
        };
    }
    
    return  _noDataView ;
}
@end
