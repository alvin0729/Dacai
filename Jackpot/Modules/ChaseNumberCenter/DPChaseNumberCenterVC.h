//
//  DPChaseNumberCenterVC.h
//  Jackpot
//
//  Created by sxf on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    indexTypeChaseAll = 0,//全部
    indexTypeChaseRuning = 1,//进行中
    indexTypeChaseUnPay = 2,//待支付
     indexTypeChaseFinished = 3,//已完成
    
}indexChaseType;

@interface DPChaseNumberCenterVC : UIViewController

@property (nonatomic, assign)indexChaseType index;
@end
