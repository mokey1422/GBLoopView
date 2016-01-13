//
//  GBLoopView.m
//  跑马灯效果
//
//  Created by 张国兵 on 15/7/20.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBLoopView.h"
#import <QuartzCore/QuartzCore.h>

#define iOS8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0

@implementation GBLoopView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupView];
    }
    return self;
}

/*  返回当前屏幕的size*/
-(CGSize) screenSize{
    
    UIInterfaceOrientation orientation =[UIApplication sharedApplication].statusBarOrientation;
    if(appScreenSize.width==0 || lastOrientation != orientation){
        appScreenSize = CGSizeMake(0, 0);
        CGSize screenSize = [[UIScreen mainScreen] bounds].size; // 这里如果去掉状态栏，只要用applicationFrame即可。
        if(orientation == UIDeviceOrientationLandscapeLeft ||orientation == UIDeviceOrientationLandscapeRight){
            // 横屏，那么，返回的宽度就应该是系统给的高度。注意这里，全屏应用和非全屏应用，应该注意自己增减状态栏的高度。
            appScreenSize.width = screenSize.height;
            appScreenSize.height = screenSize.width;
        }else{
            appScreenSize.width = screenSize.width;
            appScreenSize.height = screenSize.height;
        }
        lastOrientation = orientation;
    }
    return appScreenSize;
}

-(void)setupView {
    
    
    tickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [tickerLabel setBackgroundColor:[UIColor clearColor]];
    //屏幕状态监测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [tickerLabel setNumberOfLines:1];
    tickerLabel.font=[UIFont boldSystemFontOfSize:15.f];
    tickerLabel.textColor=[UIColor whiteColor];
    [self addSubview:tickerLabel];
    loops = YES;
    // 默认初始方向是向左
    _Direction = GBLoopDirectionLeft;
}
-(void)setBackColor:(UIColor *)color
{
    [self setBackgroundColor:color];
}
-(void)animateCurrentTickerString
{
    NSString *currentString = [_tickerArrs objectAtIndex:currentIndex];
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.f]};
    CGSize textSize=[currentString sizeWithAttributes:attrs];
    
    // 设置起点和终点
    float startingX = 0.0f;
    float endX = 0.0f;
    switch (_Direction) {
        case GBLoopDirectionLeft:
            startingX = -textSize.width;
            endX = self.frame.size.width;
            break;
        case GBLoopDirectionRight:
        default:
            startingX = self.frame.size.width;
            endX = -textSize.width;
            break;
    }
    
    
    [tickerLabel setFrame:CGRectMake(startingX, tickerLabel.frame.origin.y, textSize.width, tickerLabel.frame.size.height)];
    [tickerLabel setText:currentString];
    float duration = (textSize.width + self.frame.size.width) / _Speed;
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(tickerMoveAnimationDidStop:finished:context:)];
    CGRect tickerFrame = tickerLabel.frame;
    tickerFrame.origin.x = endX;
    [tickerLabel setFrame:tickerFrame];
    
    [UIView commitAnimations];
}

-(void)tickerMoveAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
    currentIndex++;
    if(currentIndex >= [_tickerArrs count]) {
        currentIndex = 0;
        
        if(!loops) {
            
            running = NO;
            
            return;
        }
    }
    
    [self animateCurrentTickerString];
}

#pragma mark - Ticker Animation Handling
-(void)start {
    
    // 开启动画默认第一条信息
    currentIndex = 0;
    
    // 设置状态
    running = YES;
    
    // 开始动画
    [self animateCurrentTickerString];
}

-(void)pause {
    
    //检查状态运行则暂停运行
    if(running) {
        
        [self pauseLayer:self.layer];
        
        running = NO;
    }
}

-(void)resume {
    
    // 检查状态不运行则恢复运行
    if(!running) {
        
        [self resumeLayer:self.layer];
        
        running = YES;
    }
}
#pragma mark - 通知屏幕状态返回View大小
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation ==UIInterfaceOrientationLandscapeLeft)
    {
        //横屏
        
        if(iOS8){
            
            self.frame = CGRectMake(0, self.frame.origin.y, [self screenSize].height, self.frame.size.height);
            
        }else{
            
            self.frame = CGRectMake(0, self.frame.origin.y, [self screenSize].width, self.frame.size.height);
            
        }
        
        
    }
    
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //竖屏
        
        self.frame = CGRectMake(0, self.frame.origin.y, [self screenSize].width, self.frame.size.height);
        
        
    }
    
    
}
#pragma mark - UIView layer animations utilities
-(void)pauseLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

@end
