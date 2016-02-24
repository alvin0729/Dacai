//
//  UIImage+DPCache.h
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DPCache)

//- (UIImage *)dp_imageWithSize:(CGSize)size;
//- (UIImage *)dp_imageWithRect:(CGRect)rect;

+ (UIImage *)dp_retinaImageNamed:(NSString *)named;
+ (UIImage *)dp_resizeImageNamed:(NSString *)named;

@end
