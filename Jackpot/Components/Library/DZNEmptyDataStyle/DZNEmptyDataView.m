//
//  DZNEmptyDataView.m
//  Jackpot
//
//  Created by WUFAN on 15/10/28.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <objc/runtime.h>
#import "DZNEmptyDataView.h"
#import "DZNEmptyDataStyle.h"

@interface DZNEmptyDataView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSArray *widthConstraints;
@property (nonatomic, assign) BOOL hasSetRequestResult;
@end

@implementation DZNEmptyDataView

#pragma mark - Life cycle

+ (DZNEmptyDataView *)emptyDataView {
    return [[DZNEmptyDataView alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _showButtonForNoData = YES;
        _hasSetRequestResult = NO;
        _textForNoData = @"空列表永远不会中奖, \n跨出第一步吧";
        _textForFailure = @"数据加载失败";
        _textForNoNetwork = @"当前网络不可用";
        _buttonTitleForNoData = @"去投注";
        _buttonTitleForFailure = @"重试";
        _buttonTitleForNoNetwork = @"去设置";
        _imageForNoData = dp_LoadingImage(@"emptyList.png");
        _imageForFailure = dp_LoadingImage(@"loadFailure.png");
        _imageForNoNetwork = dp_LoadingImage(@"noNetwork.png");
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    DZNEmptyDataView *view = [[DZNEmptyDataView allocWithZone:zone] init];
    view.showButtonForNoData = self.showButtonForNoData;
    view.imageForNoData = self.imageForNoData;
    view.imageForFailure = self.imageForFailure;
    view.imageForNoNetwork = self.imageForNoNetwork;
    view.textForNoData = self.textForNoData;
    view.textForFailure = self.textForFailure;
    view.textForNoNetwork = self.textForNoNetwork;
    view.attrTextForNoData = self.attrTextForNoData;
    view.attrTextForFailure = self.attrTextForFailure;
    view.attrTextForNoNetwork = self.attrTextForNoNetwork;
    view.buttonTitleForNoData = self.buttonTitleForNoData;
    view.buttonTitleForFailure = self.buttonTitleForFailure;
    view.buttonTitleForNoNetwork = self.buttonTitleForNoNetwork;
    view.buttonTappedEvent = self.buttonTappedEvent;
    return view;
}

#pragma mark - Layout

- (void)prepareReuse {
    if (!self.imageView.superview) {
        [self addSubview:self.imageView];
    }
    if (!self.textLabel.superview) {
        [self addSubview:self.textLabel];
    }
    if ((self.showButtonForNoData && !self.button.superview) || self.viewType != DZNEmptyDataViewTypeNoData) {
        [self addSubview:self.button];
    } else if (!self.showButtonForNoData && self.button.superview && self.viewType == DZNEmptyDataViewTypeNoData) {
        [self.button removeFromSuperview];
    }
    
    switch (self.viewType) {
        case DZNEmptyDataViewTypeNoData: {
            self.imageView.image = self.imageForNoData;
            if (self.attrTextForNoData) {
                self.textLabel.attributedText = self.attrTextForNoData;
            } else {
                self.textLabel.text = self.textForNoData;
            }
            [self.button setTitle:self.buttonTitleForNoData forState:UIControlStateNormal];
            [self.button setTitleColor:self.buttonTextColorForNoData?self.buttonTextColorForNoData:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
            [self.button setBackgroundImage:self.buttonBgImageForNoData?self.buttonBgImageForNoData:dp_LoadingImage(@"goPlay.png") forState:UIControlStateNormal];
            break;
        }
        case DZNEmptyDataViewTypeFailure: {
            self.imageView.image = self.imageForFailure;
            if (self.attrTextForFailure) {
                self.textLabel.attributedText = self.attrTextForFailure;
            } else {
                self.textLabel.text = self.textForFailure;
            }
            [self.button setTitle:self.buttonTitleForFailure forState:UIControlStateNormal];
            [self.button setTitleColor:[UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1] forState:UIControlStateNormal];
            [self.button setBackgroundImage:dp_LoadingImage(@"retry.png") forState:UIControlStateNormal];
            break;
        }
        case DZNEmptyDataViewTypeNoNetwork: {
            self.imageView.image = self.imageForNoNetwork;
            if (self.attrTextForNoNetwork) {
                self.textLabel.attributedText = self.attrTextForNoNetwork;
            } else {
                self.textLabel.text = self.textForNoNetwork;
            }
            [self.button setTitle:self.buttonTitleForNoNetwork forState:UIControlStateNormal];
            [self.button setTitleColor:[UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1] forState:UIControlStateNormal];
            [self.button setBackgroundImage:dp_LoadingImage(@"retry.png") forState:UIControlStateNormal];
            break;
        }
    }
}

- (void)setupConstraints {
    if (!self.widthConstraints) {
        self.widthConstraints = [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreenWidth));
        }];
    }
    // 布局
    switch (self.viewType) {
        case DZNEmptyDataViewTypeNoData: {
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.and.centerX.equalTo(self);
            }];
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imageView.mas_bottom).offset(self.textToImageMarginForNoData?self.textToImageMarginForNoData:26);
                make.centerX.equalTo(self);
                
                if (!self.showButtonForNoData) {
                    make.bottom.equalTo(self);
                }
            }];
            
            if (self.showButtonForNoData) {
                [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.textLabel.mas_bottom).offset(self.buttonToTextMarginForNoData?self.buttonToTextMarginForNoData:72.5);
                    make.centerX.and.bottom.equalTo(self);
                }];
            }
            break;
        }
        case DZNEmptyDataViewTypeFailure:
        case DZNEmptyDataViewTypeNoNetwork: {
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.and.centerX.equalTo(self);
            }];
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imageView.mas_bottom).offset(26);
                make.centerX.equalTo(self);
            }];
            [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.textLabel.mas_bottom).offset(26);
                make.centerX.and.bottom.equalTo(self);
            }];
            break;
        }
    }
}

