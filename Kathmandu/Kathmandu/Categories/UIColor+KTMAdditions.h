//
//  UIColor+KTMAdditions.h
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0x00FF0000) >> 16)) / 255.0     \
                                                 green:((float)((rgbValue & 0x0000FF00) >>  8)) / 255.0     \
                                                  blue:((float)((rgbValue & 0x000000FF) >>  0)) / 255.0     \
                                                 alpha:1.0]
#define colorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define ycolorWithRGB(r,g,b) [UIColor colorWithRed:r green:g blue:b alpha:1]
#define randomColor colorWithRGB(arc4random_uniform(255)%255, arc4random_uniform(255)%255, arc4random_uniform(255)%255)

@interface UIColor (KTMAdditions)

+ (UIColor *)dp_colorWithUInt8Red:(UInt8)red green:(UInt8)green blue:(UInt8)blue alpha:(UInt8)alpha;
+ (UIColor *)dp_colorFromRGB:(NSUInteger)rgb;
+ (UIColor *)dp_colorFromRGBA:(NSUInteger)rgba;
+ (UIColor *)dp_colorFromHexString:(NSString *)hexString;
+ (UIColor *)dp_oppositeColorOf:(UIColor *)mainColor;

@property (nonatomic, assign, readonly) CGFloat dp_red;
@property (nonatomic, assign, readonly) CGFloat dp_green;
@property (nonatomic, assign, readonly) CGFloat dp_blue;
@property (nonatomic, assign, readonly) CGFloat dp_alpha;

+ (UIColor *)dp_randomColor;

+ (UIColor *)dp_coverColor;
// flat color
+ (UIColor *)dp_flatBackgroundColor;
+ (UIColor *)dp_flatWhiteColor;
+ (UIColor *)dp_flatBlackColor;
+ (UIColor *)dp_flatGrayColor;
+ (UIColor *)dp_flatRedColor;
+ (UIColor *)dp_flatBlueColor;



+ (UIColor *)dp_flatDarkRedColor;
+ (UIColor *)dp_flatMediumElectricBlueColor;
+ (UIColor *)dp_flatGreenColor;

@end
