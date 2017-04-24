//
//  FRMessage.h
//  FRMessage
//
//  Created by 曾凡旭 on 2017/4/24.
//  Copyright © 2017年 zengfxios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRMessageView.h"

@interface FRMessage : NSObject

+ (instancetype)sharedMessage;

+(FRMessageView *)getCurrentHud:(UIViewController *)currentVC;

#pragma mark - show
+(void)showLoadingHUD:(NSString *)loadingMsg;
+(void)showLoadingHUD:(NSString *)loadingMsg
            currentVC:(UIViewController *)currentVC;

/// 默认type:success
+(void)showTipSuccessMessage:(NSString *)tipMsg;
+(void)showTipErrorMessage:(NSString *)tipMsg;
+(void)showTipMessage:(NSString *)tipMsg withType:(FRMessageHUDType)type;
+(void)showTipMessage:(NSString *)tipMsg withType:(FRMessageHUDType)type withVC:(UIViewController *)currentVC;

#pragma mark - hide
+(void)hideHUD;
+(void)hideHUD:(UIViewController *)currentVC;

@end
