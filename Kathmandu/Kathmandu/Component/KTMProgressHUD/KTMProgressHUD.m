//
//  KTMProgressHUD.m
//  Kathmandu
//
//  Created by WUFAN on 15/11/30.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMProgressHUD.h"

@interface KTMProgressHUD ()
+ (KTMProgressHUD *)sharedHUD;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation KTMProgressHUD

#pragma mark - Life cycle
+ (KTMProgressHUD *)sharedHUD {
    static dispatch_once_t onceToken;
    static KTMProgressHUD *progressHUD;
    dispatch_once(&onceToken, ^{
        progressHUD = [[KTMProgressHUD alloc] initInternal];
    });
    // load configure
    
    
    return progressHUD;
}

- (instancetype)initInternal {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Internal Interface
- (void)showInView:(UIView *)view withText:(NSString *)text {
    self.frame = view.bounds;
    self.layer.cornerRadius = 10;
}


#pragma mark - Public Interface
+ (void)showInView:(UIView *)view withText:(NSString *)text {

}

@end
