//
//  KTMCountLabel.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMCountLabel : UILabel

/**
 *  动画递增 Label 数字
 *
 *  @param duration       [in]动画时间
 *  @param animationCurve [in]动画曲线
 *  @param fromNumber     [in]起始数字
 *  @param toNumber       [in]结束数字
 *  @param textHandler    [in]自定义文字, 如果为 nil, 则使用当前 number 作为 text
 */
- (void)countWithDuration:(NSTimeInterval)duration
           animationCurve:(UIViewAnimationCurve)animiatonCurve
               fromNumber:(NSInteger)fromNumber
                 toNumber:(NSInteger)toNumber
              textHandler:(NSString *(^)(NSInteger number))textHandler;

@end
