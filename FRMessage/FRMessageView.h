//
//  FRMessageView.h
//  FRMessage
//
//  Created by 曾凡旭 on 2017/4/24.
//  Copyright © 2017年 zengfxios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FRMessageHUDMode){
    FRMessageHUDModeText,   // 纯文本显示,warning,error,success时显示
    FRMessageHUDModeIndicator   // 带指示器动画显示,只有当YPMessageTypeNormal的情况下才显示
};

typedef NS_ENUM(NSInteger, FRMessageHUDType) {
    FRMessageHUDTypeNormal = 0,
    FRMessageHUDTypeWarning,
    FRMessageHUDTypeError,
    FRMessageHUDTypeSuccess,
    FRMessageHUDTypeCustom
};

typedef NS_ENUM(NSInteger, FRMessagePosition) {
    FRMessagePositionTop = 0,
    FRMessagePositionCenter,
    FRMessagePositionBottom
};

typedef void (^FRMessageHUDCompletionBlock)();

@class FRMessageConfig;
@interface FRMessageView : UIView

@property (nonatomic, assign, getter=hasFinished) BOOL finished;
@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;

@property (nonatomic, copy) NSString *labelText;

@property (nonatomic,assign) FRMessagePosition position;
@property (nonatomic,assign) FRMessageHUDType type;
@property (nonatomic,assign) FRMessageHUDMode mode;

@property (nonatomic,copy) FRMessageHUDCompletionBlock completionBlock;

+ (instancetype)showHUDAddedTo:(UIView *)view withMode:(FRMessageHUDMode)mode withMessage:(NSString *)message;
+ (instancetype)showHUDAddedTo:(UIView *)view withMessage:(NSString *)message;
+ (instancetype)showHUDAddedTo:(UIView *)view withMessage:(NSString *)message withType:(FRMessageHUDType)type;
+ (instancetype)showHUDAddedTo:(UIView *)view withType:(FRMessageHUDType)type withMode:(FRMessageHUDMode)mode withMessage:(NSString *)message;

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;
- (id)initWithView:(UIView *)view;
+ (FRMessageView *)HUDForView:(UIView *)view;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end

@interface FRMessageConfig : NSObject

// default : 2.0 sec
@property (nonatomic,assign) NSTimeInterval tipMessageDuration UI_APPEARANCE_SELECTOR;

@property (nonatomic,strong) UIColor *normalColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor *warningColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor *errorColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor *successColor UI_APPEARANCE_SELECTOR;

+(instancetype)shared;

@end

