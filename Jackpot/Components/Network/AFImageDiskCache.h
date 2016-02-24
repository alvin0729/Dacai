//
//  AFImageDiskCache.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

extern NSString *AFImageDiskCachePathFromURL(NSString *absoluteString);

@interface AFImageDiskCache : NSObject <AFImageCache>

+ (instancetype)sharedCache;

/**
 Returns a cached image for the specififed request, if available.
 
 @param url The image url.
 
 @return The cached image.
 */
- (UIImage *)cachedImageForURL:(NSString *)url;

/**
 Caches a particular image for the specified request.
 
 @param image The image to cache.
 @param url The url to be used as a cache key.
 */
- (void)cacheImage:(UIImage *)image forURL:(NSString *)url;

@end