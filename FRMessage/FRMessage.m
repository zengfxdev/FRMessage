//
//  FRMessage.m
//  FRMessage
//
//  Created by 曾凡旭 on 2017/4/24.
//  Copyright © 2017年 zengfxios. All rights reserved.
//

#import "FRMessage.h"
#import "UIViewController+FRTopViewController.h"

@implementation FRMessage

+ (instancetype)sharedMessage{
    static FRMessage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FRMessage new];
    });
    return instance;
}

+(FRMessageView *)getCurrentHud:(UIViewController *)currentVC{
    FRMessageView *hud = [FRMessageView HUDForView:currentVC.navigationController.view];
    if(!hud){
        hud = [FRMessageView HUDForView:currentVC.view];
    }
    if(!hud){
        return nil;
    }
    return hud;
}

#pragma mark - show
+(void)showLoadingHUD:(NSString *)loadingMsg{
    [self showLoadingHUD:loadingMsg currentVC:[UIViewController topViewController]];
}

+(void)showLoadingHUD:(NSString *)loadingMsg
            currentVC:(UIViewController *)currentVC
{
    FRMessageView *hud = [self getCurrentHud:currentVC];
    if(hud){
        [hud hideAnimated:NO];
    }
    
    void (^createhud)()=^{
        [FRMessageView showHUDAddedTo:currentVC.view withMode:FRMessageHUDModeIndicator withMessage:loadingMsg];
    };
    
    if( [NSThread isMainThread] ){
        createhud();
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            createhud();
        });
    }
}

+(void)showTipSuccessMessage:(NSString *)tipMsg{
    [self showTipMessage:tipMsg withType:FRMessageHUDTypeSuccess withVC:[UIViewController topViewController]];
}

+(void)showTipErrorMessage:(NSString *)tipMsg{
    [self showTipMessage:tipMsg withType:FRMessageHUDTypeError withVC:[UIViewController topViewController]];
}

+(void)showTipMessage:(NSString *)tipMsg withType:(FRMessageHUDType)type{
    [self showTipMessage:tipMsg withType:type withVC:[UIViewController topViewController]];
}

+(void)showTipMessage:(NSString *)tipMsg withType:(FRMessageHUDType)type withVC:(UIViewController *)currentVC
{
    FRMessageView *hud = [self getCurrentHud:currentVC];
    // 已经存在hud的情况下
    if(hud){
        if(hud.hasFinished){
            [hud hideAnimated:NO];
        }
        else{
            hud.labelText = tipMsg;
            hud.type = type;
            [hud hideAnimated:YES afterDelay:[FRMessageConfig shared].tipMessageDuration];
        }
    }
    else{
        void (^createhud)()=^{
            // 无hud存在
            FRMessageView *hud = [FRMessageView showHUDAddedTo:[UIViewController topViewController].view withMessage:tipMsg withType:type];
            [hud hideAnimated:YES afterDelay:[FRMessageConfig shared].tipMessageDuration];
        };
        
        if( [NSThread isMainThread] ){
            createhud();
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                createhud();
            });
        }
    }
}

#pragma mark - hide
+(void)hideHUD{
    [self hideHUD:[UIViewController topViewController]];
}

+(void)hideHUD:(UIViewController *)currentVC{
    FRMessageView *hud = [self getCurrentHud:currentVC];
    if(hud){
        if( [NSThread isMainThread] ){
            if(hud){
                [hud hideAnimated:YES];
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(hud){
                    [hud hideAnimated:YES];
                }
            });
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [FRMessageView hideHUDForView:currentVC.view animated:YES];
        });
    }
}

@end
