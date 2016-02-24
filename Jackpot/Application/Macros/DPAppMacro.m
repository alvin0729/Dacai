//
//  DPAppMacro.m
//  Jackpot
//
//  Created by wufan on 15/10/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPAppMacro.h"
#import "DPAppConfigurator.h"

NSString *server_base_url() {
    return [DPAppConfigurator baseURL];
}

NSString *server_ssl_url() {
    return [DPAppConfigurator SSLURL];
}