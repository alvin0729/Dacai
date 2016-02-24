//
//  KTMAlertView.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMAlertView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSAttributedString *attrTitle;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSAttributedString *attrMessage;
@property (nonatomic, assign) BOOL dismissWhenTouches;    // 点击外部消失

/**
 *  创建alertView
 *
 *  @param title   [in]标题, NSString、NSAttributedString 类型, 下同
 *  @param message [in]内容, NSString、NSAttributedString 类型, 下同
 *
 *  @return
 */
+ (KTMAlertView *)alertViewWithTitle:(id)title message:(id)message;

+ (KTMAlertView *)alertViewWithTitle:(id)title
                             message:(id)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                 cancelButtonhandler:(void (^)(void))cancelButtonhandler;

+ (KTMAlertView *)alertViewWithTitle:(id)title
                             message:(id)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                 cancelButtonhandler:(void (^)(void))cancelButtonhandler
                  confirmButtonTitle:(NSString *)confirmButtonTitle
                confirmButtonHandler:(void (^)(void))confirmButtonHandler;

//- (void)addButtonWithTitle:(NSString *)title handler:(void (^)(void))handler;
- (void)show;
- (void)dismiss;
@end
