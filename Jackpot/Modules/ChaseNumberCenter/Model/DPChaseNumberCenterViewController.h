//
//  DPChaseNumberCenterVC.h
//  Jackpot
//
//  Created by sxf on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    DPChaseNumberIndexTypeAll = 0,//全部
    DPChaseNumberIndexTypeRuning = 1,//进行中
    DPChaseNumberIndexTypeUnPay = 2,//待支付
    DPChaseNumberIndexTypeFinished = 3,//已完成
    
}DPChaseNumberIndexType;

@interface DPChaseNumberCenterInfoViewController : UIViewController

@property (nonatomic, assign)DPChaseNumberIndexType index;
@end
