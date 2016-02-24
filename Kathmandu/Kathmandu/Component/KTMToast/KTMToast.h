//
//  KTMToast.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/1.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMToast : UIView
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (void)showText:(NSString *)text;
+ (void)dismiss;
@end
