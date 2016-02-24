//
//  DPWatchImageModel.m
//  Jackpot
//
//  Created by sxf on 16/1/19.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import "DPWatchImageModel.h"



@interface DPWatchImageModel ()
@property (nonatomic, strong) NSURLSessionDataTask *task;

- (void)dealWithImage:(UIImage *)image;

@end


@implementation DPWatchImageModel



- (void)dealWithImage:(UIImage *)image {
    self.image = image;
}

- (void)requestImageIfNeeded:(NSString *)imageURL{
    if (!self.image && !self.task && imageURL) {
        UIImage *image = [[AFImageDiskCache sharedCache] cachedImageForURL:imageURL];
        if (image) {
            [self dealWithImage:image];
            return;
        }
        
        @weakify(self);
        self.task = [[AFHTTPSessionManager dp_sharedImageManager] GET:imageURL
                                                            parameters:nil
                                                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                   @strongify(self);
                                                                   [[AFImageDiskCache sharedCache] cacheImage:responseObject forURL:imageURL];
                                                                   [self dealWithImage:responseObject];
                                                                   self.task = nil;
                                                               }
                                                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                   @strongify(self);
                                                                   self.task = nil;
                                                               }];
    }
}


- (void)dealloc {
    [self.task cancel];
}
@end
