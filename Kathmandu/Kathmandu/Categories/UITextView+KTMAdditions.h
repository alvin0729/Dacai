//
//  UITextView+KTMAdditions.h
//  Kathmandu
//
//  Created by Ray on 15/4/22.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (KTMAdditions)

/**
 *  限制字符提示(应用场景限制字符数据）
 *
 *  @param target   action的Target
 *  @param action   限制条件执行事件
 *  @param limitMax 内容宽度最大值
 */
-(void)addTarget:(id)target action:(SEL)action limitMax:(NSInteger)limitMax;


@end
