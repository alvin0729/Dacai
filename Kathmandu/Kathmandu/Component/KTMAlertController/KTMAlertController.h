//
//  KTMAlertController.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/15.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KTMAlertActionStyle) {
    KTMAlertActionStyleDefault = 0,
    KTMAlertActionStyleCancel,
    KTMAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, KTMAlertControllerStyle) {
    KTMAlertControllerStyleActionSheet = 0,
    KTMAlertControllerStyleAlert
};

@interface KTMAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(KTMAlertActionStyle)style handler:(void (^ __nullable)(KTMAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) KTMAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface KTMAlertController : NSObject

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(KTMAlertControllerStyle)preferredStyle;

- (void)addAction:(KTMAlertAction *)action;
@property (nonatomic, readonly) NSArray<KTMAlertAction *> *actions;

@property (nonatomic, strong, nullable) KTMAlertAction *preferredAction;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) KTMAlertControllerStyle preferredStyle;
@end

@interface KTMAlertController (Internal)
@property (nonatomic, strong, readonly) UIAlertController *alertController;
@property (nonatomic, strong, readonly) UIAlertView *alertView;
@property (nonatomic, strong, readonly) UIActionSheet *alertSheet;

@property (nonatomic, strong, readonly) id presentedObject;
@end

NS_ASSUME_NONNULL_END
