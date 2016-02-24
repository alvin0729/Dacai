//
//  DPPrerogativeLVView.m
//  Jackpot
//
//  Created by mu on 15/8/11.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPPrerogativeLVView.h"
@interface DPPrerogativeLVView()
@property (nonatomic, assign) NSInteger currentStep;
/**
 *  进度比率
 */
@property (nonatomic, assign) CGFloat progressRate;
@end


@implementation DPPrerogativeLVView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dp_flatBackgroundColor];
        self.currentStep = 0;
    }
    return self;
}
- (void)setLVCount:(NSInteger)LVCount{
    _LVCount = LVCount;
    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(79,0,1, self.frame.size.height)];
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:verticalLine];
    
    
    for (NSInteger i = 0 ; i<_LVCount; i++) {
        CGFloat LVHeight  = [self.LVHeightArray[i] floatValue];
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.bounds = CGRectMake(0, 0, 20, 20);
        iconBtn.center = CGPointMake(80.25, 30+LVHeight*i);
        [iconBtn setImage:dp_GropSystemResizeImage(@"futureLevel.png") forState:UIControlStateNormal];
        iconBtn.tag = 100+i;
        iconBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:iconBtn];
        
        UILabel *prepogativeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(iconBtn.frame), CGRectGetMidX(iconBtn.frame)-8, 20)];
        prepogativeLab.textColor = UIColorFromRGB(0xbbb6b2);
        prepogativeLab.textAlignment = NSTextAlignmentRight;
        prepogativeLab.font = [UIFont systemFontOfSize:12];
        prepogativeLab.tag = 300+i;
        prepogativeLab.text = [NSString stringWithFormat:@"LV%ld",(long)i];
        prepogativeLab.backgroundColor = [UIColor clearColor];
        [self addSubview:prepogativeLab];
    }
    
    CGFloat progressHeight = 0;
    UIView *progressLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, progressHeight)];
    progressLine.backgroundColor = [UIColor dp_flatRedColor];
    progressLine.tag = 200;
    [verticalLine addSubview:progressLine];
    

    NSArray *jifenArray = @[@"975",@"1600",@"2850",@"10350",@"25350",@"55350",@"115350",@"235350",@"475350",@"955350",@"1915350"];
    self.progressRate = self.currentLV ==0 ?self.currentJifen/[jifenArray[self.currentLV] floatValue]:self.currentJifen/[jifenArray[self.currentLV-1] floatValue];
    [self lunXun];
}
- (void)lunXun{
    UIView *progressLine = [self viewWithTag:200];
    UIButton *btn = (UIButton *)[self viewWithTag:100+self.currentStep];
    UILabel *label = (UILabel *)[self viewWithTag:300+self.currentStep];
    [UIView animateWithDuration:2 animations:^{
        progressLine.frame = CGRectMake(0, 0,2,CGRectGetMinY(btn.frame));
        if (self.currentStep == self.currentLV) {
            progressLine.frame = CGRectMake(0, 0,2,CGRectGetMinY(btn.frame)+150*self.progressRate);
        }
    }completion:^(BOOL finished) {
        [btn setImage:dp_GropSystemResizeImage(@"currentLevel.png") forState:UIControlStateNormal];
        label.textColor = UIColorFromRGB(0x666666);
        self.currentStep ++;
        if (self.currentStep<=self.currentLV) {
            [self performSelector:@selector(lunXun) withObject:nil afterDelay:0.1];
        }
    }];
}




@end
