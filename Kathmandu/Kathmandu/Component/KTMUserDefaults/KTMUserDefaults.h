//
//  KTMUserDefaults.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/3.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTMUserDefaults : NSProxy
+ (KTMUserDefaults *)standardUserDefaults;
- (void)synchronize;
@end
