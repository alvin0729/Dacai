//
//  DPAddBankView.h
//  Jackpot
//
//  Created by sxf on 15/8/25.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DPSelectBankBlock)(NSString *bankName,NSString*bankCode,BOOL isSure);
@interface DPAddBankView : UIView

@property(nonatomic,strong)NSMutableArray *dataArray ;
@property(nonatomic,strong)NSMutableArray *codeArray ;

@property(nonatomic,copy)DPSelectBankBlock bankBlock ;
@property(nonatomic,strong,readonly) NSString *currentBankName ;
@property(nonatomic,strong,readonly) NSString *currentBankCode ;

@property(nonatomic,strong,readonly)UITableView *tableView ;
@end
