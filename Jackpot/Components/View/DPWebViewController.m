//
//  DPWebViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <NJKWebViewProgress/NJKWebViewProgressView.h>
#import "DPWebViewController.h"
#import "DPShareView.h"
#import "DPNodataView.h"
#import "UMSocial.h"
#import "DPThirdCallCenter.h"
#import "DPShareRootViewController.h"
typedef void (^WebShareBlock)(void);

@interface DPWebViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate, DPShareViewDelegate,UMSocialUIDelegate> {
@private
    UIWebView *_webView;
    UIToolbar *_toolBar;
    UIBarButtonItem *_backItem;
    UIBarButtonItem *_forwardItem;
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic, strong, readonly) UIToolbar *toolBar;
@property (nonatomic, strong, readonly) UIBarButtonItem *backItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardItem;

@property (nonatomic, strong, readonly) NJKWebViewProgressView *progressView;
@property (nonatomic, strong, readonly) NJKWebViewProgress *progressProxy;

@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, strong) NSString *shareURL;
@property (nonatomic, assign) BOOL localHTML;

@end

@implementation DPWebViewController

+ (DPWebViewController *)setNetWebController {
    DPWebViewController *webView = [[DPWebViewController alloc] init];
    webView.title = @"网络设置";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"noNet" ofType:@"html"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [[NSBundle mainBundle] bundleURL];
    [webView.webView loadHTMLString:str baseURL:url];
    return webView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.canHighlight = YES;
        self.shouldFitWidth = NO;
        self.bounces = NO;
        self.showToolBar = NO;
        self.type = DPWebViewLoadingTypeHUD;
    }
    return self;
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png")
                                                                         target:self
                                                                         action:@selector(pvt_onClose)]];
    [self.view addSubview:self.webView];
    
    if (self.type == DPWebViewLoadingTypeProgress) {
        self.webView.delegate = self.progressProxy;
    }
    
    if (self.showToolBar) {
        [self.view addSubview:self.toolBar];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 40, 0));
        }];
        [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@40);
        }];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *fixedItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedItem1.width = 5;
        UIBarButtonItem *fixedItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedItem2.width = 20;
        UIBarButtonItem *fixedItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedItem3.width = 5;
        UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithImage:dp_CommonImage(@"reload.png") style:UIBarButtonItemStylePlain target:self action:@selector(pvt_onReload)];
        [self.toolBar setItems:@[fixedItem1, self.backItem, fixedItem2, self.forwardItem, flexibleItem, reloadItem, fixedItem3]];
    } else {
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.webView loadRequest:self.requset];
    
    self.view.backgroundColor = [UIColor dp_flatWhiteColor] ;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_progressView.superview) {
        [_progressView removeFromSuperview];
    }
}


- (void)dealloc {
    [self.webView stopLoading];
    [self.webView setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_ThirdShareFinishKey object:nil];
}

#pragma mark - setter
- (void)setRequset:(NSURLRequest *)requset {
    _requset = [[AFHTTPSessionManager dp_sharedManager].requestSerializer requestBySerializingRequest:requset withParameters:nil error:nil];
}

- (void)setBounces:(BOOL)bounces {
    _bounces = bounces;
    self.webView.scrollView.bounces = self.bounces;
}

#pragma mark - getter
- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor dp_flatBackgroundColor];
        _webView.opaque = NO;
    }
    return _webView;
}

- (UIToolbar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc] init];
        _toolBar.translucent = YES;
        _toolBar.opaque = NO;
    }
    return _toolBar;
}

- (UIBarButtonItem *)backItem {
    if (_backItem == nil) {
        _backItem = [[UIBarButtonItem alloc] initWithImage:dp_CommonImage(@"back.png") style:UIBarButtonItemStylePlain target:self action:@selector(pvt_onBack)];
        _backItem.enabled = NO;
    }
    return _backItem;
}

