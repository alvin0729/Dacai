//
//  UIImage+ImageEffects.h
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)

- (UIImage *)dp_applyLightEffect;
- (UIImage *)dp_applyExtraLightEffect;
- (UIImage *)dp_applyDarkEffect;
- (UIImage *)dp_applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)dp_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
