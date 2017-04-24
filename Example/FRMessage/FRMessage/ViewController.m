//
//  ViewController.m
//  FRMessage
//
//  Created by 曾凡旭 on 2017/4/24.
//  Copyright © 2017年 zengfxios. All rights reserved.
//

#import "ViewController.h"
#import "FRMessage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FRMessage showLoadingHUD:@"加载中..."];
    [self performSelector:@selector(hideMessageView) withObject:nil afterDelay:2.0];
}

-(void)hideMessageView{
    [FRMessage hideHUD:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
