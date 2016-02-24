//
//  DPWatchImageModel.h
//  Jackpot
//
//  Created by sxf on 16/1/19.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPWatchImageModel : NSObject

@property (nonatomic, strong) UIImage *image;

- (void)requestImageIfNeeded:(NSString *)imageURL;
@end