- (void)reloadData {
    [self prepareReuse];
    [self setupConstraints];
    [self setNeedsLayout];
}

- (void)tappedButton {
    if (self.buttonTappedEvent) {
        self.buttonTappedEvent(self.viewType);
    }
}

#pragma mark - Property (getter, setter)

- (void)setRequestSuccess:(BOOL)requestSuccess {
    DZNEmptyDataViewType viewType = DZNEmptyDataViewTypeNoData;
    if (requestSuccess) {
        viewType = DZNEmptyDataViewTypeNoData;
    } else {
        AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            viewType = DZNEmptyDataViewTypeFailure;
        } else {
            viewType = DZNEmptyDataViewTypeNoNetwork;
        }
    }
    
    if (!_hasSetRequestResult || _viewType != viewType) {
        _viewType = viewType;
        
        [self reloadData];
    }
    
    _requestSuccess = requestSuccess;
    _hasSetRequestResult = YES;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.titleLabel.font = [UIFont dp_systemFontOfSize:17];
        
        [_button addTarget:self action:@selector(tappedButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
        _textLabel.font = [UIFont dp_systemFontOfSize:16];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end

static const void *kEmptyDataViewKey = &kEmptyDataViewKey;
static const void *kEmptyDataStyleKey = &kEmptyDataStyleKey;

@implementation UIScrollView (EmptyDataNetwork)

- (void)setEmptyDataView:(DZNEmptyDataView *)emptyDataView {
    DZNEmptyDataStyle *style = [[DZNEmptyDataStyle alloc] init];
    style.customView = emptyDataView;
    style.allowTouch = YES;
    style.shouldDisplayBlock = ^BOOL (UIScrollView *scrollView) {
        return emptyDataView.hasSetRequestResult;
    };
    
    objc_setAssociatedObject(self, kEmptyDataViewKey, emptyDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kEmptyDataStyleKey, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.emptyDataSetSource = style;
    self.emptyDataSetDelegate = style;
}

- (DZNEmptyDataView *)emptyDataView {
    return objc_getAssociatedObject(self, kEmptyDataViewKey);
}

- (BOOL)isEmptyDataViewVisible {
    return self.isEmptyDataSetVisible;
}

@end