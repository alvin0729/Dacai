//
//  NSData+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 15/11/11.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "NSData+KTMAdditions.h"

@implementation NSData (KTMAdditions)

- (NSString *)dp_hexString {
    NSMutableString *hexString = [NSMutableString stringWithCapacity:2 * self.length];
    for (int i = 0; i < self.length; i++) {
        [hexString appendFormat:@"%02x", ((const unsigned char *)self.bytes)[i]];
    }
    return hexString;
}

@end
