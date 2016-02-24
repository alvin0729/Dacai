//
//  DPAppDelegate.h
//  Jackpot
//
//  Created by wufan on 15/9/16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MMWormhole/MMWormhole.h>
#import "AFImageDiskCache.h"
#import "DrawNotice.pbobjc.h"
@interface DPAppDelegate : UIResponder <UIApplicationDelegate>

{
    AFImageDiskCache *_imageCache;
}

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) MMWormhole *wormhole;
@property (nonatomic, strong, readonly) AFImageDiskCache *imageCache;
@property(nonatomic, strong) NSOperationQueue *imageQueue;
@property(nonatomic,strong) PBMDrawHomeList *resultDataBase;
@end
