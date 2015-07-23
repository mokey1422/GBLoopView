//
//  ViewController.m
//  跑马灯效果
//
//  Created by 张国兵 on 15/7/20.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.

#import "ViewController.h"
#import "GBLoopView.h"
@interface ViewController ()
@property(nonatomic,retain)GBLoopView*LoopView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *loopStrings = [NSArray arrayWithObjects:@"在iOS中动画实现技术主要是：Core Animation", @"我们知道每个UIView都关联到一个CALayer对象，CALayer是Core Animation中的图层。",@"zsc库真好用",nil];
    
    _LoopView = [[GBLoopView alloc] initWithFrame:CGRectMake(0, 64,self.view.bounds.size.width, 30)];
    [_LoopView setDirection:GBLoopDirectionRight];
    [_LoopView setTickerStrings:loopStrings];
    [_LoopView setSpeed:60.0f];
    [self.view addSubview:_LoopView];
    [_LoopView start];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //支持竖屏
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
