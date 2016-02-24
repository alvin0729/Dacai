//
//  KTMHierarchySearcher.h
//  Kathmandu
//
//  Created by WUFAN on 15/10/29.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMHierarchySearcher : NSObject
+ (__kindof UIViewController *)topmostViewController;
+ (__kindof UIViewController *)topmostNonModalViewController;
+ (__kindof UINavigationController *)topmostNavigationController;
@end
