//
//  DPAppDebugger.h
//  Jackpot
//
//  Created by WUFAN on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#ifdef DEBUG

#import <UIKit/UIKit.h>

@interface DPAppDebugger : NSObject
+ (DPAppDebugger *)defaultDebugger;
- (void)attach:(UIWindow *)window;
@end

#endif
