//
//  UMComNavigationController.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComNavigationController.h"
#import "UMComTools.h"

@interface UMComNavigationController ()

@end

@implementation UMComNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:[UIColor dp_flatRedColor]];
    self.navigationBar.translucent = NO;
    
    NSMutableDictionary *navigationDic = [NSMutableDictionary dictionary];
    [navigationDic setValue:[UIColor dp_flatWhiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationBar setTitleTextAttributes:navigationDic];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
