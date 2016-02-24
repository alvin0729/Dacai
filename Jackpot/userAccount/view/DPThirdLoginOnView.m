//
//  DPThirdLoginOnView.m
//  Jackpot
//
//  Created by mu on 15/8/17.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPThirdLoginOnView.h"
#import "DPThirdCallCenter.h"
@interface DPThirdLoginOnView()
@end
@implementation DPThirdLoginOnView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = colorWithRGB(192, 192, 192);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"其他登录方式";
        titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(12);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        for (NSInteger i = 0; i<2; i++) {
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = colorWithRGB(192, 192, 192);
            [self addSubview:lineView];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLabel.mas_centerY);
                if (i==0) {
                    make.left.mas_equalTo(0);
                    make.right.equalTo(titleLabel.mas_left).offset(-8);
                }else{
                    make.left.equalTo(titleLabel.mas_right).offset(8);
                    make.right.mas_equalTo(0);
                }
                make.height.mas_equalTo(0.5);
            }];
            
        }

    }
    return self;
}


- (void)setItems:(NSArray *)items{
    _items = items;
    
    CGFloat margin = (self.frame.size.width-50*self.items.count)/(self.items.count-1);
    NSInteger analytics = DPAnalyticsTypeRegistQQ ;
    if (self.fromLogInVC) {
        analytics = DPAnalyticsTypeLoginQQ ;
    }
    for(NSInteger i = 0; i<_items.count; i++) {
        NSString *imageName = _items[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        btn.layer.cornerRadius = 50*0.5;
        btn.backgroundColor = [UIColor clearColor];
        btn.imageView.contentMode = UIViewContentModeCenter;
        [btn setImage:dp_AccountImage(imageName) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(loginBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        btn.dp_eventId = (DPAnalyticsType)(analytics+i) ;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo((50+margin)*i);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
}
//第三方登录事件
- (void)loginBtnTapped:(UIButton *)btn{
    switch (btn.tag) {
        case 100://QQ
        {
            [[DPThirdCallCenter sharedInstance] dp_QQLogin ];
            
        }
            break;
        case 101://WEIXI
        {
            UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
            UINavigationController *nav = (UINavigationController *)tabbar.selectedViewController;
            
            [[DPThirdCallCenter sharedInstance] dp_wxLoginWithController:nav.topViewController];
        }
            break;
        case 102://DAZHIHUI
        {
            if (self.btnBlock) {
                self.btnBlock(btn);
            }
        }
            break;
        case 103://ZHIFUBAO
        {
            [[DPThirdCallCenter sharedInstance]dp_aliPayLogin];
        }
            break;
        case 104://WEIBO
        {
            [[DPThirdCallCenter sharedInstance] dp_sinaWeiboLogout];
            [[DPThirdCallCenter sharedInstance] dp_sinaWeiboLogin];
            
        }
            break;
        default:
            break;
    }
 
}


@end