- (UIBarButtonItem *)forwardItem {
    if (_forwardItem == nil) {
        _forwardItem = [[UIBarButtonItem alloc] initWithImage:dp_CommonImage(@"forward.png") style:UIBarButtonItemStylePlain target:self action:@selector(pvt_onForward)];
        _forwardItem.enabled = NO;
    }
    return _forwardItem;
}

- (NJKWebViewProgress *)progressProxy {
    if (_progressProxy == nil) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
    }
    return _progressProxy;
}

- (NJKWebViewProgressView *)progressView {
    if (_progressView == nil) {
        CGFloat progressBarHeight = 2.f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progressBarView.backgroundColor = UIColorFromRGB(0xf6de2b);
    }
    return _progressView;
}

#pragma mark - event
- (void)pvt_onClose {
    if (self.navigationController.viewControllers.firstObject != self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)pvt_onBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.backItem setEnabled:NO];
    }
}

- (void)pvt_onForward {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    } else {
        [self.forwardItem setEnabled:NO];
    }
}

- (void)pvt_onReload {
    [self.webView reload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *scheme = [request.URL.scheme lowercaseString];
    if ([scheme isEqualToString:@"file"]) {
        self.localHTML = YES;
    }
    if ([scheme isEqualToString:dp_URLScheme]) {
        NSString *resourceSpecifier = [request.URL resourceSpecifier];
        if (resourceSpecifier.length > 9 && [[[resourceSpecifier substringToIndex:9] lowercaseString] hasPrefix:@"//mutual?"]) {
            resourceSpecifier = [resourceSpecifier substringFromIndex:9];
            if (resourceSpecifier.length) {
//                CFrameWork::GetInstance()->SetSessionContent(resourceSpecifier.UTF8String);
            }
            return NO;
        }
    } else if ([scheme isEqualToString:@"js-frame"]) {
        NSArray *components = [[request.URL resourceSpecifier] componentsSeparatedByString:@":"];
        if (components.count == 3) {
            NSString *function = [components[0] lowercaseString];
            NSInteger callbackId = [components[1] integerValue];
            NSString *argsAsString = [KTMCrypto URLDecoding:components[2]];
            
            NSData *data = [argsAsString dataUsingEncoding:NSUTF8StringEncoding];//[DPCryptUtilities base64Decode:self.actionLinks[index]];
            NSError *error;
            NSArray *args = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (error || [args isEqual:[NSNull null]]) {
                args = nil;
            }
            
            [self handleCall:function callbackId:callbackId args:args];
        }
        
        return NO;
    }
    return YES;
}

- (void)handleCall:(NSString *)functionName callbackId:(NSInteger)callbackId args:(NSArray *)args {
    if ([functionName isEqualToString:@"getuserinfo"]) {
//        NSArray *userInfo = @[ [NSString stringWithUTF8String:CFrameWork::GetInstance()->GetUserToken().c_str()],
//                               [NSNumber numberWithInteger:CFrameWork::GetInstance()->GetChannelId()],
//                               [KTMUtilities applicationVersion],
//                               [NSString stringWithUTF8String:CFrameWork::GetInstance()->GetDeviceToken().c_str()],
//                               [NSString stringWithUTF8String:CFrameWork::GetInstance()->GetActiveGUID().c_str()], ];
//        
//        NSError *error = nil;
//        NSData *data = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];
//        if (error == nil && data) {
//            [self responseCallbackId:callbackId args:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
//        } else {
//            [self responseCallbackId:callbackId args:nil];
//        }
    } else if ([functionName isEqualToString:@"login"]) {
        [self loginWithCallbackId:callbackId];
    } else if ([functionName isEqualToString:@"relogin"]) {
//        CFrameWork::GetInstance()->GetAccount()->Logout();
//        [self loginWithCallbackId:callbackId];
    } else if ([functionName isEqualToString:@"addshare"]) {
        if (args.count >= 3) {
            self.shareTitle = args[0];
            self.shareDesc = args[1];
            self.shareURL = args[2];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png") target:self action:@selector(pvt_onShare)];
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    } else if ([functionName isEqualToString:@"jump"]) {
        if (args.count >= 1) {
            NSString *url = args[0];
            DPWebViewController *vc = [[DPWebViewController alloc] init];
            vc.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            vc.showToolBar = YES;
            vc.type = DPWebViewLoadingTypeProgress;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([functionName isEqualToString:@"secureid"]) {
//        NSArray *info = @[ [NSString stringWithUTF8String:CFrameWork::GetInstance()->GetSecureHardUUID().c_str()], ];
//        NSError *error = nil;
//        NSData *data = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
//        if (error == nil && data) {
//            [self responseCallbackId:callbackId args:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
//        } else {
//            [self responseCallbackId:callbackId args:nil];
//        }
    }
}

- (void)loginWithCallbackId:(NSInteger)callbackId {
//    __weak __typeof(self) weakSelf = self;
//    
//    DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
//    viewController.entryType = DPLoginEntryTypeWeb;
//    viewController.finishBlock = ^ {
//        NSArray *userInfo = @[ [NSString stringWithUTF8String:CFrameWork::GetInstance()->GetUserToken().c_str()],
//                               [NSNumber numberWithInteger:CFrameWork::GetInstance()->GetChannelId()],
//                               [DPSystemUtilities appVersion],
//                               [NSString stringWithUTF8String:CFrameWork::GetInstance()->GetDeviceToken().c_str()],
//                               [NSString stringWithUTF8String:CFrameWork::GetInstance()->GetActiveGUID().c_str()], ];
//        NSError *error = nil;
//        NSData *data = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];
//        [weakSelf responseCallbackId:callbackId args:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
//    };
//    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)responseCallbackId:(NSInteger)callbackId args:(NSString *)args {
    NSString *js = [NSString stringWithFormat:@"NativeBridge.resultForCallback(%@,%@);", @(callbackId), nil == args ? @"null" : args];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark DPShareView delegate
- (void)shareWithThirdType:(kThirdShareType)type {
//    [[DPThirdCallCenter sharedInstance] dp_shareWithType:type title:self.shareTitle content:self.shareDesc image:nil thumbImg:nil urlString:self.shareURL];

    DPShareRootViewController *shareController = [[DPShareRootViewController alloc]init];
    shareController.object.shareTitle = self.shareTitle;
    shareController.object.shareContent = self.shareDesc;
    shareController.object.shareUrl = self.shareURL;
    [self dp_showViewController:shareController animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}

- (void)pvt_onShare {

}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (DPWebViewLoadingTypeHUD == self.type) {
        [self showHUD];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (DPWebViewLoadingTypeHUD == self.type) {
        [self dismissHUD];
    }
    if (self.shouldFitWidth) {
        [self.webView dp_fitWidth];
    }
    if (!self.canHighlight) {
        [self.webView dp_removeTapCSS];
    }
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title.length) {
        self.title = title;
    }
    
    [self reloadToolBar];
    
    if (self.finishLoadBlock) {
        self.finishLoadBlock();
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (!self.localHTML) {
        if ([AFNetworkReachabilityManager sharedManager].reachable == NO) {
            [[DPToast makeText:kNoWorkNet_] show];
        } else {
            NSString *msg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
            if (msg && ![msg isEqual:[NSNull null]]) {
                [[DPToast makeText:[NSString stringWithFormat:@"%@", msg]] show];
            }
        }
    }

    if (DPWebViewLoadingTypeHUD == self.type) {
        [self dismissHUD];
    }

    [self reloadToolBar];
}

- (void)reloadToolBar {
    if (self.showToolBar) {
        self.backItem.enabled = [self.webView canGoBack];
        self.forwardItem.enabled = [self.webView canGoForward];
    }
}

@end

@interface UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect)frame;

@end

@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect)frame {
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    
    [customAlert show];
}

@end
