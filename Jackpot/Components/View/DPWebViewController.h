//
//  DPWebViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DPWebViewLoadingType) {
    DPWebViewLoadingTypeProgress,
    DPWebViewLoadingTypeHUD,
};

@interface DPWebViewController : UIViewController

@property (nonatomic, assign) DPWebViewLoadingType type;
@property (nonatomic, assign) BOOL canHighlight;    // default is YES.
@property (nonatomic, assign) BOOL showToolBar;     // default is NO
@property (nonatomic, assign) BOOL shouldFitWidth;  // default is NO.
@property (nonatomic, assign) BOOL bounces;         // default is NO.

@property (nonatomic, copy) NSURLRequest *requset;
@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, copy) void (^finishLoadBlock)();
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error ;

+(DPWebViewController*)setNetWebController;

@end
