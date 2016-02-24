//
//  DPHLHeartLoveMark.m
//  Jackpot
//
//  Created by mu on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLHeartLoveMark.h"

@implementation DPHLHeartLoveMark

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.markImage = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLPolygon.png")];
        [self addSubview:self.markImage];
        [self.markImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        self.markTitleLable = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:12]];
        [self addSubview:self.markTitleLable];
        [self.markTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
    }
    return self;
}

@end
