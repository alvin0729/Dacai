//
//  DPFootballCenterIntegralViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterBaseViewModel.h"

@interface DPFootballCenterIntegralViewModel : DPDataCenterBaseViewModel <IDPDataCenterViewModel>
@property (nonatomic, assign, readonly) NSInteger rowCount;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSAttributedString *areaText;

- (NSArray *)textListAtIndex:(NSInteger)index;
- (UIColor *)textColorAtIndex:(NSInteger)index;
- (UIColor *)backgroundColorAtIndex:(NSInteger)index;
@end
