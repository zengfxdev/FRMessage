//
//  UIColor+FRAdd.m
//  youpin-trace-ios
//
//  Created by 曾凡旭 on 2017/4/24.
//  Copyright © 2017年 youpin. All rights reserved.
//

#import "UIColor+FRAdd.h"

@implementation UIColor (FRAdd)

+(UIColor *)colorWithHexString:(NSString *)hexStr{
    unsigned rgbValue = 0;
    hexStr = [hexStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
