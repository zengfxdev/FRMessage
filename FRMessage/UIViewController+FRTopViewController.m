//
//  UIViewController+FRTopViewController.m
//  youpin-trace-ios
//
//  Created by 曾凡旭 on 2017/4/24.
//  Copyright © 2017年 youpin. All rights reserved.
//

#import "UIViewController+FRTopViewController.h"

@implementation UIViewController (FRTopViewController)

+(UIViewController *)topViewController{
    //1.
    UIViewController *topController = ((UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0]).rootViewController;
    //2.
    UIViewController *topVC = [self topViewController:topController];
    //3.
    while (topVC.presentedViewController) {
        topVC = [self topViewController:topVC.presentedViewController];
    }
    return topVC;
}

+ (UIViewController *)topViewController:(UIViewController *)controller {
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)controller topViewController]];
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)controller selectedViewController]];
    } else {
        return controller;
    }
}

@end
