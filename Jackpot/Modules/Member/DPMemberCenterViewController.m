//
//  DPMemberCenterViewController.m
//  Jackpot
//
//  Created by wufan on 15/8/11.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPMemberCenterViewController.h"

@interface DPMemberCenterViewController ()

@end

@implementation DPMemberCenterViewController


#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Layout

- (void)makeViewConstraints {
    
}

#pragma mark - Public Interface

#pragma mark - Internal Interface

#pragma mark - Override


#pragma mark - User Interaction

// - (void)foobarButtonTapped;

#pragma mark - Delegate


#pragma mark - Properties (getter, setter)



@end
